CLASS zcl_hcm_loan_admin DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .

    TYPES:
      BEGIN OF lty_msg,
        tipo(1) TYPE c,
        msg     TYPE string,
      END OF lty_msg .
    TYPES:
      hcm_calculate_loan TYPE STANDARD TABLE OF zc_hcm_calculate_loan WITH DEFAULT KEY .
    TYPES:
      hcm_approv_reject_loan TYPE STANDARD TABLE OF zc_hcm_approv_reject_loan WITH DEFAULT KEY .
    TYPES:
      hcm_history_loan TYPE STANDARD TABLE OF zc_hcm_history_loan WITH DEFAULT KEY .
    TYPES:
      hcm_collaborator_cond TYPE STANDARD TABLE OF zc_hcm_collaborator_cond WITH DEFAULT KEY .
    TYPES:
      hcm_employee_info TYPE STANDARD TABLE OF zc_hcm_employee_info WITH DEFAULT KEY .
    TYPES:
      hcm_terms_cond TYPE STANDARD TABLE OF zc_hcm_terms_cond WITH DEFAULT KEY .
    TYPES:
      hcm_reason_loan TYPE STANDARD TABLE OF zc_hcm_reason_loan WITH DEFAULT KEY .
    TYPES:
      hcm_request_loan TYPE STANDARD TABLE OF zc_hcm_request_loan WITH DEFAULT KEY .
    TYPES:
      hcm_employee_searchs TYPE STANDARD TABLE OF zc_hcm_employee_searchs WITH DEFAULT KEY .
    TYPES:
      hcm_employee_data_init TYPE STANDARD TABLE OF zc_hcm_employee_data_init WITH DEFAULT KEY .
    TYPES:
      hcm_messages TYPE STANDARD TABLE OF String .
    TYPES:
      hcm_msg  TYPE STANDARD TABLE OF lty_msg .
    TYPES:
      hcm_motivo TYPE STANDARD TABLE OF cawao_s_subtytab.

    METHODS get_employee_search
      IMPORTING
        !user_name        TYPE uname
      CHANGING
        !employee_searchs TYPE hcm_employee_searchs .
    METHODS manager_ztsolprestamo
      IMPORTING
        !request_loan           TYPE hcm_request_loan OPTIONAL
        !action                 TYPE char1 OPTIONAL
        !numsol                 TYPE ze_numsolpres OPTIONAL
        !num_employee           TYPE pernr_d OPTIONAL
      EXPORTING
        !result_solici_prestamo TYPE hcm_request_loan
        !ep_mensaje             TYPE bapiret2
        !result_num_prestamo    TYPE ze_numsolpres
        !date_init_amort        TYPE ze_fec_sol
        !date_fin_pago          TYPE ze_finpago .
    METHODS save_general
      IMPORTING
        !action            TYPE char01 OPTIONAL
        !nr_cuota          TYPE ze_numcuota OPTIONAL
        !monto             TYPE ze_monto_prestamo OPTIONAL
        !motivo            TYPE dlart OPTIONAL
        !nr_emp            TYPE pernr_d OPTIONAL
        !monto_end         TYPE ze_monto OPTIONAL
        !re_lab            TYPE ansvh OPTIONAL
        !fecha_fin_cont    TYPE ctedt OPTIONAL
        !fecha_inicio      TYPE sy-datum OPTIONAL
        !nr_cuota_max      TYPE ze_numcuota OPTIONAL
        !area_per          TYPE persk OPTIONAL
        !fecha_cierre      TYPE char2 OPTIONAL
        !jefe_flag         TYPE flag OPTIONAL
        !nivel             TYPE char1 OPTIONAL
        !aprov_reject_loan TYPE hcm_approv_reject_loan OPTIONAL
      EXPORTING
        !trangr            TYPE ze_trangresion
        !trangr_msg        TYPE ze_msjtransgre .
    METHODS calcular_prestamo
      IMPORTING
        !fecha_cierre TYPE char2
        !monto        TYPE ze_monto_prestamo
        !motivo       TYPE dlart OPTIONAL
        !nr_cuota     TYPE ze_numcuota
      CHANGING
        !cuota_grt    TYPE ze_imp_cuota_grati
        !cuota_sim    TYPE ze_imp_cuota_simple
        !fecha_fin    TYPE ze_finpago
        !fecha_ini    TYPE ze_fec_sol .
    METHODS validar_solicitud
      IMPORTING
        !fecha_fin      TYPE ze_finpago OPTIONAL
        !fecha_fin_cont TYPE ctedt OPTIONAL
        !jefe_ju        TYPE char1 OPTIONAL
        !monto          TYPE ze_monto_prestamo OPTIONAL
        !montoend       TYPE ze_monto OPTIONAL
        !motivo         TYPE dlart OPTIONAL
        !nivel          TYPE char1 OPTIONAL
        !nr_cuota       TYPE ze_numcuota OPTIONAL
        !nr_emp         TYPE pernr_d OPTIONAL
        !nr_maxpres     TYPE ze_numcuota OPTIONAL
        !rel_lab        TYPE ansvh OPTIONAL
        !action         TYPE char01 OPTIONAL
        !area_per       TYPE persk OPTIONAL
        !comentario     TYPE ze_comenprest OPTIONAL
        !fecha_cierre   TYPE char2 OPTIONAL
      EXPORTING
        !table_message  TYPE hcm_messages
        !table_msg      TYPE hcm_msg
      CHANGING
        !trangr         TYPE ze_trangresion OPTIONAL
        !trangr_msg     TYPE ze_msjtransgre OPTIONAL .
    METHODS get_reason_loan
      IMPORTING
        !employee_number TYPE pernr_d OPTIONAL
      EXPORTING
        !reason_loans    TYPE hcm_reason_loan .
    METHODS get_terms_cond
      EXPORTING
        !terms_cond TYPE hcm_terms_cond .
    METHODS get_employee_info
      IMPORTING
        !employee_number TYPE pernr_d OPTIONAL
      EXPORTING
        !employee_info   TYPE hcm_employee_info .
    METHODS get_collaborator_cond
      IMPORTING
        !employee_number   TYPE pernr_d OPTIONAL
      EXPORTING
        !collaborator_cond TYPE hcm_collaborator_cond .
    METHODS get_history_loan
      IMPORTING
        !employee_number TYPE pernr_d OPTIONAL
      EXPORTING
        !history_loan    TYPE hcm_history_loan .
    METHODS post_aprov_reject_loan
      IMPORTING
        !aprov_reject_loan TYPE hcm_approv_reject_loan OPTIONAL
      EXPORTING
        !type              TYPE ze_trangresion
        !message           TYPE ze_msjtransgre .
    METHODS get_calculate_loan
      IMPORTING
        !monto         TYPE ze_monto_prestamo OPTIONAL
        !motivo        TYPE dlart OPTIONAL
        !nr_couta      TYPE ze_numcuota OPTIONAL
      EXPORTING
        !calulate_loan TYPE hcm_calculate_loan .
    METHODS get_aprov_reject_loan
      IMPORTING
        !input_number_loan TYPE ze_numsolpres
      EXPORTING
        !output_loan_ap_re TYPE hcm_approv_reject_loan .
    METHODS approv_loan
      IMPORTING
        !aprov_reject_loan TYPE hcm_approv_reject_loan OPTIONAL
      EXPORTING
        !icon              TYPE string
        !message           TYPE string .
    METHODS reject_loan
      IMPORTING
        !aprov_reject_loan TYPE hcm_approv_reject_loan OPTIONAL
      EXPORTING
        !type              TYPE ze_trangresion
        !message           TYPE ze_msjtransgre .
    METHODS create_loan_admin
      IMPORTING
        !request_loan        TYPE hcm_request_loan OPTIONAL
        !action              TYPE char1 OPTIONAL
        !numsol              TYPE ze_numsolpres OPTIONAL
        !num_employee        TYPE pernr_d OPTIONAL
      EXPORTING
        !ep_mensaje          TYPE bapiret2
        !result_num_prestamo TYPE ze_numsolpres.
    METHODS get_data_init_loan_admin
      IMPORTING
        !lv_nr_emp         TYPE bapiusr01-employeeno OPTIONAL
      EXPORTING
        !lv_nombre         TYPE pad_cname
        !lv_icon           TYPE string
        !lv_msg            TYPE string
        !lv_dni_emp        TYPE pa0185-icnum
        !lv_mail           TYPE string
        !lv_moneda         TYPE ktext
        !lv_montoend       TYPE ze_monto
        !lv_montoend2      TYPE maxbt
        !lv_rel_lab        TYPE ansvh
        !lv_saldo          TYPE maxbt
        !lv_remu           TYPE maxbt
        !lv_timsv          TYPE intdays
        !lv_fecha_fin_cont TYPE ctedt
        !lv_area_per       TYPE persk
        !lv_codmon         TYPE waers
        !lv_jefe_flag      TYPE flag
        !lv_cierre         TYPE char2
        !lv_fecha_inicio   TYPE sy-datum
        !lv_nrcuota        TYPE ze_numcuota
        !lit_motivo        TYPE hcm_motivo
        !lv_nr_maxpres     TYPE ze_numcuota
        !lv_mon_cuota_min  TYPE ze_monto.
  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_hcm_loan_admin IMPLEMENTATION.


  METHOD get_employee_search.

    TYPES:
      BEGIN OF gty_pa0105,
        pernr TYPE pa0105-pernr,
        subty TYPE pa0105-subty,
        objps TYPE pa0105-objps,
        sprps TYPE pa0105-sprps,
        endda TYPE pa0105-endda,
        begda TYPE pa0105-begda,
        seqnr TYPE pa0105-seqnr,
      END OF gty_pa0105.

    TYPES:
      BEGIN OF gty_employee,
        pernr      TYPE pernr_d,
        vorna      TYPE pad_vorna,
        nachn      TYPE pad_nachn,
        icnum      TYPE psg_idnum,
        usrid_long TYPE comm_id_long,
        sname      TYPE   smnam,

      END OF gty_employee.

    DATA:
      ls_id      TYPE sysid,
      lr_pernr   TYPE RANGE OF pa0105-pernr,
      lr_seqnr   TYPE RANGE OF pa0105-seqnr,
      lt_object  TYPE STANDARD TABLE OF hrwpc_s_objec,
      lwa_pa0105 TYPE gty_pa0105,
      ls_orgeh   TYPE pa0001-orgeh,
      ls_plans   TYPE pa0001-plans.

    DATA: data_employees TYPE STANDARD TABLE OF gty_employee.
    DATA: employee_search LIKE LINE OF employee_searchs.

    ls_id = sy-uname.

    SELECT SINGLE pernr subty objps sprps endda begda seqnr
       INTO lwa_pa0105
       FROM pa0105
      WHERE pernr IN lr_pernr
        AND subty = '0001'
        AND objps = space
        AND sprps = space
        AND endda >= sy-datum
        AND begda <= sy-datum
        AND seqnr IN lr_seqnr
        AND usrid = ls_id.

    SELECT SINGLE orgeh plans
      INTO (ls_orgeh, ls_plans)
      FROM pa0001
     WHERE pernr = lwa_pa0105-pernr
       AND subty = space
       AND objps = lwa_pa0105-objps
       AND sprps = lwa_pa0105-sprps
       AND endda = lwa_pa0105-endda.

    CHECK ls_orgeh IS NOT INITIAL.
    CHECK ls_plans IS NOT INITIAL.

    CALL FUNCTION 'Z_HR_RFC_GET_DATA_BY_UNIT_ORG'
      EXPORTING
        ip_flag  = 'T'
        ip_objid = ls_orgeh
      TABLES
        t_objec  = lt_object.

    CHECK lt_object[] IS NOT INITIAL.

    DELETE lt_object WHERE objid = lwa_pa0105-pernr. "is reconsidered

    CHECK lt_object[] IS NOT INITIAL.

    SELECT p2~pernr p2~vorna p2~nachn p185~icnum
      INTO TABLE data_employees
      FROM pa0002 AS p2 INNER JOIN
           pa0185 AS p185 ON p2~pernr EQ p185~pernr
       FOR ALL ENTRIES IN lt_object
     WHERE p2~pernr = lt_object-objid
       AND p2~subty = space
       AND p2~objps = space
       AND p2~sprps = space
       AND p2~endda = '99991231'
       AND p185~endda = '99991231'
       AND p2~begda <= sy-datum.

    TYPES:
      BEGIN OF gty_employee_email,
        pernr      TYPE pernr_d,
        usrid_long TYPE comm_id_long,
      END OF gty_employee_email.

    DATA: data_employees_email TYPE STANDARD TABLE OF gty_employee_email.

    SELECT pernr usrid_long FROM pa0105
      INTO TABLE data_employees_email
        FOR ALL ENTRIES IN data_employees
      WHERE pernr = data_employees-pernr AND
            subty = '0010'.

    TYPES:
      BEGIN OF gty_employee_sname,
        pernr TYPE pernr_d,
        sname TYPE smnam,
      END OF gty_employee_sname.

    DATA: sname_employee TYPE STANDARD TABLE OF gty_employee_sname.

    SELECT pernr sname INTO TABLE  sname_employee
                        FROM  pa0001
                        FOR ALL ENTRIES IN data_employees
                        WHERE pernr EQ data_employees-pernr AND
                              endda EQ '99991231'.

    DATA: line_sname_employee   TYPE gty_employee_sname.
    DATA: data_employ_email     TYPE gty_employee_email.

    LOOP AT data_employees INTO DATA(data_employee).
      CLEAR: employee_search.
      CLEAR: data_employ_email.

      employee_search-EmployeeNumber    = data_employee-pernr.
      employee_search-EmployeeName      = data_employee-vorna.
      employee_search-LastName          = data_employee-nachn.
      employee_search-Dni               = data_employee-icnum.

      READ TABLE data_employees_email WITH KEY pernr = data_employee-pernr INTO data_employ_email.
      employee_search-Mail              = data_employ_email-usrid_long.

      READ TABLE sname_employee WITH KEY pernr = data_employee-pernr INTO line_sname_employee.
      employee_search-EmployeeFullName  = line_sname_employee-sname.

      APPEND employee_search TO employee_searchs.

    ENDLOOP.


  ENDMETHOD.


  METHOD if_rap_query_provider~select.
