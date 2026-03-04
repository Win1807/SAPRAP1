CLASS lhc_zc_hcm_vacation_fraction DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zc_hcm_vacation_fraction RESULT result.

    METHODS create FOR MODIFY
      IMPORTING vacations FOR CREATE zc_hcm_vacation_fraction.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zc_hcm_vacation_fraction.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zc_hcm_vacation_fraction.

    METHODS read FOR READ
      IMPORTING keys FOR READ zc_hcm_vacation_fraction RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zc_hcm_vacation_fraction.

    METHODS validationvacation FOR MODIFY
      IMPORTING vacations FOR ACTION zc_hcm_vacation_fraction~validationvacation.

ENDCLASS.

CLASS lhc_zc_hcm_vacation_fraction IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    " data FRACTIONATION_DATA  Type STANDARD TABLE OF VACATION_SPLIT_STRUCT.
    DATA result   TYPE bapiret2.
    DATA Frac_Vac TYPE REF TO zcl_hcm_frac_vac.

    DATA(vacation) = vacations[ 1 ].

    Frac_Vac = NEW #( ).
    DATA notice      TYPE string.
    DATA workin_days TYPE wkwdy.
    workin_days = Vacation-WorkingDays.
    notice = vacation-AuthorizerNote.
    Frac_Vac->send_vacation_request( EXPORTING absenteeism_class   = vacation-AbsenteeismClass
                                               begda_vacation      = vacation-StartDate
                                               endda_vacation      = vacation-EndDate
*                                               employeenumber      = vacation-EmployeeNumber
                                               notice              = notice
                                               weekly_working_days = workin_days
                                     IMPORTING result              = result ).

    " GET MESSAGE AND SHOW IT
    CASE result-type.
      WHEN 'E'.
        DATA(message_type) = ms-error.
      WHEN 'W'.
        message_type = ms-warning.
      WHEN 'S'.
        message_type = ms-success.
    ENDCASE.

    APPEND VALUE #( %msg = new_message( id       = 'ZHCM_RAP_PE'
                                        number   = '016'
                                        v1       = result-message(50)
                                        v2       = result-message+50(50)
                                        v3       = result-message+100(50)
                                        v4       = result-message+150(50)
                                        severity = message_type  ) ) TO reported-zc_hcm_vacation_fraction.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD ValidationVacation.
    DATA Frac_Vac TYPE REF TO zcl_hcm_frac_vac.

    Frac_Vac = NEW #( ).
    Frac_Vac->initial_splitting_check( EXPORTING user_name = sy-uname " user_name
                                       IMPORTING results   = DATA(Messages) ).
*                                                 vacation_split = DATA(vacation_split) ).

    " GET MESSAGE AND SHOW IT
    LOOP AT Messages INTO DATA(Message).

      CASE Message-type.
        WHEN 'E'.
          DATA(message_type) = ms-error.
        WHEN 'W'.
          message_type = ms-warning.
        WHEN 'S'.
          message_type = ms-success.
      ENDCASE.
      IF Message-message IS NOT INITIAL.
        APPEND VALUE #( %msg = new_message( id       = 'ZHCM_RAP_PE'
                                            number   = '016'
                                            v1       = Message-message(50)
                                            v2       = Message-message+50(50)
                                            v3       = Message-message+100(50)
                                            v4       = Message-message+150(50)
                                            severity = message_type  ) ) TO reported-zc_hcm_vacation_fraction.

      ELSE.
        APPEND VALUE #( %msg = new_message( id       = Message-id
                                            number   = Message-number
                                            v1       = Message-message_v1
                                            v2       = Message-message_v2
                                            v3       = Message-message_v3
                                            v4       = Message-message_v4
                                            severity = message_type  ) ) TO reported-zc_hcm_vacation_fraction.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zc_hcm_vacation_fraction DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zc_hcm_vacation_fraction IMPLEMENTATION.

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
