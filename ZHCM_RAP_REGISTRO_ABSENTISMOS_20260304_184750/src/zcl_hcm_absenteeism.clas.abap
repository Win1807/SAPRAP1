class ZCL_HCM_ABSENTEEISM definition
  public
  final
  create public .

public section.

  interfaces IF_RAP_QUERY_PROVIDER .

  types:
    hcm_employee_searchs  TYPE STANDARD TABLE OF zc_hcm_employee_search .
  types:
    hcm_absenteeism       TYPE STANDARD TABLE OF zc_hcm_absenteeism .
  types:
    hcm_absenteeismclass  TYPE STANDARD TABLE OF zi_hcm_vh_absenteeismclass .
  types:
    hcm_useful_days       TYPE STANDARD TABLE OF zc_hcm_useful_days .
  types:
    hcm_asistencia_diaria TYPE STANDARD TABLE OF zc_hcm_asistencia_diaria .
  methods SET_CREATE_ABSENTEEISM
    importing
       ABSENTEEISM type ZC_HCM_ABSENTEEISM
    returning
      value(RESULT) type BAPIRET2 .
  methods SET_UPDATE_ABSENTEEISM
    importing
       ABSENTEEISM type ZC_HCM_ABSENTEEISM
    returning
      VALUE(RESULT) type BAPIRET2 .
  methods SET_DELETE_ABSENTEEISM
    importing
       ABSENTEEISM type ZC_HCM_ABSENTEEISM
    returning
      VALUE(RESULT) type BAPIRET2 .
  PROTECTED SECTION.
    TYPES ty_employee_list TYPE STANDARD TABLE OF hrwpc_s_objec WITH DEFAULT KEY.

    METHODS get_employee_list
      IMPORTING employee_search         TYPE zc_hcm_employee_search
                i_employee_lists        TYPE ty_employee_list
      CHANGING  VALUE(employee_searchs) TYPE zcl_hcm_absenteeism=>hcm_employee_searchs.

private section.


  data AO_CONSTANTES type ref to ZBC_CONSTANTS_ADMIN_N .
  data STATUS type CHAR1 value 1 ##NO_TEXT.
  data MANT_S type CHAR1 value 'S' ##NO_TEXT.
  data OPERATION_CREATE type CHAR1 value 'S' ##NO_TEXT.
  data OPERATION_UPDATE type CHAR1 value 'U' ##NO_TEXT.
  data C_ERROR type CHAR1 value 'E' ##NO_TEXT.
  data C_SUCEFULL type CHAR1 value 'S' ##NO_TEXT.
  data INFTY type INFTY value 2001 ##NO_TEXT.
  data REPID type PROGNAME value 'PT007' ##NO_TEXT.
  data RANGEID type ZRANGEID value '0000000289' ##NO_TEXT.
  data C_WARNING type CHAR1 value 'W' ##NO_TEXT.

  methods GET_EMPLOYEE_SEARCH
    importing
      !USER_NAME type UNAME
    changing
      !EMPLOYEE_SEARCHS type HCM_EMPLOYEE_SEARCHS .
  methods GET_EMPLOYEE_ABSENTEEISM
    changing
      !ABSENTEEISMS type ZCL_HCM_ABSENTEEISM=>HCM_ABSENTEEISM .
  methods GET_VH_ABSENTEEISM_CLASS
    importing
      !EMPLOYEENUMBER type HR_PERNR
    changing
      value(ABSENTEEISMCLASS) type ZCL_HCM_ABSENTEEISM=>HCM_ABSENTEEISMCLASS optional .



  methods GET_USEFUL_DAYS
    changing
      !USEFUL_DAYS type HCM_USEFUL_DAYS .
ENDCLASS.