*  METHODS select IMPORTING io_request  TYPE REF TO if_rap_query_request
*                           io_response TYPE REF TO if_rap_query_response
*                 RAISING   cx_rap_query_prov_not_impl
*                           cx_rap_query_provider.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " @parameter io_request  | Request information which should be used as input for parameterizing the query implementation
    " @parameter io_response | Response receiver which has to be filled with the result output of the query implementation
    "
    " @raising cx_rap_query_prov_not_impl | Should be raised if the provider lacks the ability to fulfill the request at hand
    "                                       in its current state of implementation.
    " @raising cx_rap_query_provider      | General failure. Must be raised if an error prevents successful query processing.

    TRY.
        TRY.
            " TODO: variable is assigned but never used (ABAP cleaner)
            DATA(lt_filter_cond) = io_request->get_parameters( ).
            DATA(filter_object) = io_request->get_filter( )->get_as_ranges( ).

            DATA(page_size) = io_request->get_paging( )->get_page_size( ).
            DATA(offset) = io_request->get_paging( )->get_offset( ).
            " TODO: variable is assigned but never used (ABAP cleaner)
            DATA(parameters) = io_request->get_parameters( ).
            DATA(sort_order)    = io_request->get_sort_elements( ).

            CASE io_request->get_entity_id( ).

              WHEN 'ZC_HCM_EMPLOYEE_SEARCHS'.

                TRY.
                    " --- Request data
                    IF io_request->is_data_requested( ).

                      DATA personal_data      TYPE hcm_employee_searchs.
                      DATA personal_data_aux  TYPE hcm_employee_searchs.
                      DATA interface_personal TYPE hcm_employee_searchs.

                      DATA(filter_personal_advanced) = io_request->get_filter( )->get_as_ranges( ).
                      DATA(filter_personal_string) = io_request->get_search_expression( ).

                      get_employee_search( EXPORTING user_name        = sy-uname " user_name
                                           CHANGING  employee_searchs = personal_data ).

                      "--- Filters
                      IF filter_personal_string IS NOT INITIAL.

                        CONCATENATE '*' filter_personal_string '*' INTO filter_personal_string.

                        personal_data_aux = personal_data.
                        CLEAR personal_data.

                        LOOP AT personal_data_aux INTO DATA(personal_structure) WHERE EmployeeNumber CP filter_personal_string OR LastName CP filter_personal_string OR EmployeeName CP filter_personal_string OR Dni CP filter_personal_string.
                          APPEND personal_structure TO personal_data.
                        ENDLOOP.

                      ENDIF.

                      "--- Filters Advanced
                      IF filter_personal_advanced IS NOT INITIAL.

                        LOOP AT filter_personal_advanced INTO DATA(filter_personal_u).

                          CASE filter_personal_u-name.
                            WHEN 'EMPLOYEENUMBER'.
                              DATA(filter_employeeNumber) = filter_personal_u-range.
                            WHEN 'EMPLOYEENAME'.
                              DATA(filter_vorna) = filter_personal_u-range.
                            WHEN 'LASTNAME'.
                              DATA(filter_nachn) = filter_personal_u-range.
                            WHEN 'DNI'.
                              DATA(filter_dni) = filter_personal_u-range.
                          ENDCASE.

                        ENDLOOP.

                        personal_data_aux = personal_data.
                        CLEAR personal_data.

                        LOOP AT personal_data_aux INTO DATA(personal_structure_2) WHERE EmployeeNumber IN filter_employeeNumber AND LastName IN filter_nachn AND EmployeeName IN filter_vorna AND Dni IN filter_dni.
                          APPEND personal_structure_2 TO personal_data.
                        ENDLOOP.

                      ENDIF.

                      " -- SORT

                      IF sort_order IS NOT INITIAL.

                        DATA(element_name_employee) = sort_order[ 1 ]-element_name.

                        IF sort_order[ 1 ]-descending = 'X'.
                          SORT personal_data BY (element_name_employee) DESCENDING.
                        ELSE.
                          SORT personal_data BY (element_name_employee).
                        ENDIF.

                      ENDIF.

                      " Fill response
                      DATA interface_personal_u LIKE LINE OF interface_personal.

                      IF page_size > 0.
                        LOOP AT personal_data INTO DATA(personal_u) FROM offset + 1 TO ( offset + page_size ).

                          MOVE-CORRESPONDING personal_u TO interface_personal_u.
                          APPEND interface_personal_u TO interface_personal.
                        ENDLOOP.
                      ELSE.
                        LOOP AT personal_data INTO personal_u.

                          MOVE-CORRESPONDING personal_u TO interface_personal_u.
                          APPEND interface_personal_u TO interface_personal.
                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( interface_personal ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( personal_data ) ).
                      ENDIF.

                    ENDIF.

                  CATCH cx_rfc_dest_provider_error INTO DATA(lx_dest). " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.
              WHEN 'ZC_HCM_REQUEST_LOAN'.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).

                      " Initialize values
                      DATA request_loans TYPE hcm_request_loan.
                      DATA request_loans_interface TYPE hcm_request_loan.
                      DATA action_solic_pres TYPE char1.

                      action_solic_pres = 'L'.

                      " Filters
                      DATA(filter_advanced) = io_request->get_filter( )->get_as_ranges( ).
                      DATA number_solic_pres TYPE ze_numsolpres.
                      DATA number_employee TYPE pernr_d.

                      IF filter_advanced IS NOT INITIAL.

                        LOOP AT filter_advanced INTO DATA(line_filter).

                          CASE line_filter-name.
                            WHEN 'LOANAPPNUMBER'.
                              number_solic_pres = line_filter-range[ 1 ]-low.
                              action_solic_pres = 'R'.
                            WHEN 'EMPLOYEENUMBER'.
                              number_employee = line_filter-range[ 1 ]-low.
                          ENDCASE.

                        ENDLOOP.

                      ENDIF.


                      manager_ztsolprestamo( EXPORTING action = action_solic_pres
                                                       numsol = number_solic_pres
                                                       num_employee = number_employee
                                             IMPORTING result_solici_prestamo = request_loans ).


                      " Fill response
                      DATA request_loan_interface LIKE LINE OF request_loans_interface.

                      IF page_size > 0.
                        LOOP AT request_loans INTO DATA(request_loan) FROM offset + 1 TO ( offset + page_size ).

                          MOVE-CORRESPONDING request_loan TO request_loan_interface.
                          APPEND request_loan_interface TO request_loans_interface.

                        ENDLOOP.
                      ELSE.
                        LOOP AT request_loans INTO request_loan.

                          MOVE-CORRESPONDING request_loan TO request_loan_interface.
                          APPEND request_loan_interface TO request_loans_interface.
                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( request_loans_interface ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( request_loans ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO lx_dest. " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.

              WHEN 'ZC_HCM_REASON_LOAN'.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).

                      " Initialize values
                      DATA reason_loans TYPE hcm_reason_loan.
                      DATA interface_reason_loans TYPE hcm_reason_loan.

                      " Filters
                      DATA(filter_reason_loan) = io_request->get_filter( )->get_as_ranges( ).
                      DATA employeeNumber TYPE pernr_d.

                      IF filter_reason_loan IS NOT INITIAL.

                        LOOP AT filter_reason_loan INTO DATA(line_filter_reason).

                          CASE line_filter_reason-name.
                            WHEN 'EMPLOYEENUMBER'.
                              employeeNumber = line_filter_reason-range[ 1 ]-low.
                          ENDCASE.

                        ENDLOOP.

                      ENDIF.


                      get_reason_loan( EXPORTING employee_number = employeeNumber
                                       IMPORTING reason_loans = reason_loans ).


                      " Fill response
                      DATA interface_reason_loan LIKE LINE OF interface_reason_loans.

                      IF page_size > 0.
                        LOOP AT reason_loans INTO DATA(reason_loan) FROM offset + 1 TO ( offset + page_size ).

                          MOVE-CORRESPONDING reason_loan TO interface_reason_loan.
                          APPEND interface_reason_loan TO interface_reason_loans.

                        ENDLOOP.
                      ELSE.
                        LOOP AT reason_loans INTO reason_loan.

                          MOVE-CORRESPONDING reason_loan TO interface_reason_loan.
                          APPEND interface_reason_loan TO interface_reason_loans.
                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( interface_reason_loans ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( reason_loans ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO lx_dest. " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.

              WHEN 'ZC_HCM_TERMS_COND'.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).

                      " Initialize values
                      DATA terms_conds TYPE hcm_terms_cond.
                      DATA interface_terms_conds TYPE hcm_terms_cond.

                      get_terms_cond( IMPORTING terms_cond = terms_conds ).


                      " Fill response
                      DATA interface_terms_cond LIKE LINE OF interface_terms_conds.

                      IF page_size > 0.
                        LOOP AT terms_conds INTO DATA(terms_cond) FROM offset + 1 TO ( offset + page_size ).

                          MOVE-CORRESPONDING terms_cond TO interface_terms_cond.
                          APPEND interface_terms_cond TO interface_terms_conds.

                        ENDLOOP.
                      ELSE.
                        LOOP AT terms_conds INTO terms_cond.

                          MOVE-CORRESPONDING terms_cond TO interface_terms_cond.
                          APPEND interface_terms_cond TO interface_terms_conds.
                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( interface_terms_conds ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( terms_conds ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO lx_dest. " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.

              WHEN 'ZC_HCM_EMPLOYEE_INFO'.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).

                      " Initialize values
                      DATA employee_infos TYPE hcm_employee_info.
                      DATA interface_employee_infos TYPE hcm_employee_info.

                      " Filters
                      DATA(filter_employee_info) = io_request->get_filter( )->get_as_ranges( ).
                      DATA employNumber TYPE pernr_d.

                      IF filter_employee_info IS NOT INITIAL.

                        LOOP AT filter_employee_info INTO DATA(line_filter_emp_info).

                          CASE line_filter_emp_info-name.
                            WHEN 'EMPLOYEENUMBER'.
                              employNumber = line_filter_emp_info-range[ 1 ]-low.
                          ENDCASE.

                        ENDLOOP.

                      ENDIF.

                      get_employee_info( EXPORTING employee_number = employNumber
                                         IMPORTING employee_info = employee_infos ).

                      " Fill response
                      DATA interface_employee_info LIKE LINE OF interface_employee_infos.

                      IF page_size > 0.
                        LOOP AT employee_infos INTO DATA(employee_info) FROM offset + 1 TO ( offset + page_size ).

                          MOVE-CORRESPONDING employee_info TO interface_employee_info.
                          APPEND interface_employee_info TO interface_employee_infos.

                        ENDLOOP.
                      ELSE.
                        LOOP AT employee_infos INTO employee_info.

                          MOVE-CORRESPONDING employee_info TO interface_employee_info.
                          APPEND interface_employee_info TO interface_employee_infos.
                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( interface_employee_infos ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( employee_infos ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO lx_dest. " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.

              WHEN 'ZC_HCM_COLLABORATOR_COND'.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).

                      " Initialize values
                      DATA collaborator_conds TYPE hcm_collaborator_cond.
                      DATA interface_collaborator_conds TYPE hcm_collaborator_cond.

                      " Filters
                      DATA(filter_collaborator_cond) = io_request->get_filter( )->get_as_ranges( ).
                      DATA employ_number TYPE pernr_d.

                      IF filter_collaborator_cond IS NOT INITIAL.

                        LOOP AT filter_collaborator_cond INTO DATA(line_filter_collaborator_cond).

                          CASE line_filter_collaborator_cond-name.
                            WHEN 'EMPLOYEENUMBER'.
                              employ_number = line_filter_collaborator_cond-range[ 1 ]-low.
                          ENDCASE.

                        ENDLOOP.

                      ENDIF.

                      get_collaborator_cond( EXPORTING employee_number = employ_number
                                         IMPORTING collaborator_cond = collaborator_conds ).

                      " Fill response
                      DATA interface_collaborator_cond LIKE LINE OF interface_collaborator_conds.

                      IF page_size > 0.
                        LOOP AT collaborator_conds INTO DATA(collaborator_cond) FROM offset + 1 TO ( offset + page_size ).

                          MOVE-CORRESPONDING collaborator_cond TO interface_collaborator_cond.
                          APPEND interface_collaborator_cond TO interface_collaborator_conds.

                        ENDLOOP.
                      ELSE.
                        LOOP AT collaborator_conds INTO collaborator_cond.

                          MOVE-CORRESPONDING collaborator_cond TO interface_collaborator_cond.
                          APPEND interface_collaborator_cond TO interface_collaborator_conds.
                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( interface_collaborator_conds ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( collaborator_conds ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO lx_dest. " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.

              WHEN 'ZC_HCM_HISTORY_LOAN'.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).

                      " Initialize values
                      DATA history_loans TYPE hcm_history_loan.
                      DATA interface_history_loans TYPE hcm_history_loan.

                      " Filters
                      DATA(filter_history_loan) = io_request->get_filter( )->get_as_ranges( ).
                      DATA employ_number_hist TYPE pernr_d.

                      IF filter_history_loan IS NOT INITIAL.

                        LOOP AT filter_history_loan INTO DATA(line_filter_history_loan).

                          CASE line_filter_history_loan-name.
                            WHEN 'EMPLOYEENUMBER'.
                              employ_number_hist = line_filter_history_loan-range[ 1 ]-low.
                          ENDCASE.

                        ENDLOOP.

                      ENDIF.

                      get_history_loan( EXPORTING employee_number = employ_number_hist
                                         IMPORTING history_loan = history_loans ).

                      " Fill response
                      DATA interface_history_loan LIKE LINE OF interface_history_loans.

                      IF page_size > 0.
                        LOOP AT history_loans INTO DATA(history_loan) FROM offset + 1 TO ( offset + page_size ).

                          MOVE-CORRESPONDING history_loan TO interface_history_loan.
                          APPEND interface_history_loan TO interface_history_loans.

                        ENDLOOP.
                      ELSE.
                        LOOP AT history_loans INTO history_loan.

                          MOVE-CORRESPONDING history_loan TO interface_history_loan.
                          APPEND interface_history_loan TO interface_history_loans.
                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( interface_history_loans ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( history_loans ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO lx_dest. " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.

              WHEN 'ZC_HCM_CALCULATE_LOAN'.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).

                      " Initialize values
                      DATA calculate_loans TYPE hcm_calculate_loan.
                      DATA interface_calculate_loans TYPE hcm_calculate_loan.

                      " Filters
                      DATA(filter_calc_loan) = io_request->get_filter( )->get_as_ranges( ).

                      DATA filterMonto TYPE ze_monto_prestamo.
                      DATA filterMotivo TYPE dlart.
                      DATA filterNumCuota TYPE ze_numcuota.

                      IF filter_calc_loan IS NOT INITIAL.

                        LOOP AT filter_calc_loan INTO DATA(line_filter_calc_loan).

                          CASE line_filter_calc_loan-name.
                            WHEN 'LOANAMOUNT'.
                              filterMonto = line_filter_calc_loan-range[ 1 ]-low.
                            WHEN 'LOANTYPE'.
                              filterMotivo = line_filter_calc_loan-range[ 1 ]-low.
                            WHEN 'QUOTANUMBERS'.
                              filterNumCuota = line_filter_calc_loan-range[ 1 ]-low.
                          ENDCASE.

                        ENDLOOP.

                      ENDIF.

                      get_calculate_loan( EXPORTING monto = filterMonto
                                                    motivo = filterMotivo
                                                    nr_couta = filterNumCuota
                                         IMPORTING calulate_loan = calculate_loans ).

                      " Fill response
                      DATA interface_calculate_loan LIKE LINE OF interface_calculate_loans.

                      IF page_size > 0.
                        LOOP AT calculate_loans INTO DATA(calculate_loan) FROM offset + 1 TO ( offset + page_size ).

                          MOVE-CORRESPONDING calculate_loan TO interface_calculate_loan.
                          APPEND interface_calculate_loan TO interface_calculate_loans.

                        ENDLOOP.
                      ELSE.
                        LOOP AT calculate_loans INTO calculate_loan.

                          MOVE-CORRESPONDING calculate_loan TO interface_calculate_loan.
                          APPEND interface_calculate_loan TO interface_calculate_loans.
                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( interface_calculate_loans ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( calculate_loans ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO lx_dest. " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.

              WHEN 'ZC_HCM_APPROV_REJECT_LOAN'.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).

                      " Initialize values
                      DATA approv_rej_loans TYPE hcm_approv_reject_loan.
                      DATA interface_approv_rej_loans TYPE hcm_approv_reject_loan.

                      " Filters
                      DATA(filter_loan_apr) = io_request->get_filter( )->get_as_ranges( ).

                      DATA filterNumberLoan TYPE ze_numsolpres.

                      IF filter_loan_apr IS NOT INITIAL.

                        LOOP AT filter_loan_apr INTO DATA(line_filter_loan_apr).

                          CASE line_filter_loan_apr-name.
                            WHEN 'LOANAPPNUMBER'.
                              filterNumberLoan = line_filter_loan_apr-range[ 1 ]-low.
                          ENDCASE.

                        ENDLOOP.

                      ENDIF.

                      get_aprov_reject_loan( EXPORTING input_number_loan = filterNumberLoan
                                             IMPORTING output_loan_ap_re = approv_rej_loans ).


                      " Fill response
                      DATA interface_approv_rej_loan LIKE LINE OF interface_approv_rej_loans.

                      IF page_size > 0.
                        LOOP AT approv_rej_loans INTO DATA(approv_rej_loan) FROM offset + 1 TO ( offset + page_size ).

                          MOVE-CORRESPONDING approv_rej_loan TO interface_approv_rej_loan.
                          APPEND interface_approv_rej_loan TO interface_approv_rej_loans.

                        ENDLOOP.
                      ELSE.
                        LOOP AT approv_rej_loans INTO approv_rej_loan.

                          MOVE-CORRESPONDING approv_rej_loan TO interface_approv_rej_loan.
                          APPEND interface_approv_rej_loan TO interface_approv_rej_loans.
                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( interface_approv_rej_loans ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( approv_rej_loans ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO lx_dest. " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.

               WHEN 'ZC_HCM_EMPLOYEE_DATA_INIT'.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).

                      " Initialize values
                      DATA employee_data_inits TYPE hcm_employee_data_init.
                      DATA interface_employee_data_inits TYPE hcm_employee_data_init.

                      " Filters
                      DATA(filter_employee) = io_request->get_filter( )->get_as_ranges( ).

                      DATA filterEmployeeNumber TYPE pernr_d.

                      IF filter_employee IS NOT INITIAL.

                        LOOP AT filter_employee INTO DATA(line_filter_employee).

                          CASE line_filter_employee-name.
                            WHEN 'EMPLOYEENUMBER'.
                              filterEmployeeNumber = line_filter_employee-range[ 1 ]-low.
                          ENDCASE.

                        ENDLOOP.

                      ENDIF.

                      DATA interface_employee_data_init LIKE LINE OF interface_employee_data_inits.

                      interface_employee_data_init-EmployeeNumber = filterEmployeeNumber.

                      get_data_init_loan_admin( EXPORTING lv_nr_emp = filterEmployeeNumber
                                                IMPORTING lv_moneda = interface_employee_data_init-Currency
                                                          lv_dni_emp = interface_employee_data_init-EmployeeDni
                                                          lv_codmon  = interface_employee_data_init-CurrencyKey
                                                          ).

                      APPEND interface_employee_data_init TO interface_employee_data_inits.

                      io_response->set_data( interface_employee_data_inits ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( interface_employee_data_inits ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO lx_dest. " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.


            ENDCASE.
          CATCH cx_rap_query_filter_no_range.
        ENDTRY.
      CATCH cx_rap_query_provider.
    ENDTRY.
  ENDMETHOD.


  METHOD manager_ztsolprestamo.

    DATA: import_solpres          TYPE zwsolprestamo.
    DATA: import_number_solpres   TYPE ze_numsolpres.
    DATA: import_pernr            TYPE pernr_d.

    IF request_loan IS NOT INITIAL.

      DATA: gs_constantsn TYPE REF TO zbc_constants_admin_n.
      DATA: const_dia_cierre TYPE zva_zbcranv_n.

      TRY.
          CREATE OBJECT gs_constantsn
            EXPORTING
*             pi_repid = sy-repid.  "Actualizar en la ZBCP0001
              pi_repid = 'SAPLZHRG0016'.
        CATCH cx_alert_unknown .                        "#EC NO_HANDLER
      ENDTRY.

      " FECHA CIERRE CONSTANTE ---------------------------------------------
      " --------------------------------------------------------------------
      DATA: fecha_cierre TYPE char2.

      CALL METHOD gs_constantsn->get_first_value_range_n
        EXPORTING
          pi_rangeid     = '0000000080'
          pi_bukrs       = '*'
        IMPORTING
          pe_first_value = const_dia_cierre.

      fecha_cierre = const_dia_cierre-rangeid.

      DATA: fecha_fin_pago TYPE ze_finpago.
      DATA: fecha_inicio_amort TYPE ze_fec_sol.
      DATA: cuota_grt TYPE ze_imp_cuota_grati.
      DATA: cuota_sim TYPE ze_imp_cuota_simple.

      calcular_prestamo( EXPORTING
                            fecha_cierre = fecha_cierre
                            monto        = request_loan[ 1 ]-LoanAmount
                            nr_cuota     = request_loan[ 1 ]-QuotaNumbers
                         CHANGING
                            cuota_sim = cuota_sim
                            cuota_grt = cuota_grt
                            fecha_fin = fecha_fin_pago
                            fecha_ini = fecha_inicio_amort
                         ).
      date_init_amort = fecha_inicio_amort.
      date_fin_pago   = fecha_fin_pago.


      import_solpres-znumsp     = request_loan[ 1 ]-LoanAppNumber.
      import_solpres-pernr      = request_loan[ 1 ]-EmployeeNumber.
      import_solpres-dlart      = request_loan[ 1 ]-LoanType.
      import_solpres-zmonpr     = request_loan[ 1 ]-LoanAmount.
      import_solpres-waers      = request_loan[ 1 ]-CurrencyKey.
      import_solpres-zimpcs     = request_loan[ 1 ]-QuotaAmountSimple.
      import_solpres-zimpcg     = request_loan[ 1 ]-QuotaAmountGrat.
      import_solpres-zncuot     = request_loan[ 1 ]-QuotaNumbers.
      import_solpres-zfecfp     = fecha_fin_pago.
      import_solpres-zcomen     = request_loan[ 1 ]-CommentLoan.
      import_solpres-zususl     = sy-uname.
      import_solpres-zfecsl     = sy-datum.
      import_solpres-zusuaproju = request_loan[ 1 ]-UserAppBossU.
      import_solpres-zfecaproju = request_loan[ 1 ]-DateAppBossU.
      import_solpres-zusuaprojd = request_loan[ 1 ]-UserAppBossD.
      import_solpres-zfecaprojd = request_loan[ 1 ]-DateAppBossD.
      import_solpres-zusuaproap = request_loan[ 1 ]-UserAppAdminP.
      import_solpres-zfecaproap = request_loan[ 1 ]-DateAppAdminP.
      import_solpres-ztrang     = request_loan[ 1 ]-TransgressionInd.
      import_solpres-zmsjtrangr = request_loan[ 1 ]-TransgressionMes.
      import_solpres-zestap     = request_loan[ 1 ]-StatusAppAdminP.
      import_solpres-zestjd     = request_loan[ 1 ]-StatusAppBossD.
      import_solpres-zestju     = request_loan[ 1 ]-StatusAppBossU.
      IF action EQ 'S' .
        import_solpres-zestju = '1'.
      ENDIF.
      import_solpres-dni        = request_loan[ 1 ]-DNINumber.
      import_solpres-mail       = request_loan[ 1 ]-Mail.
      import_solpres-obs        = request_loan[ 1 ]-Obs.
      import_solpres-terycond   = request_loan[ 1 ]-TermsConditions.

      import_pernr          = request_loan[ 1 ]-EmployeeNumber.

    ENDIF.

    import_number_solpres = numsol.

    IF import_pernr IS INITIAL.

      " Obtención del Nro Empleado
      CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
        EXPORTING
          id             = sy-uname
          begindate      = sy-datum
          enddate        = sy-datum
        IMPORTING
          employeenumber = import_pernr.

    ENDIF.

    IF num_employee IS NOT INITIAL.
      import_pernr = num_employee.
    ENDIF.

    DATA: result_solpres      TYPE zwsolprestamo.

    DATA: result_prestamo   TYPE STANDARD TABLE OF pa0045.
    DATA: result_prestamo2  TYPE STANDARD TABLE OF ztsolprestamo.
    DATA: result_prestamo3  TYPE STANDARD TABLE OF pa0078.

    CALL FUNCTION 'Z_HR_RFC_MANAGER_ZTSOLPRESTAMO' DESTINATION 'NONE'
      EXPORTING
        ip_accion    = action
        iw_solpres   = import_solpres
        ip_numsol    = import_number_solpres
        i_pernr      = import_pernr
      IMPORTING
        ew_solpres   = result_solpres
        ep_numsol    = result_num_prestamo
        ep_mensaje   = ep_mensaje
      TABLES
        t_prestamos  = result_prestamo
        t_prestamos2 = result_prestamo2
        t_prestamos3 = result_prestamo3.


    DATA: line_result_prestamo2 LIKE LINE OF result_prestamo2.
    DATA: line_result_solici_pres LIKE LINE OF result_solici_prestamo.

    IF action EQ 'R'.

      line_result_solici_pres-LoanAppNumber       = result_solpres-znumsp.
      line_result_solici_pres-EmployeeNumber      = result_solpres-pernr.
      line_result_solici_pres-LoanType            = result_solpres-dlart.
      line_result_solici_pres-LoanAmount          = result_solpres-zmonpr.
      line_result_solici_pres-CurrencyKey         = result_solpres-waers.
      line_result_solici_pres-QuotaAmountSimple   = result_solpres-zimpcs.
      line_result_solici_pres-QuotaAmountGrat     = result_solpres-zimpcg.
      line_result_solici_pres-QuotaNumbers        = result_solpres-zncuot.
      line_result_solici_pres-PaymentEndDate      = result_solpres-zfecfp.
      line_result_solici_pres-CommentLoan         = result_solpres-zcomen.
      line_result_solici_pres-ReqUser             = result_solpres-zususl.
      line_result_solici_pres-ReqDate             = result_solpres-zfecsl.
      line_result_solici_pres-UserAppBossU        = result_solpres-zusuaproju.
      line_result_solici_pres-DateAppBossU        = result_solpres-zfecaproju.
      line_result_solici_pres-UserAppBossD        = result_solpres-zusuaprojd.
      line_result_solici_pres-DateAppBossD        = result_solpres-zfecaprojd.
      line_result_solici_pres-UserAppAdminP       = result_solpres-zusuaproap.
      line_result_solici_pres-DateAppAdminP       = result_solpres-zfecaproap.
      line_result_solici_pres-TransgressionInd    = result_solpres-ztrang .
      line_result_solici_pres-TransgressionMes    = result_solpres-zmsjtrangr.
      line_result_solici_pres-StatusAppAdminP     = result_solpres-zestap .
      line_result_solici_pres-StatusAppBossD      = result_solpres-zestjd .
      line_result_solici_pres-StatusAppBossU      = result_solpres-zestju.
      line_result_solici_pres-DNINumber           = result_solpres-dni.
      line_result_solici_pres-Mail                = result_solpres-mail.
      line_result_solici_pres-Obs                 = result_solpres-obs.
      line_result_solici_pres-TermsConditions     = result_solpres-terycond.

      get_data_init_loan_admin( EXPORTING lv_nr_emp = result_solpres-pernr
                                IMPORTING
                                          lv_moneda  = line_result_solici_pres-Currency
                                          lv_dni_emp = line_result_solici_pres-DNINumber
                                          lv_codmon  = line_result_solici_pres-CurrencyKey
                                               ).

      APPEND line_result_solici_pres TO result_solici_prestamo.

    ELSE.

      LOOP AT result_prestamo2 INTO line_result_prestamo2.

        CLEAR:line_result_solici_pres.

        line_result_solici_pres-LoanAppNumber       = line_result_prestamo2-znumsp.
        line_result_solici_pres-EmployeeNumber      = line_result_prestamo2-pernr.
        line_result_solici_pres-LoanType            = line_result_prestamo2-dlart.
        line_result_solici_pres-LoanAmount          = line_result_prestamo2-zmonpr.
        line_result_solici_pres-CurrencyKey         = line_result_prestamo2-waers.
        line_result_solici_pres-QuotaAmountSimple   = line_result_prestamo2-zimpcs.
        line_result_solici_pres-QuotaAmountGrat     = line_result_prestamo2-zimpcg.
        line_result_solici_pres-QuotaNumbers        = line_result_prestamo2-zncuot.
        line_result_solici_pres-PaymentEndDate      = line_result_prestamo2-zfecfp.
        line_result_solici_pres-CommentLoan         = line_result_prestamo2-zcomen.
        line_result_solici_pres-ReqUser             = line_result_prestamo2-zususl.
        line_result_solici_pres-ReqDate             = line_result_prestamo2-zfecsl.
        line_result_solici_pres-UserAppBossU        = line_result_prestamo2-zusuaproju.
        line_result_solici_pres-DateAppBossU        = line_result_prestamo2-zfecaproju.
        line_result_solici_pres-UserAppBossD        = line_result_prestamo2-zusuaprojd.
        line_result_solici_pres-DateAppBossD        = line_result_prestamo2-zfecaprojd.
        line_result_solici_pres-UserAppAdminP       = line_result_prestamo2-zusuaproap.
        line_result_solici_pres-DateAppAdminP       = line_result_prestamo2-zfecaproap.
        line_result_solici_pres-TransgressionInd    = line_result_prestamo2-ztrang .
        line_result_solici_pres-TransgressionMes    = line_result_prestamo2-zmsjtrangr.
        line_result_solici_pres-StatusAppAdminP     = line_result_prestamo2-zestap .
        line_result_solici_pres-StatusAppBossD      = line_result_prestamo2-zestjd .
        line_result_solici_pres-StatusAppBossU      = line_result_prestamo2-zestju.
        line_result_solici_pres-DNINumber           = line_result_prestamo2-dni.
        line_result_solici_pres-Mail                = line_result_prestamo2-mail.
        line_result_solici_pres-Obs                 = line_result_prestamo2-obs.
        line_result_solici_pres-TermsConditions     = line_result_prestamo2-terycond.
        line_result_solici_pres-CreatedName         = line_result_prestamo2-cname.
        line_result_solici_pres-CreatedDate         = line_result_prestamo2-cdate.
        line_result_solici_pres-CreatedTime         = line_result_prestamo2-ctime.
        line_result_solici_pres-ModName             = line_result_prestamo2-uname.
        line_result_solici_pres-ModDate             = line_result_prestamo2-udate.
        line_result_solici_pres-ModTime             = line_result_prestamo2-utime.

        get_data_init_loan_admin( EXPORTING lv_nr_emp = line_result_prestamo2-pernr
                                  IMPORTING
                                            lv_moneda  = line_result_solici_pres-Currency
                                            lv_dni_emp = line_result_solici_pres-DNINumber
                                            lv_codmon  = line_result_solici_pres-CurrencyKey
                                       ).

        APPEND line_result_solici_pres TO result_solici_prestamo.


      ENDLOOP.

    ENDIF.


  ENDMETHOD.


  METHOD calcular_prestamo.

    DATA: lv_nrcuota         TYPE ze_numcuota,
          lv_monto           TYPE ze_monto_prestamo,
          lv_imp_sim         TYPE ze_imp_cuota_simple,
          lv_imp_sim_aux     TYPE ze_imp_cuota_simple,
          lv_imp_round(20)   TYPE c,
          lv_imp_grt         TYPE ze_imp_cuota_grati,
          lv_fecha_inicio    TYPE sy-datum,
          lv_fecha_fin       TYPE sy-datum,
          lv_fecha_cierre(2) TYPE c,
          lv_cont            TYPE sy-tabix,
          lv_index           TYPE sy-tabix,
          lv_index_nex       TYPE sy-tabix,
          lv_flag_grt        TYPE c.

    TYPES: BEGIN OF lty_fechas ,
             fecha TYPE sy-datum,
           END OF lty_fechas.
    DATA: ls_fechas     TYPE lty_fechas,
          ls_fechas_nex TYPE lty_fechas,
          ls_fechas_aux TYPE lty_fechas,
          lt_fechas     TYPE TABLE OF lty_fechas,
          lt_fechas_aux TYPE TABLE OF lty_fechas.

    lv_nrcuota = nr_cuota.
    lv_monto = monto.
    lv_fecha_cierre = fecha_cierre.
    CHECK lv_nrcuota GT 0 AND lv_monto GT 0. " validar que se hayan ingresado montos y cuotas
* calcular importe de la cuota

    IF lv_monto GT 0 AND lv_nrcuota GT 0.
      lv_imp_sim = lv_monto / lv_nrcuota.
      lv_imp_sim_aux = lv_imp_sim * lv_nrcuota.
      lv_imp_sim_aux = lv_imp_sim_aux - lv_monto.
      IF lv_imp_sim_aux LT 0.
        lv_imp_sim_aux = lv_imp_sim * 100.
        lv_imp_sim_aux = lv_imp_sim_aux  + 1.
        lv_imp_sim = lv_imp_sim_aux / 100.
      ENDIF.
    ENDIF.
* calcular fecha inicio y fin de amortizacion

*  IF fecha_ini(6) NE sy-datum(6). " en caso de que ya se haya hecho este calculo de fecha fin
    fecha_ini = sy-datum.
*  ENDIF.
    lv_fecha_inicio = fecha_ini.
    IF lv_fecha_inicio+6(2) LE lv_fecha_cierre.

      CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
        EXPORTING
          day_in            = lv_fecha_inicio
        IMPORTING
          last_day_of_month = lv_fecha_inicio
        EXCEPTIONS
          day_in_no_date    = 1
          OTHERS            = 2.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
    ELSE.
      lv_fecha_inicio+6(2) = '01'.
      CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
        EXPORTING
          months  = '001'
          olddate = lv_fecha_inicio
        IMPORTING
          newdate = lv_fecha_inicio.
    ENDIF.

    lv_fecha_fin = lv_fecha_inicio.
    CLEAR ls_fechas.
    ls_fechas-fecha = lv_fecha_fin.
    APPEND ls_fechas TO lt_fechas.
    lv_nrcuota = lv_nrcuota - 1.

    DO lv_nrcuota TIMES.
      CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
        EXPORTING
          months  = '001'
          olddate = ls_fechas-fecha
        IMPORTING
          newdate = ls_fechas-fecha.
      IF sy-datum+6(2) LE lv_fecha_cierre.
        CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
          EXPORTING
            day_in            = ls_fechas-fecha
          IMPORTING
            last_day_of_month = ls_fechas-fecha
          EXCEPTIONS
            day_in_no_date    = 1
            OTHERS            = 2.
        IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
        ENDIF.
      ENDIF.
      APPEND ls_fechas TO lt_fechas.
    ENDDO.

*  lt_fechas_aux[] = ls_fechas[].

    DESCRIBE TABLE lt_fechas LINES lv_cont.
    READ TABLE lt_fechas INTO ls_fechas INDEX lv_cont.
    IF sy-subrc EQ 0.
      lv_fecha_fin = ls_fechas-fecha.
    ENDIF.
    CLEAR lv_index.
    WHILE lv_index LE lv_cont.
      ADD 1 TO lv_index.
      CHECK lv_index LE lv_cont.
      lv_index_nex = lv_index.
      ADD 1 TO lv_index_nex.
      READ TABLE lt_fechas INTO ls_fechas INDEX lv_index.
      IF sy-subrc EQ 0.
        CASE ls_fechas+4(2).
          WHEN '07' OR '12'.
            READ TABLE lt_fechas INTO ls_fechas_nex INDEX lv_index_nex.
            IF sy-subrc EQ 0.
              IF lv_index EQ 1 AND ls_fechas+6(2) EQ '01'.
                DELETE lt_fechas INDEX lv_cont.
                SUBTRACT 1 FROM lv_cont.
                lv_imp_grt = lv_imp_sim.
              ELSEIF lv_index GT 1.
                DELETE lt_fechas INDEX lv_cont.
                SUBTRACT 1 FROM lv_cont.
                lv_imp_grt = lv_imp_sim.
              ENDIF.
            ENDIF.
        ENDCASE.
      ENDIF.
    ENDWHILE.
    READ TABLE lt_fechas INTO ls_fechas INDEX lv_cont.
    IF sy-subrc EQ 0.
      lv_fecha_fin = ls_fechas-fecha.
    ENDIF.
    fecha_ini = lv_fecha_inicio.
    fecha_fin = lv_fecha_fin.
    cuota_sim = lv_imp_sim.
    cuota_grt = lv_imp_grt.

  ENDMETHOD.


  METHOD save_general.

* controladores y componentes
    DATA:
      lv_node      TYPE REF TO if_wd_context_node,
      lv_node_info TYPE REF TO if_wd_context_node_info.

    DATA: lv_bool_field TYPE wdy_boolean,
          lv_bool_but1  TYPE wdy_boolean,
          lv_bool_but2  TYPE wdy_boolean.
*** datos del prestamo

    DATA: lv_nrcuota        TYPE ze_numcuota,
          lv_monto          TYPE ze_monto_prestamo,
          lv_imp_sim        TYPE ze_imp_cuota_simple,
          lv_imp_grt        TYPE ze_imp_cuota_grati,
          lv_motivo         TYPE dlart,
          lv_fecha_inicio   TYPE sy-datum,
          lv_fecha_fin      TYPE sy-datum,
          lv_comentario     TYPE ze_comenprest,
          lv_motivodesc     TYPE sbttx,
          lv_rel_lab        TYPE ansvh,
          lv_area_per       TYPE persk,
          lv_fecha_fin_cont TYPE ctedt,
          lv_montoend       TYPE ze_monto,
          lv_saldo          TYPE maxbt,
          lv_timsv          TYPE intdays,
          lv_remu           TYPE maxbt,
          lv_trangr         TYPE ze_trangresion,
          lv_nr_maxpres     TYPE ze_numcuota,
          lv_montoend2      TYPE maxbt,
          lv_nr_emp         TYPE bapiusr01-employeeno,
          lv_status         TYPE wdy_boolean,
          lv_action         TYPE c, " 1 Grabar, 2 Aprobar, 3 Rechazar, 4 Devolver
          lv_fecha_cierre   TYPE char2,
          lv_trangr_msg     TYPE ze_msjtransgre,
          lv_jefe_flag      TYPE flag,
          lv_nivel          TYPE c.


    CONSTANTS: c_mark(1)    VALUE 'X', " True
               c_iconch(11) VALUE 'ICON_CHANGE',
               c_txtedi(9)  VALUE 'Modificar',
               gc_sty045    TYPE infty VALUE '0045'.

* APP Node Accion
    lv_action =  action.
* lv_node = wd_context->get_child_node( name = `APP_NODE` ).
* lv_node->set_attribute( EXPORTING name = 'ACTION_AP'  value = lv_action  ).
* lv_node->get_attribute( EXPORTING name = 'NIVEL_AP' IMPORTING value = lv_nivel  ).

*   datos del prestamo del empleado

* lv_node = wd_context->get_child_node( name = `PRESTAMO_NODE` ).
* lv_node_info = lv_node->get_node_info( ).
    lv_nrcuota          = nr_cuota.
    lv_monto            = monto.
    lv_motivo           = motivo.
    lv_nr_emp           = nr_emp.
    lv_montoend         = monto_end.
    lv_rel_lab          = re_lab.
    lv_fecha_fin_cont   = fecha_fin_cont.
    lv_fecha_inicio     = fecha_inicio.
    lv_nr_maxpres       = nr_cuota_max.
    lv_area_per         = area_per.
    lv_fecha_cierre     = fecha_cierre.
    lv_jefe_flag        = jefe_flag.
    lv_nivel            = nivel.

* obtener descripcion del motivo

    SELECT SINGLE stext INTO lv_motivodesc
           FROM t591s
           WHERE sprsl EQ sy-langu
             AND infty EQ gc_sty045
             AND subty EQ lv_motivo.

* calcular monto de prestamo

    me->calcular_prestamo( EXPORTING
                                 nr_cuota       = lv_nrcuota
                                 monto          = lv_monto
                                 fecha_cierre   = lv_fecha_cierre
                            CHANGING
                                 cuota_sim      = lv_imp_sim
                                 cuota_grt      = lv_imp_grt
                                 fecha_ini      = lv_fecha_inicio
                                 fecha_fin      = lv_fecha_fin ).

** validaciones de prestamo
    DATA: table_message TYPE STANDARD TABLE OF string.
    DATA: table_msg    TYPE hcm_msg.
    me->validar_solicitud( EXPORTING
                                 nivel          = lv_nivel
                                 jefe_ju        = lv_jefe_flag
                                 action         = lv_action
                                 rel_lab        = lv_rel_lab
                                 fecha_cierre   = lv_fecha_cierre
                                 area_per       = lv_area_per
                                 fecha_fin      = lv_fecha_fin
                                 fecha_fin_cont = lv_fecha_fin_cont
                                 monto          = lv_monto
                                 montoend       = lv_montoend
                                 nr_maxpres     = lv_nr_maxpres
                                 nr_emp         = lv_nr_emp
                                 nr_cuota       = lv_nrcuota
                                 motivo         = lv_motivo
                            IMPORTING
                                  table_message = table_message
                                  table_msg = table_msg
                            CHANGING
                                  trangr        = trangr
                                  trangr_msg    = trangr_msg ).


    DATA: isError Type Char1.

    isError = 'A'.

    IF table_msg IS NOT INITIAL.
        LOOP AT table_msg INTO DATA(msg_error).
            IF msg_error-tipo EQ 'E'.
               isError = 'E'.
            ENDIF.
        ENDLOOP.
    ENDIF.

    IF isError EQ 'A'.
** Aprobar prestamo

      DATA: output_icon TYPE string.
      DATA: output_message TYPE string.

      me->approv_loan(  EXPORTING aprov_reject_loan = aprov_reject_loan
                        IMPORTING icon = output_icon
                                  message = output_message ).

      IF output_icon EQ 'ICON_SYSTEM_OKAY'.

        trangr = 'S'.
        trangr_msg = output_message.

      ELSE.

        trangr = 'E'.
        trangr_msg = output_message.

      ENDIF.

    ELSE.

      LOOP AT table_msg INTO DATA(line_msg).
        trangr = line_msg-tipo.
        trangr_msg = line_msg-msg.
      ENDLOOP.


    ENDIF.


  ENDMETHOD.


  METHOD validar_solicitud.

    TYPES: BEGIN OF lty_msg,
             tipo(1) TYPE c,
             msg     TYPE string,
           END OF lty_msg.

    DATA: lv_monto          TYPE ze_monto_prestamo,
          lv_montoend       TYPE ze_monto,
          lt_mensaje        TYPE TABLE OF string,
          ls_mensaje        LIKE LINE OF lt_mensaje,
          ls_mensaje2       TYPE string,
          ls_mensaje3       TYPE string,
          lv_fecha_fin      TYPE sy-datum,
          lv_fecha_fin_cont TYPE sy-datum,
          lv_fecha_for(10)  TYPE c, " formateo de fecha
          lv_area_per       TYPE persk,
          lv_nr_emp         TYPE pernr_d,
          lv_num_pres       TYPE i,
          lv_num_max        TYPE i,
          lv_num_maxc(3)    TYPE c,
          lv_fini           TYPE rdir_cdate,
          lv_ffin           TYPE rdir_cdate,
          lv_date           TYPE sy-datum,
          lv_year(4)        TYPE n,
          lv_button_op      TYPE wdr_popup_button_kind,
          lv_error_flg      TYPE c,
          lv_trangr         TYPE ze_trangresion,
          lv_motivo         TYPE dlart,
          lv_nr_cuota       TYPE ze_numcuota,
          lv_fecha_cierre   TYPE char2,
          lv_rel_lab        TYPE ansvh,
          lv_msgtrang       TYPE string,
          lv_action         TYPE c,
          lv_jefe_flag      TYPE flag,
          lv_nivel          TYPE c.
***
    DATA: lv_periodo TYPE t549q-pabrp,
          lv_ano     TYPE t549q-pabrj.
***
    DATA: ltd_rt_saldo  TYPE STANDARD TABLE OF pc207,
          ltd_rtx_saldo TYPE STANDARD TABLE OF zpc207,
          ltd_v0_saldo  TYPE STANDARD TABLE OF pc20c.
***
    DATA lo_window_manager TYPE REF TO if_wd_window_manager.
    DATA lo_api_component  TYPE REF TO if_wd_component.
    DATA: lo_window   TYPE REF TO if_wd_window,
          lv_messtype TYPE wdr_popup_msg_type.
    DATA lo_api_start_view TYPE REF TO if_wd_view_controller.

    DATA: lv_node      TYPE REF TO if_wd_context_node,
          lv_node_info TYPE REF TO if_wd_context_node_info.

    DATA: lt_msg TYPE TABLE OF lty_msg,
          ls_msg TYPE lty_msg.

    CONSTANTS: c_pf(2)      VALUE 'PF', " Plazo Fijo
               c_area_gf(2) VALUE 'GF', " Gerente
               c_area_ge(2) VALUE 'GE', " Gerente
               c_error(1)   VALUE 'E', " Error
               c_trang(1)   VALUE 'X', " trnasgresion
               c_9105(4)    VALUE '9105'. " Dia de la madre

    DATA:  wd_assist TYPE REF TO zhr_prest_admin_txt.
    wd_assist = NEW #( ).

    DATA: lo_constant TYPE REF TO zbc_constants_admin,
          lr_subty    TYPE RANGE OF subty.

    TRY.
        CREATE OBJECT lo_constant
          EXPORTING
            ps_repid = 'ZHR_PREST_ADMIN'.
      CATCH zcx_programa_desconocido.
    ENDTRY.

    CALL METHOD lo_constant->get_range
      EXPORTING
        ps_rangeid = 90974
      CHANGING
        pt_range   = lr_subty.

* action
    lv_action =  action. " aprobar grabar rechazar devolver
* jefe unidad
    lv_jefe_flag = jefe_ju.
* nivel de aprobacion
    lv_nivel =   nivel.
* llamar a textos

* los textos con valor 0XX son informativos, los que inician con AXX son advertencias, EXX son errores
*  ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = '001' ).
*  INSERT ls_mensaje INTO TABLE lt_mensaje.
    CLEAR: lv_error_flg, lv_trangr.
    lv_rel_lab  = rel_lab.
    lv_area_per = area_per.
    lv_nr_emp   = nr_emp.
    lv_num_max = nr_maxpres.
*  lv_num_maxC = nr_maxpres.
    lv_monto = monto.
    lv_montoend = montoend.
    lv_fecha_fin = fecha_fin.
    lv_fecha_fin_cont = fecha_fin_cont.
    lv_motivo = motivo.
    lv_nr_cuota = nr_cuota.
    lv_fecha_cierre =  fecha_cierre.
* validacion de los campos obligatorios
    IF lv_motivo IS INITIAL OR lv_nr_cuota LE 0 OR lv_monto LE 0.
*  ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = 'E03' ).
*  INSERT ls_mensaje INTO TABLE lt_mensaje.
*   lv_error_flg  = c_error.

      CLEAR ls_msg.
      ls_msg-tipo = c_error.
      ls_msg-msg = wd_assist->if_wd_component_assistance~get_text( key = 'E03' ).
      APPEND ls_msg TO lt_msg.
    ENDIF.

** si no es gerente valida condiciones de prestamo.
* se validan errores y transgresiones
    CASE lv_area_per .
      WHEN c_area_ge OR c_area_gf.
* validaciones propias para gerentes
* Obtenemos el año y periodo
        IF lv_fecha_cierre >= sy-datum+6(2).
          lv_periodo = sy-datum+4(2).
          lv_ano = sy-datum+0(4).
          IF lv_periodo EQ '01'. "Enero
            lv_periodo = '12'.
            lv_ano = sy-datum+0(4) - 1.
          ELSE.
            lv_periodo = lv_periodo - 1.
          ENDIF.
        ELSE.
          lv_periodo = sy-datum+4(2).
          lv_ano = sy-datum+0(4).
        ENDIF.

        CALL FUNCTION 'ZHR_LEE_CLUSTER_PE'
          EXPORTING
            persno                 = lv_nr_emp
            payroll_period         = lv_periodo
            payroll_year           = lv_ano
            payroll_type           = space
            payroll_payid          = space
            begda                  = '01011800'
            endda                  = '31129999'
            flag_ztb_549q          = space
            authority_check        = space
          TABLES
            rt                     = ltd_rt_saldo
            rtx                    = ltd_rtx_saldo
            v0                     = ltd_v0_saldo
          EXCEPTIONS
            no_hay_datos           = 1
            empleado_no_existe     = 2
            empleado_no_encontrado = 3
            molga_no_definido      = 4
            molga_no_implementado  = 5
            OTHERS                 = 6.

        IF sy-subrc <> 0.
          lv_periodo = sy-datum+4(2).
          lv_ano = sy-datum+0(4).

          CALL FUNCTION 'ZHR_LEE_CLUSTER_PE'
            EXPORTING
              persno                 = lv_nr_emp
              payroll_period         = lv_periodo
              payroll_year           = lv_ano
              payroll_type           = space
              payroll_payid          = space
              begda                  = '01011800'
              endda                  = '31129999'
              flag_ztb_549q          = space
              authority_check        = space
            TABLES
              rt                     = ltd_rt_saldo
              rtx                    = ltd_rtx_saldo
              v0                     = ltd_v0_saldo
            EXCEPTIONS
              no_hay_datos           = 1
              empleado_no_existe     = 2
              empleado_no_encontrado = 3
              molga_no_definido      = 4
              molga_no_implementado  = 5
              OTHERS                 = 6.

          CASE sy-subrc.
            WHEN 1.
*    "No hay datos de Nómina

            WHEN 2.
* Empleado no existe
              CLEAR ls_msg.
              ls_msg-tipo = c_error.
              ls_msg-msg = wd_assist->if_wd_component_assistance~get_text( key = 'E05' ).
              APPEND ls_msg TO lt_msg.
            WHEN 3.
* Empleado no encontrado
              CLEAR ls_msg.
              ls_msg-tipo = c_error.
              ls_msg-msg = wd_assist->if_wd_component_assistance~get_text( key = 'E06' ).
              APPEND ls_msg TO lt_msg.
            WHEN 4.
* Molga no definido
              CLEAR ls_msg.
              ls_msg-tipo = c_error.
              ls_msg-msg = wd_assist->if_wd_component_assistance~get_text( key = 'E07' ).
              APPEND ls_msg TO lt_msg.
            WHEN 5.
* Molga no implementado
              CLEAR ls_msg.
              ls_msg-tipo = c_error.
              ls_msg-msg = wd_assist->if_wd_component_assistance~get_text( key = 'E08' ).
              APPEND ls_msg TO lt_msg.
            WHEN 6.
* Otros
              CLEAR ls_msg.
              ls_msg-tipo = c_error.
              ls_msg-msg = wd_assist->if_wd_component_assistance~get_text( key = 'E09' ).
              APPEND ls_msg TO lt_msg.
          ENDCASE.
        ENDIF.
* validar prestamos vigentes dia de la madre
        IF lv_motivo EQ c_9105.
          CLEAR lv_num_pres.
          SELECT COUNT( * ) INTO lv_num_pres FROM pa0045
          WHERE pernr  = lv_nr_emp
                AND subty   EQ c_9105
                AND endda  GE sy-datum.
          IF lv_num_pres GT 0.
            ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = 'E12' ).
            REPLACE '&1'  WITH lv_nr_emp INTO ls_mensaje.
            CLEAR ls_msg.
            ls_msg-tipo = c_error.
            ls_msg-msg = ls_mensaje.
            APPEND ls_msg TO lt_msg.

          ENDIF.
        ENDIF.
      WHEN OTHERS.

* validar monto
        IF lv_monto GT lv_montoend.
          CLEAR: ls_mensaje, ls_mensaje2, ls_mensaje3.
          ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = 'E10' ).
          ls_mensaje3 = wd_assist->if_wd_component_assistance~get_text( key = 'E15' ).
          ls_mensaje2 = lv_montoend.
          CLEAR ls_msg.
          CONCATENATE ls_mensaje ls_mensaje2 ls_mensaje3 INTO ls_msg-msg SEPARATED BY space.
          ls_msg-tipo = c_error.
          APPEND ls_msg TO lt_msg.
*        lv_trangr = c_trang.
        ENDIF.
* validar fecha fin de contrato.
        IF lv_rel_lab EQ c_pf. " Plazo Fijo.
          IF  lv_fecha_fin_cont IS INITIAL.
            CLEAR: ls_mensaje, ls_mensaje2, ls_mensaje3.
            CLEAR: ls_mensaje, ls_mensaje2, ls_mensaje3.
            ls_mensaje2 = wd_assist->if_wd_component_assistance~get_text( key = 'A04' ).
            ls_mensaje3 = wd_assist->if_wd_component_assistance~get_text( key = 'A06' ).
            CONCATENATE ls_mensaje2 ls_mensaje3 INTO ls_mensaje.
*          ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = 'A04' ).
** variable de transgresion
*          lv_msgtrang = ls_mensaje.
*          INSERT ls_mensaje INTO TABLE lt_mensaje.
*          lv_trangr = c_trang.

            CLEAR ls_msg.
            ls_msg-tipo = c_trang.
            ls_msg-msg = ls_mensaje.
            APPEND ls_msg TO lt_msg.
          ENDIF.
* validar fecha fin de contrato.
          IF NOT lv_fecha_fin_cont IS INITIAL AND lv_fecha_fin GE lv_fecha_fin_cont .
            CLEAR: ls_mensaje, ls_mensaje2, ls_mensaje3.
*          ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = 'A02' ).
**          CONCATENATE ls_mensaje lv_fecha_fin_cont lv_fecha_fin INTO ls_mensaje2 SEPARATED BY space.
**          ls_mensaje = ls_mensaje2.
*          CLEAR lv_fecha_for.
*          WRITE lv_fecha_fin_cont TO lv_fecha_for DD/MM/YYYY.
*          REPLACE '&1' WITH lv_fecha_for INTO ls_mensaje.
*          CLEAR lv_fecha_for.
*          WRITE lv_fecha_fin TO lv_fecha_for DD/MM/YYYY.
*          REPLACE '&2' WITH lv_fecha_for INTO ls_mensaje.
            CLEAR: ls_mensaje, ls_mensaje2, ls_mensaje3.
            ls_mensaje2 = wd_assist->if_wd_component_assistance~get_text( key = 'A02' ).
            ls_mensaje3 = wd_assist->if_wd_component_assistance~get_text( key = 'A05' ).
            CONCATENATE ls_mensaje2 ls_mensaje3 INTO ls_mensaje.

* variable de transgresion
            CLEAR ls_msg.
            ls_msg-tipo = c_trang.
            ls_msg-msg = ls_mensaje.
            APPEND ls_msg TO lt_msg.
          ENDIF.
        ENDIF.
* validar prestamos vigentes


*      IF lv_motivo NE c_9105 AND lv_motivo NOT IN lr_subty.
*        SELECT COUNT( * ) INTO lv_num_pres FROM pa0045
*        WHERE pernr  = lv_nr_emp
*              AND subty   NE c_9105
*              AND subty   NOT IN lr_subty
*              AND endda  GE sy-datum.
*        IF lv_num_pres GT 0.
*          ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = 'E12' ).
*          REPLACE '&1'  WITH lv_nr_emp INTO ls_mensaje.
*          CLEAR ls_msg.
*          ls_msg-tipo = c_error.
*          ls_msg-msg = ls_mensaje.
*          APPEND ls_msg TO lt_msg.
*        ENDIF.
*      ENDIF.

        "@jcl+{
        "Validar que no existe una solicitud pendiente de registro(TX. ZHRP0107)

        DATA: lr_cdate TYPE RANGE OF pa0045-begda,
              lw_cdate LIKE LINE OF lr_cdate.

        lw_cdate-sign = 'I'.
        lw_cdate-option = 'BT'.
        CONCATENATE sy-datum+0(4) '0101' INTO lw_cdate-low.
        CONDENSE lw_cdate-low NO-GAPS.
        CONCATENATE sy-datum+0(4) '1231' INTO lw_cdate-high.
        APPEND lw_cdate TO lr_cdate.

        TYPES: BEGIN OF ty_pa0045,
                 mandt TYPE pa0045-mandt,
                 pernr TYPE pa0045-pernr,
                 subty TYPE pa0045-subty,
                 objps TYPE pa0045-objps,
                 sprps TYPE pa0045-sprps,
                 endda TYPE pa0045-endda,
                 begda TYPE pa0045-begda,
                 seqnr TYPE pa0045-seqnr,
                 dlend TYPE pa0045-dlend,
               END OF ty_pa0045,


               BEGIN OF ty_pa0078,
                 mandt TYPE pa0078-mandt,
                 pernr TYPE pa0078-pernr,
                 subty TYPE pa0078-subty,
                 objps TYPE pa0078-objps,
                 sprps TYPE pa0078-sprps,
                 endda TYPE pa0078-endda,
                 begda TYPE pa0078-begda,
                 seqnr TYPE pa0078-seqnr,
               END OF ty_pa0078.

        DATA: lt_pa0045 TYPE TABLE OF ty_pa0045,
              lt_pa0078 TYPE TABLE OF ty_pa0078.

        IF lv_motivo NE c_9105 AND lv_motivo NOT IN lr_subty.
          CLEAR lt_pa0045[].

          SELECT mandt pernr subty objps sprps
                 endda begda seqnr dlend
            INTO CORRESPONDING FIELDS OF TABLE lt_pa0045
            FROM pa0045
            WHERE pernr = lv_nr_emp
*+@CCC{ No considerar el préstamo 9105
            AND subty NE c_9105
*}+@CCC
            AND begda IN lr_cdate.

          IF sy-subrc EQ 0.


            SORT lt_pa0045 BY begda DESCENDING.
            READ TABLE lt_pa0045 ASSIGNING FIELD-SYMBOL(<fs_prestamo>) INDEX 1.

            IF sy-datum < <fs_prestamo>-dlend.
              SELECT mandt pernr subty objps sprps
                     endda begda seqnr
                INTO TABLE lt_pa0078
                FROM pa0078
                WHERE pernr = lv_nr_emp
                AND begda >= <fs_prestamo>-begda
                AND zahla EQ '0200'.

              IF sy-subrc NE 0.
                ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = 'E18' ).
                REPLACE '&1'  WITH lv_nr_emp INTO ls_mensaje.
                CLEAR ls_msg.
                ls_msg-tipo = c_error.
                ls_msg-msg = ls_mensaje.
                APPEND ls_msg TO lt_msg.
              ENDIF.

            ENDIF.

          ENDIF.

        ENDIF.



*
*      IF lv_motivo NE c_9105 AND lv_motivo NOT IN lr_subty.
*        SELECT COUNT( * ) INTO lv_num_pres FROM ztsolprestamo
*          WHERE pernr = lv_nr_emp
*          AND   cdate IN lr_cdate
*          AND   zestju EQ  '3'.
*
*          IF lv_num_pres gt 0.
*          ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = 'E18' ).
*          REPLACE '&1'  WITH lv_nr_emp INTO ls_mensaje.
*          CLEAR ls_msg.
*          ls_msg-tipo = c_error.
*          ls_msg-msg = ls_mensaje.
*          APPEND ls_msg TO lt_msg.
*          ENDIF.
*
*
*      ENDIF.

        "@jcl+}


* validar cantidad de prestamos al año
        IF lv_motivo NE c_9105 AND lv_motivo NOT IN lr_subty.
          CLEAR lv_num_pres.
          lv_fini = sy-datum.

          CALL FUNCTION 'CCM_GO_BACK_MONTHS'
            EXPORTING
              currdate   = lv_fini
              backmonths = '012'
            IMPORTING
              newdate    = lv_ffin.

          SELECT COUNT( * ) INTO lv_num_pres FROM pa0045
              WHERE pernr  = lv_nr_emp
               AND subty   NE c_9105
               AND subty   NOT IN lr_subty
               AND begda  BETWEEN  lv_ffin AND lv_fini .

          IF lv_num_pres GE lv_num_max.
            CLEAR lv_date.
            SELECT MIN( begda ) INTO lv_date FROM pa0045
              WHERE pernr  = lv_nr_emp
               AND subty   NE c_9105
               AND subty   NOT IN lr_subty
               AND begda  BETWEEN  lv_ffin AND lv_fini .

            CLEAR: ls_mensaje, ls_mensaje2, ls_mensaje3.

            ADD 1 TO lv_date.
            CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
              EXPORTING
                months  = '012'
                olddate = lv_date
              IMPORTING
                newdate = lv_date.

            lv_num_maxc = lv_num_pres.
            ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = 'E02' ).
            ls_mensaje2 = wd_assist->if_wd_component_assistance~get_text( key = 'E16' ).
            WRITE lv_date TO lv_fecha_for DD/MM/YYYY.
            CONCATENATE ls_mensaje lv_num_maxc ls_mensaje2 lv_fecha_for INTO ls_mensaje3 SEPARATED BY space.
