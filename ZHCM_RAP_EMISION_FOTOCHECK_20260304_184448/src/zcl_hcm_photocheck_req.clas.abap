class ZCL_HCM_PHOTOCHECK_REQ definition
  public
  final
  create public .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    TYPES hcm_vh_reasons TYPE STANDARD TABLE OF zi_hcm_vh_reason_req WITH DEFAULT KEY.

    METHODS request_fotocheck
      IMPORTING username    TYPE uname
                idreason    TYPE ze_id_motivo
                commentsol  TYPE ze_comentario
      EXPORTING messagetext TYPE t100-text
                messageid   TYPE char1.

    METHODS get_employee_number
      IMPORTING  user_name              TYPE uname      DEFAULT sy-uname
                 reference_date         TYPE syst_datum DEFAULT sy-datum
      RETURNING  VALUE(employee_number) TYPE persno
      EXCEPTIONS query_error.

    METHODS get_error_messages
      EXPORTING error_message TYPE bapiret2_tab.

protected section.

  data EMPLOYEE_RECORD type PA0001 .
  data ERROR_MESSAGES type BAPIRET2_TAB .

  methods GET_REASON_REQ
    importing
      !USERNAME type SYUNAME optional
    exporting
      !REASONS_LIST type HCM_VH_REASONS .
private section.
ENDCLASS.



CLASS ZCL_HCM_PHOTOCHECK_REQ IMPLEMENTATION.


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


  method GET_ERROR_MESSAGES.
  endmethod.


  METHOD GET_REASON_REQ.
