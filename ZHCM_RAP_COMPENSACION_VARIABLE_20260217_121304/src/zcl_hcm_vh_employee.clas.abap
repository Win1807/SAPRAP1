" ---------------------------------------------------------------------
" ---------------------------------------------------------------------
CLASS zcl_hcm_vh_employee DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    TYPES hcm_vh_employees TYPE STANDARD TABLE OF zi_hcm_vh_employee WITH DEFAULT KEY.

  PROTECTED SECTION.
    METHODS get_employee_list
      IMPORTING user_name      TYPE xuaname
                reference_date TYPE e_refdate
      EXPORTING employees_list TYPE hcm_vh_employees.

ENDCLASS.



CLASS ZCL_HCM_VH_EMPLOYEE IMPLEMENTATION.


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

        CASE io_request->get_entity_id( ).

          WHEN 'ZI_HCM_VH_EMPLOYEE'.

            DATA(page_size) = io_request->get_paging( )->get_page_size( ).
            DATA(offset) = io_request->get_paging( )->get_offset( ).

            " TODO: variable is assigned but never used (ABAP cleaner)
            DATA(parameters) = io_request->get_parameters( ).

            " TODO: variable is assigned but never used (ABAP cleaner)
            DATA(search_string) = io_request->get_search_expression( ).

            DATA(sort_order)    = io_request->get_sort_elements( ).
            DATA(requested_fields)  = io_request->get_requested_elements( ).

            DATA(filter_personal_advanced) = io_request->get_filter( )->get_as_ranges( ).
            DATA(filter_personal_string) = io_request->get_search_expression( ).


            " --- Request data
            IF io_request->is_data_requested( ).
              "-- Paging:
              " TODO: variable is assigned but never used (ABAP cleaner)
              DATA(skip_rows_number) = io_request->get_paging( )->get_offset( ).

              DATA employees_list           TYPE hcm_vh_employees.
              DATA employees_list_aux       TYPE hcm_vh_employees.
              DATA interface_employees_list TYPE hcm_vh_employees.

              get_employee_list( EXPORTING user_name      = sy-uname
                                           reference_date = sy-datum
                                 IMPORTING employees_list = employees_list ).
              " filters
              IF filter_personal_string IS NOT INITIAL.

                CONCATENATE '*' filter_personal_string '*' INTO filter_personal_string.

                employees_list_aux = employees_list.
                CLEAR: employees_list.

                LOOP AT employees_list_aux INTO DATA(employee_structure) WHERE ( EmployeeNumber CP filter_personal_string OR
                                                                                 FirstSurname   CP filter_personal_string OR
                                                                                 SecondSurname  CP filter_personal_string OR
                                                                                 FullName       CP filter_personal_string ).
                    APPEND employee_structure TO employees_list.
                ENDLOOP.

              ENDIF.

              " filters advanced
              IF filter_personal_advanced IS NOT INITIAL.

                LOOP AT filter_personal_advanced INTO DATA(filter_personal_u).

                  CASE filter_personal_u-name.
                    WHEN 'EMPLOYEENUMBER'.
                      DATA(filter_employeeNumber) = filter_personal_u-range.
                    WHEN 'FIRSTSURNAME'.
                      DATA(filter_firsturname) = filter_personal_u-range.
                    WHEN 'SECONDSURNAME'.
                      DATA(filter_secondsurname) = filter_personal_u-range.
                    WHEN 'FULLLNAME'.
                      DATA(filter_fullname) = filter_personal_u-range.
                  ENDCASE.

                 ENDLOOP.

                 employees_list_aux = employees_list.
                 CLEAR: employees_list.

                 LOOP AT employees_list_aux INTO DATA(employee_structure_2) WHERE ( EmployeeNumber IN filter_employeeNumber AND
                                                                                    FirstSurname   IN filter_firsturname AND
                                                                                    SecondSurname  IN filter_secondsurname AND
                                                                                    FullName       IN filter_fullname ).
                    APPEND employee_structure_2 TO employees_list.
                 ENDLOOP.

              ENDIF.

              " Fill response
              DATA interface_employee_list LIKE LINE OF interface_employees_list.

              IF page_size > 0.
                LOOP AT employees_list INTO DATA(employee_list) FROM offset + 1 TO ( offset + page_size ).
                  MOVE-CORRESPONDING employee_list TO interface_employee_list.
                  APPEND interface_employee_list TO interface_employees_list.
                ENDLOOP.
              ELSE.
                LOOP AT employees_list INTO employee_list.
                  MOVE-CORRESPONDING employee_list TO interface_employee_list.
                  APPEND interface_employee_list TO interface_employees_list.
                ENDLOOP.
              ENDIF.

              io_response->set_data( interface_employees_list ).

              IF io_request->is_total_numb_of_rec_requested( ).
                io_response->set_total_number_of_records( lines( employees_list ) ).
              ENDIF.

            ENDIF.

        ENDCASE.

      CATCH cx_rap_query_provider.

    ENDTRY.
  ENDMETHOD.


  METHOD get_employee_list.
