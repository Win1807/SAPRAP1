"! <strong> Clase: ZCL_HCM_PERSONAL_CHANGE - Clase de la App Cambio Personal </strong><br>
"!  Proveer métodos para manejo de cambios personales en HCM
CLASS zcl_hcm_personal_change DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    TYPES hcm_personal_searchs       TYPE STANDARD TABLE OF zc_hcm_personal_search.
    TYPES hcm_division_changes       TYPE STANDARD TABLE OF zc_hcm_division_change.
    TYPES hcm_valid_personal_changes TYPE STANDARD TABLE OF zc_hcm_valid_personal_change.

    METHODS set_change_division
      IMPORTING division_change TYPE zc_hcm_division_change
      RETURNING VALUE(result)   TYPE bapiret2.

protected section.

  types:
    ty_employee_list TYPE STANDARD TABLE OF hrwpc_s_objec .

    "! Método que obtiene lista de personal en base a filtros aplicados
    "! @parameter i_personal_search | Búsqueda personal aplicada
    "! @parameter i_employee_lists  | Lista de empleados filtrados
    "! @parameter personal_list     | Tabla que almacena la lista de personal obtenida
  methods GET_PERSONAL_LIST
    importing
      !I_PERSONAL_SEARCH type ZC_HCM_PERSONAL_SEARCH
      !I_EMPLOYEE_LISTS type TY_EMPLOYEE_LIST
    changing
      value(PERSONAL_LIST) type ZCL_HCM_PERSONAL_CHANGE=>HCM_PERSONAL_SEARCHS .
  PRIVATE SECTION.
    DATA ao_constantes TYPE REF TO zbc_constants_admin_n.
    DATA medida        TYPE char2                        VALUE 'A8' ##NO_TEXT.
    DATA status        TYPE char1                        VALUE 1 ##NO_TEXT.
    DATA mant_s        TYPE pa0001-persg                 VALUE 'S' ##NO_TEXT.

    "! Método para obtener los datos organizacionales de un empleado específico
    "! @parameter division_change | Almacena los cambios de división obtenidos
    METHODS get_data_personal
      CHANGING division_change TYPE zc_hcm_division_change.

    "! DIVISION_CHANGE type ZC_HCM_DIVISION_CHANGE .
    "! Valida los cambios personales de un empleado
    "! @parameter objid                      | ID del objeto empleado
    "! @parameter hcm_valid_personal_changes | Tabla de cambios personales válidos
    METHODS valid_personal_changes
      IMPORTING objid                      TYPE hrp1000-objid
      CHANGING  hcm_valid_personal_changes TYPE zcl_hcm_personal_change=>hcm_valid_personal_changes.

    "! Método que obtiene los datos personales de un usuario
    "! @parameter user_name        | Nombre de usuario
    "! @parameter personal_searchs | Tabla para almacenar los resultados de búsqueda personal
    METHODS get_personal
      IMPORTING user_name        TYPE uname
      CHANGING  personal_searchs TYPE hcm_personal_searchs.
ENDCLASS.



