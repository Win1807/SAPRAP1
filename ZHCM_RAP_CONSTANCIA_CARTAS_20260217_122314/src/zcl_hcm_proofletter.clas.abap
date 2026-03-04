class ZCL_HCM_PROOFLETTER definition
  public
  final
  create public .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

*    TYPES hcm_data_certif_itf TYPE STANDARD TABLE OF zi_hcm_data_certif_itf WITH DEFAULT KEY.

    METHODS get_employee_number
      IMPORTING  user_name              TYPE uname      DEFAULT sy-uname
                 reference_date         TYPE syst_datum DEFAULT sy-datum
      RETURNING  VALUE(employee_number) TYPE persno
      EXCEPTIONS query_error.

    METHODS get_error_messages
      EXPORTING error_message TYPE bapiret2_tab.

    METHODS get_proof_work
      IMPORTING VALUE(lettertype) TYPE ze_tipcar DEFAULT 'T'
                VALUE(user_name)  TYPE uname
                VALUE(emp)        TYPE string
      EXPORTING VALUE(return)     TYPE bapiret2
                VALUE(pdf)        TYPE xstring.

    METHODS get_pre_emb
      IMPORTING user_name           TYPE uname        OPTIONAL
                emp                 TYPE string       OPTIONAL
                letterrequestnumber TYPE ze_numsol    OPTIONAL
                employeenumber      TYPE persno       OPTIONAL
                reason              TYPE ze_motivo    OPTIONAL
                lettertype          TYPE ze_tipcar    DEFAULT 'E'
                embassy             TYPE landx        OPTIONAL
                course              TYPE ze_curso     OPTIONAL
                organizer           TYPE ze_instit    OPTIONAL
                reasonothers        TYPE ze_detall    OPTIONAL
                requesttype         TYPE ze_tipcar    OPTIONAL
                wrango              TYPE zhcmt_wrango OPTIONAL
      EXPORTING VALUE(return)       TYPE bapiret2
                VALUE(pdf)          TYPE xstring.

    METHODS get_lettertype
      IMPORTING user_name  TYPE uname DEFAULT sy-uname
      EXPORTING lettertype TYPE ze_tipcar.

  PROTECTED SECTION.

    DATA employee_record TYPE pa0001 .
    DATA error_messages TYPE bapiret2_tab .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_HCM_PROOFLETTER IMPLEMENTATION.


  METHOD GET_EMPLOYEE_NUMBER.
*      IMPORTING  reference_date         TYPE syst_datum DEFAULT sy-datum
*                 user_name              TYPE uname      DEFAULT sy-uname
*      RETURNING  VALUE(employee_number) TYPE persno
*      EXCEPTIONS error_code .

    CLEAR me->error_messages.
    DATA return_struct TYPE bapiret2.

    CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
      EXPORTING
        id             = !user_name
        begindate      = !reference_date
        enddate        = !reference_date
      IMPORTING
        return         = return_struct
        employeenumber = !employee_number.

    IF return_struct IS NOT INITIAL.
      APPEND return_struct TO me->error_messages.
      RAISE query_error.
    ENDIF.
  ENDMETHOD.


  METHOD GET_ERROR_MESSAGES.
    error_message = me->error_messages.
  ENDMETHOD.


  METHOD GET_LETTERTYPE.
*   IMPORTING USER_NAME   TYPE UNAME
*   EXPORTING PERSG       TYPE PERSG

    CONSTANTS practicant TYPE c VALUE 'H'.
    DATA employeenumber TYPE pernr_d.
*&----------------------------------------------------------------------------&
*&-----------------1.Obtener Número de Personal del usuario ------------------&
*&----------------------------------------------------------------------------&

    me->get_employee_number(
      EXPORTING  user_name       = user_name "CHANGE
                 reference_date  = sy-datum
      RECEIVING  employee_number = employeenumber
      EXCEPTIONS query_error     = 1
                 OTHERS          = 2 ).

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

  SELECT SINGLE persg FROM pa0001
    INTO @data(persg)
    WHERE pernr EQ @employeenumber
      and endda = '99991231'.
    IF persg EQ practicant.
      lettertype = 'P'.
    ELSE.
      lettertype = 'T'.
    ENDIF.

  ENDMETHOD.


  METHOD GET_PRE_EMB.

*  IMPORTING USER_NAME            TYPE UNAME
*            EMP                  TYPE STRING
*            LETTERREQUESTNUMBER  TYPE ZE_NUMSOL
*            EMPLOYEENUMBER       TYPE PERSNO
*            REASON               TYPE ZE_MOTIVO
*            LETTERTYPE           TYPE ZE_TIPCAR default 'E'
*            EMBASSY              TYPE LANDX
*            COURSE               TYPE ZE_CURSO
*            ORGANIZER            TYPE ZE_INSTIT
*            REASONOTHERS         TYPE ZE_DETALL
*            REQUESTTYPE          TYPE ZE_TIPCAR
*            WRANGO               TYPE ZHCMT_WRANGO
*   EXPORTING RETURN              TYPE  BAPIRET2
*             PDF                 TYPE  XSTRING

    DATA lv_employeenumber TYPE pernr_d.
    DATA rangos TYPE STANDARD TABLE OF zwrango.