*      IMPORTING user_name      TYPE xuaname
*                reference_date TYPE e_refdate
*      EXPORTING employees_list TYPE hcm_vh_employees.

    DATA employee_manager_o TYPE REF TO zcl_employee_manager.
    DATA is_manager         TYPE abap_bool.

    employee_manager_o = NEW #( ).
    employee_manager_o->is_manager( EXPORTING  user_name      = user_name
                                               reference_date = reference_date
                                    RECEIVING  is_manager     = is_manager
                                    EXCEPTIONS query_error    = 1
                                               OTHERS         = 2 ).
    IF sy-subrc <> 0.
*       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    " Si el usuario es Jefe
    IF is_manager = abap_true.

      DATA organizational_unit TYPE orgeh.
      DATA objects             TYPE STANDARD TABLE OF hrwpc_s_objec.

      CALL FUNCTION 'Z_HR_RFC_GET_DATA_BY_UNIT_ORG'
        EXPORTING ip_flag  = 'T'
                  ip_objid = organizational_unit
                  ip_otype = 'P'
        TABLES    t_objec  = objects.

      DATA range_employees TYPE RANGE OF persno.

      range_employees[] = VALUE #( FOR object IN objects
                                   ( sign = 'I' option = 'EQ' low = object-objid ) ).

    ELSE.
      " Si el usuario no es Jefe
      DATA personal_number TYPE pernr_d.

      " Se obtiene el número del empleado asociado al usuario
      CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
        EXPORTING id             = user_name
                  begindate      = reference_date
                  enddate        = reference_date
        IMPORTING employeenumber = personal_number.

      IF personal_number IS NOT INITIAL.
        range_employees[] = VALUE #( sign   = 'I'
                                     option = 'EQ'
                                     ( low = personal_number ) ).
      ENDIF.
    ENDIF.

    IF range_employees[] IS NOT INITIAL.

      SELECT pernr, nachn, nach2, vorna
        FROM pa0002
        INTO TABLE @DATA(employee_infotype_2_t)
        WHERE pernr IN @range_employees
          AND subty  = @space
          AND objps  = @space
          AND sprps  = @space
          AND endda >= @reference_date
          AND begda <= @reference_date
          AND seqnr  = @space.
    ENDIF.

    LOOP AT employee_infotype_2_t ASSIGNING FIELD-SYMBOL(<employee_infotype_2>).
      APPEND INITIAL LINE TO employees_list ASSIGNING FIELD-SYMBOL(<employee_list>).
      <employee_list>-employeenumber = <employee_infotype_2>-pernr.
      <employee_list>-firstsurname   = <employee_infotype_2>-nachn.
      <employee_list>-secondsurname  = <employee_infotype_2>-nach2.
      <employee_list>-fullname       = <employee_infotype_2>-vorna.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