CLASS ZCL_HCM_PERSONAL_CHANGE IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    TRY.
        TRY.
            DATA(filters) = io_request->get_filter( )->get_as_ranges( ).
            DATA(page_size) = io_request->get_paging( )->get_page_size( ).
            DATA(offset) = io_request->get_paging( )->get_offset( ).

            CASE io_request->get_entity_id( ).
              WHEN 'ZC_HCM_PERSONAL_SEARCH'.
                DATA personal_searchs TYPE STANDARD TABLE OF zc_hcm_personal_search.
                DATA personal_search  LIKE LINE OF personal_searchs.

                LOOP AT filters ASSIGNING FIELD-SYMBOL(<fs_filter>).
                  CASE <fs_filter>-name.
                    WHEN 'EMPLOYEENUMBER'.
                      personal_search-employeenumber = <fs_filter>-range[ 1 ]-low.
                    WHEN 'LASTNAME'.
                      personal_search-lastname = <fs_filter>-range[ 1 ]-low.
                    WHEN 'EMPLOYEENAME'.
                      personal_search-employeename = <fs_filter>-range[ 1 ]-low.
                    WHEN 'SEARCHTYPE'.
                      personal_search-searchtype = <fs_filter>-range[ 1 ]-low.
                  ENDCASE.
                ENDLOOP.
                INSERT personal_search INTO TABLE personal_searchs.

                get_personal( EXPORTING user_name        = sy-uname
                              CHANGING  personal_searchs = personal_searchs ).

                DATA i_personal_searchs TYPE STANDARD TABLE OF zc_hcm_personal_search.
                DATA i_personal_search  LIKE LINE OF i_personal_searchs.

                IF page_size > 0.
                  LOOP AT personal_searchs INTO personal_search FROM offset + 1 TO ( offset + page_size ).
                    MOVE-CORRESPONDING personal_search TO i_personal_search.
                    INSERT i_personal_search INTO TABLE i_personal_searchs.
                  ENDLOOP.
                ELSE.
                  LOOP AT personal_searchs INTO personal_search.
                    MOVE-CORRESPONDING personal_search TO i_personal_search.
                    INSERT i_personal_search INTO TABLE i_personal_searchs.
                  ENDLOOP.
                ENDIF.

                io_response->set_data( i_personal_searchs ).

                IF io_request->is_total_numb_of_rec_requested( ).
                  io_response->set_total_number_of_records( lines( i_personal_searchs ) ).
                ENDIF.

              WHEN 'ZC_HCM_DIVISION_CHANGE'.
                DATA hcm_division_changes TYPE hcm_division_changes.

                INSERT INITIAL LINE INTO TABLE hcm_division_changes ASSIGNING FIELD-SYMBOL(<division_change>).
                LOOP AT filters ASSIGNING <fs_filter>.
                  CASE <fs_filter>-name.
                    WHEN 'EMPLOYEENUMBER'.
                      <division_change>-employeenumber = <fs_filter>-range[ 1 ]-low.
                    WHEN 'EMPLOYEEFULLNAME'.
                      <division_change>-employeefullname = <fs_filter>-range[ 1 ]-low.
                  ENDCASE.
                ENDLOOP.

                get_data_personal( CHANGING division_change = <division_change> ).

                DATA i_division_changes TYPE STANDARD TABLE OF zc_hcm_division_change.
                DATA i_division_change  LIKE LINE OF i_division_changes.

                IF page_size > 0.
                  LOOP AT hcm_division_changes ASSIGNING <division_change> FROM offset + 1 TO ( offset + page_size ).
                    MOVE-CORRESPONDING <division_change> TO i_division_change.
                    INSERT i_division_change INTO TABLE  i_division_changes.
                  ENDLOOP.
                ELSE.
                  LOOP AT hcm_division_changes ASSIGNING <division_change>.
                    MOVE-CORRESPONDING <division_change> TO i_division_change.
                    INSERT i_division_change INTO TABLE  i_division_changes.
                  ENDLOOP.
                ENDIF.
                io_response->set_data( i_division_changes ).

                IF io_request->is_total_numb_of_rec_requested( ).
                  io_response->set_total_number_of_records( lines( i_division_changes ) ).
                ENDIF.

              WHEN 'ZC_HCM_VALID_PERSONAL_CHANGE'.
                DATA hcm_valid_personal_changes TYPE hcm_valid_personal_changes.
                DATA employeenumber             TYPE hrobjid.

                LOOP AT filters ASSIGNING <fs_filter>.
                  CASE <fs_filter>-name.
                    WHEN 'EMPLOYEENUMBER'.
                      employeenumber = <fs_filter>-range[ 1 ]-low.
                  ENDCASE.
                ENDLOOP.

                valid_personal_changes( EXPORTING objid                      = employeenumber
                                        CHANGING  hcm_valid_personal_changes = hcm_valid_personal_changes ).

                io_response->set_data( hcm_valid_personal_changes ).

                IF io_request->is_total_numb_of_rec_requested( ).
                  io_response->set_total_number_of_records( lines( hcm_valid_personal_changes ) ).
                ENDIF.
            ENDCASE.
          CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_range).
            MESSAGE lx_no_range->get_text( ) TYPE 'E'.
        ENDTRY.
      CATCH cx_rap_query_provider INTO DATA(lx_dest).
        MESSAGE lx_dest->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD get_personal_list.
    DATA employeenumber_r     TYPE RANGE OF pernr_d.
    DATA employeename_r       TYPE RANGE OF vorna.
    DATA lastname_r           TYPE RANGE OF nachn.

    DATA apellido_masyucula   TYPE c LENGTH 40.
    DATA apellido_minuscula   TYPE c LENGTH 40.
    DATA apellido_primera_may TYPE c LENGTH 40.
    DATA nombre_mayuscula     TYPE c LENGTH 40.
    DATA nombre_minuscula     TYPE c LENGTH 40.
    DATA nombre_primera_may   TYPE c LENGTH 40.

    apellido_masyucula = to_upper( i_personal_search-lastname ).
    nombre_mayuscula = to_upper( i_personal_search-employeename ).

    apellido_minuscula = to_lower( i_personal_search-lastname ).
    nombre_minuscula = to_lower( i_personal_search-employeename ).

    apellido_primera_may = |{ apellido_masyucula(2) }| & |{ to_lower( apellido_masyucula+2 ) }|.
    nombre_primera_may = |{ nombre_mayuscula(2) }| & |{ to_lower( nombre_mayuscula+2 ) }|.

    IF i_personal_search-employeenumber IS NOT INITIAL.
      INSERT VALUE #( sign   = 'I'
                      option = 'EQ'
                      low    = i_personal_search-employeenumber ) INTO TABLE employeenumber_r.
    ENDIF.

    IF i_personal_search-employeename IS NOT INITIAL.
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

    IF i_personal_search-lastname IS NOT INITIAL.
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
          AND sprps  = ''
          AND ( nachn IN @lastname_r OR nach2 IN @lastname_r )
          AND vorna IN @employeename_r.
    ELSE.
      SELECT pernr vorna nachn INTO TABLE employeepa0002
        FROM pa0002
        FOR ALL ENTRIES IN i_employee_lists
        WHERE pernr  = i_employee_lists-objid
          AND begda <= sy-datum
          AND endda >= sy-datum
          AND sprps  = ''
          AND ( nachn IN lastname_r OR nach2 IN lastname_r )
          AND vorna IN employeename_r.
    ENDIF.

    REFRESH personal_list.
    LOOP AT employeepa0002 INTO DATA(employee).
      READ TABLE i_employee_lists INTO DATA(employee_list) WITH KEY objid = employee-pernr.
      IF sy-subrc IS INITIAL.
        INSERT INITIAL LINE INTO TABLE personal_list ASSIGNING FIELD-SYMBOL(<personal>).
        <personal>-employeenumber   = employee_list-objid.
        <personal>-employeefullname = employee_list-stext.
        <personal>-startdate        = employee_list-begda.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD get_personal.
    DATA objid          TYPE orgeh.
    DATA employeenumber TYPE bapiusr01-employeeno.

    READ TABLE personal_searchs INTO DATA(personal_search) INDEX 1.
    DATA employee_lists TYPE STANDARD TABLE OF hrwpc_s_objec.

    CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
      EXPORTING id             = user_name
                begindate      = sy-datum
                enddate        = sy-datum
      IMPORTING employeenumber = employeenumber.

    CALL FUNCTION 'Z_BAPI_PA_GET_IT0001_DATA_DATE'
      EXPORTING pernr       = employeenumber
                ip_key_date = sy-datum
      IMPORTING orgeh       = objid.

    CALL FUNCTION 'Z_HR_RFC_GET_DATA_BY_UNIT_ORG'
      EXPORTING ip_flag  = personal_search-searchtype
                ip_objid = objid
                ip_otype = 'P'
      TABLES    t_objec  = employee_lists.

    IF employee_lists[] IS NOT INITIAL.
      DELETE employee_lists WHERE objid = employeenumber.
      get_personal_list( EXPORTING i_personal_search = personal_search
                                   i_employee_lists  = employee_lists
                         CHANGING  personal_list     = personal_searchs ).
    ELSE.

      CLEAR: personal_searchs.

    ENDIF.
  ENDMETHOD.


  METHOD get_data_personal.
    DATA employeenumber  TYPE bapiemplb-perno.
    DATA org_assignments TYPE STANDARD TABLE OF bapip0001b.

    employeenumber = division_change-employeenumber.

    CALL FUNCTION 'BAPI_EMPLOYEE_GETDATA'
      EXPORTING employee_id     = employeenumber
                authority_check = 'X'
      TABLES    org_assignment  = org_assignments.

    READ TABLE org_assignments INTO DATA(org_assignment) WITH KEY perno = division_change-employeenumber.
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    SELECT SINGLE HCMPersonnelAreaName
      INTO @DATA(personnelareaname)
      FROM I_HCMPersonnelArea
      WHERE CompanyCode              = @org_assignment-comp_code
        AND HCMPersonnelArea         = @org_assignment-pers_area
        AND HCMCountryRegionGrouping = '99'.

    SELECT SINGLE PersonnelSubareaName
      INTO @DATA(personnelsubareaname)
      FROM I_HCMPersonnelSubarea
      WHERE HCMPersonnelArea    = @org_assignment-pers_area
        AND HCMPersonnelSubarea = @org_assignment-p_subarea.

    division_change-employeefullname       = org_assignment-name.
    division_change-companycode            = org_assignment-comp_code.
    division_change-currentdivision        = org_assignment-pers_area.
    division_change-currentsubdivision     = org_assignment-p_subarea.

    division_change-currentdivisiontext    = personnelareaname.
    division_change-currentsubdivisiontext = personnelsubareaname.
  ENDMETHOD.


  METHOD set_change_division.
    CONSTANTS c_error    TYPE char1 VALUE 'E'.
    CONSTANTS c_sucefull TYPE char1 VALUE 'S'.

    DATA medidas                    TYPE zhr_medidas_pa.
    DATA managernumber              TYPE pernr_d.
    DATA message                    TYPE plm_mver_di-htext.
    DATA error                      TYPE pa0001-persg.
    DATA hcm_valid_personal_changes TYPE hcm_valid_personal_changes.

    valid_personal_changes( EXPORTING objid                      = division_change-employeenumber
                            CHANGING  hcm_valid_personal_changes = hcm_valid_personal_changes ).

    READ TABLE hcm_valid_personal_changes INTO DATA(personal_change) WITH KEY status = c_error.
    IF sy-subrc IS INITIAL.
      Result-message = personal_change-message.
      Result-id      = personal_change-status.
      EXIT.
    ENDIF.

    CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
      EXPORTING id             = sy-uname
                begindate      = sy-datum
                enddate        = sy-datum
      IMPORTING employeenumber = managernumber.

    medidas-pernr           = division_change-employeenumber.
    medidas-medida          = medida.
    medidas-fecha_efect     = division_change-requestdate.
    medidas-fecha_solicitud =  sy-datum.
    medidas-division        = division_change-newdivision.
    medidas-sub_division    = division_change-newsubdivision.
    medidas-status          = status.
    medidas-creacion_uname  = sy-uname.
    medidas-creacion_aedtm  = sy-datum.
    medidas-creacion_aenzt  = sy-uzeit.
    medidas-pernr_gerente   = managernumber.

    CALL FUNCTION 'Z_HR_ACT_MEDIDAS_PA' DESTINATION 'NONE'
      EXPORTING ip_mant           = mant_s
      IMPORTING ep_text           = message
                ep_error          = error
      CHANGING  mw_zhr_medidas_pa = medidas.

    IF error = c_error.
      Result-message = message.
      Result-id      = error.
    ELSE.
      MESSAGE e011(zhcm_rap_pe) WITH division_change-employeenumber INTO Result-message.
      Result-type = c_sucefull.
    ENDIF.
  ENDMETHOD.


  METHOD valid_personal_changes.

    CONSTANTS otype TYPE hrp1000-otype VALUE 'P'.
    DATA time    TYPE hrp1000-begda.
    DATA message TYPE char120.
    DATA status  TYPE char1.

    time = sy-datum.

    CALL FUNCTION 'Z_HR_VALIDA_CAMBIOS_PERSONAL'
      EXPORTING ip_time    = time
                ip_otype   = otype
                ip_objid   = objid
      IMPORTING ep_status  = status
                ep_mensaje = message.

    IF status = 'E'.
      INSERT INITIAL LINE INTO TABLE hcm_valid_personal_changes ASSIGNING FIELD-SYMBOL(<hcm_valid_personal_change>).
      <hcm_valid_personal_change>-employeenumber = objid.
      <hcm_valid_personal_change>-status         = status.
      <hcm_valid_personal_change>-message        = message.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
