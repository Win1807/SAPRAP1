CLASS lhc_ZC_HCM_APPROV_REJECT_LOAN DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    TYPES hcm_approv_reject_loan TYPE STANDARD TABLE OF zc_hcm_approv_reject_loan.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zc_hcm_approv_reject_loan RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zc_hcm_approv_reject_loan.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zc_hcm_approv_reject_loan.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zc_hcm_approv_reject_loan.

    METHODS read FOR READ
      IMPORTING keys FOR READ zc_hcm_approv_reject_loan RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zc_hcm_approv_reject_loan.

ENDCLASS.

CLASS lhc_ZC_HCM_APPROV_REJECT_LOAN IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.

    DATA cl_loan_admin      TYPE REF TO zcl_hcm_loan_admin.

    DATA approv_reject_loans TYPE hcm_approv_reject_loan.
    DATA approv_reject_loan  LIKE LINE OF approv_reject_loans.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entitie>).
      MOVE-CORRESPONDING <entitie> TO approv_reject_loan.
    ENDLOOP.
    APPEND approv_reject_loan TO approv_reject_loans.

    DATA message_out TYPE ze_msjtransgre.
    DATA message_type TYPE ze_trangresion.

    cl_loan_admin = NEW #( ).

    IF approv_reject_loans[ 1 ]-Action EQ '2'."Aprobacion

      cl_loan_admin->post_aprov_reject_loan(
                    EXPORTING aprov_reject_loan = approv_reject_loans
                    IMPORTING message =  message_out
                              type    =  message_type ).

    ELSE."Rechazo

      cl_loan_admin->reject_loan(
                    EXPORTING aprov_reject_loan = approv_reject_loans
                    IMPORTING message =  message_out
                              type    =  message_type ).
    ENDIF.

    " GET MESSAGE AND SHOW IT

    DATA part_message         TYPE string.
    DATA offset_value         TYPE i VALUE 0.
    DATA table_parts_messages TYPE TABLE OF string.

    DO 4 TIMES.
      IF offset_value < strlen( message_out ).
        part_message = message_out+offset_value(50).
      ELSE.
        CLEAR part_message.
      ENDIF.

      APPEND part_message TO table_parts_messages.
      offset_value += 50.
    ENDDO.

    IF message_type = 'E'.
      reported-zc_hcm_approv_reject_loan = VALUE #( ( %msg = new_message( id       = ''
                                                             number   = '01'
                                                             severity = if_abap_behv_message=>severity-error
                                                             v1       = table_parts_messages[ 1 ]
                                                             v2       = table_parts_messages[ 2 ]
                                                             v3       = table_parts_messages[ 3 ]
                                                             v4       = table_parts_messages[ 4 ] ) ) ).
    ELSE.
      reported-zc_hcm_approv_reject_loan = VALUE #( ( %msg = new_message( id       = ''
                                                             number   = '01'
                                                             severity = if_abap_behv_message=>severity-success
                                                             v1       = table_parts_messages[ 1 ]
                                                             v2       = table_parts_messages[ 2 ]
                                                             v3       = table_parts_messages[ 3 ]
                                                             v4       = table_parts_messages[ 4 ] ) ) ).
    ENDIF.


  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZC_HCM_APPROV_REJECT_LOAN DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZC_HCM_APPROV_REJECT_LOAN IMPLEMENTATION.

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