CLASS ZCL_HCM_ABSENTEEISM IMPLEMENTATION.


  METHOD get_employee_absenteeism.
    DATA from_date        TYPE bapihritbase-from_date.
    DATA to_date          TYPE bapihritbase-to_date.
    DATA employeefullname TYPE stext.
    DATA sel_employees    TYPE STANDARD TABLE OF bapihrselemployee.
    DATA hrtimesrec_lists TYPE STANDARD TABLE OF bapihrtimreclist.
    DATA return           TYPE STANDARD TABLE OF bapiret2.

    ASSIGN absenteeisms[ 1 ] TO FIELD-SYMBOL(<absenteeism>).
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    INSERT INITIAL LINE INTO TABLE sel_employees ASSIGNING FIELD-SYMBOL(<sel_employee>).
    <sel_employee>-sign   = 'I'.
    <sel_employee>-option = 'EQ'.
    <sel_employee>-low    = <absenteeism>-employeenumber.
    <sel_employee>-high   = <absenteeism>-employeenumber.
    employeefullname = <absenteeism>-employeefullname.

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING date      = sy-datum
                days      = 0
                months    = 0
                signum    = '-'
                years     = 1
      IMPORTING calc_date = from_date.

    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING date      = sy-datum
                days      = 0
                months    = 3
                signum    = '+'
                years     = 0
      IMPORTING calc_date = to_date.

    CALL FUNCTION 'BAPI_EMPATTABS_GETLIST'
      EXPORTING from_date       = from_date
                to_date         = to_date
      TABLES    sel_employee    = sel_employees
                hrtimesrec_list = hrtimesrec_lists
                return          = return.

    REFRESH absenteeisms.
    SORT hrtimesrec_lists DESCENDING BY from_date.
    LOOP AT hrtimesrec_lists INTO DATA(hrtimesrec_list).
      INSERT INITIAL LINE INTO TABLE absenteeisms ASSIGNING <absenteeism>.
      <absenteeism>-logicalsystem       = hrtimesrec_list-logicalsystem.
      <absenteeism>-documentnumber      = hrtimesrec_list-documentnumber.
      <absenteeism>-employeenumber      = hrtimesrec_list-employeenumber.
      <absenteeism>-absenteeismclass    = hrtimesrec_list-rectype.
      <absenteeism>-absenteeismclasstxt = hrtimesrec_list-rectype_text.
      <absenteeism>-employeefullname    = employeefullname.
      <absenteeism>-fromstart           = hrtimesrec_list-from_date.
      <absenteeism>-fromend             = hrtimesrec_list-to_date.
      <absenteeism>-timestart           = hrtimesrec_list-start_time.
      <absenteeism>-timeend             = hrtimesrec_list-end_time.
    ENDLOOP.
  ENDMETHOD.

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
    apellido_masyucula = to_upper( employee_search-lastname ).
    nombre_mayuscula = to_upper( employee_search-employeename ).

    " MINUSCULAS:
    apellido_minuscula = to_lower( employee_search-lastname ).
    nombre_minuscula = to_lower( employee_search-employeename ).

    " primera mayúscula:
    apellido_primera_may = apellido_masyucula.
    nombre_primera_may = nombre_mayuscula.

    apellido_primera_may = to_lower( apellido_primera_may+1 ).
    nombre_primera_may = to_lower( nombre_primera_may+1 ).

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

    IF employee_search-lastname IS NOT INITIAL.
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
      INSERT INITIAL LINE INTO TABLE employee_searchs ASSIGNING FIELD-SYMBOL(<employee_search>).
      <employee_search>-employeenumber = employee-pernr.
      <employee_search>-lastname       = employee-nachn.
      <employee_search>-employeename   = employee-vorna.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_employee_search.
    " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA objid          TYPE orgeh.
    DATA employeenumber TYPE bapiusr01-employeeno.

    " Si no se envía filtro se agrega el dato ¨*" para traer todos los usuarios
    READ TABLE employee_searchs INTO DATA(employee_search) INDEX 1.
    IF employee_search IS INITIAL.
      employee_search-employeename = '*'.
    ENDIF.

    DATA employees TYPE STANDARD TABLE OF pa0002.

    " Obtención del Nro Empleado
    CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
      EXPORTING id             = user_name
                begindate      = sy-datum
                enddate        = sy-datum
      IMPORTING employeenumber = employeenumber.

    " Obtención de la organización de Unidad del Usuario
    CALL FUNCTION 'Z_BAPI_PA_GET_IT0001_DATA_DATE'
      EXPORTING pernr       = employeenumber
                ip_key_date = sy-datum
      IMPORTING orgeh       = objid.

    " Obtención de la lista de empleados
    CALL FUNCTION 'Z_HR_RFC_EMPLOYEE_SEARCH2'
      EXPORTING ip_pernr     = employee_search-employeenumber
                ip_vorna     = employee_search-employeename
                ip_nachn     = employee_search-lastname
                ip_flag      = 'T'
      TABLES    et_employees = employees.

    REFRESH employee_searchs.

    " Agrega los datos a los empleados
    LOOP AT employees ASSIGNING FIELD-SYMBOL(<employee>).
      INSERT INITIAL LINE INTO TABLE employee_searchs ASSIGNING FIELD-SYMBOL(<employee_search>).
      CONCATENATE <employee>-nachn <employee>-nach2 <employee>-vorna INTO <employee_search>-employeefullname SEPARATED BY space.
      CONCATENATE <employee>-nachn <employee>-nach2 INTO <employee_search>-lastname SEPARATED BY space.
      <employee_search>-employeename   = <employee>-vorna.
      <employee_search>-employeenumber = <employee>-pernr.
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

          WHEN 'ZC_HCM_EMPLOYEE_SEARCH'.

            TRY.
                IF io_request->is_data_requested( ).
                  io_request->get_paging( ).

                  " Initialize values
                  DATA employee_searchs TYPE hcm_employee_searchs.

                  REFRESH employee_searchs.

                  INSERT INITIAL LINE INTO TABLE employee_searchs ASSIGNING FIELD-SYMBOL(<employee_search>).
                  LOOP AT filter_object ASSIGNING FIELD-SYMBOL(<fs_filter>).
                    CASE <fs_filter>-name.
                      WHEN 'EMPLOYEENUMBER'.
                        <employee_search>-employeenumber = <fs_filter>-range[ 1 ]-low.

                      WHEN 'LASTNAME'.
                        <employee_search>-lastname = <fs_filter>-range[ 1 ]-low.
                        REPLACE ALL OCCURRENCES OF '*' IN <employee_search>-lastname WITH ''.
                      WHEN 'EMPLOYEENAME'.
                        <employee_search>-employeename = <fs_filter>-range[ 1 ]-low.
                        REPLACE ALL OCCURRENCES OF '*' IN <employee_search>-employeename WITH ''.
                    ENDCASE.
                  ENDLOOP.

                  get_employee_search( EXPORTING user_name        = sy-uname
                                       CHANGING  employee_searchs = employee_searchs ).

                  DATA i_employee_searchs TYPE STANDARD TABLE OF zc_hcm_employee_search.
                  DATA i_employee_search  LIKE LINE OF i_employee_searchs.

                  IF page_size > 0.
                    LOOP AT employee_searchs ASSIGNING <employee_search> FROM offset + 1 TO ( offset + page_size ).
                      MOVE-CORRESPONDING <employee_search> TO i_employee_search.
                      INSERT i_employee_search INTO TABLE i_employee_searchs.
                    ENDLOOP.
                  ELSE.
                    LOOP AT employee_searchs ASSIGNING <employee_search>.
                      MOVE-CORRESPONDING <employee_search> TO i_employee_search.
                      INSERT i_employee_search INTO TABLE i_employee_searchs.
                    ENDLOOP.
                  ENDIF.

                  io_response->set_data( i_employee_searchs ).

                  IF io_request->is_total_numb_of_rec_requested( ).
                    io_response->set_total_number_of_records( lines( i_employee_searchs ) ).
                  ENDIF.

                ENDIF.
              CATCH cx_rap_query_provider INTO DATA(lx_dest).
                MESSAGE lx_dest->get_text( ) TYPE 'E'.
            ENDTRY.

          WHEN 'ZC_HCM_ABSENTEEISM'.

            TRY.
                IF io_request->is_data_requested( ).
                  io_request->get_paging( ).

                  " Initialize values
                  DATA absenteeisms TYPE hcm_absenteeism.

                  REFRESH absenteeisms.

                  INSERT INITIAL LINE INTO TABLE absenteeisms ASSIGNING FIELD-SYMBOL(<absenteeism>).
                  LOOP AT filter_object ASSIGNING <fs_filter>.
                    CASE <fs_filter>-name.
                      WHEN 'EMPLOYEENUMBER'.
                        <absenteeism>-employeenumber = <fs_filter>-range[ 1 ]-low.
                      WHEN 'EMPLOYEEFULLNAME'.
                        <absenteeism>-employeefullname = <fs_filter>-range[ 1 ]-low.
                    ENDCASE.
                  ENDLOOP.

                  get_employee_absenteeism( CHANGING absenteeisms = absenteeisms  ).

                  DATA i_absenteeisms TYPE STANDARD TABLE OF zc_hcm_absenteeism.
                  DATA i_absenteeism  LIKE LINE OF i_absenteeisms.

                  IF page_size > 0.
                    LOOP AT absenteeisms ASSIGNING <absenteeism> FROM offset + 1 TO ( offset + page_size ).
                      MOVE-CORRESPONDING <absenteeism> TO i_absenteeism.
                      INSERT i_absenteeism INTO TABLE i_absenteeisms.
                    ENDLOOP.
                  ELSE.
                    LOOP AT absenteeisms ASSIGNING <absenteeism>.
                      MOVE-CORRESPONDING <absenteeism> TO i_absenteeism.
                      INSERT i_absenteeism INTO TABLE i_absenteeisms.
                      INSERT i_absenteeism INTO TABLE i_absenteeisms.
                    ENDLOOP.
                  ENDIF.

                  io_response->set_data( i_absenteeisms ).

                  IF io_request->is_total_numb_of_rec_requested( ).
                    io_response->set_total_number_of_records( lines( i_absenteeisms ) ).
                  ENDIF.
                ENDIF.
              CATCH cx_rap_query_provider INTO lx_dest.
                MESSAGE lx_dest->get_text( ) TYPE 'E'.
            ENDTRY.

          WHEN 'ZI_HCM_VH_ABSENTEEISMCLASS'.

            TRY.
                IF io_request->is_data_requested( ).
                  io_request->get_paging( ).

                  DATA absenteeisms_class TYPE hcm_absenteeismclass.
                  DATA employeenumber     TYPE hr_pernr.
                  REFRESH absenteeisms_class.

                  LOOP AT filter_object ASSIGNING <fs_filter>.
                    CASE <fs_filter>-name.
                      WHEN 'EMPLOYEENUMBER'.
                        employeenumber = <fs_filter>-range[ 1 ]-low.
                    ENDCASE.
                  ENDLOOP.
                  get_vh_absenteeism_class( EXPORTING employeenumber     = employeenumber
                                            CHANGING ABSENTEEISMCLASS = absenteeisms_class ).

                  DATA i_absenteeisms_class TYPE STANDARD TABLE OF zi_hcm_vh_absenteeismclass.
                  DATA i_absenteeisms_clas  LIKE LINE OF i_absenteeisms_class.

                  IF page_size > 0.
                    LOOP AT absenteeisms_class ASSIGNING FIELD-SYMBOL(<fs_absenteeisms_class>) FROM offset + 1 TO ( offset + page_size ).
                      MOVE-CORRESPONDING <fs_absenteeisms_class> TO i_absenteeisms_clas.
                      INSERT i_absenteeisms_clas INTO TABLE i_absenteeisms_class.
                    ENDLOOP.
                  ELSE.
                    LOOP AT absenteeisms_class ASSIGNING <fs_absenteeisms_class>.
                      MOVE-CORRESPONDING <fs_absenteeisms_class> TO i_absenteeisms_clas.
                      INSERT i_absenteeisms_clas INTO TABLE i_absenteeisms_class.
                    ENDLOOP.
                  ENDIF.

                  io_response->set_data( i_absenteeisms_class ).

                  IF io_request->is_total_numb_of_rec_requested( ).
                    io_response->set_total_number_of_records( lines( i_absenteeisms_class ) ).
                  ENDIF.
                ENDIF.
              CATCH cx_rap_query_provider INTO lx_dest.
                MESSAGE lx_dest->get_text( ) TYPE 'E'.
            ENDTRY.

          WHEN 'ZC_HCM_USEFUL_DAYS'.
            TRY.
                IF io_request->is_data_requested( ).
                  io_request->get_paging( ).

                  " Initialize values
                  DATA useful_days TYPE hcm_useful_days.

                  REFRESH useful_days.

                  " Se llenan los datos filtrados
                  INSERT INITIAL LINE INTO TABLE useful_days ASSIGNING FIELD-SYMBOL(<useful_day>).
                  LOOP AT filter_object ASSIGNING <fs_filter>.
                    CASE <fs_filter>-name.
                      WHEN 'EMPLOYEENUMBER'.
                        <useful_day>-employeenumber = <fs_filter>-range[ 1 ]-low.
                      WHEN 'ABSENTEEISMCLASS'.
                        <useful_day>-absenteeismclass = <fs_filter>-range[ 1 ]-low.
                      WHEN 'FROMSTART'.
                        <useful_day>-fromstart = <fs_filter>-range[ 1 ]-low.
                      WHEN 'FROMEND'.
                        <useful_day>-fromend = <fs_filter>-range[ 1 ]-low.
                      WHEN 'ABSENTEEISMDAYS'.
                        <useful_day>-absenteeismdays = <fs_filter>-range[ 1 ]-low.
                    ENDCASE.
                  ENDLOOP.

                  get_useful_days( CHANGING useful_days = useful_days  ).

                  DATA i_useful_days TYPE STANDARD TABLE OF zc_hcm_useful_days.
                  DATA i_useful_day  LIKE LINE OF i_useful_days.

                  IF page_size > 0.
                    LOOP AT useful_days ASSIGNING <useful_day> FROM offset + 1 TO ( offset + page_size ).
                      MOVE-CORRESPONDING <useful_day> TO i_useful_day.
                      INSERT i_useful_day INTO TABLE i_useful_days.
                    ENDLOOP.
                  ELSE.
                    LOOP AT useful_days ASSIGNING <useful_day>.
                      MOVE-CORRESPONDING <useful_day> TO i_useful_day.
                      INSERT i_useful_day INTO TABLE i_useful_days.
                    ENDLOOP.
                  ENDIF.

                  io_response->set_data( i_useful_days ).

                  IF io_request->is_total_numb_of_rec_requested( ).
                    io_response->set_total_number_of_records( lines( useful_days ) ).
                  ENDIF.
                ENDIF.
              CATCH cx_rap_query_provider INTO lx_dest.
                MESSAGE lx_dest->get_text( ) TYPE 'E'.
            ENDTRY.
          WHEN 'ZC_HCM_ASISTENCIA_DIARIA'.
            TRY.
                IF io_request->is_data_requested( ).
                  io_request->get_paging( ).

                  " Initialize values
                  DATA asistencia_diarias TYPE hcm_asistencia_diaria.
                  DATA companycode        TYPE bapip0001b-comp_code.

                  INSERT INITIAL LINE INTO TABLE asistencia_diarias ASSIGNING FIELD-SYMBOL(<asistencia_diaria>).
                  LOOP AT filter_object ASSIGNING <fs_filter>.
                    CASE <fs_filter>-name.
                      WHEN 'EMPLOYEENUMBER'.
                        <asistencia_diaria>-employeenumber = <fs_filter>-range[ 1 ]-low.
                        employeenumber = <asistencia_diaria>-employeenumber.
                    ENDCASE.
                  ENDLOOP.

                  CALL FUNCTION 'Z_HR_RFC_GET_IT0001_DATA'
                    EXPORTING ip_pernr = employeenumber
                    IMPORTING bukrs    = companycode.

                  <asistencia_diaria>-CompanyCode = companycode.
                  io_response->set_data( asistencia_diarias ).

                  IF io_request->is_total_numb_of_rec_requested( ).
                    io_response->set_total_number_of_records( lines( asistencia_diarias ) ).
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


  METHOD get_vh_absenteeism_class.
    DATA absentismos TYPE STANDARD TABLE OF zwhr_help_searh_abst_presc_vac.

    DATA ranges      TYPE zttranv.
    DATA ep_ok       TYPE flag.
    DATA zlow        TYPE zetvarv_val.

    CALL FUNCTION 'Z_HR_RFC_ABSENTISMO'
      EXPORTING ip_pernr     = employeenumber
      TABLES    t_absentismo = absentismos.

    CALL FUNCTION 'Z_BC_OBTENER_RANGO'
      EXPORTING ip_repid   = repid
                ip_rangeid = rangeid
      IMPORTING et_range   = ranges
                ep_ok      = ep_ok.

    LOOP AT absentismos INTO DATA(absentismo).
      zlow = absentismo-awart.
      " TODO: variable is assigned but never used (ABAP cleaner)
      READ TABLE ranges INTO DATA(range) WITH KEY zlow = zlow.
      IF sy-subrc IS INITIAL.
        INSERT INITIAL LINE INTO TABLE ABSENTEEISMCLASS ASSIGNING FIELD-SYMBOL(<absenteeism>).
        <absenteeism>-employeenumber      = employeenumber.
        <absenteeism>-absenteeismclass    = absentismo-awart.
        <absenteeism>-absenteeismclasstxt = absentismo-atext.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD set_create_absenteeism.
    CONSTANTS absenteeismclass_subty TYPE subty VALUE '1010'.
    DATA record TYPE p2001.
    DATA return TYPE bapireturn1-message.

    record-logsys = absenteeism-logicalsystem.
    record-docnr  = absenteeism-documentnumber.

    record-pernr  = absenteeism-employeenumber.
    record-infty  = infty.
    record-subty  = absenteeism-absenteeismclass.
    record-endda  = absenteeism-fromstart.
    record-begda  = absenteeism-fromend.
    record-beguz  = absenteeism-timestart.
    record-enduz  = absenteeism-timeend.
    record-awart  = absenteeism-absenteeismclass.
    record-abwtg  = absenteeism-absenteeismdays.
    record-stdaz  = absenteeism-absenteeismtime.

    CALL FUNCTION 'Z_HR_BAPI_RECORD_INFOTYPE_2001' DESTINATION 'NONE'
      EXPORTING ip_pernr     = absenteeism-employeenumber
                ip_endda     = absenteeism-fromend
                ip_begda     = absenteeism-fromstart
                ip_operation = operation_create
                iw_record    = record
      IMPORTING ep_return    = return.

    IF return IS NOT INITIAL.
      result-type    = c_error.
      result-message = return.
    ELSE.
      IF ( absenteeism-fromend <> absenteeism-fromstart ) AND absenteeism-absenteeismclass = absenteeismclass_subty.
        IF absenteeism-timeend IS NOT INITIAL OR absenteeism-timestart IS NOT INITIAL.
          MESSAGE e015(zhcm_rap_pe) WITH absenteeism-employeenumber INTO result-message.
          result-type = c_warning.
          EXIT.
        ENDIF.
      ENDIF.
      MESSAGE e011(zhcm_rap_pe) WITH absenteeism-employeenumber INTO result-message.
      result-type = c_sucefull.
    ENDIF.
  ENDMETHOD.


  METHOD set_delete_absenteeism.
    DATA return TYPE bapireturn1-message.

    CALL FUNCTION 'Z_HR_BAPI_DELETE_INFOTYPE_2001' DESTINATION 'NONE'
      EXPORTING pi_pernr   = absenteeism-employeenumber
                pi_endda   = absenteeism-fromend
                pi_begda   = absenteeism-fromstart
                pi_logsys  = absenteeism-logicalsystem
                pi_docnum  = absenteeism-documentnumber
      IMPORTING ep_mensaje = return.

    IF return IS NOT INITIAL.
      result-type    = c_error.
      result-message = return.
    ELSE.
      MESSAGE e013(zhcm_rap_pe) WITH absenteeism-employeenumber INTO result-message.
      result-type = c_sucefull.
    ENDIF.
  ENDMETHOD.


  METHOD set_update_absenteeism.
    DATA record TYPE p2001.
    DATA return TYPE bapireturn1-message.

    record-logsys = absenteeism-logicalsystem.
    record-docnr  = absenteeism-documentnumber.

    record-pernr  = absenteeism-employeenumber.
    record-infty  = infty.
    record-subty  = absenteeism-absenteeismclass.
    record-beguz  = absenteeism-timestart.
    record-enduz  = absenteeism-timeend.
    record-awart  = absenteeism-absenteeismclass.
    record-abwtg  = absenteeism-absenteeismdays.
    record-stdaz  = absenteeism-absenteeismtime.

    CALL FUNCTION 'Z_HR_BAPI_RECORD_INFOTYPE_2001' DESTINATION 'NONE'
      EXPORTING ip_pernr     = absenteeism-employeenumber
                ip_endda     = absenteeism-fromend
                ip_begda     = absenteeism-fromstart
                ip_operation = operation_update
                iw_record    = record
      IMPORTING ep_return    = return.

    IF return IS NOT INITIAL.
      result-type    = c_error.
      result-message = return.
    ELSE.
      MESSAGE e012(zhcm_rap_pe) WITH absenteeism-employeenumber INTO result-message.
      result-type = c_sucefull.
    ENDIF.
  ENDMETHOD.


  METHOD get_useful_days.
    DATA ep_text          TYPE t100-text.
    DATA absenteeismclass TYPE p2001-awart.
    DATA absenteeismdays  TYPE i.
    DATA employenumber    TYPE p2001-pernr.
    DATA fromstart        TYPE begda.
    DATA fromend          TYPE endda.

    ASSIGN useful_days[ 1 ] TO FIELD-SYMBOL(<useful_day>).
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    employenumber = <useful_day>-employeenumber.
    absenteeismclass = <useful_day>-absenteeismclass.
    fromstart = <useful_day>-fromstart.
    fromend = <useful_day>-fromend.
    absenteeismdays = <useful_day>-absenteeismdays.

    CALL FUNCTION 'Z_HR_RFC_DIAS_UTILES'
      EXPORTING ip_pernr    = employenumber
                ip_awart    = absenteeismclass
                ip_begda    = fromstart
      IMPORTING ep_text     = ep_text
      CHANGING  mp_endda    = fromend
                mp_duracion = absenteeismdays.

    <useful_day>-absenteeismdays = absenteeismdays.
    <useful_day>-fromend         = fromend.
  ENDMETHOD.
ENDCLASS.