*&----------------------------------------------------------------------------&
*&-----------------1.Obtener Número de Personal del usuario ------------------&
*&----------------------------------------------------------------------------&

    me->get_employee_number(
      EXPORTING  user_name       = user_name
                 reference_date  = sy-datum
      RECEIVING  employee_number = lv_employeenumber
      EXCEPTIONS query_error     = 1
                 OTHERS          = 2 ).

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

*&----------------------------------------------------------------------------&
*&-----------------2.Obtener Número de Personal del usuario ------------------&
*&----------------------------------------------------------------------------&

    CALL FUNCTION 'Z_HR_RFC_SOLICITUD_CARTAS'
      EXPORTING
        ip_tipcar        = lettertype
        ip_solici        = lv_employeenumber
        p_emp            = emp
        ip_matricula     = user_name
        ip_motivo        = reason
        ip_tipo          = requesttype
        ip_embajada      = embassy
        ip_curso         = course
        ip_organizador   = organizer
        ip_otros_motivos = reasonothers
      IMPORTING
        ep_return        = return
        ep_xstring       = pdf
      TABLES
        et_rangos        = wrango.

  ENDMETHOD.


  METHOD get_proof_work.

*   IMPORTING LETTERTYPE  TYPE ZE_TIPCAR 'T'
*             USER_NAME   TYPE UNAME
*             EMP         TYPE STRING
*   EXPORTING RETURN      TYPE  BAPIRET2
*             EP_XSTRING  TYPE  XSTRING

    CONSTANTS practicant TYPE c VALUE 'H'.
    DATA employeenumber TYPE pernr_d.
    DATA rangos TYPE STANDARD TABLE OF zwrango.
*&----------------------------------------------------------------------------&
*&-----------------1.Obtener Número de Personal del usuario ------------------&
*&----------------------------------------------------------------------------&

    me->get_employee_number(
      EXPORTING  user_name       = user_name "CHANGE
                 reference_date  = sy-datum
      RECEIVING  employee_number = employeenumber
      EXCEPTIONS query_error     = 1
                 OTHERS          = 2 ).

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

