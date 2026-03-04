CLASS zcl_hcm_staff_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_search_staff_report
      IMPORTING
        io_request  TYPE REF TO if_rap_query_request
        io_response TYPE REF TO if_rap_query_response.
    METHODS get_search_matrix_report
      IMPORTING
        io_request  TYPE REF TO if_rap_query_request
        io_response TYPE REF TO if_rap_query_response.
    METHODS get_search_matrix_report_tree
      IMPORTING
        io_request  TYPE REF TO if_rap_query_request
        io_response TYPE REF TO if_rap_query_response.
ENDCLASS.



CLASS zcl_hcm_staff_report IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    CASE io_request->get_entity_id( ).

      WHEN 'ZC_HCM_STAFFREPORT'.
        get_search_staff_report(
            io_request  = io_request
            io_response = io_response ).
      WHEN 'ZC_HCM_MATRIXREPORT'.
        get_search_matrix_report(
            io_request  = io_request
            io_response = io_response ).
      WHEN 'ZC_HCM_MATRIXREPORTTREE'.
        get_search_matrix_report_tree(
            io_request  = io_request
            io_response = io_response ).



    ENDCASE.
  ENDMETHOD.

  METHOD get_search_staff_report.
    DATA(page_size) = io_request->get_paging( )->get_page_size( ).
    DATA(offset) = io_request->get_paging( )->get_offset( ).

    DATA(sort_elements) = io_request->get_sort_elements( ).

    DATA results TYPE lcl_staff_report=>tt_staffreport.
    TRY.

        DATA(staff_report) = NEW lcl_staff_report( ).

        DATA lt_sort_criteria TYPE string_table.
        DATA(lv_sql_filter) = io_request->get_filter( )->get_as_sql_string( ).

        lt_sort_criteria = VALUE #( FOR sort_element IN sort_elements
                                    ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true
                                                                           THEN ` descending`
                                                                           ELSE ` ascending` ) ) ).
        DATA lv_sort_string TYPE string.
        lv_sort_string = COND #( WHEN lt_sort_criteria IS INITIAL
                                 THEN ` PersonnelNumber ascending`
                                 ELSE concat_lines_of( table = lt_sort_criteria
                                                       sep   = `, ` ) ).

        staff_report->proces_staff_report( EXPORTING io_request = io_request
                                           CHANGING  results    = results ).

        DATA interface_results TYPE lcl_staff_report=>tt_staffreport.
        " Fill response
        DATA interface_result  LIKE LINE OF interface_results.
        SELECT FROM @results AS r
          FIELDS *
           where (lv_sql_filter)
          ORDER BY (lv_sort_string)
          INTO TABLE @interface_results.
        results = interface_results.
        CLEAR interface_results.

        IF page_size > 0.
          LOOP AT results ASSIGNING FIELD-SYMBOL(<result>) FROM offset + 1 TO ( offset + page_size ).
            MOVE-CORRESPONDING <result> TO interface_result.
            APPEND interface_result TO interface_results.
          ENDLOOP.
        ELSE.
          LOOP AT results ASSIGNING <result>.
            MOVE-CORRESPONDING <result> TO interface_result.
            APPEND interface_result TO interface_results.
          ENDLOOP.
        ENDIF.

        io_response->set_data( interface_results ).

        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( lines( results ) ).
        ENDIF.
      CATCH cx_root INTO DATA(exception).
        " TODO: variable is assigned but never used (ABAP cleaner)
*        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
*        DATA(exception_t100_key) = cl_message_helper=>get_latest_t100_exception( exception )->t100key.
*
*        RAISE EXCEPTION NEW zcx_staff_report( textid   = VALUE scx_t100key( msgid = exception_t100_key-msgid
*                                                                            msgno = exception_t100_key-msgno
*                                                                            attr1 = exception_t100_key-attr1
*                                                                            attr2 = exception_t100_key-attr2
*                                                                            attr3 = exception_t100_key-attr3
*                                                                            attr4 = exception_t100_key-attr4 )
*                                              previous = exception ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_search_matrix_report.
    DATA(page_size) = io_request->get_paging( )->get_page_size( ).
    DATA(offset) = io_request->get_paging( )->get_offset( ).

    DATA(sort_elements) = io_request->get_sort_elements( ).
         DATA(filters) = io_request->get_filter( ).
    DATA results TYPE lcl_staff_report=>tt_matrix_report.
    TRY.

        DATA(staff_report) = NEW lcl_staff_report( ).

        DATA lt_sort_criteria TYPE string_table.
        lt_sort_criteria = VALUE #( FOR sort_element IN sort_elements
                                    ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true
                                                                           THEN ` descending`
                                                                           ELSE ` ascending` ) ) ).
        DATA lv_sort_string TYPE string.
        lv_sort_string = COND #( WHEN lt_sort_criteria IS INITIAL
                                 THEN ` roleSignSuperiorSubordinate ascending`
                                 ELSE concat_lines_of( table = lt_sort_criteria
                                                       sep   = `, ` ) ).

        staff_report->proces_matrix_report( EXPORTING io_request = io_request
                                           CHANGING  results    = results ).

        DATA interface_results TYPE lcl_staff_report=>tt_matrix_report.
        " Fill response
        DATA interface_result  LIKE LINE OF interface_results.
        SELECT FROM @results AS r
          FIELDS *
          ORDER BY (lv_sort_string)
          INTO TABLE @interface_results.
        results = interface_results.
        CLEAR interface_results.

        IF page_size > 0.
          LOOP AT results ASSIGNING FIELD-SYMBOL(<result>) FROM offset + 1 TO ( offset + page_size ).
            MOVE-CORRESPONDING <result> TO interface_result.
            APPEND interface_result TO interface_results.
          ENDLOOP.
        ELSE.
          LOOP AT results ASSIGNING <result>.
            MOVE-CORRESPONDING <result> TO interface_result.
            APPEND interface_result TO interface_results.
          ENDLOOP.
        ENDIF.

        io_response->set_data( interface_results ).

        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( lines( results ) ).
        ENDIF.
      CATCH cx_root INTO DATA(exception).
        " TODO: variable is assigned but never used (ABAP cleaner)
