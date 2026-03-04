CLASS lhc_zc_hcm_request_med_employe DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR RequestEmployee RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE RequestEmployee.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE RequestEmployee.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE RequestEmployee.

    METHODS read FOR READ
      IMPORTING keys FOR READ RequestEmployee RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK RequestEmployee.

ENDCLASS.

CLASS lhc_zc_hcm_request_med_employe IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    TYPES hcm_request_employees TYPE STANDARD TABLE OF zc_hcm_request_med_employee.
    DATA request_employees TYPE hcm_request_employees.
    DATA request_employee  LIKE LINE OF request_employees.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_enti>).
      MOVE-CORRESPONDING <fs_enti> TO request_employee.
    ENDLOOP.
    APPEND request_employee TO request_employees.

    DATA sol_desc_med TYPE REF TO zcl_hcm_solic_descanso_medico.

    sol_desc_med = NEW #( ).

    DATA(Messages) = sol_desc_med->validate_input( CHANGING request_employees = request_employees ).

    " GET MESSAGE AND SHOW IT
    LOOP AT Messages ASSIGNING FIELD-SYMBOL(<fs_message>).
      reported-requestemployee = VALUE #(
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                          text     = <fs_message>-message ) ) ).
    ENDLOOP.

    IF lines( Messages ) IS NOT INITIAL.
      RETURN.
    ENDIF.

    DATA(Message_req) = sol_desc_med->save_request( request_medical_leave = request_employees ). " Tabla retorno

    IF Message_req-id = 'E'.
      reported-requestemployee = VALUE #(
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                          text     = Message_req-message ) ) ).
    ELSE.
      reported-requestemployee = VALUE #(
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                          text     = Message_req-message ) ) ).
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

*  METHOD send_request.
*    READ ENTITIES OF zc_hcm_request_med_employee IN LOCAL MODE
*       ENTITY zc_hcm_request_med_employee
*         FIELDS ( userid employeenumber employeename )
*          WITH CORRESPONDING #( keys )
*       RESULT DATA(travels).
*
*    LOOP AT travels INTO DATA(travel).
*    ENDLOOP.
*  ENDMETHOD.

ENDCLASS.

CLASS lsc_zc_hcm_request_med_employe DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zc_hcm_request_med_employe IMPLEMENTATION.

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
