"! <p class="shorttext synchronized" lang="en">Daily consultation</p>
CLASS zcl_hcm_daily_consultation DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION."#EC INTF_IN_CLASS
    INTERFACES if_rap_query_provider.

    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_absence_type FOR TABLE FUNCTION ZTF_Absencetype.

    "! <p class="shorttext synchronized"></p>
    "!
    "! @parameter io_request                 | <p class="shorttext synchronized"></p>
    "! @parameter io_response                | <p class="shorttext synchronized"></p>
    "! @raising   cx_rap_query_prov_not_impl | <p class="shorttext synchronized"></p>
    "! @raising   cx_rap_query_provider      | <p class="shorttext synchronized"></p>
    METHODS get_search_result
      IMPORTING io_request  TYPE REF TO if_rap_query_request
                io_response TYPE REF TO if_rap_query_response
      RAISING   cx_rap_query_prov_not_impl
                cx_rap_query_provider.

    METHODS get_search_result_resum
      IMPORTING io_request  TYPE REF TO if_rap_query_request
                io_response TYPE REF TO if_rap_query_response.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_hcm_daily_consultation IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    CASE io_request->get_entity_id( ).

      WHEN 'ZC_HCM_DAILYC_DETAIL'.
        get_search_result(
            io_request  = io_request
            io_response = io_response ).
      WHEN 'ZC_HCM_DAILYC_RESUMM'.
        get_search_result_resum(
            io_request  = io_request
            io_response = io_response ).



    ENDCASE.
  ENDMETHOD.

  METHOD get_search_result.
    DATA(page_size) = io_request->get_paging( )->get_page_size( ).
    DATA(offset) = io_request->get_paging( )->get_offset( ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(parameters) = io_request->get_parameters( ).
    DATA(sort_elements) = io_request->get_sort_elements( ).
    DATA(search_string) = io_request->get_search_expression( ).
    IF search_string IS NOT INITIAL.
      " TODO: variable is assigned but never used (ABAP cleaner)
      DATA(search_sql) = |'*{ cl_abap_dyn_prg=>escape_quotes( search_string ) }*'|.

    ENDIF.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(params) = io_request->get_parameters( ).
    DATA(filters) = io_request->get_filter( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(sql_filters) = filters->get_as_sql_string( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(filters_range) = filters->get_as_ranges( ).

    DATA results TYPE STANDARD TABLE OF zc_hcm_dailyc_detail.
    DATA result  TYPE zc_hcm_dailyc_detail.

    DATA(daily_consult_actions) = NEW zcl_hcm_daily_consult_actions( ).

    DATA lt_sort_criteria TYPE string_table.
    lt_sort_criteria = VALUE #( FOR sort_element IN sort_elements
                                ( sort_element-element_name && COND #( WHEN sort_element-descending = abap_true
                                                                       THEN ` descending`
                                                                       ELSE ` ascending` ) ) )."#EC TEXT_ASSEMBLY
    DATA lv_sort_string TYPE string.
    lv_sort_string = COND #( WHEN lt_sort_criteria IS INITIAL
                             THEN ` PersonnelNumber ascending`
                             ELSE concat_lines_of( table = lt_sort_criteria
                                                   sep   = `, ` ) ).

    daily_consult_actions->proces_detail_data( EXPORTING io_request  = io_request

                                               CHANGING  hcm_details = results ).


    DATA interface_results TYPE STANDARD TABLE OF zc_hcm_dailyc_detail.
    " Fill response
    DATA interface_result  LIKE LINE OF interface_results.
    SELECT FROM @results AS r
      FIELDS *
      ORDER BY (lv_sort_string)
      INTO TABLE @interface_results.
    results = interface_results.
    CLEAR interface_results.

    IF page_size > 0.
      LOOP AT results INTO result FROM offset + 1 TO ( offset + page_size ).
        MOVE-CORRESPONDING result TO interface_result.
        APPEND interface_result TO interface_results."#EC PREF_INSERT_INT
      ENDLOOP.
    ELSE.
      LOOP AT results INTO result.
        MOVE-CORRESPONDING result TO interface_result.
        APPEND interface_result TO interface_results."#EC PREF_INSERT_INT
      ENDLOOP.
    ENDIF.

    io_response->set_data( interface_results ).

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( lines( results ) ).
    ENDIF.
  ENDMETHOD.

  METHOD get_search_result_resum.
    DATA(page_size) = io_request->get_paging( )->get_page_size( ).
    DATA(offset) = io_request->get_paging( )->get_offset( ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(parameters) = io_request->get_parameters( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(sort_order)    = io_request->get_sort_elements( ).
    DATA(search_string) = io_request->get_search_expression( ).
    IF search_string IS NOT INITIAL.
      " TODO: variable is assigned but never used (ABAP cleaner)
      DATA(search_sql) = |'*{ cl_abap_dyn_prg=>escape_quotes( search_string ) }*'|.

    ENDIF.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(params) = io_request->get_parameters( ).
    DATA(filters) = io_request->get_filter( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(sql_filters) = filters->get_as_sql_string( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(filters_range) = filters->get_as_ranges( ).

    DATA results TYPE STANDARD TABLE OF zc_hcm_dailyc_resumm.
    DATA result  TYPE zc_hcm_dailyc_resumm.

    DATA(daily_consult_actions) = NEW zcl_hcm_daily_consult_actions( ).

    daily_consult_actions->proces_resumm_data( EXPORTING io_request  = io_request
                                               CHANGING  hcm_resumms = results ).

    DATA interface_results TYPE STANDARD TABLE OF zc_hcm_dailyc_resumm.
    " Fill response
    DATA interface_result  LIKE LINE OF interface_results.

    IF page_size > 0.
      LOOP AT results INTO result FROM offset + 1 TO ( offset + page_size ).
        MOVE-CORRESPONDING result TO interface_result.
        APPEND interface_result TO interface_results."#EC PREF_INSERT_INT
      ENDLOOP.
    ELSE.
      LOOP AT results INTO result.
        MOVE-CORRESPONDING result TO interface_result.
        APPEND interface_result TO interface_results."#EC PREF_INSERT_INT
      ENDLOOP.
    ENDIF.

    io_response->set_data( interface_results ).

    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records( lines( results ) ).
    ENDIF.
  ENDMETHOD.

  METHOD get_absence_type BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY
  USING t001p pa0001 pa0105 t554t
*  zbcranv_n
   ZHCMCUSTOMABST
  .

declare lt_custom_absenc table ( mandt "$ABAP.type( SY-MANDT )", awart "$ABAP.type( AWART )",  atext "$ABAP.type( abwtxt )" );

    declare lv_user  "$ABAP.type( syuname )";
    declare lv_exits char( 1 ) default '0';
    declare lv_row_count int;
    declare lv_row_count_manager int;


LT_CUSTOM_ABSENC = select :client as mandt, cast( 'FXJ' as "$ABAP.type( awart )" )  as awart, cast( 'Falta por Justificar' as "$ABAP.type( abwtxt )" ) as atext from dummy
            UNION select :client as mandt, cast( 'TXJ' as "$ABAP.type( awart )" )  as awart, cast( 'Tardanza por Justificar' as "$ABAP.type( abwtxt )" ) as atext from dummy
            UNION select :client as mandt, cast( 'FER' as "$ABAP.type( awart )" )  as awart, cast( 'Feriado' as "$ABAP.type( abwtxt )" ) as atext from dummy
            UNION select :client as mandt, cast( 'M1V' as "$ABAP.type( awart )" )  as awart, cast( 'Marco solo 1 vez' as "$ABAP.type( abwtxt )" ) as atext from dummy;

 lt_absence =
 SELECT PA0105.MANDT,
pa0105.pernr,
pa0105.usrid,
PA0001.werks,
PA0001.BTRTL,
T001P.moabw,
t554t.awart,
t554t.atext
 FROM pa0105 INNER JOIN  PA0001 ON
                         pa0105.MANDT = PA0001.MANDT AND
                         pa0105.pernr = PA0001.pernr and
                         PA0001.endda >= current_date and
                         PA0001.begda <= current_date
             INNER JOIN T001P ON
                                 PA0001.MANDT = T001P.MANDT AND
                                PA0001.werks = T001P.werks AND
                                 PA0001.btrtl = T001P.btrtl
             INNER  JOIN T554T ON
                                T001P.MANDT = T554T.MANDT AND
                                T001P.moabw = T554T.moabw AND
                                t554t.sprsl = 'S'
 where usrid = :UserPerson and
        pa0105.endda >= current_date and
        pa0105.begda <= current_date AND
        PA0105.MANDT = :client;



*lt_report = select mandt, awart, atext from :lt_absence
*            UNION select :client , 'FXJ', 'Falta por Justificar' from dummy
*            UNION select :client, 'TXJ', 'Tardanza por Justificar' from dummy
*            UNION select :client, 'FER', 'Feriado' from dummy
*            UNION select :client, 'M1V', 'Marco solo 1 vez' from dummy;

*lt_report0 = select :client as mandt, cast( zlow as "$ABAP.type( awart )" )  as awart ,  cast( zhigh as "$ABAP.type( abwtxt )" ) as atext
*                from zbcranv_n
*                where rangeid = '0000900241';

lt_report = select mandt, awart, atext from :lt_absence
            UNION  SELECT MANDT, AWART, ATEXT FROM ZHCMCUSTOMABST
            ;

*lt_report = select mandt, awart, atext from :lt_absence
*                   WHERE AWART <> ''
*                UNION select mandt, awart, atext from :lt_report0;



return  select
MANDT,
awart,
atext
 from :lt_report;
  ENDMETHOD.
ENDCLASS.