*        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
*        DATA(exception_t100_key) = cl_message_helper=>get_latest_t100_exception( exception )->t100key.
*
*        RAISE EXCEPTION NEW zcx_staff_report( textid   = VALUE scx_t100key( msgid = exception_t100_key-msgid
*                                                                            msgno = exception_t100_key-msgno
*                                                                            attr1 = exception_t100_key-attr1
*                                                                            attr2 = exception_t100_key-attr2
*                                                                            attr3 = exception_t100_key-attr3
*                                                                            attr4 = exception_t100_key-attr4 )
*                                              previous = exception ).
    ENDTRY.
  ENDMETHOD.


  METHOD get_search_matrix_report_tree.
  DATA(page_size) = io_request->get_paging( )->get_page_size( ).
    DATA(offset) = io_request->get_paging( )->get_offset( ).

    DATA(sort_elements) = io_request->get_sort_elements( ).
         DATA(filters) = io_request->get_filter( ).
    DATA results TYPE lcl_staff_report=>tt_matrix_report_tree.
    TRY.

        DATA(staff_report) = NEW lcl_staff_report( ).

        DATA lt_sort_criteria TYPE string_table.
        lt_sort_criteria = VALUE #( FOR sort_element IN sort_elements
                                    ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true
                                                                           THEN ` descending`
                                                                           ELSE ` ascending` ) ) ).
        DATA lv_sort_string TYPE string.
        lv_sort_string = COND #( WHEN lt_sort_criteria IS INITIAL
                                 THEN ` roleSignSuperiorSubordinate ascending`
                                 ELSE concat_lines_of( table = lt_sort_criteria
                                                       sep   = `, ` ) ).

        staff_report->proces_matrix_report_tree( EXPORTING io_request = io_request
                                           CHANGING  results    = results ).

        DATA interface_results TYPE lcl_staff_report=>tt_matrix_report_tree.
        " Fill response
        DATA interface_result  LIKE LINE OF interface_results.
        SELECT FROM @results AS r
          FIELDS *
          ORDER BY (lv_sort_string)
          INTO TABLE @interface_results.
        results = interface_results.
        CLEAR interface_results.

        IF page_size > 0.
          LOOP AT results ASSIGNING FIELD-SYMBOL(<result>) FROM offset + 1 TO ( offset + page_size ).
            MOVE-CORRESPONDING <result> TO interface_result.
            APPEND interface_result TO interface_results.
          ENDLOOP.
        ELSE.
          LOOP AT results ASSIGNING <result>.
            MOVE-CORRESPONDING <result> TO interface_result.
            APPEND interface_result TO interface_results.
          ENDLOOP.
        ENDIF.

        io_response->set_data( interface_results ).

        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( lines( results ) ).
        ENDIF.
      CATCH cx_root INTO DATA(exception).
        " TODO: variable is assigned but never used (ABAP cleaner)
*        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
*        DATA(exception_t100_key) = cl_message_helper=>get_latest_t100_exception( exception )->t100key.
*
*        RAISE EXCEPTION NEW zcx_staff_report( textid   = VALUE scx_t100key( msgid = exception_t100_key-msgid
*                                                                            msgno = exception_t100_key-msgno
*                                                                            attr1 = exception_t100_key-attr1
*                                                                            attr2 = exception_t100_key-attr2
*                                                                            attr3 = exception_t100_key-attr3
*                                                                            attr4 = exception_t100_key-attr4 )
*                                              previous = exception ).
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