*&----------------------------------------------------------------------------&
*&-----------------2.Obtener Número de Personal del usuario ------------------&
*&----------------------------------------------------------------------------&

    SELECT SINGLE persg FROM pa0001
      INTO @DATA(persg)
      WHERE pernr EQ @employeenumber
      AND endda = '99991231'.
    IF persg EQ practicant.
      lettertype = 'P'.
    ELSE.
      lettertype = 'T'.
    ENDIF.

    IF strlen( emp ) GT '132'.
      MESSAGE e006(zhcm_rap_pe) INTO return-message.
      return-id = 'E'.
      EXIT.
    ENDIF.

    CALL FUNCTION 'Z_HR_RFC_SOLICITUD_CARTAS'
      EXPORTING
        ip_tipcar    = lettertype
        ip_solici    = employeenumber
        p_emp        = emp
        ip_matricula = user_name
      IMPORTING
        ep_return    = return
        ep_xstring   = pdf
      TABLES
        et_rangos    = rangos.

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

    DATA return         TYPE bapiret2.
    DATA pdf_string     TYPE xstring.
    DATA proof_pdf      TYPE TABLE OF zc_hcm_proof_work.
    DATA emb_pdf        TYPE TABLE OF zc_hcm_pre_emb.
    DATA hcm_lettertype TYPE TABLE OF zc_hcm_lettertype.
    DATA lettertype     TYPE ze_tipcar.

    TRY.
        "-- Paging:
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(page_size) = io_request->get_paging( )->get_page_size( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(offset) = io_request->get_paging( )->get_offset( ).

        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(parameters) = io_request->get_parameters( ).

        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(search_string) = io_request->get_search_expression( ).

        CASE io_request->get_entity_id( ).

          WHEN 'ZC_HCM_PROOF_WORK'.

            " --- Request data
            IF io_request->is_data_requested( ).

              " TODO: filter is assigned but never used (ABAP cleaner)
              TRY.
                  DATA(filter_object) = io_request->get_filter( )->get_as_ranges( ).

                  " Get value EMP
                  ASSIGN filter_object[ name = 'EMP' ] TO FIELD-SYMBOL(<fs_filter>).
                  IF sy-subrc IS INITIAL.
                    ASSIGN <fs_filter>-range[ 1 ] TO FIELD-SYMBOL(<fs_range>).
                    IF sy-subrc IS INITIAL.
                      DATA(emp) = <fs_range>-low.
                    ENDIF.
                  ENDIF.

                  " Execute the method get_proof_work for PDF
                  get_proof_work( EXPORTING user_name = sy-uname
                                            emp       = emp
                                  IMPORTING return    = return
                                            pdf       = pdf_string ).

                  APPEND INITIAL LINE TO proof_pdf ASSIGNING FIELD-SYMBOL(<fs_pdf>).
                  <fs_pdf>-pdf       = pdf_string.
                  <fs_pdf>-messageid = return-id.
                  <fs_pdf>-messageid = return-message.
                  io_response->set_total_number_of_records( lines( proof_pdf ) ).
                  io_response->set_data( proof_pdf ).
                CATCH cx_rap_query_filter_no_range.
                  " handle exception
              ENDTRY.
            ENDIF.

          WHEN 'ZC_HCM_PRE_EMB'.

            " --- Request data
            IF io_request->is_data_requested( ).

              DATA embassy      TYPE landx.
              DATA reason       TYPE ze_motivo.
              DATA course       TYPE ze_curso.
              DATA organizer    TYPE ze_instit.
              DATA reasonothers TYPE ze_detall.
              DATA requesttype  TYPE ze_requesttype.
              DATA wrango       TYPE zhcmt_wrango.
              DATA wrangos      LIKE LINE OF wrango.

              " Get filter
              TRY.
                  filter_object = io_request->get_filter( )->get_as_ranges( ).

                  LOOP AT filter_object ASSIGNING <fs_filter>.
                    CASE <fs_filter>-name.
                      WHEN 'EMBASSY'.
                        embassy = <fs_filter>-range[ 1 ]-low.
                      WHEN 'REASON'.
                        reason = <fs_filter>-range[ 1 ]-low.
                      WHEN 'COURSE'.
                        course = <fs_filter>-range[ 1 ]-low.
                      WHEN 'ORGANIZER'.
                        organizer = <fs_filter>-range[ 1 ]-low.
                      WHEN 'REASONOTHERS'.
                        reasonothers = <fs_filter>-range[ 1 ]-low.
                      WHEN 'REQUESTTYPE'.
                        requesttype = <fs_filter>-range[ 1 ]-low.
                      WHEN 'SUBTY'.
                        LOOP AT <fs_filter>-range ASSIGNING FIELD-SYMBOL(<fs_filter_range>).
                          wrangos-subty = <fs_filter_range>-low.
                          APPEND wrangos TO wrango.
                        ENDLOOP.
                      WHEN OTHERS.
                    ENDCASE.

                  ENDLOOP.

                  LOOP AT filter_object ASSIGNING <fs_filter> WHERE name = 'OBJPS'.
                    LOOP AT <fs_filter>-range ASSIGNING <fs_filter_range>.
                      ASSIGN wrango[ sy-tabix ] TO FIELD-SYMBOL(<fs_wrango>).
                      IF sy-subrc IS INITIAL.
                        <fs_wrango>-objps = <fs_filter_range>-low.
                      ENDIF.
                    ENDLOOP.
                  ENDLOOP.

                  get_pre_emb( EXPORTING user_name    = sy-uname
                                         embassy      = embassy
                                         reason       = reason
                                         course       = course
                                         organizer    = organizer
                                         reasonothers = reasonothers
                                         requesttype  = requesttype
                                         wrango       = wrango
                               IMPORTING return       = return
                                         pdf          = pdf_string ).

                  APPEND INITIAL LINE TO emb_pdf ASSIGNING FIELD-SYMBOL(<fs_emb_pdf>).
                  <fs_emb_pdf>-pdf = pdf_string.
                  io_response->set_total_number_of_records( lines( emb_pdf ) ).
                  io_response->set_data( emb_pdf ).
                CATCH cx_rap_query_filter_no_range.
                  " handle exception
              ENDTRY.
            ENDIF.

          WHEN 'ZC_HCM_LETTERTYPE'.
            " --- Request data
            IF io_request->is_data_requested( ).

              " Get Filter
              TRY.
                  filter_object = io_request->get_filter( )->get_as_ranges( ).

                  get_lettertype( EXPORTING user_name  = sy-uname
                                  IMPORTING lettertype = lettertype ).

                  APPEND INITIAL LINE TO hcm_lettertype ASSIGNING FIELD-SYMBOL(<fs_lettertype>).
                  <fs_lettertype>-lettertype = lettertype.
                  io_response->set_total_number_of_records( lines( hcm_lettertype ) ).
                  io_response->set_data( hcm_lettertype ).
                CATCH cx_rap_query_filter_no_range.
                  " handle exception
              ENDTRY.
            ENDIF.
        ENDCASE.

      CATCH cx_rap_query_provider.

    ENDTRY.
  ENDMETHOD.
ENDCLASS.