*          REPLACE '&1' WITH lv_num_maxc INTO ls_mensaje.
            CLEAR ls_msg.
            ls_msg-tipo =  c_error.
            ls_msg-msg = ls_mensaje3.
            APPEND ls_msg TO lt_msg.
          ENDIF.
        ENDIF.
***
* Obtenemos el año y periodo
        IF lv_fecha_cierre >= sy-datum+6(2).
          lv_periodo = sy-datum+4(2).
          lv_ano = sy-datum+0(4).
          IF lv_periodo EQ '01'. "Enero
            lv_periodo = '12'.
            lv_ano = sy-datum+0(4) - 1.
          ELSE.
            lv_periodo = lv_periodo - 1.
          ENDIF.
        ELSE.
          lv_periodo = sy-datum+4(2).
          lv_ano = sy-datum+0(4).
        ENDIF.
        CALL FUNCTION 'ZHR_LEE_CLUSTER_PE'
          EXPORTING
            persno                 = lv_nr_emp
            payroll_period         = lv_periodo
            payroll_year           = lv_ano
            payroll_type           = space
            payroll_payid          = space
            begda                  = '01011800'
            endda                  = '31129999'
            flag_ztb_549q          = space
            authority_check        = space
          TABLES
            rt                     = ltd_rt_saldo
            rtx                    = ltd_rtx_saldo
            v0                     = ltd_v0_saldo
          EXCEPTIONS
            no_hay_datos           = 1
            empleado_no_existe     = 2
            empleado_no_encontrado = 3
            molga_no_definido      = 4
            molga_no_implementado  = 5
            OTHERS                 = 6.

        IF sy-subrc <> 0.
          lv_periodo = sy-datum+4(2).
          lv_ano = sy-datum+0(4).

          CALL FUNCTION 'ZHR_LEE_CLUSTER_PE'
            EXPORTING
              persno                 = lv_nr_emp
              payroll_period         = lv_periodo
              payroll_year           = lv_ano
              payroll_type           = space
              payroll_payid          = space
              begda                  = '01011800'
              endda                  = '31129999'
              flag_ztb_549q          = space
              authority_check        = space
            TABLES
              rt                     = ltd_rt_saldo
              rtx                    = ltd_rtx_saldo
              v0                     = ltd_v0_saldo
            EXCEPTIONS
              no_hay_datos           = 1
              empleado_no_existe     = 2
              empleado_no_encontrado = 3
              molga_no_definido      = 4
              molga_no_implementado  = 5
              OTHERS                 = 6.
          CASE sy-subrc.
            WHEN 1.
