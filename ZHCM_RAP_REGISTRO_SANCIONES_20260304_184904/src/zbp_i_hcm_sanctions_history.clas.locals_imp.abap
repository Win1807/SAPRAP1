CLASS lhc_zi_hcm_sanctions_history DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_hcm_sanctions_history RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zi_hcm_sanctions_history.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_hcm_sanctions_history.

    METHODS delete FOR MODIFY
      IMPORTING entities FOR DELETE zi_hcm_sanctions_history.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_hcm_sanctions_history RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_hcm_sanctions_history.

ENDCLASS.

CLASS lhc_zi_hcm_sanctions_history IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
    TYPES hcm_sanctions_historys TYPE STANDARD TABLE OF zi_hcm_sanctions_history.
    DATA sanctions_historys TYPE STANDARD TABLE OF zi_hcm_sanctions_history.
    DATA sanctions_history  LIKE LINE OF sanctions_historys.
    DATA sanctions_registry TYPE REF TO zcl_hcm_sanctions_registry.

    sanctions_registry = NEW #( ).

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entitie>).
      MOVE-CORRESPONDING <entitie> TO sanctions_history.
      DATA(Message) = sanctions_registry->set_sanction_delete( sanctions_history = sanctions_history ).
    ENDLOOP.

    IF Message-id = 'E'.
      reported-zi_hcm_sanctions_history = VALUE #(
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                          text     = Message-message ) ) ).
    ELSE.
      reported-zi_hcm_sanctions_history = VALUE #(
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                          text     = Message-message ) ) ).
    ENDIF.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_hcm_sanctions_history DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save              REDEFINITION.

    METHODS cleanup           REDEFINITION.

    METHODS cleanup_finalize  REDEFINITION.

ENDCLASS.

CLASS lsc_zi_hcm_sanctions_history IMPLEMENTATION.

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
