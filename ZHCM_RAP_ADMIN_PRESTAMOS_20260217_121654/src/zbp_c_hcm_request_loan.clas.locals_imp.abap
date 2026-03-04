CLASS lhc_ZC_HCM_REQUEST_LOAN DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES hcm_request_loan TYPE STANDARD TABLE OF zc_hcm_request_loan.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zc_hcm_request_loan RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zc_hcm_request_loan.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zc_hcm_request_loan.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zc_hcm_request_loan.

    METHODS read FOR READ
      IMPORTING keys FOR READ zc_hcm_request_loan RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zc_hcm_request_loan.

ENDCLASS.

CLASS lhc_ZC_HCM_REQUEST_LOAN IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

    DATA cl_loan_admin      TYPE REF TO zcl_hcm_loan_admin.

    DATA request_loan TYPE hcm_request_loan.
    DATA line_request_loan  LIKE LINE OF request_loan.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entitie>).
      MOVE-CORRESPONDING <entitie> TO line_request_loan.
    ENDLOOP.
    APPEND line_request_loan TO request_loan.

    DATA message_out TYPE bapiret2.
    DATA result_num_presta TYPE ze_numsolpres.
    DATA fecha_init_amort TYPE ZE_FEC_SOL.
    DATA fecha_fin_pago   TYPE ZE_FINPAGO.

    cl_loan_admin = NEW #( ).

    cl_loan_admin->create_loan_admin(
     EXPORTING action = 'S'
               request_loan = request_loan
     IMPORTING ep_mensaje =  message_out
               result_num_prestamo = result_num_presta
               ).

    " GET MESSAGE AND SHOW IT

    DATA part_message         TYPE string.
    DATA offset_value         TYPE i VALUE 0.
    DATA table_parts_messages TYPE TABLE OF string.

    DO 4 TIMES.
      IF offset_value < strlen( message_out-message ).
        part_message = message_out-message+offset_value(50).
      ELSE.
        CLEAR part_message.
      ENDIF.

      APPEND part_message TO table_parts_messages.
      offset_value += 50.
    ENDDO.

    IF message_out-type = 'E'.
      reported-zc_hcm_request_loan = VALUE #( ( %msg = new_message( id       = ''
                                                             number   = '01'
                                                             severity = if_abap_behv_message=>severity-error
                                                             v1       = table_parts_messages[ 1 ]
                                                             v2       = table_parts_messages[ 2 ]
                                                             v3       = table_parts_messages[ 3 ]
                                                             v4       = table_parts_messages[ 4 ] ) ) ).
    ELSE.


      reported-zc_hcm_request_loan = VALUE #( ( %msg = new_message( id       = ''
                                                             number   = '01'
                                                             severity = if_abap_behv_message=>severity-success
                                                             v1       = table_parts_messages[ 1 ]
                                                             v2       = table_parts_messages[ 2 ]
                                                             v3       = table_parts_messages[ 3 ]
                                                             v4       = table_parts_messages[ 4 ] )
                                                              )
                                                  ).


      LOOP AT entities ASSIGNING FIELD-SYMBOL(<entities>).

        APPEND VALUE #( %cid = <entities>-%cid LoanAppNumber = result_num_presta ) TO mapped-zc_hcm_request_loan.


      ENDLOOP.

    ENDIF.

  ENDMETHOD.

  METHOD update.

    DATA cl_loan_admin      TYPE REF TO zcl_hcm_loan_admin.

    DATA request_loan TYPE hcm_request_loan.
    DATA line_request_loan  LIKE LINE OF request_loan.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entitie>).
      MOVE-CORRESPONDING <entitie> TO line_request_loan.
    ENDLOOP.
    APPEND line_request_loan TO request_loan.

    DATA message_out TYPE bapiret2.

    cl_loan_admin = NEW #( ).

    cl_loan_admin->manager_ztsolprestamo(
     EXPORTING action = 'M'
               request_loan = request_loan
     IMPORTING ep_mensaje =  message_out ).

    " GET MESSAGE AND SHOW IT

    DATA part_message         TYPE string.
    DATA offset_value         TYPE i VALUE 0.
    DATA table_parts_messages TYPE TABLE OF string.

    DO 4 TIMES.
      IF offset_value < strlen( message_out-message ).
        part_message = message_out-message+offset_value(50).
      ELSE.
        CLEAR part_message.
      ENDIF.

      APPEND part_message TO table_parts_messages.
      offset_value += 50.
    ENDDO.

    IF message_out-type = 'E'.
      reported-zc_hcm_request_loan = VALUE #( ( %msg = new_message( id       = ''
                                                             number   = '01'
                                                             severity = if_abap_behv_message=>severity-error
                                                             v1       = table_parts_messages[ 1 ]
                                                             v2       = table_parts_messages[ 2 ]
                                                             v3       = table_parts_messages[ 3 ]
                                                             v4       = table_parts_messages[ 4 ] ) ) ).
    ELSE.
      reported-zc_hcm_request_loan = VALUE #( ( %msg = new_message( id       = ''
                                                             number   = '01'
                                                             severity = if_abap_behv_message=>severity-success
                                                             v1       = table_parts_messages[ 1 ]
                                                             v2       = table_parts_messages[ 2 ]
                                                             v3       = table_parts_messages[ 3 ]
                                                             v4       = table_parts_messages[ 4 ] ) ) ).
    ENDIF.

  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZC_HCM_REQUEST_LOAN DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZC_HCM_REQUEST_LOAN IMPLEMENTATION.

  METHOD finalize.
      DATA: test type char1.
      test = '1'.
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
