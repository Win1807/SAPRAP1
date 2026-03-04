class ZCL_HCM_SUBSTITUTION_RECORD definition
  public
  final
  create public .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    TYPES hcm_data_employees          TYPE STANDARD TABLE OF zc_hcm_get_employee.
    TYPES hcm_data_employee_data      TYPE STANDARD TABLE OF zc_hcm_get_employee_data.
    TYPES hcm_data_time_work_schedule TYPE STANDARD TABLE OF zc_hcm_time_work_schedule.
    TYPES hcm_register_subs           TYPE STANDARD TABLE OF zc_hcm_register_subs.
    TYPES hcm_data_personal_subs      TYPE STANDARD TABLE OF zc_hcm_get_personal_substitute.
    TYPES ep_p0002                    TYPE STANDARD TABLE OF pa0002.

    METHODS get_employee_search
      IMPORTING employee_number   TYPE pernr_d
                employee_name     TYPE vorna
                employee_lastname TYPE nachn
                flag              TYPE char0001 DEFAULT 'T'
      RETURNING VALUE(result)     TYPE zhcmt_employees.

    METHODS get_employee_data
      IMPORTING employee_number TYPE persno
      RETURNING VALUE(result)   TYPE zhcms_empoyee_data.

    METHODS get_time_work_schedule
      IMPORTING employee_number TYPE pernr_d
                value_date      TYPE sy-datum
      RETURNING VALUE(result)   TYPE zhcms_time_work_schedule.

    METHODS post_register_substitute
      IMPORTING register_substitute_employees TYPE hcm_register_subs
      RETURNING VALUE(result)                 TYPE zhcms_message.

    METHODS get_personal_substitute
      IMPORTING employee_number   TYPE persno
                !name             TYPE vornamc OPTIONAL
                patternal_surname TYPE nachnmc OPTIONAL
                society           TYPE bukrs
      changing personal_subs     TYPE hcm_data_personal_subs.

protected section.
private section.
ENDCLASS.