*    "No hay datos de Nómina
              CLEAR: ls_mensaje, ls_mensaje2, ls_mensaje3.
              ls_mensaje2 = wd_assist->if_wd_component_assistance~get_text( key = 'A03' ).
              ls_mensaje3 = wd_assist->if_wd_component_assistance~get_text( key = 'A05' ).
              CONCATENATE ls_mensaje2 ls_mensaje3 INTO ls_mensaje.
              CLEAR ls_msg.
              ls_msg-tipo =  c_trang.
              ls_msg-msg = ls_mensaje.
              APPEND ls_msg TO lt_msg.
            WHEN 2.
*      Empleado no existe
              CLEAR ls_msg.
              ls_msg-tipo =   c_error.
              ls_msg-msg = wd_assist->if_wd_component_assistance~get_text( key = 'E05' ).
              APPEND ls_msg TO lt_msg.
            WHEN 3.
* Empleado no encontrado
              CLEAR ls_msg.
              ls_msg-tipo =   c_error.
              ls_msg-msg = wd_assist->if_wd_component_assistance~get_text( key = 'E06' ).
              APPEND ls_msg TO lt_msg.
            WHEN 4.
* Molga no definido
              CLEAR ls_msg.
              ls_msg-tipo =   c_error.
              ls_msg-msg = wd_assist->if_wd_component_assistance~get_text( key = 'E07' ).
              APPEND ls_msg TO lt_msg.
            WHEN 5.
