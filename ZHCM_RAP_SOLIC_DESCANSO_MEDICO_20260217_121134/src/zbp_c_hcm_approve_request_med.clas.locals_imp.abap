CLASS lhc_zc_hcm_approve_request_med DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS read FOR READ
      IMPORTING keys FOR READ zc_hcm_approve_request_med RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zc_hcm_approve_request_med.

    METHODS approve_request FOR MODIFY
      IMPORTING entities FOR ACTION zc_hcm_approve_request_med~approve_request.

    METHODS Reject_Request FOR MODIFY
      IMPORTING entities FOR ACTION zc_hcm_approve_request_med~Reject_Request.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zc_hcm_approve_request_med RESULT result.

ENDCLASS.

CLASS lhc_zc_hcm_approve_request_med IMPLEMENTATION.
  METHOD Approve_Request.
    TYPES hcm_APPROVE_REQUEST TYPE STANDARD TABLE OF zc_hcm_approve_request_med.
    DATA approve_requests TYPE hcm_APPROVE_REQUEST.
    DATA approve_request  LIKE LINE OF approve_requests.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entiti>).
      MOVE-CORRESPONDING <entiti> TO approve_request.
    ENDLOOP.

    APPEND approve_request TO approve_requests.

    DATA sol_desc_med TYPE REF TO zcl_hcm_solic_descanso_medico.

    sol_desc_med = NEW #( ).

    DATA(Messages) = sol_desc_med->approve_request( approve_request = approve_requests ). " Obtiene el mensaje de la aprobacion de la solicitud

    " GET MESSAGE AND SHOW IT
    LOOP AT Messages ASSIGNING FIELD-SYMBOL(<message>).
      IF <message>-id = 'E'.
        reported-zc_hcm_approve_request_med = VALUE #(
            ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                            text     = <message>-message ) ) ).
      ELSE.
        reported-zc_hcm_approve_request_med = VALUE #(
            ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                            text     = <message>-message ) ) ).
      ENDIF.

      EXIT.
    ENDLOOP.
  ENDMETHOD.

  METHOD Reject_Request.
    TYPES hcm_APPROVE_REQUEST TYPE STANDARD TABLE OF zc_hcm_approve_request_med.
    DATA reject_requests TYPE hcm_APPROVE_REQUEST.
    DATA reject_request  LIKE LINE OF reject_requests.
    DATA rejet_reason type zeobservacion.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entiti>).
      MOVE-CORRESPONDING <entiti> TO reject_request.
      rejet_reason = <ENTITI>-%PARAM-REASONREJECTION.
    ENDLOOP.

    reject_request-ReasonRejection = rejet_reason.

    APPEND reject_request TO reject_requests.

    DATA sol_desc_med TYPE REF TO zcl_hcm_solic_descanso_medico.

    sol_desc_med = NEW #( ).

    DATA(Messages) = sol_desc_med->Reject_Request( reject_request = reject_requests ). " Obtiene el mensaje de la aprobacion de la solicitud

    " GET MESSAGE AND SHOW IT
    LOOP AT Messages ASSIGNING FIELD-SYMBOL(<message>).
      IF <message>-id = 'E'.
        reported-zc_hcm_approve_request_med = VALUE #(
            ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                            text     = <message>-message ) ) ).
      ELSE.
        reported-zc_hcm_approve_request_med = VALUE #(
            ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                            text     = <message>-message ) ) ).
      ENDIF.

      EXIT.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.


  METHOD get_global_authorizations.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zc_hcm_approve_request_med DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zc_hcm_approve_request_med IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
