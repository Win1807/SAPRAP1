CLASS lhc_zc_hcm_sanctions_record DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zc_hcm_sanctions_record RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE zc_hcm_sanctions_record.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zc_hcm_sanctions_record.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zc_hcm_sanctions_record.

    METHODS read FOR READ
      IMPORTING keys FOR READ zc_hcm_sanctions_record RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zc_hcm_sanctions_record.

ENDCLASS.

CLASS lhc_zc_hcm_sanctions_record IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD create.
    TYPES hcm_sanctions_records TYPE STANDARD TABLE OF zc_hcm_sanctions_record.
    TYPES hcm_validate_dateends TYPE STANDARD TABLE OF zc_hcm_validate_dateend.

    DATA validate_dateends TYPE hcm_validate_dateends.

    DATA sanctions_records TYPE hcm_sanctions_records.
    DATA sanctions_record  LIKE LINE OF sanctions_records.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<fs_enti>).
      MOVE-CORRESPONDING <fs_enti> TO sanctions_record.

      " OBTIENE EL CODIGO DE COMPAÑIA DEL EMPLEADO
      CALL FUNCTION 'Z_HR_RFC_GET_IT0001_DATA'
        EXPORTING ip_pernr = sanctions_record-employeenumber
        IMPORTING bukrs    = sanctions_record-company.

      " VALIDA SI LA FECHA DE INICIO ESTA VACIO SE OBDENTRA LA FECHA ACTUAL
      IF sanctions_record-DateBegin IS INITIAL.
        sanctions_record-DateBegin = sy-datum.
      ENDIF.

      " VALIDA SI LA FECHA DE FIN ESTA VACIO SE OBDENTRA LA FECHA ACTUAL
      IF sanctions_record-DateEnd IS INITIAL.
        sanctions_record-DateEnd = sy-datum.
      ENDIF.

      APPEND INITIAL LINE TO validate_dateends ASSIGNING FIELD-SYMBOL(<validate_dateend>).
      MOVE-CORRESPONDING sanctions_record TO <validate_dateend>.
      <validate_dateend>-begda = sanctions_record-DateBegin.
      <validate_dateend>-endda = sanctions_record-DateEnd.

    ENDLOOP.
    APPEND sanctions_record TO sanctions_records.

    DATA sanctions_registry TYPE REF TO zcl_hcm_sanctions_registry.

    sanctions_registry = NEW #( ).

    " VALIDAR SI LA FECHA ES LABORAABLE O NO
    sanctions_registry->get_validate_dateend( CHANGING sanctions_validates = validate_dateends ).
    ASSIGN validate_dateends[ 1 ] TO <validate_dateend>.
    IF <validate_dateend>-message IS NOT INITIAL.
      reported-zc_hcm_sanctions_record = VALUE #(
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                          text     = <validate_dateend>-message ) ) ).
      RETURN.
    ENDIF.

    " VALIDAR SI EXISTE UNA SANCION REGISTRADA
    DATA(Message_validate_santion) = sanctions_registry->get_validate_sanction( sanctions_validate = sanctions_record ).

    IF Message_validate_santion IS NOT INITIAL.
      reported-zc_hcm_sanctions_record = VALUE #(
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                          text     = Message_validate_santion-message ) ) ).

      RETURN.
    ENDIF.

    " REALIZ EL REGISTRO DE LA SANCION INGRESADA
    DATA(Message_record) = sanctions_registry->set_sanction_save( sanctions_record = sanctions_record ). " Tabla retorno

    IF Message_record-id = 'E'.
      reported-zc_hcm_sanctions_record = VALUE #(
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                          text     = Message_record-message ) ) ).
    ELSE.
      reported-zc_hcm_sanctions_record = VALUE #(
          ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                          text     = Message_record-message ) ) ).
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

CLASS lsc_zc_hcm_sanctions_record DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save              REDEFINITION.

    METHODS cleanup           REDEFINITION.

    METHODS cleanup_finalize  REDEFINITION.

ENDCLASS.

CLASS lsc_zc_hcm_sanctions_record IMPLEMENTATION.

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