* Molga no implementado
              CLEAR ls_msg.
              ls_msg-tipo =   c_error.
              ls_msg-msg = wd_assist->if_wd_component_assistance~get_text( key = 'E08' ).
              APPEND ls_msg TO lt_msg.
            WHEN 6.
* Otros
              CLEAR ls_msg.
              ls_msg-tipo =   c_error.
              ls_msg-msg = wd_assist->if_wd_component_assistance~get_text( key = 'E09' ).
              APPEND ls_msg TO lt_msg.
          ENDCASE.
        ENDIF.
    ENDCASE.
** incluir el texto de aceptacion de prestamo
    CLEAR: trangr, trangr_msg, lv_error_flg.
    READ TABLE lt_msg INTO ls_msg WITH KEY tipo = c_error.
    IF sy-subrc EQ 0.
      DELETE lt_msg WHERE tipo NE c_error.
      lv_error_flg = c_error.
      CLEAR ls_msg.
      ls_msg-tipo = c_error.
      ls_msg-msg = wd_assist->if_wd_component_assistance~get_text( key = '001' ).

      INSERT ls_msg INTO lt_msg INDEX 1.

    ELSE.
      READ TABLE lt_msg INTO ls_msg WITH KEY tipo =  c_trang.
      IF sy-subrc EQ 0.
        lv_error_flg = c_trang.
        lv_trangr = c_trang.
        lv_msgtrang = ls_msg-msg.
        ls_msg-tipo = c_trang.
        ls_msg-msg = wd_assist->if_wd_component_assistance~get_text( key = '011' ).
        INSERT ls_msg INTO lt_msg INDEX 1.
      ENDIF.
    ENDIF.
    LOOP AT lt_msg INTO ls_msg.
      CLEAR ls_mensaje.
      ls_mensaje = ls_msg-msg.
      INSERT ls_mensaje INTO TABLE lt_mensaje.
    ENDLOOP.
** incluir el texto de aceptacion de prestamo
    CLEAR lv_messtype.
    CASE lv_error_flg.
      WHEN c_error." Error no envia a grabar la Solicitud
        lv_button_op = '2'." cancel
        ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = '003' ).
        INSERT ls_mensaje INTO TABLE lt_mensaje.
        lv_messtype = if_wd_window=>co_msg_type_error.
      WHEN OTHERS." advertencias o transgresiones
        lv_button_op = '4'. " Yes and no
        CLEAR lv_num_max.
        DESCRIBE TABLE lt_mensaje LINES lv_num_max.
        IF lv_num_max GT 1.
          ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = '007' ).
          INSERT ls_mensaje INTO TABLE lt_mensaje.
        ENDIF.
        ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = '002' ).
        INSERT ls_mensaje INTO TABLE lt_mensaje.
        lv_messtype = if_wd_window=>co_msg_type_warning.
    ENDCASE.

    CASE lv_action.
      WHEN '1'. " Grabar
        ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = '008' ).
        INSERT ls_mensaje INTO TABLE lt_mensaje.
        lv_button_op = '4'. " por defecto queda en opcion si y no
      WHEN '2'. " Aprobar
      WHEN '3'. " rechazar
      WHEN '4'. " Devolver.
        CASE lv_nivel.
          WHEN '2'.
            IF lv_jefe_flag NE space.
              ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = '009' ).
              INSERT ls_mensaje INTO TABLE lt_mensaje.
              lv_button_op = '4'. " por defecto queda en opcion si y no
            ELSE.
              lv_button_op = '2'. "No puede devolver a un nivel inferior si no existe jefe y es gdh
              ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = '010' ).
              REPLACE '&1'  WITH lv_nr_emp INTO ls_mensaje.
              INSERT ls_mensaje INTO TABLE lt_mensaje.
            ENDIF.
          WHEN '3'.
            ls_mensaje = wd_assist->if_wd_component_assistance~get_text( key = '009' ).
            INSERT ls_mensaje INTO TABLE lt_mensaje.
            lv_button_op = '4'. " por defecto queda en opcion si y no
        ENDCASE.

    ENDCASE.

    table_msg = lt_msg.
    table_message = lt_mensaje.
    trangr = lv_trangr.
    trangr_msg =  lv_msgtrang.

  ENDMETHOD.


  METHOD get_reason_loan.

    DATA: table_subtys TYPE STANDARD TABLE OF cawao_s_subtytab.


    CALL FUNCTION 'Z_HR_RFC_OBTIENE_SUBTIPOS'
      EXPORTING
        pernr    = employee_number
      TABLES
        et_subty = table_subtys.

    DATA: reason_loan LIKE LINE OF reason_loans.

    LOOP AT table_subtys INTO DATA(table_subty).
      CLEAR: reason_loan.

      reason_loan-LoanType = table_subty-subty.
      reason_loan-LoanDesc = table_subty-subtytext.

      APPEND reason_loan TO reason_loans.

    ENDLOOP.


  ENDMETHOD.


  METHOD get_terms_cond.

    DATA: line_term_cond LIKE LINE OF terms_cond.

    DATA: wd_assist TYPE REF TO zhr_prest_admin_txt.

    wd_assist = NEW #( ).

    DATA: lv_msg  TYPE string,
          lv_msg2 TYPE string,
          lv_msg3 TYPE string.

    lv_msg = wd_assist->if_wd_component_assistance~get_text( key = 'T01' ).
    lv_msg2 = wd_assist->if_wd_component_assistance~get_text( key = 'T02' ).
    CLEAR lv_msg3.
    CONCATENATE  lv_msg lv_msg2 INTO lv_msg3 SEPARATED BY space.
    CLEAR: lv_msg, lv_msg2 .
    lv_msg = wd_assist->if_wd_component_assistance~get_text( key = 'T03' ).
    lv_msg2 = lv_msg3.
    CLEAR lv_msg3.
    CONCATENATE  lv_msg2 lv_msg INTO lv_msg3 SEPARATED BY space.
    CLEAR: lv_msg, lv_msg2 .
    lv_msg = wd_assist->if_wd_component_assistance~get_text( key = 'T04' ).
    lv_msg2 = lv_msg3.
    CLEAR lv_msg3.
    CONCATENATE  lv_msg2 lv_msg INTO lv_msg3 SEPARATED BY space.
    CLEAR: lv_msg, lv_msg2 .
    lv_msg = wd_assist->if_wd_component_assistance~get_text( key = 'T05' ).
    lv_msg2 = lv_msg3.
    CLEAR lv_msg3.
    CONCATENATE  lv_msg2 lv_msg INTO lv_msg3 SEPARATED BY space.
    CLEAR: lv_msg, lv_msg2 .
    lv_msg = wd_assist->if_wd_component_assistance~get_text( key = 'T06' ).
    lv_msg2 = lv_msg3.
    CLEAR lv_msg3.
    CONCATENATE  lv_msg2 lv_msg INTO lv_msg3 SEPARATED BY space.
    CLEAR: lv_msg, lv_msg2 .
    lv_msg = wd_assist->if_wd_component_assistance~get_text( key = 'T07' ).
    lv_msg2 = lv_msg3.
    CLEAR lv_msg3.
    CONCATENATE  lv_msg2 lv_msg INTO lv_msg3 SEPARATED BY space.
    CLEAR: lv_msg, lv_msg2 .
    lv_msg = wd_assist->if_wd_component_assistance~get_text( key = 'T08' ).
    lv_msg2 = lv_msg3.
    CLEAR lv_msg3.
    CONCATENATE  lv_msg2 lv_msg INTO lv_msg3 SEPARATED BY space.
    CLEAR: lv_msg, lv_msg2 .
    lv_msg = wd_assist->if_wd_component_assistance~get_text( key = 'T09' ).
    lv_msg2 = lv_msg3.
    CLEAR lv_msg3.
    CONCATENATE  lv_msg2 lv_msg INTO lv_msg3 SEPARATED BY space.
    CLEAR: lv_msg, lv_msg2 .
    lv_msg = wd_assist->if_wd_component_assistance~get_text( key = 'T10' ).
    lv_msg2 = lv_msg3.
    CLEAR lv_msg3.
    CONCATENATE  lv_msg2 lv_msg INTO lv_msg3 SEPARATED BY space.
    CLEAR: lv_msg, lv_msg2 .
    lv_msg = wd_assist->if_wd_component_assistance~get_text( key = 'T11' ).
    lv_msg2 = lv_msg3.
    CLEAR lv_msg3.
    CONCATENATE  lv_msg2 lv_msg INTO lv_msg3 SEPARATED BY space.


    line_term_cond-TermsConditions = 'X'.

    line_term_cond-FileTerms = lv_msg3.

    APPEND line_term_cond TO terms_cond.


  ENDMETHOD.


  METHOD get_employee_info.

    DATA: line_employee_info LIKE LINE OF employee_info.

    DATA: emp_numb TYPE pernr_d.

    emp_numb = employee_number.

    IF employee_number IS INITIAL.

      CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
        EXPORTING
          id             = sy-uname
          begindate      = sy-datum
          enddate        = sy-datum
        IMPORTING
          employeenumber = emp_numb.

    ENDIF.

    DATA: lv_flag TYPE char1.

    CALL FUNCTION 'Z_HR_TIENE_JEFE_MENOR_DIVISION'
      EXPORTING
        pi_pernr = emp_numb
      IMPORTING
        pe_tiene = lv_flag.

    IF lv_flag EQ 'X'. " No es jefe

      line_employee_info-IsBoss = ''.

    ELSE." Es jefe

      line_employee_info-IsBoss = 'X'.

    ENDIF.


    DATA: data_employees TYPE zhcmt_employee_loan_info.

    SELECT p2~pernr p2~vorna p2~nachn p185~icnum p105~usrid_long
      INTO TABLE data_employees
      FROM pa0002 AS p2 INNER JOIN
           pa0185 AS p185 ON p2~pernr EQ p185~pernr INNER JOIN
           pa0105 AS p105 ON p2~pernr EQ p105~pernr
     WHERE p2~pernr = emp_numb
       AND p2~subty = space
       AND p2~objps = space
       AND p2~sprps = space
       AND p2~endda = '99991231'
       AND p185~endda = '99991231'
       AND p2~begda <= sy-datum.

    DATA: mail_employee TYPE comm_id_long.
    LOOP AT data_employees INTO DATA(empoyee).

      IF empoyee-usrid_long IS NOT INITIAL.
        mail_employee = empoyee-usrid_long.
      ENDIF.

    ENDLOOP.

    DATA: sname_employee TYPE smnam.

    SELECT SINGLE sname INTO  sname_employee
                        FROM  pa0001
                        WHERE pernr EQ emp_numb AND
                              endda EQ '99991231'.

    line_employee_info-EmployeeNumber      = emp_numb.
    line_employee_info-UserSystem          = sy-uname.

    line_employee_info-LastName            = data_employees[ 1 ]-nachn.
    line_employee_info-EmployeeName        = data_employees[ 1 ]-vorna.

    line_employee_info-EmployeeFullName    = sname_employee.

    line_employee_info-Dni                 = data_employees[ 1 ]-icnum.

    line_employee_info-Mail                = mail_employee.


    APPEND line_employee_info TO employee_info.


  ENDMETHOD.


  METHOD get_collaborator_cond.

    DATA: line_collaborator_cond LIKE LINE OF collaborator_cond.

    line_collaborator_cond-EmployeeNumber = employee_number.

    IF employee_number IS INITIAL.

      CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
        EXPORTING
          id             = sy-uname
          begindate      = sy-datum
          enddate        = sy-datum
        IMPORTING
          employeenumber = line_collaborator_cond-EmployeeNumber.

    ENDIF.

    get_data_init_loan_admin( EXPORTING
                                lv_nr_emp = line_collaborator_cond-EmployeeNumber
                              IMPORTING
                                lv_nrcuota = line_collaborator_cond-QuotaNumbersMax ).

    CALL FUNCTION 'Z_HR_RFC_OBTIENE_INFO_PRESTAMO'
      EXPORTING
        ip_pernr = line_collaborator_cond-EmployeeNumber
      IMPORTING
        ep_ansvh = line_collaborator_cond-RelationLaboral
        ep_anstx = line_collaborator_cond-RelationLaboralDesc
        ep_ctedt = line_collaborator_cond-DateEndCont.


    APPEND line_collaborator_cond TO collaborator_cond.


  ENDMETHOD.


  METHOD get_history_loan.

    DATA: line_history_loan LIKE LINE OF history_loan.

    line_history_loan-EmployeeNumber = employee_number.

    IF employee_number IS INITIAL.

      CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
        EXPORTING
          id             = sy-uname
          begindate      = sy-datum
          enddate        = sy-datum
        IMPORTING
          employeenumber = line_history_loan-EmployeeNumber.

    ENDIF.

    DATA: et_prest TYPE STANDARD TABLE OF zwprestpendiente.
    DATA: et_message TYPE STANDARD TABLE OF bapiret1.

    CALL FUNCTION 'Z_HR_RFC_HISTORIAL_PRESTAMO'
      EXPORTING
        ip_pernr = employee_number
      TABLES
        et_prest = et_prest
        t_return = et_message.

    IF et_prest IS NOT INITIAL.

      LOOP AT et_prest INTO DATA(es_prest).
        CLEAR:line_history_loan.

        line_history_loan-EmployeeNumber = employee_number.
        line_history_loan-LoanType = es_prest-dlart.
        line_history_loan-ActualNumber = es_prest-objps.
        line_history_loan-LoanTypeDesc = es_prest-sbttx.
        line_history_loan-LoanAmount = es_prest-darbt.
        line_history_loan-CurrencyKey = es_prest-waers.
        line_history_loan-QuotaNumbers = es_prest-zncuot.
        line_history_loan-QuotaAmountSimple = es_prest-zsaldo.
        line_history_loan-OutBalance = es_prest-tilbt.
        line_history_loan-EstEndPayment = es_prest-dlend.
        line_history_loan-LoanStatus = es_prest-status.

        APPEND line_history_loan TO history_loan.
      ENDLOOP.

    ELSE.

      line_history_loan-MessageType = et_message[ 1 ]-type.
      line_history_loan-Message = et_message[ 1 ]-message.

      APPEND line_history_loan TO history_loan.

    ENDIF.


  ENDMETHOD.


  METHOD post_aprov_reject_loan.

    DATA: line_aprov_reject_loan LIKE LINE OF aprov_reject_loan.
    DATA: gs_constantsn TYPE REF TO zbc_constants_admin_n.
    DATA: gs_constantsn2 TYPE REF TO zbc_constants_admin_n.
    DATA: const_dia_cierre TYPE zva_zbcranv_n.

    line_aprov_reject_loan = aprov_reject_loan[ 1 ].
    TRY.
        CREATE OBJECT gs_constantsn
          EXPORTING
*           pi_repid = sy-repid.  "Actualizar en la ZBCP0001
            pi_repid = 'SAPLZHRG0016'.
      CATCH cx_alert_unknown .                          "#EC NO_HANDLER
    ENDTRY.

    " FECHA CIERRE CONSTANTE ---------------------------------------------
    " --------------------------------------------------------------------
    DATA: fecha_cierre TYPE char2.

    CALL METHOD gs_constantsn->get_first_value_range_n
      EXPORTING
        pi_rangeid     = '0000000080'
        pi_bukrs       = '*'
      IMPORTING
        pe_first_value = const_dia_cierre.

    fecha_cierre = const_dia_cierre-rangeid.

    DATA: const_cuotas_max TYPE zva_zbcranv_n.
    DATA: num_cuotas_max TYPE ze_numcuota.

    " NUMERO DE CUOTAS MAX -----------------------------------------------
    " --------------------------------------------------------------------

    TRY.
        CREATE OBJECT gs_constantsn2
          EXPORTING
