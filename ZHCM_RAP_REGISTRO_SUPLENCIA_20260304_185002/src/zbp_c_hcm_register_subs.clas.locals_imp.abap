CLASS lhc_RegisterSubs DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    TYPES hcm_register_subs TYPE STANDARD TABLE OF zc_hcm_register_subs.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR RegisterSubs RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE RegisterSubs.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE RegisterSubs.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE RegisterSubs.

    METHODS read FOR READ
      IMPORTING keys FOR READ RegisterSubs RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK RegisterSubs.

ENDCLASS.

CLASS lhc_RegisterSubs IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA cl_substitution_record        TYPE REF TO zcl_hcm_substitution_record.
    DATA employee_substitute_registers TYPE hcm_register_subs.
    DATA employee_substitute_register  LIKE LINE OF employee_substitute_registers.
    DATA message_out                   TYPE zhcms_message.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_enti>).
      MOVE-CORRESPONDING <fs_enti> TO employee_substitute_register.
      APPEND employee_substitute_register TO employee_substitute_registers.
    ENDLOOP.

    cl_substitution_record = NEW #( ).

    message_out = cl_substitution_record->post_register_substitute(
                      register_substitute_employees = employee_substitute_registers ).

    " GET MESSAGE AND SHOW IT

    DATA part_message         TYPE string.
    DATA offset_value         TYPE i VALUE 0.
    DATA table_parts_messages TYPE TABLE OF string.

    DO 4 TIMES.
      IF offset_value < strlen( message_out-text ).
        part_message = message_out-text+offset_value(50).
      ELSE.
        CLEAR part_message.
      ENDIF.

      APPEND part_message TO table_parts_messages.
      offset_value += 50.
    ENDDO.

    IF message_out-type_error = 'E' OR message_out-type_error = 'X'.


      APPEND VALUE #( %msg = new_message( id       = 'ZHCM_RAP_PE'
                                          number   = '016'
                                          severity = if_abap_behv_message=>severity-error
                                          v1       = table_parts_messages[ 1 ]
                                          v2       = table_parts_messages[ 2 ]
                                          v3       = table_parts_messages[ 3 ]
                                          v4       = table_parts_messages[ 4 ] ) ) TO reported-registersubs.
    ELSE.


      APPEND VALUE #( %msg = new_message( id       = 'ZHCM_RAP_PE'
                                          number   = '016'
                                          severity = if_abap_behv_message=>severity-success
                                          v1       = table_parts_messages[ 1 ]
                                          v2       = table_parts_messages[ 2 ]
                                          v3       = table_parts_messages[ 3 ]
                                          v4       = table_parts_messages[ 4 ] ) ) TO reported-registersubs.

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

CLASS lsc_ZC_HCM_REGISTER_SUBS DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZC_HCM_REGISTER_SUBS IMPLEMENTATION.

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
