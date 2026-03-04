class ZCL_HCM_SANCTIONS_REGISTRY definition
  public
  final
  create public .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    TYPES hcm_employee_search_sancs TYPE STANDARD TABLE OF zc_hcm_employee_search_sanc.
    TYPES r_nachn                   TYPE RANGE OF nachn.
    TYPES ty_employee_list          TYPE STANDARD TABLE OF hrwpc_s_objec.
    TYPES:
      BEGIN OF ty_field,
        field TYPE c LENGTH 40,
      END OF ty_field.
    TYPES hcm_sanctions_records  TYPE STANDARD TABLE OF zc_hcm_sanctions_record.
    TYPES r_vorna                TYPE RANGE OF vorna.
    TYPES ty_fields              TYPE STANDARD TABLE OF ty_field.
    TYPES hcm_sanctions_lists    TYPE STANDARD TABLE OF zc_hcm_sanctions_list WITH DEFAULT KEY.
    TYPES hcm_sanctions_historys TYPE STANDARD TABLE OF zi_hcm_sanctions_history.
    TYPES hcm_validate_dateends  TYPE STANDARD TABLE OF zc_hcm_validate_dateend.

    METHODS set_sanction_delete
      IMPORTING sanctions_history TYPE zi_hcm_sanctions_history
      RETURNING VALUE(result)     TYPE bapiret2.

    METHODS get_validate_sanction
      IMPORTING sanctions_validate TYPE zc_hcm_sanctions_record
      RETURNING VALUE(result)      TYPE bapiret2.

    METHODS get_validate_dateend
      CHANGING sanctions_validates TYPE hcm_validate_dateends.

    METHODS set_sanction_save
      IMPORTING sanctions_record TYPE zc_hcm_sanctions_record
      RETURNING VALUE(result)    TYPE bapiret2.

    METHODS set_filter_name
      IMPORTING employee_lastname TYPE ty_fields OPTIONAL
                employee_name     TYPE ty_fields OPTIONAL
      CHANGING  r_vorna           TYPE r_vorna   OPTIONAL
                r_nachn           TYPE r_nachn   OPTIONAL.

  PROTECTED SECTION.
    METHODS get_employee_search
      IMPORTING user_name         TYPE uname   OPTIONAL
                user_id           TYPE sysid   OPTIONAL
                employee_name     TYPE vorna   OPTIONAL
                employee_lastname TYPE nachn   OPTIONAL
                employee_number   TYPE pernr_d OPTIONAL
      CHANGING  employee_searchs  TYPE hcm_employee_search_sancs.

    METHODS get_sanction_list
      RETURNING VALUE(sanctions_lists) TYPE hcm_sanctions_lists.

    METHODS get_employee_list
      IMPORTING employee_search         TYPE zc_hcm_employee_search_sanc
                i_employee_lists        TYPE ty_employee_list
      CHANGING  VALUE(employee_searchs) TYPE zcl_hcm_sanctions_registry=>hcm_employee_search_sancs.

    METHODS set_sanction_record_inf2001
      IMPORTING sanctions_record TYPE zc_hcm_sanctions_record
      RETURNING VALUE(result)    TYPE bapiret2.

  PRIVATE SECTION.
    DATA c_error    TYPE char1 VALUE 'E' ##NO_TEXT.
    DATA c_sucefull TYPE char1 VALUE 'S' ##NO_TEXT.
    DATA flag_t     TYPE char1 VALUE 'T' ##NO_TEXT.

    METHODS set_sanction_record
      IMPORTING sanctions_record TYPE zc_hcm_sanctions_record
      RETURNING VALUE(result)    TYPE bapiret2.
ENDCLASS.



