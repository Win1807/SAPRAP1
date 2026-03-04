CLASS lhc_zc_hcm_initial_check_polit DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zc_hcm_initial_check_politics RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zc_hcm_initial_check_politics.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zc_hcm_initial_check_politics.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zc_hcm_initial_check_politics.

    METHODS read FOR READ
      IMPORTING keys FOR READ zc_hcm_initial_check_politics RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zc_hcm_initial_check_politics.

    METHODS ApprovePolicy FOR MODIFY
      IMPORTING vacations FOR ACTION zc_hcm_initial_check_politics~ApprovePolicy.

    METHODS ValidationPolicyCheck FOR MODIFY
      IMPORTING vacations FOR ACTION zc_hcm_initial_check_politics~ValidationPolicyCheck.

    METHODS RejectPolicy FOR MODIFY
      IMPORTING vacations FOR ACTION zc_hcm_initial_check_politics~RejectPolicy.

ENDCLASS.

CLASS lhc_zc_hcm_initial_check_polit IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD ApprovePolicy.
    DATA Frac_Vac       TYPE REF TO zcl_hcm_frac_vac.
    DATA employeenumber TYPE bapiusr01-employeeno.
    DATA Message        TYPE bapiret2.

    CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
      EXPORTING id             = sy-uname
                begindate      = sy-datum
                enddate        = sy-datum
      IMPORTING return         = Message
                employeenumber = employeenumber.

    IF Message IS NOT INITIAL.
      APPEND VALUE #( %msg = new_message( id       = 'ZHCM_RAP_PE'
                                          number   = '016'
                                          v1       = Message-message(50)
                                          v2       = Message-message+50(50)
                                          v3       = Message-message+100(50)
                                          v4       = Message-message+150(50)
                                          severity = ms-error  ) ) TO reported-zc_hcm_initial_check_politics.

    ENDIF.

    Frac_Vac = NEW #( ).
    Message = Frac_Vac->approve_policy( employeenumber = EmployeeNumber
                                        approve_reject = '1' ).

    " GET MESSAGE AND SHOW IT
    CASE Message-type.
      WHEN 'E'.
        DATA(message_type) = ms-error.
      WHEN 'W'.
        message_type = ms-warning.
      WHEN 'S'.
        message_type = ms-success.
    ENDCASE.

    APPEND VALUE #( %msg = new_message( id       = 'ZHCM_RAP_PE'
                                        number   = '016'
                                        v1       = Message-message(50)
                                        v2       = Message-message+50(50)
                                        v3       = Message-message+100(50)
                                        v4       = Message-message+150(50)
                                        severity = message_type  ) ) TO reported-zc_hcm_initial_check_politics.
  ENDMETHOD.

  METHOD ValidationPolicyCheck.
    DATA Frac_Vac TYPE REF TO zcl_hcm_frac_vac.

    Frac_Vac = NEW #( ).
    Frac_Vac->initial_policy_check( EXPORTING user_name    = sy-uname " user_name
                                    IMPORTING results      = DATA(Messages)
                                              flag_message = DATA(flag_message) ).
    LOOP AT Messages INTO DATA(Message).
      IF flag_message IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      CASE Message-type.
        WHEN 'E'.
          DATA(message_type) = ms-error.
      ENDCASE.

      APPEND VALUE #( %msg = new_message( id       = 'ZHCM_RAP_PE'
                                          number   = '016'
                                          v1       = Message-message(50)
                                          v2       = Message-message+50(50)
                                          v3       = Message-message+100(50)
                                          v4       = Message-message+150(50)
                                          severity = message_type  ) ) TO reported-zc_hcm_initial_check_politics.
    ENDLOOP.
  ENDMETHOD.

  METHOD RejectPolicy.
    DATA Frac_Vac       TYPE REF TO zcl_hcm_frac_vac.
    DATA employeenumber TYPE bapiusr01-employeeno.
    DATA Message        TYPE bapiret2.

    CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
      EXPORTING id             = sy-uname
                begindate      = sy-datum
                enddate        = sy-datum
      IMPORTING return         = Message
                employeenumber = employeenumber.

    IF Message IS INITIAL.

      Frac_Vac = NEW #( ).
      Message = Frac_Vac->approve_policy( employeenumber = EmployeeNumber
                                          approve_reject = '2' ).

      " GET MESSAGE AND SHOW IT
      CASE Message-type.
        WHEN 'E'.
          DATA(message_type) = ms-error.
        WHEN 'W'.
          message_type = ms-warning.
        WHEN 'S'.
          message_type = ms-success.
      ENDCASE.
    ENDIF.
    APPEND VALUE #( %msg = new_message( id       = 'ZHCM_RAP_PE'
                                        number   = '016'
                                        v1       = Message-message(50)
                                        v2       = Message-message+50(50)
                                        v3       = Message-message+100(50)
                                        v4       = Message-message+150(50)
                                        severity = message_type  ) ) TO reported-zc_hcm_initial_check_politics.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zc_hcm_initial_check_polit DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zc_hcm_initial_check_polit IMPLEMENTATION.

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
