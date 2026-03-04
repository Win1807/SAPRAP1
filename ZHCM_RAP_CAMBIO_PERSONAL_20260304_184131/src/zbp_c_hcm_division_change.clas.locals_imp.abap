CLASS lhc_zc_hcm_division_change DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zc_hcm_division_change RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zc_hcm_division_change.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zc_hcm_division_change.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zc_hcm_division_change.

    METHODS read FOR READ
      IMPORTING keys FOR READ zc_hcm_division_change RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zc_hcm_division_change.

ENDCLASS.

CLASS lhc_zc_hcm_division_change IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    TYPES hcm_division_changes TYPE STANDARD TABLE OF zc_hcm_division_change.
    DATA division_changes TYPE hcm_division_changes.
    DATA division_change  LIKE LINE OF division_changes.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entitie>).
      MOVE-CORRESPONDING <entitie> TO division_change.
    ENDLOOP.
    APPEND division_change TO division_changes.

    DATA personal_change TYPE REF TO zcl_hcm_personal_change.

    personal_change = NEW #( ).

    DATA(Messages) = personal_change->set_change_division( division_change = division_change ).

    " GET MESSAGE AND SHOW IT
    IF Messages-id = 'E'.
      reported-zc_hcm_division_change = VALUE #(
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                          text     = Messages-message ) ) ).
    ELSE.
      reported-zc_hcm_division_change = VALUE #(
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                          text     = Messages-message ) ) ).
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

CLASS lsc_zc_hcm_division_change DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zc_hcm_division_change IMPLEMENTATION.

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