*           pi_repid = sy-repid.  "Actualizar en la ZBCP0001
            pi_repid = 'HR_PO_PY001'.
      CATCH cx_alert_unknown .                          "#EC NO_HANDLER
    ENDTRY.

    CALL METHOD gs_constantsn2->get_first_value_range_n
      EXPORTING
        pi_rangeid     = '0000000084'
        pi_bukrs       = '*'
      IMPORTING
        pe_first_value = const_cuotas_max.

    num_cuotas_max = const_cuotas_max-rangeid.

    " MONTO MAX ----------------------------------------------------------
    " --------------------------------------------------------------------

    DATA: const_monto_max TYPE ztprestamoxrelab.
    DATA: monto_max TYPE ze_monto.
    DATA: society TYPE bukrs.
    DATA: re_lab TYPE ansvh.
    DATA: area_person TYPE persk.

    CALL FUNCTION 'Z_HR_RFC_GET_IT0001_DATA'
      EXPORTING
        ip_pernr = line_aprov_reject_loan-EmployeeNumber
      IMPORTING
        bukrs    = society
        ansvh    = re_lab
        persk    = area_person.


    SELECT SINGLE * FROM ztprestamoxrelab INTO const_monto_max
        WHERE bukrs = society AND
              ansvh = re_lab.

    monto_max = const_monto_max-monto.

    CALL FUNCTION 'Z_HR_RFC_OBTIENE_INFO_PRESTAMO'
      EXPORTING
        ip_pernr = line_aprov_reject_loan-EmployeeNumber
      IMPORTING
        ep_ansvh = line_aprov_reject_loan-RelationLaboral
        ep_ctedt = line_aprov_reject_loan-DateEndCont.

    "Nivel Obtener

    DATA: lv_para_value TYPE string,
          lv_wi_id      TYPE sww_wiid,
          lv_wi_text    TYPE sww_witext,
          lv_wi_rh_task TYPE sww_task,
          lv_text       TYPE string.

    CONCATENATE '%Evaluar' '%préstamo%' line_aprov_reject_loan-LoanAppNumber '%' INTO lv_text.

    SELECT SINGLE wi_text wi_rh_task INTO (lv_wi_text, lv_wi_rh_task)
        FROM swwwihead
        WHERE wi_text LIKE lv_text.

    CONSTANTS: c_mark(1)    VALUE 'X', " True
               c_iconch(11) VALUE 'ICON_CHANGE',
               c_txtedi(9)  VALUE 'Modificar',
               c_pend(1)    VALUE '1', "Pendiente
               c_modi(1)    VALUE '2', " Modificado
               c_apro(1)    VALUE '3', " Aprobado
               c_rech(1)    VALUE '4', " Rechazado
               c_devu(1)    VALUE '5', " Devuelto,
               c_9105(4)    VALUE '9105',  " Dia de la madre
               c_t90(10)    VALUE 'TS90000090', " Tarea jefe JUnidad
               c_t91(10)    VALUE 'TS90000091', " Tarea GDH
               c_t93(10)    VALUE 'TS90000093'. " Tarea Jefe Aprobador

    DATA: lv_nivel TYPE char1.
* identificar el nivel
* Primer nivel JU, Segundo Nivel JD , Tercer Nivel AP

    CLEAR lv_nivel.
    CASE lv_wi_rh_task.
      WHEN c_t90. " Nivel 1 Jefe unidad
        lv_nivel = '1'.
      WHEN c_t91. " Nivel 2 Aprobador GDH
        lv_nivel = '2'.
      WHEN c_t93. " Nivel 3 Aprobador final
        lv_nivel = '3'.
      WHEN OTHERS.
        lv_nivel = '0'.
    ENDCASE.

    save_general( EXPORTING
                    action          = line_aprov_reject_loan-Action
                    nr_cuota        = line_aprov_reject_loan-QuotaNumbers
                    monto           = line_aprov_reject_loan-LoanAmount
                    motivo          = line_aprov_reject_loan-LoanType
                    nr_emp          = line_aprov_reject_loan-EmployeeNumber
                    monto_end       = line_aprov_reject_loan-AmountEnd
                    re_lab          = line_aprov_reject_loan-RelationLaboral
                    fecha_fin_cont  = line_aprov_reject_loan-DateEndCont
                    fecha_inicio    = line_aprov_reject_loan-DateInit
                    nr_cuota_max    = line_aprov_reject_loan-QuotaNumbersMax
                    area_per        = line_aprov_reject_loan-PersonnelArea
                    fecha_cierre    = line_aprov_reject_loan-DateClose
                    jefe_flag       = line_aprov_reject_loan-FlagBoss
                    nivel           = line_aprov_reject_loan-Nivel
                    aprov_reject_loan = aprov_reject_loan
                   IMPORTING
                    trangr          = type
                    trangr_msg      = message
                    ).


  ENDMETHOD.


  METHOD get_calculate_loan.

    DATA: gs_constantsn TYPE REF TO zbc_constants_admin_n.
    DATA: const_dia_cierre TYPE zva_zbcranv_n.

    TRY.
        CREATE OBJECT gs_constantsn
          EXPORTING
*           pi_repid = sy-repid.  "Actualizar en la ZBCP0001
            pi_repid = 'SAPLZHRG0016'.
      CATCH cx_alert_unknown .                          "#EC NO_HANDLER
    ENDTRY.

    " FECHA CIERRE CONSTANTE ---------------------------------------------
    " --------------------------------------------------------------------
    DATA: fecha_cierre TYPE char2.

    CALL METHOD gs_constantsn->get_first_value_range_n
      EXPORTING
        pi_rangeid     = '0000000080'
        pi_bukrs       = '*'
      IMPORTING
        pe_first_value = const_dia_cierre.

    fecha_cierre = const_dia_cierre-rangeid.

    DATA line_calculate_loan LIKE LINE OF calulate_loan.

    calcular_prestamo( EXPORTING
                                 fecha_cierre = fecha_cierre
                                 monto = monto
                                 motivo = motivo
                                 nr_cuota = nr_couta
                       CHANGING
                                fecha_ini = line_calculate_loan-PaymentStartDate
                                fecha_fin = line_calculate_loan-PaymentEndDate
                                cuota_grt = line_calculate_loan-ImportQuotaGrati
                                cuota_sim = line_calculate_loan-ImportQuotaSimp ).

    APPEND line_calculate_loan TO calulate_loan.

  ENDMETHOD.


  METHOD get_aprov_reject_loan.

** Constantes
    DATA: ls_constants  TYPE REF TO zbc_constants_admin_n.
* variable
    DATA: lv_nr_emp       TYPE bapiusr01-employeeno,
          lv_nrcuota      TYPE ze_numcuota,
          lv_nrcuota_cont TYPE ze_numcuota,
          lv_motivo       TYPE dlart,
          lit_motivo      TYPE TABLE OF cawao_s_subtytab,
          lwa_motivo      TYPE  cawao_s_subtytab,
          lv_dni_emp      TYPE pa0185-icnum,
          lv_nombre       TYPE pad_cname,
          lv_moneda       TYPE ktext,
          ls_solpres      TYPE  zwsolprestamo,
          ls_mensaje      TYPE  bapiret2,
          lv_trasmsg      TYPE ze_msjtransgre,
          lv_trassta      TYPE ze_trangresion,
          lv_nr_pres      TYPE ze_numsolpres,
          lv_mensaje      TYPE string,
          lv_value        TYPE string.
    DATA:
      lit_value         TYPE TABLE OF wdr_context_attr_value,
      lwa_value         TYPE wdr_context_attr_value,
      lv_node           TYPE REF TO if_wd_context_node,
      lv_node_info      TYPE REF TO if_wd_context_node_info,
      lv_node_elem      TYPE REF TO if_wd_context_element,
      lv_bool_field     TYPE wdy_boolean,
      lv_bool_but1      TYPE wdy_boolean,
      lv_bool_but2      TYPE wdy_boolean,
      lv_ene_but1       TYPE wdy_boolean,
      lv_ene_but2       TYPE wdy_boolean,
      lv_ene_but3       TYPE wdy_boolean,
      lv_ene_but4       TYPE wdy_boolean,
      lv_ene_but5       TYPE wdy_boolean,
      lv_rellab         TYPE ansvh,
      lv_rellabdes      TYPE anstx,
      lv_monto          TYPE ze_monto,
      lv_imp_cuota_sim  TYPE ze_monto,
      lv_imp_cuota_grt  TYPE ze_monto,
      lv_comentario     TYPE ze_comenprest,
      lv_montoend       TYPE ze_monto,
      lv_fecha_fin_cont TYPE ctedt,
      lv_fecha_inicio   TYPE ctedt,
      lv_fecha_fin      TYPE ctedt,
      lv_fecha_sol      TYPE ctedt,
      lv_area_per       TYPE persk,
      lv_saldo          TYPE maxbt,
      lv_timsv          TYPE intdays,
      lv_remu           TYPE maxbt,
      lv_montoend2      TYPE maxbt,
      lv_codmon         TYPE waers,
      lv_nr_maxpres     TYPE ze_numcuota,
      lv_nr_maxcons     TYPE string,
      lv_correo         TYPE string,
      lv_msg            TYPE string,
      lv_icon           TYPE string,
      lv_jefe_flag      TYPE flag,
      lv_group_res      TYPE REF TO cl_wd_group,
      lv_nivel          TYPE char01, " nivel de aprobacion en el que se encuentra
      lv_status_sol     TYPE c,
      lv_cierre         TYPE char02,
      lv_flag_ge        TYPE flag.
*types
    TYPES: BEGIN OF lty_historico,
             hnr_pres_ap       TYPE ze_numsolpres,
             hmotivo_ap        TYPE dlart,
             hobjps_ap         TYPE objps,
             hmotivodesc_ap    TYPE sbttx,
             hmonto_ap         TYPE ze_monto_prestamo,
             hmoneda_ap        TYPE waers,
             hnr_cuota_ap      TYPE ze_numcuota,
             himp_cuota_sim_ap TYPE ze_imp_cuota_simple,
             hr_saldo_pres_ap  TYPE ze_monto_prestamo,
             hr_fin_pago_ap    TYPE ze_finpago,
             hstatus           TYPE char15,
           END OF lty_historico.
* internal tables
*  data: lit_historico type table of lty_historico.
    DATA: lit_pres_his  TYPE TABLE OF zwprestpendiente,
          lit_historico TYPE TABLE OF lty_historico,
          lit_return    TYPE TABLE OF bapiret1.
    DATA: ls_historico TYPE lty_historico,
          ls_pres_his  TYPE  zwprestpendiente.

    CONSTANTS: c_mark(1)    VALUE 'X', " True
               c_iconch(11) VALUE 'ICON_CHANGE',
               c_txtedi(9)  VALUE 'Modificar',
               c_pend(1)    VALUE '1', "Pendiente
               c_modi(1)    VALUE '2', " Modificado
               c_apro(1)    VALUE '3', " Aprobado
               c_rech(1)    VALUE '4', " Rechazado
               c_devu(1)    VALUE '5', " Devuelto,
               c_9105(4)    VALUE '9105',  " Dia de la madre
               c_t90(10)    VALUE 'TS90000090', " Tarea jefe JUnidad
               c_t91(10)    VALUE 'TS90000091', " Tarea GDH
               c_t93(10)    VALUE 'TS90000093'. " Tarea Jefe Aprobador

    DATA: lv_para_value TYPE string,
          lv_wi_id      TYPE sww_wiid,
          lv_wi_text    TYPE sww_witext,
          lv_wi_rh_task TYPE sww_task.
* obtener numero de prestamo de url

    DATA: lv_text TYPE string.

    CONCATENATE '%Evaluar' '%préstamo%' input_number_loan '%' INTO lv_text.

    SELECT SINGLE wi_text wi_rh_task INTO (lv_wi_text, lv_wi_rh_task)
        FROM swwwihead
        WHERE wi_text LIKE lv_text.

    CHECK sy-subrc EQ 0.
    CLEAR lv_nr_pres.
    lv_nr_pres = input_number_loan. " de la descripcion se obtiene el numero de prestamo

    CHECK NOT lv_nr_pres IS INITIAL.
**************

    TRY.
        CREATE OBJECT ls_constants
          EXPORTING
            pi_repid = 'HR_PO_PY001'.
      CATCH cx_alert_unknown .
    ENDTRY.
* obtener datos del prestamos
    CLEAR ls_solpres.
* test


    CALL FUNCTION 'Z_HR_RFC_MANAGER_ZTSOLPRESTAMO'
      EXPORTING
        ip_accion  = 'R'
        ip_numsol  = lv_nr_pres
      IMPORTING
        ew_solpres = ls_solpres
        ep_mensaje = ls_mensaje.

* fecha inicio
*numero de empleado
    lv_nr_emp = ls_solpres-pernr.
* leer prestamos historicos
    CLEAR: lit_historico, lit_return.

    CALL FUNCTION 'Z_HR_RFC_HISTORIAL_PRESTAMO'
      EXPORTING
        ip_pernr = lv_nr_emp
      TABLES
        et_prest = lit_pres_his
        t_return = lit_return.

*numero de empleado
    lv_nr_emp = ls_solpres-pernr.

    lv_monto = ls_solpres-zmonpr.
* Dni
    lv_dni_emp = ls_solpres-dni.
*WAERS
    lv_imp_cuota_sim = ls_solpres-zimpcs.
    lv_imp_cuota_grt = ls_solpres-zimpcg.
    lv_correo = ls_solpres-mail.
    lv_comentario = ls_solpres-zcomen.
* fecha solicitud prestamo
    lv_fecha_inicio =  ls_solpres-zfecsl.
* fecha fin de prestamos
    lv_fecha_fin = ls_solpres-zfecfp.
* mensaje de transgresion
    lv_trasmsg = ls_solpres-zmsjtrangr.

* area de personal.
    SELECT SINGLE persk INTO lv_area_per
    FROM pa0001
    WHERE pernr = lv_nr_emp AND
          endda >= sy-datum AND
          begda <= sy-datum.
    CLEAR lv_flag_ge.
    CALL FUNCTION 'Z_HR_ES_GERENTE_PERSK'
      EXPORTING
        pi_persk     = lv_area_per
      IMPORTING
        pe_esgerente = lv_flag_ge.
    CASE lv_flag_ge.
      WHEN 'X'.
        lv_area_per = 'GE'. " Gerente.
      WHEN OTHERS.
    ENDCASE.
* otros datos de personal

    CALL FUNCTION 'Z_HR_RFC_OBTIENE_INFO_PRESTAMO'
      EXPORTING
        ip_pernr = lv_nr_emp
      IMPORTING
        ep_ansvh = lv_rellab
        ep_anstx = lv_rellabdes
        ep_monto = lv_montoend
        ep_waers = lv_codmon
        ep_ktext = lv_moneda
        ep_ctedt = lv_fecha_fin_cont
        ep_nombr = lv_nombre
        ep_saldo = lv_saldo
        ep_timsv = lv_timsv
        ep_remu  = lv_remu
        ep_endeu = lv_montoend2.


*lv_NR_EMP = '000123'.
    DATA: line_aprov_reject LIKE LINE OF output_loan_ap_re.

* numero de prestamo
    line_aprov_reject-LoanAppNumber = lv_nr_pres.
* numero de empleado
    line_aprov_reject-EmployeeNumber = lv_nr_emp.
* numero de dni
    line_aprov_reject-DNINumber = lv_dni_emp.
* Nombre del empleado
    line_aprov_reject-EmployeeName = lv_nombre.
* Moneda descripcion
    line_aprov_reject-CurrencyKey = lv_moneda.
* codigo de la moneda del prestamo
    line_aprov_reject-CurrencyKeyCode = lv_codmon.
* Monto Prestamo
    line_aprov_reject-LoanAmount = lv_monto.
* Importe cuota simple
    line_aprov_reject-QuotaAmountSimple = lv_imp_cuota_sim.
* Importe Cuota grati
    line_aprov_reject-QuotaAmountGrat = lv_imp_cuota_grt.
* Correo
    line_aprov_reject-Mail = lv_correo.
* comentario
    line_aprov_reject-CommentLoan = lv_comentario.
* relacion laboral cod
    line_aprov_reject-RelationLaboral = lv_rellab.
* relacion laboral desc
    line_aprov_reject-RelationLaboralDesc = lv_rellabdes.
* fecha fin de contrato
    line_aprov_reject-DateEndCont = lv_fecha_fin_cont.
** area de personal
    line_aprov_reject-PersonnelArea = lv_area_per.
** Monto endeudamiento
    line_aprov_reject-AmountEnd = lv_montoend.
    line_aprov_reject-AmountEnd2 = lv_montoend2.
* fecha inicio de prestamos
    line_aprov_reject-DateInit = lv_fecha_inicio.
*   Fecha fin de prestamos
    line_aprov_reject-DateEnd = lv_fecha_fin.


** remuneracion
*  lv_node->set_attribute( EXPORTING name   = 'REMUN_EM' value  = lv_remu ).
** tiempo de interes dias
*  lv_node->set_attribute( EXPORTING name   = 'TIMSV_EM' value  = lv_timsv ).

    CLEAR lv_jefe_flag.
* verificar si empleado tiene jefe
    CALL FUNCTION 'Z_HR_TIENE_JEFE_MENOR_DIVISION'
      EXPORTING
        pi_pernr               = lv_nr_emp
      IMPORTING
        pe_tiene               = lv_jefe_flag
      EXCEPTIONS
        unidad_maxima_superada = 1
        no_encontrado          = 2
        OTHERS                 = 3.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ELSE.
* flag empleado tiene jefe directo
      line_aprov_reject-FlagBoss = lv_jefe_flag.
    ENDIF.
* fecha de cierre
* Obtenemos la fecha de cierre

    CALL METHOD ls_constants->get_first_value_range
      EXPORTING
        pi_rangeid     = '0000000080'
      IMPORTING
        pe_first_value = lv_cierre.

    line_aprov_reject-DateClose = lv_cierre.

* numero de cuotas
    CALL METHOD ls_constants->get_first_value_range
      EXPORTING
        pi_rangeid     = '0000000084'
*       pi_bukrs       = '*'
      IMPORTING
        pe_first_value = lv_nrcuota.
    CLEAR lv_nrcuota_cont.

    DO lv_nrcuota TIMES.
      ADD 1 TO lv_nrcuota_cont.
      lwa_value-value = lv_nrcuota_cont.
      lwa_value-text = lv_nrcuota_cont.
      APPEND lwa_value TO lit_value.
    ENDDO.

    "lv_node_info->set_attribute_value_set( name = 'NR_CUOTA_AP'  value_set = lit_value ).
* set valor defual numero de cuota
    lv_nrcuota = ls_solpres-zncuot.
    line_aprov_reject-QuotaNumbers = lv_nrcuota.

* motivo de prestamo
    CALL FUNCTION 'Z_HR_RFC_OBTIENE_SUBTIPOS'
      EXPORTING
        pernr    = lv_nr_emp
* IMPORTING
*       E_MONDM  =
*       E_CUODM  =
*       E_INIDM  =
*       E_FINDM  =
*       E_ABODM  =
*       E_NUMCUO =
*       E_PDM    =
*       E_PRESMAX       =
      TABLES
        et_subty = lit_motivo.
    CLEAR: lit_value, lwa_value.
    LOOP AT lit_motivo INTO lwa_motivo WHERE subty NE c_9105. " todos menos el dia de la madre
      lwa_value-value = lwa_motivo-subty.
      lwa_value-text = lwa_motivo-subtytext.
      APPEND lwa_value TO lit_value.
    ENDLOOP.
    "lv_node_info->set_attribute_value_set( name = 'MOTIVO_AP'  value_set = lit_value ). -- Es para la lista de motivos