CLASS ZCL_HCM_SANCTIONS_REGISTRY IMPLEMENTATION.


  METHOD get_employee_list.
    DATA employeenumber_r     TYPE RANGE OF pernr_d.
    DATA employeename_r       TYPE RANGE OF vorna.
    DATA lastname_r           TYPE RANGE OF nachn.

    DATA apellido_masyucula   TYPE c LENGTH 40.
    DATA apellido_minuscula   TYPE c LENGTH 40.
    DATA apellido_primera_may TYPE c LENGTH 40.
    DATA nombre_mayuscula     TYPE c LENGTH 40.
    DATA nombre_minuscula     TYPE c LENGTH 40.
    DATA nombre_primera_may   TYPE c LENGTH 40.

    " MAYUSCULAS:
    apellido_masyucula = to_upper( employee_search-employeelastname ).
    nombre_mayuscula = to_upper( employee_search-employeename ).

    " MINUSCULAS:
    apellido_minuscula = to_lower( employee_search-employeelastname ).
    nombre_minuscula = to_lower( employee_search-employeename ).

    " Primera Mayuscula:
    apellido_primera_may = apellido_masyucula.
    nombre_primera_may = nombre_mayuscula.

    apellido_primera_may = |{ apellido_primera_may(1) }| & |{ to_lower( apellido_primera_may+1 ) }|.
    nombre_primera_may = |{ nombre_primera_may(1) }| & |{ to_lower( nombre_primera_may+1 ) }|.

    IF employee_search-employeenumber IS NOT INITIAL.
      INSERT VALUE #( sign   = 'I'
                      option = 'EQ'
                      low    = employee_search-employeenumber ) INTO TABLE employeenumber_r.

    ENDIF.

    IF employee_search-employeename IS NOT INITIAL.

      INSERT VALUE #( sign   = 'I'
                      option = 'CP'
                      low    = nombre_mayuscula ) INTO TABLE employeename_r.
      INSERT VALUE #( sign   = 'I'
                      option = 'CP'
                      low    = nombre_minuscula ) INTO TABLE employeename_r.
      INSERT VALUE #( sign   = 'I'
                      option = 'CP'
                      low    = nombre_primera_may ) INTO TABLE employeename_r.

    ENDIF.

    IF employee_search-employeelastname IS NOT INITIAL.
      INSERT VALUE #( sign   = 'I'
                      option = 'CP'
                      low    = apellido_masyucula ) INTO TABLE lastname_r.
      INSERT VALUE #( sign   = 'I'
                      option = 'CP'
                      low    = apellido_minuscula ) INTO TABLE lastname_r.
      INSERT VALUE #( sign   = 'I'
                      option = 'CP'
                      low    = apellido_primera_may ) INTO TABLE lastname_r.

    ENDIF.

    IF employeenumber_r[] IS NOT INITIAL.
      SELECT pernr, vorna, nachn INTO TABLE @DATA(employeepa0002)
        FROM pa0002
        WHERE pernr IN @employeenumber_r
          AND begda <= @sy-datum
          AND endda >= @sy-datum
          AND nachn IN @lastname_r
          AND vorna IN @employeename_r.
    ELSE.
      SELECT pernr vorna nachn INTO TABLE employeepa0002
        FROM pa0002
        FOR ALL ENTRIES IN i_employee_lists
        WHERE pernr  = i_employee_lists-objid
          AND begda <= sy-datum
          AND endda >= sy-datum
          AND nachn IN lastname_r
          AND vorna IN employeename_r.
    ENDIF.

    REFRESH employee_searchs.
    LOOP AT employeepa0002 INTO DATA(employee).
      INSERT INITIAL LINE INTO employee_searchs ASSIGNING FIELD-SYMBOL(<employee_search>).
      <employee_search>-employeenumber   = employee-pernr.
      <employee_search>-employeelastname = employee-nachn.
      <employee_search>-employeename     = employee-vorna.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_employee_search.
    " TODO: parameter USER_NAME is never used (ABAP cleaner)
    " TODO: parameter USER_ID is never used (ABAP cleaner)
    " TODO: parameter EMPLOYEE_NAME is never used (ABAP cleaner)
    " TODO: parameter EMPLOYEE_LASTNAME is never used (ABAP cleaner)
    " TODO: parameter EMPLOYEE_NUMBER is never used (ABAP cleaner)

    DATA employee_lists TYPE zthr_absent_and_late.

    READ TABLE employee_searchs INTO DATA(employee_search) INDEX 1.

    DATA begda TYPE begda.
    DATA endda TYPE endda.

    CALL FUNCTION 'HR_JP_MONTH_BEGIN_END_DATE'
      EXPORTING iv_date             = sy-datum
      IMPORTING ev_month_begin_date = begda
                ev_month_end_date   = endda.

    IF employee_searchs IS INITIAL.
      employee_search-employeename = '*'.
    ENDIF.

    " Obtención de la lista de empleados
    CALL FUNCTION 'Z_HR_RFC_GET_LIST_ABSENT_LATE2'
      EXPORTING ip_pernr          = employee_search-employeenumber
                ip_vorna          = employee_search-employeename
                ip_nachn          = employee_search-employeelastname
                ip_flag           = flag_t
                ip_begda          = begda
                ip_endda          = endda
      TABLES    t_absent_and_late = employee_lists.

    REFRESH employee_searchs.

    LOOP AT employee_lists ASSIGNING FIELD-SYMBOL(<employee_list>).
      INSERT INITIAL LINE INTO TABLE employee_searchs ASSIGNING FIELD-SYMBOL(<employee_search>).
      <employee_search>-employeenumber = <employee_list>-pernr.

      CONCATENATE <employee_list>-nachn <employee_list>-nach2
                  INTO <employee_search>-employeelastname SEPARATED BY space.

      <employee_search>-employeename = <employee_list>-vorna.
      <employee_search>-absences     = <employee_list>-abwtg.
      <employee_search>-tardiness    = <employee_list>-stdaz.

    ENDLOOP.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    TRY.
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(lt_filter_cond) = io_request->get_parameters( ).
        DATA(filter_object) = io_request->get_filter( )->get_as_ranges( ).

        DATA(page_size) = io_request->get_paging( )->get_page_size( ).
        DATA(offset) = io_request->get_paging( )->get_offset( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(parameters) = io_request->get_parameters( ).

        CASE io_request->get_entity_id( ).

          WHEN 'ZC_HCM_EMPLOYEE_SEARCH_SANC'.

            TRY.
                IF io_request->is_data_requested( ).
                  io_request->get_paging( ).

                  " Initialize values
                  DATA employee_search_sancs TYPE hcm_employee_search_sancs.

                  REFRESH employee_search_sancs.
                  DATA(lv_lines) = lines( filter_object ).
                  IF lv_lines > 0.
                    INSERT INITIAL LINE INTO TABLE employee_search_sancs ASSIGNING FIELD-SYMBOL(<employee_search_sanc>).
                  ENDIF.

                  LOOP AT filter_object ASSIGNING FIELD-SYMBOL(<fs_filter>).
                    CASE <fs_filter>-name.
                      WHEN 'EMPLOYEENUMBER'.
                        <employee_search_sanc>-employeenumber = <fs_filter>-range[ 1 ]-low.
                      WHEN 'EMPLOYEELASTNAME'.
                        <employee_search_sanc>-employeelastname = <fs_filter>-range[ 1 ]-low.
                        REPLACE ALL OCCURRENCES OF '*' IN <employee_search_sanc>-EmployeeLastName WITH ''.
                      WHEN 'EMPLOYEENAME'.
                        <employee_search_sanc>-employeename = <fs_filter>-range[ 1 ]-low.
                        REPLACE ALL OCCURRENCES OF '*' IN <employee_search_sanc>-EmployeeName WITH ''.
                    ENDCASE.
                  ENDLOOP.

                  get_employee_search( EXPORTING user_name        = sy-uname
                                       CHANGING  employee_searchs = employee_search_sancs ).

                  DATA i_employee_search_sancs TYPE STANDARD TABLE OF zc_hcm_employee_search_sanc.
                  DATA i_employee_search_sanc  LIKE LINE OF i_employee_search_sancs.

                  IF page_size > 0.
                    LOOP AT employee_search_sancs ASSIGNING <employee_search_sanc> FROM offset + 1 TO ( offset + page_size ).
                      MOVE-CORRESPONDING <employee_search_sanc> TO i_employee_search_sanc.
                      INSERT i_employee_search_sanc INTO TABLE i_employee_search_sancs.
                    ENDLOOP.
                  ELSE.
                    LOOP AT employee_search_sancs ASSIGNING <employee_search_sanc>.
                      MOVE-CORRESPONDING <employee_search_sanc> TO i_employee_search_sanc.
                      INSERT i_employee_search_sanc INTO TABLE i_employee_search_sancs.
                    ENDLOOP.
                  ENDIF.

                  io_response->set_data( i_employee_search_sancs ).

                  IF io_request->is_total_numb_of_rec_requested( ).
                    io_response->set_total_number_of_records( lines( i_employee_search_sancs ) ).
                  ENDIF.

                ENDIF.
              CATCH cx_rap_query_provider INTO DATA(lx_dest).
                MESSAGE lx_dest->get_text( ) TYPE 'E'.
            ENDTRY.

          WHEN 'ZC_HCM_SANCTIONS_RECORD'.

            TRY.
                IF io_request->is_data_requested( ).
                  io_request->get_paging( ).
                  DATA i_sanctions_records TYPE STANDARD TABLE OF zc_hcm_sanctions_record.

                  io_response->set_data( i_sanctions_records ).

                  IF io_request->is_total_numb_of_rec_requested( ).
                    io_response->set_total_number_of_records( lines( i_sanctions_records ) ).
                  ENDIF.

                ENDIF.
              CATCH cx_rap_query_provider INTO lx_dest.
                MESSAGE lx_dest->get_text( ) TYPE 'E'.
            ENDTRY.

          WHEN 'ZC_HCM_SANCTIONS_LIST'.

            TRY.
                IF io_request->is_data_requested( ).
                  io_request->get_paging( ).
                  DATA hcm_sanctions_lists TYPE STANDARD TABLE OF zc_hcm_sanctions_list.

                  hcm_sanctions_lists = get_sanction_list( ).

                  io_response->set_data( hcm_sanctions_lists ).

                  IF io_request->is_total_numb_of_rec_requested( ).
                    io_response->set_total_number_of_records( lines( hcm_sanctions_lists ) ).
                  ENDIF.

                ENDIF.
              CATCH cx_rap_query_provider INTO lx_dest.
                MESSAGE lx_dest->get_text( ) TYPE 'E'.
            ENDTRY.

          WHEN 'ZC_HCM_VALIDATE_DATEEND'.

            TRY.
                IF io_request->is_data_requested( ).
                  io_request->get_paging( ).

                  DATA validate_dateends TYPE hcm_validate_dateends.
                  "
                  REFRESH validate_dateends.
                  INSERT INITIAL LINE INTO TABLE validate_dateends ASSIGNING FIELD-SYMBOL(<validate_dateend>).
                  "
                  LOOP AT filter_object ASSIGNING <fs_filter>.
                    CASE <fs_filter>-name.
                      WHEN 'EMPLOYEENUMBER'.
                        <validate_dateend>-employeenumber = <fs_filter>-range[ 1 ]-low.
                      WHEN 'BEGDA'.
                        <validate_dateend>-begda = <fs_filter>-range[ 1 ]-low.
                      WHEN 'NUMBERDAYS'.
                        <validate_dateend>-numberdays = <fs_filter>-range[ 1 ]-low.
                    ENDCASE.
                  ENDLOOP.

                  get_validate_dateend( CHANGING sanctions_validates = validate_dateends ).

                  DATA i_validate_dateends TYPE STANDARD TABLE OF zc_hcm_validate_dateend.
                  DATA i_validate_dateend  LIKE LINE OF i_validate_dateends.
                  "
                  IF page_size > 0.
                    LOOP AT validate_dateends ASSIGNING <validate_dateend> FROM offset + 1 TO ( offset + page_size ).
                      MOVE-CORRESPONDING <validate_dateend> TO i_validate_dateend.
                      INSERT i_validate_dateend INTO TABLE i_validate_dateends.
                    ENDLOOP.
                  ELSE.
                    LOOP AT validate_dateends ASSIGNING <validate_dateend>.
                      MOVE-CORRESPONDING <validate_dateend> TO i_validate_dateend.
                      INSERT i_validate_dateend INTO TABLE i_validate_dateends.
                    ENDLOOP.
                  ENDIF.

                  io_response->set_data( i_validate_dateends ).

                  IF io_request->is_total_numb_of_rec_requested( ).
                    io_response->set_total_number_of_records( lines( i_validate_dateends ) ).
                  ENDIF.

                ENDIF.
              CATCH cx_rap_query_provider INTO lx_dest.
                MESSAGE lx_dest->get_text( ) TYPE 'E'.
            ENDTRY.

        ENDCASE.
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_range).
        MESSAGE lx_no_range->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD set_sanction_record.
    DATA message     TYPE plm_mver_di-htext.
    DATA messagetype TYPE pa0001-persg.

    DATA sanciones   TYPE zthrsanciones.

    sanciones-sancionid = sanctions_record-sanctionid.
    sanciones-pernr     = sanctions_record-employeenumber.
    sanciones-begda     = sanctions_record-datebegin.
    sanciones-endda     = sanctions_record-dateend.
    sanciones-bukrs     = sanctions_record-company.
    sanciones-day_nr    = sanctions_record-numberdays.
    sanciones-motsan    = sanctions_record-reason.

    CALL FUNCTION 'Z_HR_RFC_ZTHRSANCIONES' DESTINATION 'NONE'
      IMPORTING ep_text          = message
                ep_error         = messagetype
      CHANGING  mw_zthrsanciones = sanciones.

    IF messagetype = 'X'.
      result-id      = c_error.
      result-message = message.
    ELSE.
      result-id      = c_sucefull.
      " Sanción registrada satisfactoriamente
      result-message = TEXT-027.
    ENDIF.
  ENDMETHOD.


  METHOD get_sanction_list.
    DATA tiposancions TYPE STANDARD TABLE OF zthrtiposancion.

    CALL FUNCTION 'Z_HR_RFC_SANCIONTYPE_GETLIST'
      TABLES t_zthrtiposancion = tiposancions.

    LOOP AT tiposancions INTO DATA(tiposancion).
      INSERT INITIAL LINE INTO TABLE sanctions_lists ASSIGNING FIELD-SYMBOL(<sanctions_list>).
      <sanctions_list>-sanctionid   = tiposancion-sancionid.
      <sanctions_list>-sanctiontext = tiposancion-abwtxt.
      <sanctions_list>-sanctiontype = tiposancion-awart.
      <sanctions_list>-begday       = tiposancion-begday_nr.
      <sanctions_list>-numberdays   = tiposancion-endday_nr.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_validate_dateend.
    DATA contador  TYPE i VALUE 1.
    DATA datebegin TYPE begda.
    DATA flag      TYPE flag.

    DATA(sanctions_validates_aux) = sanctions_validates.
    REFRESH sanctions_validates.

    ASSIGN sanctions_validates_aux[ 1 ] TO FIELD-SYMBOL(<sanctions_validate>).
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    datebegin = <sanctions_validate>-begda.
    " Valida si la fecha seleccionada es un feriado o un día no laborable
    CALL FUNCTION 'Z_HR_RFC_EVALUE_DAY'
      EXPORTING ip_pernr   = <sanctions_validate>-employeenumber
                ip_valdate = datebegin
      IMPORTING ep_flag    = flag.
    IF flag IS INITIAL.
      <sanctions_validate>-message = 'Es un día no laborable'.
      sanctions_validates = sanctions_validates_aux.
      EXIT.
    ENDIF.

    " Se busca la fecha fin a visualizar
    WHILE contador <= <sanctions_validate>-numberdays.

      CALL FUNCTION 'Z_HR_RFC_EVALUE_DAY'
        EXPORTING ip_pernr   = <sanctions_validate>-employeenumber
                  ip_valdate = datebegin
        IMPORTING ep_flag    = flag.

      IF flag = 'X'.
        contador += 1.
        <sanctions_validate>-endda = datebegin.
      ENDIF.
      datebegin += 1.
    ENDWHILE.
    CLEAR <sanctions_validate>-message.
    sanctions_validates = sanctions_validates_aux.
  ENDMETHOD.


  METHOD set_sanction_delete.
    DATA sanciones   TYPE zwhrsanchistory.
    DATA mensaje     TYPE bapi_msg.
    DATA begin_begin TYPE begda.
    CONSTANTS awart TYPE awart VALUE '1150'.

    MOVE-CORRESPONDING sanctions_history TO sanciones.
    sanciones-mandt = sy-mandt.
    sanciones-pernr = sanctions_history-employeenumber.
    sanciones-awart = sanctions_history-sanctiontype.

    IF sanciones-awart = awart.

      CALL FUNCTION 'HR_JP_MONTH_BEGIN_END_DATE'
        EXPORTING iv_date             = sy-datum
        IMPORTING ev_month_begin_date = begin_begin.

      IF sanctions_history-endda < begin_begin.
        result-id      = c_error.
        " No se puede borrar sanciones de meses anteriores
        result-message = TEXT-029.
        EXIT.
      ENDIF.
    ENDIF.

    CALL FUNCTION 'Z_HR_BAPI_DELETE_SANCION' DESTINATION 'NONE'
      EXPORTING iw_sancion = sanciones
      IMPORTING ep_mensaje = mensaje.

    IF mensaje IS NOT INITIAL.
      result-id      = c_error.
      result-message = mensaje.
    ELSE.
      result-id      = c_sucefull.
      " Sanción eliminada satisfactoriamente
      result-message = TEXT-028.
    ENDIF.
  ENDMETHOD.


  METHOD get_validate_sanction.
    DATA return TYPE flag.

    CALL FUNCTION 'Z_HR_RFC_VALIDA_SANCION'
      EXPORTING ip_pernr  = sanctions_validate-employeenumber
                ip_sanid  = sanctions_validate-sanctionid
                ip_begda  = sanctions_validate-datebegin
      IMPORTING ep_return = return.

    IF return IS NOT INITIAL.
      result-id = c_error.

      SELECT SINGLE abwtxt INTO @DATA(sanction_type)
        FROM zthrtiposancion
        WHERE sancionid = @sanctions_validate-sanctionid
          AND bukrs     = @sanctions_validate-company.

      MESSAGE e014(zhcm_rap_pe) WITH sanctions_validate-employeename sanction_type sanctions_validate-datebegin INTO result-message.
    ENDIF.
  ENDMETHOD.


  METHOD set_filter_name.
    DATA Name_Filter TYPE nachn.
    IF employee_lastname[] IS NOT INITIAL.
      LOOP AT employee_lastname INTO DATA(field).
        " Se obtiene el valor ingresado
        Name_Filter = field-field.

        " Apellido con todo mayúscula
        Name_Filter = to_upper( field-field ).
        INSERT VALUE #( sign   = 'I'
                        option = 'CP'
                        low    = |*{ Name_Filter }*| ) INTO TABLE r_nachn.

        " Apellido con primera mayúscula
        Name_Filter = |{ Name_Filter(1) }| & |{ to_lower( Name_Filter+1 ) }|.
        IF Name_Filter IS NOT INITIAL.
          INSERT VALUE #( sign   = 'I'
                          option = 'CP'
                          low    = |*{ Name_Filter }*| ) INTO TABLE r_nachn.
        ENDIF.

        " Apellido con todo minúscula
        Name_Filter = to_lower( field-field ).
        INSERT VALUE #( sign   = 'I'
                        option = 'CP'
                        low    = |*{ Name_Filter }*| ) INTO TABLE r_nachn.
      ENDLOOP.
    ENDIF.

    IF employee_name[] IS NOT INITIAL.
      LOOP AT employee_name INTO field.
        " Se obtiene el valor ingresado
        Name_Filter = field-field.

        " Nombre con todo mayúscula
        Name_Filter = to_upper( field-field ).
        INSERT VALUE #( sign   = 'I'
                        option = 'CP'
                        low    = |*{ Name_Filter }*| ) INTO TABLE r_vorna.

        " Nombre con primera mayúscula
        Name_Filter = |{ Name_Filter(1) }| & |{ to_lower( Name_Filter+1 ) }|.
        IF Name_Filter IS NOT INITIAL.
          INSERT VALUE #( sign   = 'I'
                          option = 'CP'
                          low    = |*{ Name_Filter }*| ) INTO TABLE r_vorna.
        ENDIF.
        " Nombre con todo minúscula
        Name_Filter = to_lower( field-field ).
        INSERT VALUE #( sign   = 'I'
                        option = 'CP'
                        low    = |*{ Name_Filter }*| ) INTO TABLE r_vorna.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD set_sanction_record_inf2001.
    DATA record         TYPE p2001.
    DATA message        TYPE bapi_msg.

    DATA employeenumber TYPE pernr_d.
    DATA endda          TYPE endda.
    DATA begda          TYPE begda.
    DATA operation      TYPE char_01.

    record-infty = '2001'.
    record-pernr = sanctions_record-employeenumber.
    record-endda = sanctions_record-dateend.
    record-begda = sanctions_record-datebegin.
    record-awart = sanctions_record-sanctiontype.

    employeenumber = sanctions_record-employeenumber.
    endda = sanctions_record-dateend.
    begda = sanctions_record-datebegin.
    operation = 'S'.
    CALL FUNCTION 'Z_HR_BAPI_RECORD_INFOTYPE_2001' DESTINATION 'NONE'
      EXPORTING ip_pernr     = employeenumber
                ip_endda     = endda
                ip_begda     = begda
                ip_operation = operation
                iw_record    = record
      IMPORTING ep_return    = message.

    IF message IS NOT INITIAL.
      result-id      = c_error.
      result-message = message.
    ELSE.
      result-id      = c_sucefull.
      " Sanción registrada satisfactoriamente
      result-message = TEXT-027.
    ENDIF.
  ENDMETHOD.


  METHOD set_sanction_save.
    CONSTANTS sanctiontype TYPE awart VALUE '1150'.

    IF sanctions_record-sanctiontype = sanctiontype.
      " Ejecución de registro del infotipo 2001
      result = set_sanction_record_inf2001( sanctions_record = sanctions_record ).
      IF result-id <> c_sucefull.
        RETURN.
      ENDIF.
      " Tabla retorno
      result = set_sanction_record( sanctions_record = sanctions_record ).
    ELSE.
      " Ejecución del registro de la tabla Sanciones
      result = set_sanction_record( sanctions_record = sanctions_record ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