*    IMPORTING  USERNAME      TYPE  SYUNAME
*    EXPORTING  REASONS_LIST  TYPE  HCM_VH_REASONS
    DATA zthrmotivosols TYPE STANDARD TABLE OF zthrmotivosol.

    CALL FUNCTION 'Z_HR_MOTIVO_SOL'
      TABLES
        t_zthrmotivosol = zthrmotivosols.

    LOOP AT zthrmotivosols ASSIGNING FIELD-SYMBOL(<fs_motivosol>).
      APPEND INITIAL LINE TO reasons_list ASSIGNING FIELD-SYMBOL(<fs_reasons>).
      <fs_reasons>-idreason = <fs_motivosol>-id_motivo.
      <fs_reasons>-desreason = <fs_motivosol>-des_motivo.
      <fs_reasons>-messagetext = <fs_motivosol>-mensaje.
      <fs_reasons>-username = username.
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

        DATA photocheck_req TYPE TABLE OF zc_hcm_photocheck_req.

        DATA(page_size) = io_request->get_paging( )->get_page_size( ).
        DATA(offset) = io_request->get_paging( )->get_offset( ).

        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(parameters) = io_request->get_parameters( ).

        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(search_string) = io_request->get_search_expression( ).

        CASE io_request->get_entity_id( ).

          WHEN 'ZI_HCM_VH_REASON_REQ'.

            " --- Request data
            IF io_request->is_data_requested( ).
              "-- Paging:
              " TODO: variable is assigned but never used (ABAP cleaner)
              DATA(skip_rows_number) = io_request->get_paging( )->get_offset( ).

              DATA hcm_vh_reasons_list TYPE hcm_vh_reasons.
              DATA hcm_vh_reasons      TYPE hcm_vh_reasons.

              get_reason_req( EXPORTING username     = sy-uname
                              IMPORTING reasons_list = hcm_vh_reasons_list ).

              " Fill response
              DATA hcm_vh_reason LIKE LINE OF hcm_vh_reasons.

              IF page_size > 0.
                LOOP AT hcm_vh_reasons_list INTO DATA(hcm_vh_reason_list) FROM offset + 1 TO ( offset + page_size ).
                  MOVE-CORRESPONDING hcm_vh_reason_list TO hcm_vh_reason.
                  APPEND hcm_vh_reason TO hcm_vh_reasons.
                ENDLOOP.
              ELSE.
                LOOP AT hcm_vh_reasons_list INTO hcm_vh_reason_list.
                  MOVE-CORRESPONDING hcm_vh_reason_list TO hcm_vh_reason.
                  APPEND hcm_vh_reason TO hcm_vh_reasons.
                ENDLOOP.
              ENDIF.

              io_response->set_data( hcm_vh_reasons ).

              IF io_request->is_total_numb_of_rec_requested( ).
                io_response->set_total_number_of_records( lines( hcm_vh_reasons ) ).
              ENDIF.
            ENDIF.
          WHEN 'ZC_HCM_PHOTOCHECK_REQ'.

            " --- Request data
            IF io_request->is_data_requested( ).
              "-- Paging:
              skip_rows_number = io_request->get_paging( )->get_offset( ).

              DATA idreason    TYPE ze_id_motivo.
              DATA commentsol  TYPE ze_comentario.
              DATA messagetext TYPE natxt.
              DATA messageid   TYPE char1.

              TRY.
                  " Obtén los filtros de la solicitud
                  DATA(filter_object) = io_request->get_filter( )->get_as_ranges( ).

                  LOOP AT filter_object ASSIGNING FIELD-SYMBOL(<fs_filter>).
                    CASE <fs_filter>-name.
                      WHEN 'IDREASON'. " SE OBTIENE LA ID DEL MOTIVO DE LA SOLICITUD DE FOTOCHECK
                        ASSIGN <fs_filter>-range[ 1 ] TO FIELD-SYMBOL(<fs_filter_range>).
                        IF sy-subrc IS INITIAL.
                          idreason = <fs_filter_range>-low.
                        ENDIF.
                      WHEN 'COMMENTSOL'. " SE OBTIENE EL COMENTARIO DE LA SOLICITUD DE FOTOCHECK
                        ASSIGN <fs_filter>-range[ 1 ] TO <fs_filter_range>.
                        IF sy-subrc IS INITIAL.
                          commentsol = <fs_filter_range>-low.
                        ENDIF.
                      WHEN OTHERS.
                    ENDCASE.
                  ENDLOOP.

                  " SE EJECUTA LA FUNCION Z_HR_INPUT_SOL_FOTOCHECK PARA EJECUTAR LA SOLICITUD DEL FOTOCHECK
                  request_fotocheck( EXPORTING username    = sy-uname
                                               idreason    = idreason
                                               commentsol  = commentsol
                                     IMPORTING messagetext = messagetext
                                               messageid   = messageid ).

                  " SE ENVIAN LOS DATOS DEL MENSAJE Y CONSULTA DEL FOTOCHECK
                  APPEND INITIAL LINE TO photocheck_req ASSIGNING FIELD-SYMBOL(<fs_photo>).
                  <fs_photo>-messagetext = messagetext.
                  <fs_photo>-messageid   = messageid.

                  io_response->set_total_number_of_records( lines( photocheck_req ) ).
                  io_response->set_data( photocheck_req ).


                CATCH cx_rap_query_filter_no_range.
              ENDTRY.
            ENDIF.
        ENDCASE.
      CATCH cx_rap_query_provider.

    ENDTRY.
  ENDMETHOD.


  METHOD request_fotocheck.

*   IMPORTING USERNAME    TYPE UNAME
*             IDREASON    TYPE ZE_ID_MOTIVO
*             COMMENTSOL  TYPE ZE_COMENTARIO
*   EXPORTING MESSAGETEXT TYPE T100-TEXT
*             MESSAGEID   TYPE CHAR1

    DATA employeenumber TYPE pernr_d.
*&----------------------------------------------------------------------------&
*&-----------------1.Obtener Número de Personal del usuario ------------------&
*&----------------------------------------------------------------------------&

    me->get_employee_number(
      EXPORTING  user_name       = username
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
**VALIDACIONES
*data(total) = strlen(commentsol).
    IF commentsol IS INITIAL.
      MESSAGE e004(zhcm_rap_pe) WITH 'Comentario' INTO messagetext.
      messageid = 'E'.
    ELSEIF strlen( commentsol ) GT '200'.
      MESSAGE e005(zhcm_rap_pe) WITH '200' 'Comentario' INTO messagetext.
      messageid = 'E'.
    ELSE.
      CALL FUNCTION 'Z_HR_INPUT_SOL_FOTOCHECK'
        EXPORTING
          ip_codigo_pers    = employeenumber
          ip_id_motiv_sol   = idreason
          ip_comentario_sol = commentsol
        IMPORTING
          ep_text           = messagetext
          ep_error          = messageid.

      IF messageid IS INITIAL.
        messageid = 'S'.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