* set valor defual subtipo
    lv_motivo = ls_solpres-dlart.
    line_aprov_reject-LoanType = lv_motivo.
* numero maximo de prestamos
    SELECT SINGLE zlow INTO lv_nr_maxcons FROM zbcranv_n WHERE "#EC *
          rangeid EQ '0000090443' AND
          bukrs EQ '*'.
    CONDENSE lv_nr_maxcons NO-GAPS.
    lv_nr_maxpres = lv_nr_maxcons.

    line_aprov_reject-QuotaNumbersMax = lv_nr_maxpres.
***
* identificar el nivel
* Primer nivel JU, Segundo Nivel JD , Tercer Nivel AP
    CLEAR lv_nivel.
    CASE lv_wi_rh_task.
      WHEN c_t90. " Nivel 1 Jefe unidad
        lv_nivel = '1'.
      WHEN c_t91. " Nivel 2 Aprobador GDH
        lv_nivel = '2'.
      WHEN c_t93. " Nivel 3 Aprobador final
        lv_nivel = '3'.
      WHEN OTHERS.
        lv_nivel = '0'.
    ENDCASE.


* indicar el nivel de aprobacion
    line_aprov_reject-Nivel = lv_nivel.

* transgresion mensaje
    DATA table_message TYPE STANDARD TABLE OF string.
    DATA tablet_msg TYPE hcm_msg.

    me->validar_solicitud( EXPORTING
                                 nivel          = lv_nivel
                                 jefe_ju        = lv_jefe_flag
                                 action         = '2'
                                 rel_lab        = line_aprov_reject-RelationLaboral
                                 fecha_cierre   = lv_cierre
                                 area_per       = lv_area_per
                                 fecha_fin      = lv_fecha_fin
                                 fecha_fin_cont = lv_fecha_fin_cont
                                 monto          = lv_monto
                                 montoend       = lv_montoend
                                 nr_maxpres     = lv_nr_maxpres
                                 nr_emp         = lv_nr_emp
                                 nr_cuota       = lv_nrcuota
                                 motivo         = lv_motivo
                            IMPORTING
                                 table_message = table_message
                                 table_msg     = tablet_msg
                            CHANGING
                                  trangr        = lv_trassta
                                  trangr_msg    = lv_trasmsg ).

    line_aprov_reject-TransgressionMes = lv_trasmsg.
    line_aprov_reject-TransgressionInd = lv_trassta.

    APPEND line_aprov_reject TO output_loan_ap_re.


  ENDMETHOD.


  METHOD approv_loan.

    DATA: lv_node            TYPE REF TO if_wd_context_node,
          lv_node_info       TYPE REF TO if_wd_context_node_info,
          lv_message_manager TYPE REF TO if_wd_message_manager,
          lv_api_component   TYPE REF TO if_wd_component.

    DATA: lv_save TYPE wdy_boolean.


    DATA: lv_nrcuota        TYPE ze_numcuota,
          lv_monto          TYPE ze_monto_prestamo,
          lv_imp_sim        TYPE ze_imp_cuota_simple,
          lv_imp_grt        TYPE ze_imp_cuota_grati,
          lv_nr_pres        TYPE ze_numsolpres,
          lv_motivo         TYPE dlart,
          lv_fecha_inicio   TYPE sy-datum,
          lv_fecha_fin      TYPE sy-datum,
          lv_fecha_cierre   TYPE char2,
          lv_comentario     TYPE ze_comenprest,
          lv_motivodesc     TYPE sbttx,
          lv_rel_lab        TYPE ansvh,
          lv_fecha_fin_cont TYPE ctedt,
          lv_montoend       TYPE ze_monto,
          lv_codmon         TYPE waers,
          lv_saldo          TYPE maxbt,
          lv_timsv          TYPE intdays,
          lv_remu           TYPE maxbt,
          lv_jefe_flag      TYPE flag,
          lv_montoend2      TYPE maxbt,
          lv_nr_emp         TYPE bapiusr01-employeeno,
          lv_status         TYPE wdy_boolean,
          lv_dni            TYPE psg_idnum,
          lv_correo         TYPE string,
          lv_trangr         TYPE ze_trangresion,
          ls_empleado       TYPE zwsolprestamo,
          ls_mensaje        TYPE  bapiret2,
          lv_nivel          TYPE char01,
          lv_action         TYPE char01,
          lv_msg            TYPE string,
          lv_msgtrg         TYPE ze_msjtransgre,
          lv_icon           TYPE string,
          lv_msg45          TYPE bapireturn1-message.
    DATA: lv_bool_field TYPE wdy_boolean,
          lv_bool_but1  TYPE wdy_boolean,
          lv_bool_but2  TYPE wdy_boolean,
          lv_ene_but1   TYPE wdy_boolean,
          lv_ene_but2   TYPE wdy_boolean,
          lv_ene_but3   TYPE wdy_boolean,
          lv_ene_but4   TYPE wdy_boolean,
          lv_ene_but5   TYPE wdy_boolean.
* cuota gratificacion
    DATA: lt_cuota     TYPE  TABLE OF pa0078,
          ls_cuota     TYPE pa0078,
          lv_soc       TYPE zbcranv_n-zlow,
          lv_bukrs     TYPE pa0001-bukrs,
          lv_bukrs1    TYPE pa0001-bukrs,
          lv_cont      TYPE sy-tabix,
          lv_index     TYPE sy-tabix,
          lv_index_nex TYPE sy-tabix,
          lv_flag_grt  TYPE c.

    DATA: ls_constants  TYPE REF TO zbc_constants_admin_n.

    TYPES: BEGIN OF lty_fechas ,
             fecha TYPE sy-datum,
           END OF lty_fechas.
    DATA: ls_fechas     TYPE lty_fechas,
          ls_fechas_nex TYPE lty_fechas,
          ls_fechas_aux TYPE lty_fechas,
          lt_fechas     TYPE TABLE OF lty_fechas,
          lt_fechas_aux TYPE TABLE OF lty_fechas.

    CONSTANTS: c_mark(1)    VALUE 'X', " True
               c_iconch(11) VALUE 'ICON_CHANGE',
               c_txtedi(9)  VALUE 'Modificar',
               gc_sty045    TYPE infty VALUE '0045'.


    CONSTANTS: c_pend(1) VALUE '1', "Pendiente
               c_modi(1) VALUE '2', " Modificado
               c_apro(1) VALUE '3', " Aprobado
               c_rech(1) VALUE '4', " Rechazado
               c_devo(1) VALUE '5', " Devuelto.
               c_ok(2)   VALUE 'OK'. " it 45

*  lv_node = wd_context->get_child_node( name = `APP_NODE` ).
    CLEAR: lv_icon, lv_msg, lv_msg45.
****
    DATA: line_approv_loan LIKE LINE OF aprov_reject_loan.

    line_approv_loan = aprov_reject_loan[ 1 ].

    lv_nrcuota = line_approv_loan-QuotaNumbers.

    lv_monto = line_approv_loan-LoanAmount.

    lv_motivo = line_approv_loan-LoanType.

    lv_imp_sim = line_approv_loan-QuotaAmountSimple.

    lv_imp_grt = line_approv_loan-QuotaAmountGrat.

    lv_fecha_fin = line_approv_loan-DateEnd.

    lv_fecha_cierre = line_approv_loan-DateClose.

    lv_trangr = line_approv_loan-TransgressionInd.

    lv_msgtrg = line_approv_loan-TransgressionMes.

* numero de prestamo
    lv_nr_pres = line_approv_loan-LoanAppNumber.
* Flag jefe empleado
    lv_jefe_flag = line_approv_loan-FlagBoss.

* Nivel
    lv_nivel = line_approv_loan-Nivel.
* Accion
    lv_action = line_approv_loan-Action.


* llenar estructura para generacion de prestamos
    CLEAR ls_empleado.
* leer solicitud
    CALL FUNCTION 'Z_HR_RFC_MANAGER_ZTSOLPRESTAMO'
      EXPORTING
        ip_accion  = 'R'
*       iw_solpres = ls_empleado
        ip_numsol  = lv_nr_pres
*       i_pernr    = lv_nr_emp
      IMPORTING
        ew_solpres = ls_empleado
*       ep_numsol  = lv_nr_pres
        ep_mensaje = ls_mensaje
*  tables
*       t_prestamos        =
*       T_PRESTAMOS2       =
*       T_PRESTAMOS3       =
      .
* actualizar los datos
* montivo
    ls_empleado-dlart = lv_motivo.
* Importe
    ls_empleado-zmonpr = lv_monto.
* Importe simple
    ls_empleado-zimpcs = lv_imp_sim.
* Importe gratificacion
    ls_empleado-zimpcg = lv_imp_grt.
* Numero de cutoa
    ls_empleado-zncuot = lv_nrcuota.
* fehca fin de pago
    ls_empleado-zfecfp =  lv_fecha_fin.

* transgresion
    ls_empleado-ztrang = lv_trangr.
    ls_empleado-zmsjtrangr = lv_msgtrg.
* actualizar estados de prestamo

* si es aprobado.

    CASE lv_nivel.
      WHEN '1'. " Jefe Directo
** si el empleado pertenece a la sociedad 100 indicada el flujo terminara en el jefe aprobador
        SELECT SINGLE bukrs INTO lv_bukrs
        FROM pa0001
        WHERE
        pernr EQ ls_empleado-pernr AND
        begda LE sy-datum AND
        endda GE sy-datum.
        IF sy-subrc EQ 0.
* selccionar sociedad permitida para aprobación directa.
          SELECT SINGLE zlow INTO lv_soc FROM zbcranv_n WHERE "#EC *
                rangeid EQ '0000091303' AND
                bukrs EQ lv_bukrs.
          IF sy-subrc EQ 0.
            lv_bukrs1 = lv_soc.
          ENDIF.
        ENDIF.
        IF lv_bukrs1 EQ lv_bukrs.
***** finaliza con la aprobacion del jefe de unidad

          CASE lv_action.
            WHEN '2'. "Aprobar
              ls_empleado-zestju = c_apro.
              ls_empleado-zestjd = space.
              ls_empleado-zestap = space.
              ls_empleado-zusuaproju = sy-uname.
              ls_empleado-zfecaproju = sy-datum.
            WHEN OTHERS.

          ENDCASE.
        ELSE.
          CASE lv_action.
            WHEN '2'. "Aprobar
* si esta en nivel 1 JD y existe transgresion enviar al aprobador GDH
              IF NOT lv_trangr IS INITIAL.
                ls_empleado-zestju = c_apro.
                ls_empleado-zestjd = c_pend.
                ls_empleado-zestap = space.
                ls_empleado-zusuaproju = sy-uname.
                ls_empleado-zfecaproju = sy-datum.
              ELSE. " Si no enviar a aprobador
                ls_empleado-zestju = c_apro.
                ls_empleado-zestjd = space.
                ls_empleado-zestap = c_pend.
                ls_empleado-zusuaproju = sy-uname.
                ls_empleado-zfecaproju = sy-datum.
              ENDIF.

            WHEN '3'. " Rechazar
            WHEN '4'. " Devolver.

            WHEN OTHERS. " 1 Grabar.
          ENDCASE.
        ENDIF.
      WHEN '2'. " GDH
        CASE lv_action.
          WHEN '2'. "Aprobar
            ls_empleado-zestju = space.
            ls_empleado-zestjd = c_apro.
            ls_empleado-zestap = c_pend.
            ls_empleado-zusuaprojd = sy-uname.
            ls_empleado-zfecaprojd = sy-datum.
          WHEN '3'. " Rechazar
          WHEN '4'. " Devolver.
* Estado Jefe de unida.
            CASE lv_jefe_flag.
              WHEN 'X'. " Tiene Jefe
                ls_empleado-zestju = c_pend.
                ls_empleado-zestjd = c_devo.
                ls_empleado-zestap = space.
                ls_empleado-zusuaprojd = sy-uname.
                ls_empleado-zfecaprojd = sy-datum.
              WHEN OTHERS.
*      ls_empleado-zestjd = '1'. " Enviar al aprobador GDH
            ENDCASE.

          WHEN OTHERS. " 1 Grabar.
        ENDCASE.

      WHEN  '3'. " Jefe Aprobador

        CASE lv_action.
          WHEN '2'. "Aprobar
            ls_empleado-zestjd = space.
            ls_empleado-zestju = space.
            ls_empleado-zestap = c_apro.
            ls_empleado-zusuaproap = sy-uname.
            ls_empleado-zfecaproap = sy-datum.
          WHEN '3'. " Rechazar
          WHEN '4'. " Devolver.
            IF NOT lv_trangr IS INITIAL. " GDH
              ls_empleado-zestju = space.
              ls_empleado-zestjd = c_pend.
              ls_empleado-zestap = c_devo.
              ls_empleado-zusuaproap = sy-uname.
              ls_empleado-zfecaproap = sy-datum.
            ELSE. " Si no enviar a aprobador
              CASE lv_jefe_flag.
                WHEN 'X'.  " Jefe directo
                  ls_empleado-zestju = c_pend.
                  ls_empleado-zestjd = space.
                  ls_empleado-zestap = c_devo.
                  ls_empleado-zusuaproap = sy-uname.
                  ls_empleado-zfecaproap = sy-datum.
                WHEN OTHERS. " Envia a GDH
                  ls_empleado-zestju = space.
                  ls_empleado-zestjd = c_pend.
                  ls_empleado-zestap = c_devo.
                  ls_empleado-zusuaproap = sy-uname.
                  ls_empleado-zfecaproap = sy-datum.
              ENDCASE.
            ENDIF.

          WHEN OTHERS. " 1 Grabar.
        ENDCASE.

    ENDCASE.

    CASE lv_action.
      WHEN '1'. " grabar.
        CASE lv_nivel.
          WHEN '1'.
* aprobar rechazar
            lv_bool_but2 = c_mark.
          WHEN '2'.

          WHEN '3'.
* aprobar rechazar devolver habilitado
            lv_bool_but2 = c_mark.
        ENDCASE.
* actualizar estado de los campos
        lv_bool_field = c_mark.

        CALL FUNCTION 'Z_HR_RFC_MANAGER_ZTSOLPRESTAMO'
          EXPORTING
            ip_accion  = 'U'
            iw_solpres = ls_empleado
            ip_numsol  = lv_nr_pres
*           i_pernr    = lv_nr_emp
          IMPORTING
*           EW_SOLPRES = ls_empleado
*           ep_numsol  = lv_nr_pres
            ep_mensaje = ls_mensaje.
        CASE ls_mensaje-type.
          WHEN 'S'.
            lv_icon = 'ICON_SYSTEM_OKAY'.
            lv_msg  = ls_mensaje-message.
          WHEN 'E'.
            lv_icon = 'ICON_SYSTEM_CANCEL'.
            lv_msg  = ls_mensaje-message.
        ENDCASE.
      WHEN OTHERS. "2 aprobar, 3 Rechazar, "4 Devolver.
        " Deshabilitar todos los botones si se ha ejecutado alguna accion
* si es el nivel 3 y ademas es aprobar debe generar el infotipo 45
        IF lv_action EQ '2' AND lv_nivel EQ '3'.
          REFRESH lt_cuota.
          IF  ls_empleado-zimpcg GT 0. " hay monto en cuota de gratificacion calcular las fechas
* generar los registros para la cuota extraordinaria de gratificacion
* calcular fecha inicio y fin de amortizacion
            lv_fecha_inicio = sy-datum.
            IF lv_fecha_inicio+6(2) LE lv_fecha_cierre.
              CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
                EXPORTING
                  day_in            = lv_fecha_inicio
                IMPORTING
                  last_day_of_month = lv_fecha_inicio
                EXCEPTIONS
                  day_in_no_date    = 1
                  OTHERS            = 2.
              IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
              ENDIF.
            ELSE.
              lv_fecha_inicio+6(2) = '01'.
              CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
                EXPORTING
                  months  = '001'
                  olddate = lv_fecha_inicio
                IMPORTING
                  newdate = lv_fecha_inicio.
            ENDIF.

            lv_fecha_fin = lv_fecha_inicio.
            CLEAR ls_fechas.
            ls_fechas-fecha = lv_fecha_fin.
            APPEND ls_fechas TO lt_fechas.
            lv_nrcuota = lv_nrcuota - 1.

            DO lv_nrcuota TIMES.
              CALL FUNCTION 'RE_ADD_MONTH_TO_DATE'
                EXPORTING
                  months  = '001'
                  olddate = ls_fechas-fecha
                IMPORTING
                  newdate = ls_fechas-fecha.
              IF sy-datum+6(2) LE lv_fecha_cierre.
                CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
                  EXPORTING
                    day_in            = ls_fechas-fecha
                  IMPORTING
                    last_day_of_month = ls_fechas-fecha
                  EXCEPTIONS
                    day_in_no_date    = 1
                    OTHERS            = 2.
                IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
                ENDIF.
              ENDIF.
              APPEND ls_fechas TO lt_fechas.
            ENDDO.
            DESCRIBE TABLE lt_fechas LINES lv_cont.

            READ TABLE lt_fechas INTO ls_fechas INDEX lv_cont.
            IF sy-subrc EQ 0.
              lv_fecha_fin = ls_fechas-fecha.
            ENDIF.
*
            CLEAR lv_index.
            WHILE lv_index LE lv_cont.
              ADD 1 TO lv_index.
              CHECK lv_index LE lv_cont.
              lv_index_nex = lv_index.
              ADD 1 TO lv_index_nex.
              READ TABLE lt_fechas INTO ls_fechas INDEX lv_index.
              IF sy-subrc EQ 0.
                CASE ls_fechas+4(2).
                  WHEN '07' OR '12'.
                    READ TABLE lt_fechas INTO ls_fechas_nex INDEX lv_index_nex.
                    IF sy-subrc EQ 0.
                      IF lv_index EQ 1 AND ls_fechas+6(2) EQ '01'.
                        DELETE lt_fechas INDEX lv_cont.
                        SUBTRACT 1 FROM lv_cont.
                        ls_cuota-zahld = ls_fechas.
                        APPEND ls_cuota TO lt_cuota.
                      ELSEIF lv_index GT 1.
                        DELETE lt_fechas INDEX lv_cont.
                        SUBTRACT 1 FROM lv_cont.
                        ls_cuota-zahld = ls_fechas.
                        APPEND ls_cuota TO lt_cuota.
                      ENDIF.

                    ENDIF.
                ENDCASE.
              ENDIF.
            ENDWHILE.
            READ TABLE lt_fechas INTO ls_fechas INDEX lv_cont.
            IF sy-subrc EQ 0.
              lv_fecha_fin = ls_fechas-fecha.
            ENDIF.
          ENDIF.

          CALL FUNCTION 'Z_HR_RFC_SAVE_SOL_PRESTAMO2'
            EXPORTING
              ip_numsol = lv_nr_pres
            IMPORTING
              ep_return = lv_msg45
            TABLES
              it_cuotas = lt_cuota[].

          IF lv_msg45 NE c_ok.
            lv_icon = 'ICON_SYSTEM_CANCEL'.
            lv_msg  = lv_msg45.

          ENDIF.

        ENDIF.

        CHECK lv_msg45 IS INITIAL OR lv_msg45 EQ c_ok.

        lv_bool_but2 = space.

        CALL FUNCTION 'Z_HR_RFC_MANAGER_ZTSOLPRESTAMO' DESTINATION 'NONE'
          EXPORTING
            ip_accion  = 'M'
            iw_solpres = ls_empleado
            ip_numsol  = lv_nr_pres
