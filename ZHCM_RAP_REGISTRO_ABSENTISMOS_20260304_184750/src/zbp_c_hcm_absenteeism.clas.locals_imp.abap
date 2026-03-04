CLASS lhc_zc_hcm_absenteeism DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zc_hcm_absenteeism RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zc_hcm_absenteeism.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zc_hcm_absenteeism.

    METHODS delete FOR MODIFY
      IMPORTING entities FOR DELETE zc_hcm_absenteeism.

    METHODS read FOR READ
      IMPORTING keys FOR READ zc_hcm_absenteeism RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zc_hcm_absenteeism.

ENDCLASS.

CLASS lhc_zc_hcm_absenteeism IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    TYPES hcm_absenteeism TYPE STANDARD TABLE OF zc_hcm_absenteeism.
    DATA absenteeisms TYPE hcm_absenteeism.
    DATA absenteeism  LIKE LINE OF absenteeisms.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entities>).
      MOVE-CORRESPONDING <entities> TO absenteeism.
    ENDLOOP.

    APPEND absenteeism TO absenteeisms.

    DATA Absentismo TYPE REF TO zcl_hcm_absenteeism.

    Absentismo = NEW #( ).

    DATA(Messages) = Absentismo->set_create_absenteeism( absenteeism = absenteeism ). " Obtiene el mensaje del registro de la solicitud

    " GET MESSAGE AND SHOW IT
    CASE Messages-type.
      WHEN 'E'.
        DATA(message_type) = ms-error.
      WHEN 'W'.
        message_type = ms-warning.
      WHEN 'S'.
        message_type = ms-success.
    ENDCASE.

    APPEND VALUE #( %msg = new_message( id       = 'ZHCM_RAP_PE'
                                        number   = '016'
                                        v1       = messages-message(50)
                                        v2       = messages-message+50(50)
                                        v3       = messages-message+100(50)
                                        v4       = messages-message+150(50)
                                        severity = message_type  ) ) TO reported-zc_hcm_absenteeism.
  ENDMETHOD.

  METHOD update.
    TYPES hcm_absenteeism TYPE STANDARD TABLE OF zc_hcm_absenteeism.
    DATA absenteeisms TYPE hcm_absenteeism.
    DATA absenteeism  LIKE LINE OF absenteeisms.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entities>).
      MOVE-CORRESPONDING <entities> TO absenteeism.
    ENDLOOP.

    APPEND absenteeism TO absenteeisms.

    DATA Absentismo TYPE REF TO zcl_hcm_absenteeism.

    Absentismo = NEW #( ).

    DATA(Messages) = Absentismo->set_update_absenteeism( absenteeism = absenteeism ). " Obtiene el mensaje modificado del registro de la solicitud

    " GET MESSAGE AND SHOW IT
    CASE Messages-type.
      WHEN 'E'.
        DATA(message_type) = ms-error.
      WHEN 'W'.
        message_type = ms-warning.
      WHEN 'S'.
        message_type = ms-success.
    ENDCASE.

    APPEND VALUE #( %msg = new_message( id       = 'ZHCM_RAP_PE'
                                        number   = '016'
                                        v1       = messages-message(50)
                                        v2       = messages-message+50(50)
                                        v3       = messages-message+100(50)
                                        v4       = messages-message+150(50)
                                        severity = message_type  ) ) TO reported-zc_hcm_absenteeism.
  ENDMETHOD.

  METHOD delete.
    TYPES hcm_absenteeism TYPE STANDARD TABLE OF zc_hcm_absenteeism.
    DATA absenteeisms TYPE hcm_absenteeism.
    DATA absenteeism  LIKE LINE OF absenteeisms.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entities>).
      MOVE-CORRESPONDING <entities> TO absenteeism.
    ENDLOOP.

    APPEND absenteeism TO absenteeisms.

    DATA Absentismo TYPE REF TO zcl_hcm_absenteeism.

    Absentismo = NEW #( ).

    DATA(Messages) = Absentismo->set_delete_absenteeism( absenteeism = absenteeism ). " Obtiene el mensaje del Registro Eliminado

    " GET MESSAGE AND SHOW IT
    CASE Messages-type.
      WHEN 'E'.
        DATA(message_type) = ms-error.
      WHEN 'W'.
        message_type = ms-warning.
      WHEN 'S'.
        message_type = ms-success.
    ENDCASE.

    APPEND VALUE #( %msg = new_message( id       = 'ZHCM_RAP_PE'
                                        number   = '016'
                                        v1       = messages-message(50)
                                        v2       = messages-message+50(50)
                                        v3       = messages-message+100(50)
                                        v4       = messages-message+150(50)
                                        severity = message_type  ) ) TO reported-zc_hcm_absenteeism.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zc_hcm_absenteeism DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save              REDEFINITION.

    METHODS cleanup           REDEFINITION.

    METHODS cleanup_finalize  REDEFINITION.

ENDCLASS.

CLASS lsc_zc_hcm_absenteeism IMPLEMENTATION.

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