CLASS ZCL_HCM_SUBSTITUTION_RECORD IMPLEMENTATION.


  METHOD get_employee_search.
    " TODO: parameter FLAG is never used (ABAP cleaner)

    DATA employees_aux TYPE STANDARD TABLE OF pa0002.
    DATA employee_aux  TYPE pa0002.
    DATA employee_out  TYPE zhcms_employees.

    CALL FUNCTION 'Z_HR_RFC_EMPLOYEE_SEARCH'
      EXPORTING ip_pernr     = employee_number
                ip_vorna     = employee_name
                ip_nachn     = employee_lastname
                ip_flag      = 'T'
      TABLES    et_employees = employees_aux.

    DELETE ADJACENT DUPLICATES FROM employees_aux COMPARING pernr.
    LOOP AT employees_aux INTO employee_aux.
      MOVE-CORRESPONDING employee_aux TO employee_out.
      INSERT employee_out INTO TABLE Result.
    ENDLOOP.
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
    TRY.

        DATA(page_size) = io_request->get_paging( )->get_page_size( ).
        DATA(offset) = io_request->get_paging( )->get_offset( ).

        DATA(parameters) = io_request->get_parameters( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(sort_order)    = io_request->get_sort_elements( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(search_string) = io_request->get_search_expression( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(param) = io_request->get_parameters( ).
        TRY.
            " TODO: variable is assigned but never used (ABAP cleaner)
            DATA(filter) = io_request->get_filter( ).

            CASE io_request->get_entity_id( ).

              WHEN 'ZC_HCM_GET_EMPLOYEE'.

                DATA employees           TYPE zhcmt_employees.
                DATA interface_employees TYPE hcm_data_employees.

                " Get request filters
                DATA(filters_range) = io_request->get_filter( )->get_as_ranges( ).

                DATA value_param_employ  TYPE persno.
                DATA value_param_name    TYPE vorna.
                DATA value_param_surname TYPE nachn.

                IF filters_range IS NOT INITIAL.

                  LOOP AT filters_range INTO DATA(filter_range).
                    CASE filter_range-name.
                      WHEN 'EMPLOYEENUMB'.
                        value_param_employ = filter_range-range[ 1 ]-low.
                      WHEN 'NAMEVORNA'.
                        value_param_name = filter_range-range[ 1 ]-low.
                      WHEN 'SURNAMENACHN'.
                        value_param_surname = filter_range-range[ 1 ]-low.
                    ENDCASE.
                  ENDLOOP.
                ENDIF.

                IF value_param_employ IS INITIAL AND value_param_name IS INITIAL AND value_param_surname IS INITIAL.
                  value_param_name = '*'.
                ENDIF.

                " --- Request data
                IF io_request->is_data_requested( ).
                  "-- Paging:
                  " TODO: variable is assigned but never used (ABAP cleaner)
                  DATA(skip_rows_number) = io_request->get_paging( )->get_offset( ).

                  "--- List of WorkListItem
                  employees = get_employee_search( employee_number   = value_param_employ
                                                   employee_name     = value_param_name
                                                   employee_lastname = value_param_surname ).

                  " Fill response
                  DATA interface_employee LIKE LINE OF interface_employees.

                  IF page_size > 0.
                    LOOP AT employees INTO DATA(employee) FROM offset + 1 TO ( offset + page_size ).

                      interface_employee-employeenumber  = employee-pernr.
                      interface_employee-name            = employee-vorna.
                      interface_employee-paternalsurname = employee-nachn.
                      interface_employee-maternalsurname = employee-nach2.

                      INSERT interface_employee INTO TABLE interface_employees.
                    ENDLOOP.
                  ELSE.
                    LOOP AT employees INTO employee.

                      interface_employee-employeenumber  = employee-pernr.
                      interface_employee-name            = employee-vorna.
                      interface_employee-paternalsurname = employee-nachn.
                      interface_employee-maternalsurname = employee-nach2.

                      INSERT interface_employee INTO TABLE interface_employees.
                    ENDLOOP.
                  ENDIF.

                  io_response->set_data( interface_employees ).

                  IF io_request->is_total_numb_of_rec_requested( ).
                    io_response->set_total_number_of_records( lines( employees ) ).
                  ENDIF.

                ENDIF.

              WHEN 'ZC_HCM_GET_EMPLOYEE_DATA'.

                DATA employee_aux                TYPE zhcms_empoyee_data.
                DATA interface_employees_data    TYPE hcm_data_employee_data.
                DATA value_param_employee_number TYPE persno.

                IF parameters IS NOT INITIAL.
                  value_param_employee_number = parameters[ 1 ]-value.
                ENDIF.

                employee_aux = get_employee_data( employee_number = value_param_employee_number ).

                " Fill response
                DATA interface_employee_data LIKE LINE OF interface_employees_data.

                MOVE-CORRESPONDING employee_aux TO interface_employee_data.
                INSERT interface_employee_data INTO TABLE interface_employees_data.
                io_response->set_data( interface_employees_data ).

                IF io_request->is_total_numb_of_rec_requested( ).
                  io_response->set_total_number_of_records( lines( interface_employees_data ) ).
                ENDIF.

              WHEN 'ZC_HCM_TIME_WORK_SCHEDULE'.

                DATA time_work_schedule            TYPE zhcms_time_work_schedule.
                DATA interface_time_work_schedules TYPE hcm_data_time_work_schedule.

                DATA parameter_employee_number     TYPE pernr_d.
                DATA parameter_date                TYPE sy-datum.

                IF parameters IS NOT INITIAL.
                  LOOP AT parameters INTO DATA(parameters_structure).

                    CASE parameters_structure-parameter_name.
                      WHEN 'EMPLOYEENUMBER'.
                        parameter_employee_number = parameters_structure-value.
                      WHEN 'VALUEDATE'.
                        parameter_date = parameters_structure-value.
                    ENDCASE.

                  ENDLOOP.
                ENDIF.

                time_work_schedule = get_time_work_schedule( employee_number = parameter_employee_number
                                                             value_date      = parameter_date ).

                " Fill response
                DATA interface_time_work_schedule LIKE LINE OF interface_time_work_schedules.

                MOVE-CORRESPONDING time_work_schedule TO interface_time_work_schedule.
                INSERT interface_time_work_schedule INTO TABLE interface_time_work_schedules.

                io_response->set_data( interface_time_work_schedules ).

                IF io_request->is_total_numb_of_rec_requested( ).
                  io_response->set_total_number_of_records( lines( interface_time_work_schedules ) ).
                ENDIF.

              WHEN 'ZC_HCM_REGISTER_SUBS'.

                DATA interface_emp_substi_register TYPE hcm_register_subs.

                io_response->set_data( interface_emp_substi_register ).

                IF io_request->is_total_numb_of_rec_requested( ).
                  io_response->set_total_number_of_records( lines( interface_emp_substi_register ) ).
                ENDIF.

              WHEN 'ZC_HCM_GET_PERSONAL_SUBSTITUTE'.

                DATA employee_substitutes           TYPE hcm_data_personal_subs.
                DATA interface_employee_substitutes TYPE hcm_data_personal_subs.

                DATA parameter_employee_numb        TYPE pernr_d.
                DATA parameter_society              TYPE bukrs.

                IF parameters IS NOT INITIAL.
                  LOOP AT parameters INTO DATA(p_structure).

                    CASE p_structure-parameter_name.
                      WHEN 'EMPLOYEENUMB'.
                        parameter_employee_numb = p_structure-value.
                      WHEN 'SOCIETY'.
                        parameter_society = p_structure-value.
                    ENDCASE.

                  ENDLOOP.
                ENDIF.

                get_personal_substitute( EXPORTING employee_number   = parameter_employee_numb
                                                   society           = parameter_society
                                                   name              = '*'
                                                   patternal_surname = '*'
                                         CHANGING  personal_subs     = employee_substitutes ).

                " Fill response
                DATA interface_employee_substitute LIKE LINE OF interface_employee_substitutes.

                IF page_size > 0.
                  LOOP AT employee_substitutes INTO DATA(employee_substitute) FROM offset + 1 TO ( offset + page_size ).

                    MOVE-CORRESPONDING employee_substitute TO interface_employee_substitute.
                    INSERT interface_employee_substitute INTO TABLE interface_employee_substitutes.

                  ENDLOOP.
                ELSE.
                  LOOP AT employee_substitutes INTO employee_substitute.

                    MOVE-CORRESPONDING employee_substitute TO interface_employee_substitute.
                    INSERT interface_employee_substitute INTO TABLE interface_employee_substitutes.
                  ENDLOOP.
                ENDIF.

                io_response->set_data( interface_employee_substitutes ).

                IF io_request->is_total_numb_of_rec_requested( ).
                  io_response->set_total_number_of_records( lines( interface_employee_substitutes ) ).
                ENDIF.
            ENDCASE.
          CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_range).
            MESSAGE lx_no_range->get_text( ) TYPE 'E'.
        ENDTRY.
      CATCH cx_rap_query_provider INTO DATA(lx_query_provider).
        MESSAGE lx_query_provider->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD get_employee_data.
    CALL FUNCTION 'Z_HR_RFC_GET_IT0001_DATA'
      EXPORTING ip_pernr = employee_number
      IMPORTING name     = result-name
                sname    = result-sname
                bukrs    = result-companycode
                butxt    = result-companyname
                persa    = result-personalarea
                pbtxt    = result-personalareatext
                btrtl    = result-personalsubarea
                btrtx    = result-personalsubareatext
                persg    = result-employeegroup
                pgtxt    = result-employeegroupname
                persk    = result-employeesubgroup
                pktxt    = result-employeesubgroupname
                korks    = result-areacontrolling
                bezei    = result-areacontrollingname
                gsber    = result-bussinessarea
                gtext    = result-bussinessareadesc
                abkrs    = result-payrollarea
                abktx    = result-payrollareatext
                ansvh    = result-workcontract
                anstx    = result-workcontracttext
                kostl    = result-costcenter
                kltxt    = result-description
                orgeh    = result-organizationalunit
                orgtx    = result-organizationalunitshorttext
                plans    = result-positionplans
                plstx    = result-positionshorttext
                stell    = result-job
                stltx    = result-jobtitle
                fkber    = result-functionalarea
                fkbtx    = result-functionalareaname
                otype    = result-objecttype
                otext    = result-objecttypetext.
  ENDMETHOD.


  METHOD get_time_work_schedule.
    CALL FUNCTION 'Z_HR_RFC_TIME_WORK_SCHEDULE'
      EXPORTING ip_pernr   = employee_number
                ip_valdate = value_date
      IMPORTING ep_zeity   = result-agrupareapersonal
                ep_mofid   = result-holidaycalendar
                ep_mosid   = result-agrupsubdivisions
                ep_schkz   = result-workscheduleplanrule
                ep_rtext   = result-workscheduletext.
  ENDMETHOD.


METHOD post_register_substitute.
    DATA record_infotype              TYPE zwhr_record_infotype_2003.
    DATA register_substitute_employee LIKE LINE OF register_substitute_employees.
    DATA table_message                TYPE STANDARD TABLE OF zwlog_return.
    DATA data_employee                TYPE zthrtempit2003.

    " Variables para validación fecha de corte
    DATA lv_begda       TYPE dats.
    DATA lv_primer_dia  TYPE dats.
    DATA lv_ultimo_dia  TYPE dats.
    DATA lv_fecha_corte TYPE dats.
    DATA lv_begda_str   TYPE char8.
    DATA lv_anio_mes    TYPE char6.
    DATA lv_next_str    TYPE char8.
    DATA lv_next_month  TYPE dats.

    LOOP AT register_substitute_employees INTO DATA(register_substitute_employ_aux).
      MOVE-CORRESPONDING register_substitute_employ_aux TO register_substitute_employee.
    ENDLOOP.

    " Mapeo de campos
    record_infotype-pernr = register_substitute_employee-EmployeeNumber.
    record_infotype-begda = register_substitute_employee-StartDate.
    record_infotype-endda = register_substitute_employee-EndDate.
    record_infotype-vtart = register_substitute_employee-SubstituteClass.
    record_infotype-schkz = register_substitute_employee-WorkPlanRule.
    record_infotype-mofid = register_substitute_employee-HolidaysCalendar.
    record_infotype-zeity = register_substitute_employee-GroupPersonSchedulePlan.
    record_infotype-mosid = register_substitute_employee-GroupSubdivisionPers.
    record_infotype-vpern = register_substitute_employee-EmployeeNumberSupplant.
    record_infotype-plans = register_substitute_employee-PositionPlans.
    record_infotype-altpb = register_substitute_employee-StartTime.
    record_infotype-altpe = register_substitute_employee-EndTime.
    record_infotype-altpv = register_substitute_employee-IndicateDayAnt.
    record_infotype-gsber = register_substitute_employee-Division.
    record_infotype-kostl = register_substitute_employee-CostCenter.
    record_infotype-bukrs = register_substitute_employee-Society.

    TRY.
      " 1. PRIMERO: RFC - SAP valida retroactividad aquí internamente
      CALL FUNCTION 'ZHCM_RFC_SEND_IT_2003_COPY'
        EXPORTING iw_record_2003 = record_infotype
                  ip_sol_pernr   = register_substitute_employee-SolEmployeeNumber
                  ip_sol_uname   = sy-uname
                  ip_orgeh       = register_substitute_employee-UnitOrg
        IMPORTING ep_text        = result-text
                  ep_error       = result-type_error
                  ep_requestid   = result-request_id
                  ep_ejercicio   = result-excersize
        TABLES    t_mensaje      = table_message
        EXCEPTIONS
                  OTHERS = 3.

      IF sy-subrc <> 0.
          result-type_error = 'E'.
          result-text = 'Revisar tx ST22'.
          RETURN.
      ENDIF.

      " 2. SEGUNDO: Solo si el RFC no retornó error (retro u otro),
      "    se valida la fecha de corte de nómina
      IF result-type_error IS INITIAL.
          lv_begda      = register_substitute_employee-StartDate.
          lv_begda_str  = lv_begda.
          lv_anio_mes   = lv_begda_str(6).
          lv_primer_dia = lv_anio_mes && '01'.
          lv_next_month = lv_primer_dia + 31.
          lv_next_str   = lv_next_month.
          lv_ultimo_dia = lv_next_str(6) && '01'.
          lv_ultimo_dia = lv_ultimo_dia - 1.

          SELECT SINGLE fecha FROM zhrt_date_nomina
            INTO lv_fecha_corte
            WHERE fecha BETWEEN lv_primer_dia AND lv_ultimo_dia.

          IF sy-subrc = 0 AND sy-datum >= lv_fecha_corte.
              result-type_error = 'E'.
              result-text = 'Fecha actual supera la fecha de corte de nómina, no es posible grabar el registro'.
              RETURN.
          ENDIF.
      ENDIF.

      " 3. TERCERO: Si todo OK, graba definitivamente
      IF result-type_error IS INITIAL.
        CALL FUNCTION 'Z_HR_RFC_SAVE_IT2003' DESTINATION 'NONE'
          EXPORTING ip_requestid = result-request_id
                    ip_gjahr     = result-excersize
          IMPORTING ep_text      = result-text
                    ep_error     = result-type_error
                    ep_datos     = data_employee.
      ENDIF.

    CATCH cx_root INTO DATA(lo_error).
        MESSAGE lo_error->get_text( ) TYPE 'E'.
        result-type_error = 'E'.
        result-text = lo_error->get_text( ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_personal_substitute.
    DATA employees_substitute_aux TYPE zttbancontac.
    DATA personal_substitute      LIKE LINE OF personal_subs.

    CALL FUNCTION 'Z_HR_RFC_GET_DATA_EMPLOYEE'
      EXPORTING ip_pernr    = employee_number
                ip_bukrs    = society
                ip_nombre   = name
                ip_apellido = patternal_surname
      TABLES    et_data     = employees_substitute_aux.

    LOOP AT employees_substitute_aux INTO DATA(employee_substitute_aux).
      CLEAR personal_substitute.
      personal_substitute-EmployeeNumber  = employee_substitute_aux-pernr.
      personal_substitute-Name            = employee_substitute_aux-vorna.
      personal_substitute-PaternalSurname = employee_substitute_aux-nachn.
      personal_substitute-MaternalSurname = employee_substitute_aux-nach2.

      INSERT personal_substitute INTO TABLE personal_subs.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