*           i_pernr    = lv_nr_emp
          IMPORTING
*           EW_SOLPRES = ls_empleado
*           ep_numsol  = lv_nr_pres
            ep_mensaje = ls_mensaje.

        CASE ls_mensaje-type.
          WHEN 'S'.
            lv_icon = 'ICON_SYSTEM_OKAY'.
            lv_msg  = ls_mensaje-message.
          WHEN 'E'.
            lv_icon = 'ICON_SYSTEM_CANCEL'.
            lv_msg  = ls_mensaje-message.
        ENDCASE.
    ENDCASE.


* mensaje de confirmacion
    icon = lv_icon.
    message = lv_msg.

  ENDMETHOD.


  METHOD reject_loan.
    DATA:

      lv_node      TYPE REF TO if_wd_context_node,
      lv_node_info TYPE REF TO if_wd_context_node_info,
      lv_node_elem TYPE REF TO if_wd_context_element,
      lv_msg       TYPE string,
      lv_icon      TYPE string.
    DATA: lv_nr_pres_ap TYPE ze_numsolpres,
          lv_nivel_ap   TYPE c,
          lv_ene_but1   TYPE wdy_boolean,
          lv_ene_but2   TYPE wdy_boolean,
          lv_ene_but3   TYPE wdy_boolean,
          lv_ene_but4   TYPE wdy_boolean,
          lv_ene_but5   TYPE wdy_boolean,
          lv_rej_msg    TYPE alshuffvl_wao.
    DATA: ls_empleado TYPE zwsolprestamo,
          ls_mensaje  TYPE bapiret2.


    FIELD-SYMBOLS <param> TYPE wdr_event_parameter.
    FIELD-SYMBOLS <button> TYPE wdr_value.

    DATA: line_aprov_reject_loan LIKE LINE OF aprov_reject_loan.


    line_aprov_reject_loan = aprov_reject_loan[ 1 ].


* Ok

    lv_nr_pres_ap = line_aprov_reject_loan-LoanAppNumber.
    lv_nivel_ap = line_aprov_reject_loan-Nivel.

* leer los datos del prestamos.
    CALL FUNCTION 'Z_HR_RFC_MANAGER_ZTSOLPRESTAMO' DESTINATION 'NONE'
      EXPORTING
        ip_accion  = 'R'
*       iw_solpres = ls_empleado
        ip_numsol  = lv_nr_pres_ap
*       i_pernr    = lv_nr_emp
      IMPORTING
        ew_solpres = ls_empleado
*       ep_numsol  = lv_nr_pres
        ep_mensaje = ls_mensaje.

    IF sy-subrc EQ 0.
      CASE lv_nivel_ap.
        WHEN '1'. "Jefe directo
          ls_empleado-zusuaproju = sy-uname.
          ls_empleado-zfecaproju = sy-datum.
          ls_empleado-zestju  = '4'. " Rechazad
          CLEAR: ls_empleado-zusuaprojd ,
                 ls_empleado-zfecaprojd,
                 ls_empleado-zestjd,
                 ls_empleado-zusuaproap,
                 ls_empleado-zfecaproap,
                 ls_empleado-zestap.
        WHEN '2'. "GDH
          ls_empleado-zusuaprojd = sy-uname.
          ls_empleado-zfecaprojd = sy-datum.
          ls_empleado-zestjd = '4'.
          CLEAR: ls_empleado-zusuaproju ,
             ls_empleado-zfecaproju,
             ls_empleado-zestju,
             ls_empleado-zusuaproap,
             ls_empleado-zfecaproap,
             ls_empleado-zestap.
        WHEN '3'. " Aprobador de prestamos.
          ls_empleado-zusuaproap = sy-uname.
          ls_empleado-zfecaproap = sy-datum.
          ls_empleado-zestap = '4'. "Rechazado
          CLEAR: ls_empleado-zusuaprojd ,
                   ls_empleado-zfecaprojd,
                   ls_empleado-zestjd,
                   ls_empleado-zusuaproju,
                   ls_empleado-zfecaproju,
                   ls_empleado-zestju.

      ENDCASE.

* se obtiene el mensaje de rechazo.
      lv_rej_msg = line_aprov_reject_loan-RejectMessaje.
      ls_empleado-obs = lv_rej_msg.

      CALL FUNCTION 'Z_HR_RFC_MANAGER_ZTSOLPRESTAMO' DESTINATION 'NONE'
        EXPORTING
          ip_accion  = 'M'
          iw_solpres = ls_empleado
          ip_numsol  = lv_nr_pres_ap
        IMPORTING
          ep_mensaje = ls_mensaje.
      CASE ls_mensaje-type.
        WHEN 'S'.
          lv_icon = 'ICON_SYSTEM_OKAY'.
          lv_msg  = ls_mensaje-message.
        WHEN 'E'.
          lv_icon = 'ICON_SYSTEM_CANCEL'.
          lv_msg  = ls_mensaje-message.
      ENDCASE.
* mensaje de confirmacion

      IF lv_icon EQ 'ICON_SYSTEM_OKAY'.
        type = 'S'.
        message = lv_msg.
      ELSE.
        type = 'E'.
        message = lv_msg.
      ENDIF.


    ENDIF.
  ENDMETHOD.


  METHOD create_loan_admin.

    CONSTANTS: gc_sty045 TYPE infty VALUE '0045',
               c_9105(4) TYPE c VALUE '9105'. " dia de la madre

    DATA: lv_node      TYPE REF TO if_wd_context_node,
          lv_node_info TYPE REF TO if_wd_context_node_info.

    DATA: ls_mensaje  TYPE bapiret2.

    DATA: lv_nrcuota         TYPE ze_numcuota,
          lv_monto           TYPE ze_monto_prestamo,
          lv_imp_sim         TYPE ze_imp_cuota_simple,
          lv_imp_grt         TYPE ze_imp_cuota_grati,
          lv_motivo          TYPE dlart,
          lv_fecha_inicio    TYPE sy-datum,
          lv_fecha_fin       TYPE sy-datum,
          lv_comentario      TYPE ze_comenprest,
          lv_motivodesc      TYPE sbttx,
          lv_rel_lab         TYPE ansvh,
          lv_area_per        TYPE persk,
          lv_fecha_fin_cont  TYPE ctedt,
          lv_montoend        TYPE ze_monto,
          lv_saldo           TYPE maxbt,
          lv_timsv           TYPE intdays,
          lv_remu            TYPE maxbt,
          lv_trangr          TYPE ze_trangresion,
          lv_nr_maxpres      TYPE ze_numcuota,
          lv_montoend2       TYPE maxbt,
          lv_nr_emp          TYPE bapiusr01-employeeno,
          lv_status          TYPE wdy_boolean,
          lv_fecha_cierre(2) TYPE c,
          lv_tranmsg         TYPE ze_msjtransgre,
          lv_codmon          TYPE waers,
          lv_dni             TYPE psg_idnum,
          lv_correo          TYPE string,
          lv_jefe_flag       TYPE flag,
          lv_mon_cuota_min   TYPE ze_monto.

    DATA: line_request_loan LIKE LINE OF request_loan.
    line_request_loan = request_loan[ 1 ].

    lv_nrcuota = line_request_loan-QuotaNumbers.
    lv_monto   = line_request_loan-LoanAmount.
    lv_motivo  = line_request_loan-LoanType.
    lv_comentario   = line_request_loan-CommentLoan.
    lv_nr_emp       = line_request_loan-EmployeeNumber.

    get_data_init_loan_admin( EXPORTING
                                lv_nr_emp = lv_nr_emp
                              IMPORTING
                                lv_montoend         =  lv_montoend
                                lv_montoend2        = lv_montoend2
                                lv_rel_lab          = lv_rel_lab
                                lv_saldo            = lv_saldo
                                lv_remu             = lv_remu
                                lv_timsv            = lv_timsv
                                lv_fecha_fin_cont   = lv_fecha_fin_cont
                                lv_nr_maxpres       = lv_nr_maxpres
                                lv_area_per         = lv_area_per
                                lv_cierre           = lv_fecha_cierre
                                lv_fecha_inicio     = lv_fecha_inicio
                                lv_codmon           = lv_codmon
                                lv_dni_emp          = lv_dni
                                lv_mail             = lv_correo
                                lv_jefe_flag        = lv_jefe_flag
                                lv_mon_cuota_min    = lv_mon_cuota_min
                                ).

* obtener descripcion del motivo
    SELECT SINGLE stext INTO lv_motivodesc
           FROM t591s
           WHERE sprsl EQ sy-langu
             AND infty EQ gc_sty045
             AND subty EQ lv_motivo.
* calcular monto de prestamo

    calcular_prestamo( EXPORTING nr_cuota = lv_nrcuota
                                 monto = lv_monto
                                 fecha_cierre = lv_fecha_cierre
                       CHANGING  cuota_sim = lv_imp_sim
                                 cuota_grt = lv_imp_grt
                                 fecha_ini = lv_fecha_inicio
                                 fecha_fin = lv_fecha_fin ).


** validaciones de prestamo
    DATA table_message TYPE STANDARD TABLE OF string.
    DATA table_msg TYPE hcm_msg.

    validar_solicitud( EXPORTING rel_lab      = lv_rel_lab
                                area_per =  lv_area_per
                                fecha_fin = lv_fecha_fin
                                fecha_fin_cont = lv_fecha_fin_cont
                                monto = lv_monto
                                montoend = lv_montoend
                                nr_maxpres = lv_nr_maxpres
                                nr_emp = lv_nr_emp
                                nr_cuota = lv_nrcuota
                                motivo = lv_motivo
                                fecha_cierre = lv_fecha_cierre
                                comentario  = lv_comentario
                      IMPORTING
                            table_message = table_message
                            table_msg     = table_msg
                      CHANGING   trangr = lv_trangr
                                 trangr_msg = lv_tranmsg ).

    " Valida si supera el monto mínimo por quota

    IF lv_mon_cuota_min > lv_imp_sim.

        DATA: quota_min TYPE string.

        quota_min = lv_mon_cuota_min.


        DATA: message_error  type lty_msg.

        message_error-tipo = 'E'.

        CONCATENATE 'El monto mínmo por cuota es de : ' quota_min lv_codmon ' , colocar una cuota mayor' INTO message_error-msg.

        CLEAR:table_msg.
        APPEND message_error TO table_msg.

    ENDIF.


    DATA: flag_create_loan TYPE flag.

    flag_create_loan = ''.

    IF table_msg IS INITIAL.

      flag_create_loan = 'X'.

    ELSE.

      IF table_msg[ 1 ]-tipo EQ 'X'.

        flag_create_loan = 'X'.

      ELSE.

        LOOP AT table_msg INTO DATA(line_msg).
          ep_mensaje-type = line_msg-tipo.
          ep_mensaje-message = line_msg-msg.
        ENDLOOP.

      ENDIF.

    ENDIF.

    IF flag_create_loan EQ 'X'.

** Crear Prestamo

    DATA: output_icon TYPE string.
      DATA: output_message TYPE string.

      DATA: ls_empleado       TYPE zwsolprestamo.

* llenar estructura para generacion de prestamos
      CLEAR ls_empleado.
* numero de empleado
      ls_empleado-pernr = lv_nr_emp.
* montivo
      ls_empleado-dlart = lv_motivo.
* Importe
      ls_empleado-zmonpr = lv_monto.
* moneda
      ls_empleado-waers = lv_codmon.
* Importe simple
      ls_empleado-zimpcs = lv_imp_sim.
* Importe gratificacion
      ls_empleado-zimpcg = lv_imp_grt.
* Numero de cutoa
      ls_empleado-zncuot = lv_nrcuota.
* fehca fin de pago
      ls_empleado-zfecfp =  lv_fecha_fin.
* comentario
      ls_empleado-zcomen = lv_comentario.
* Usuario
      ls_empleado-zususl = sy-uname.
* Fecha de solicitud
      ls_empleado-zfecsl = sy-datum.
* DNI
      ls_empleado-dni = lv_dni.
* Mail
      ls_empleado-mail = line_request_loan-mail.
* Estado Jefe de unida.
      CASE lv_jefe_flag.
        WHEN 'X'. " Tiene Jefe
          ls_empleado-zestju = '1'.
        WHEN OTHERS.
          ls_empleado-zestjd = '1'. " Enviar al aprobador GDH
      ENDCASE.
      CASE lv_motivo.
        WHEN c_9105.
          CLEAR: ls_empleado-zestju, ls_empleado-zestjd, ls_empleado-zestap.
        WHEN OTHERS.
      ENDCASE.
* transgresion
      ls_empleado-ztrang = lv_trangr.
      ls_empleado-zmsjtrangr = lv_tranmsg.
*+@CCC - 18.12.2023{
* Términos y condiciones
      ls_empleado-terycond = line_request_loan-TermsConditions.
*}+@CCC - 18.12.2023
* estado aprobador

      CALL FUNCTION 'Z_HR_RFC_MANAGER_ZTSOLPRESTAMO' DESTINATION 'NONE'
        EXPORTING
          ip_accion  = 'S'
          iw_solpres = ls_empleado
*         IP_NUMSOL  =
          i_pernr    = lv_nr_emp
        IMPORTING
*         EW_SOLPRES =
          ep_numsol  = result_num_prestamo
          ep_mensaje = ep_mensaje
*  tables
*         t_prestamos        =
*         T_PRESTAMOS2       =
*         T_PRESTAMOS3       =
        .

    ENDIF.


  ENDMETHOD.


  METHOD get_data_init_loan_admin.

**Constantes
    DATA: ls_constants  TYPE REF TO zbc_constants_admin_n.

    DATA: lv_nrcuota_cont TYPE ze_numcuota,
          lwa_motivo      TYPE  cawao_s_subtytab.
    DATA:
      lit_value     TYPE TABLE OF wdr_context_attr_value,
      lwa_value     TYPE wdr_context_attr_value,
      lv_node       TYPE REF TO if_wd_context_node,
      lv_node_info  TYPE REF TO if_wd_context_node_info,
      lv_node_elem  TYPE REF TO if_wd_context_element,
      lv_bool       TYPE wdy_boolean,
      lv_nr_maxcons TYPE string,
      lv_msg2       TYPE string,
      lv_msg3       TYPE string,
      lv_group_res  TYPE REF TO cl_wd_group,
      ls_mensaje    TYPE bapiret2,
      lv_ena_but1   TYPE wdy_boolean,
      lv_flag_ge    TYPE flag.

    CONSTANTS: c_9105(4) TYPE c VALUE '9105'.

    TRY.
        CREATE OBJECT ls_constants
          EXPORTING
            pi_repid = 'HR_PO_PY001'.
      CATCH cx_alert_unknown .
    ENDTRY.

*-@CCC{ - 18.12.2023
* Se inicializa inhabilitado

*}-@CCC - 18.12.2023
* mail
    SELECT SINGLE usrid_long INTO lv_mail FROM pa0105
    WHERE pernr = lv_nr_emp AND
          usrty = '0030' AND
          endda >= sy-datum AND
          begda <= sy-datum.

    CONDENSE lv_mail NO-GAPS.
* obtener  DNI empleado
*          .
    SELECT SINGLE icnum INTO lv_dni_emp FROM pa0185
    WHERE pernr = lv_nr_emp.
    CONDENSE lv_dni_emp NO-GAPS.

* area de personal.
    SELECT SINGLE persk INTO lv_area_per
    FROM pa0001
    WHERE pernr = lv_nr_emp AND
          endda >= sy-datum AND
          begda <= sy-datum.

    CLEAR lv_flag_ge.
    CALL FUNCTION 'Z_HR_ES_GERENTE_PERSK'
      EXPORTING
        pi_persk     = lv_area_per
      IMPORTING
        pe_esgerente = lv_flag_ge.
    CASE lv_flag_ge.
      WHEN 'X'.
        lv_area_per = 'GE'. " Gerente.
      WHEN OTHERS.
    ENDCASE.
* otros datos de personal

    CALL FUNCTION 'Z_HR_RFC_OBTIENE_INFO_PRESTAMO'
      EXPORTING
        ip_pernr = lv_nr_emp
      IMPORTING
        ep_ansvh = lv_rel_lab
*       EP_ANSTX =
        ep_monto = lv_montoend
        ep_waers = lv_codmon
        ep_ktext = lv_moneda
        ep_ctedt = lv_fecha_fin_cont
        ep_nombr = lv_nombre
        ep_saldo = lv_saldo
        ep_timsv = lv_timsv
        ep_remu  = lv_remu
        ep_endeu = lv_montoend2.


*lv_NR_EMP = '000123'.

* verificar si empleado tiene jefe
    CALL FUNCTION 'Z_HR_TIENE_JEFE_MENOR_DIVISION'
      EXPORTING
        pi_pernr               = lv_nr_emp
      IMPORTING
        pe_tiene               = lv_jefe_flag
      EXCEPTIONS
        unidad_maxima_superada = 1
        no_encontrado          = 2
        OTHERS                 = 3.

* Obtenemos la fecha de cierre

    CALL METHOD ls_constants->get_first_value_range
      EXPORTING
        pi_rangeid     = '0000000080'
      IMPORTING
        pe_first_value = lv_cierre.

    lv_fecha_inicio = sy-datum.
* numero de cuotas
    CALL METHOD ls_constants->get_first_value_range
      EXPORTING
        pi_rangeid     = '0000000084'
*       pi_bukrs       = '*'
      IMPORTING
        pe_first_value = lv_nrcuota.
    CLEAR lv_nrcuota_cont.

* monto cuota max
    CALL METHOD ls_constants->get_first_value_range
      EXPORTING
        pi_rangeid     = '0000000086'
*       pi_bukrs       = '*'
      IMPORTING
        pe_first_value = lv_mon_cuota_min.

* motivo de prestamo
    CALL FUNCTION 'Z_HR_RFC_OBTIENE_SUBTIPOS'
      EXPORTING
        pernr    = lv_nr_emp
* IMPORTING
*       E_MONDM  =
*       E_CUODM  =
*       E_INIDM  =
*       E_FINDM  =
*       E_ABODM  =
*       E_NUMCUO =
*       E_PDM    =
*       E_PRESMAX       =
      TABLES
        et_subty = lit_motivo.

* numero maximo de prestamos
*  CALL METHOD ls_constants->get_first_value_range
*      EXPORTING
*        pi_rangeid = '0000090443'
**      pi_bukrs   = '*'
*      IMPORTING
*        pe_first_value   = lv_nr_maxpres.

    SELECT SINGLE zlow INTO lv_nr_maxcons FROM zbcranv_n WHERE "#EC *
          rangeid EQ '0000090443' AND
          bukrs EQ '*'.
    CONDENSE lv_nr_maxcons NO-GAPS.
    lv_nr_maxpres = lv_nr_maxcons.


  ENDMETHOD.
ENDCLASS.
