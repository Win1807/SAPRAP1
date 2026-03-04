CLASS lhc_zi_hcm_declaration_pat DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_hcm_declaration_pat RESULT result.

    METHODS deep_create FOR MODIFY
      IMPORTING
        Declaration_Pats  FOR CREATE zi_hcm_declaration_pat
        Deposits FOR CREATE zi_hcm_declaration_pat\_Deposits
        Debits FOR CREATE zi_hcm_declaration_pat\_Debits
        Immovables FOR CREATE zi_hcm_declaration_pat\_Immovables
        Others FOR CREATE zi_hcm_declaration_pat\_Others
        Values FOR CREATE zi_hcm_declaration_pat\_Values
        Vehicles FOR CREATE zi_hcm_declaration_pat\_Vehicles.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_hcm_declaration_pat.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_hcm_declaration_pat.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_hcm_declaration_pat RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_hcm_declaration_pat.

    METHODS rba_debits FOR READ
      IMPORTING keys_rba FOR READ zi_hcm_declaration_pat\_debits FULL result_requested RESULT result LINK association_links.

    METHODS rba_deposits FOR READ
      IMPORTING keys_rba FOR READ zi_hcm_declaration_pat\_deposits FULL result_requested RESULT result LINK association_links.

    METHODS rba_immovables FOR READ
      IMPORTING keys_rba FOR READ zi_hcm_declaration_pat\_immovables FULL result_requested RESULT result LINK association_links.

    METHODS rba_others FOR READ
      IMPORTING keys_rba FOR READ zi_hcm_declaration_pat\_others FULL result_requested RESULT result LINK association_links.

    METHODS rba_values FOR READ
      IMPORTING keys_rba FOR READ zi_hcm_declaration_pat\_values FULL result_requested RESULT result LINK association_links.

    METHODS rba_vehicles FOR READ
      IMPORTING keys_rba FOR READ zi_hcm_declaration_pat\_vehicles FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zi_hcm_declaration_pat IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_debits.
  ENDMETHOD.

  METHOD rba_deposits.
  ENDMETHOD.

  METHOD rba_immovables.
  ENDMETHOD.

  METHOD rba_others.
  ENDMETHOD.

  METHOD rba_values.
  ENDMETHOD.

  METHOD rba_vehicles.
  ENDMETHOD.

  METHOD deep_create.
    " Inicializar variables locales y establecer referencias
    DATA employeenumber          TYPE bapiusr01-employeeno.
    DATA declaration_patrimonial TYPE REF TO zcl_hcm_declaration_pat.
    DATA T_depositos             TYPE STANDARD TABLE OF pa9301.
    DATA T_inmuebles             TYPE STANDARD TABLE OF pa9303.
    DATA T_vehiculos             TYPE STANDARD TABLE OF pa9304.
    DATA T_valores               TYPE STANDARD TABLE OF pa9305.
    DATA T_otros_ingresos        TYPE STANDARD TABLE OF pa9306.
    DATA T_deudas                TYPE STANDARD TABLE OF pa9307.

    " Obtención del Nro Empleado
    " Leer el primer registro de Declaration_Pats
    READ TABLE Declaration_Pats INTO DATA(dec_pat) INDEX 1.

    " Recorrer Deposits para agregar registros a T_depositos
    LOOP AT Deposits ASSIGNING FIELD-SYMBOL(<Deposit>).
      LOOP AT <Deposit>-%target ASSIGNING FIELD-SYMBOL(<Deposit_target>).
        APPEND INITIAL LINE TO T_depositos ASSIGNING FIELD-SYMBOL(<T_Deposit>).
        <T_Deposit>-zsaknr_type = <Deposit_target>-DepositTypeBank.
        <T_Deposit>-zbank_desc  = <Deposit_target>-DepositBankDescription.
      ENDLOOP.
    ENDLOOP.

    " Recorrer Immovables para agregar registros a T_inmuebles
    LOOP AT immovables ASSIGNING FIELD-SYMBOL(<immovable>).
      LOOP AT <immovable>-%target ASSIGNING FIELD-SYMBOL(<immovable_target>).
        APPEND INITIAL LINE TO T_inmuebles ASSIGNING FIELD-SYMBOL(<T_inmueble>).
        <T_inmueble>-zaddress = <immovable_target>-ImmovableAddress.
        <T_inmueble>-percent  = <immovable_target>-ImmovablePercent.
        <T_inmueble>-comm_val = <immovable_target>-ImmovableCommercialValue.
        <T_inmueble>-mort_val = <immovable_target>-ImmovableTaxBalance.
      ENDLOOP.
    ENDLOOP.

    " Recorrer Debits para agregar registros a T_deudas
    LOOP AT Debits ASSIGNING FIELD-SYMBOL(<Debit>).
      LOOP AT <Debit>-%target ASSIGNING FIELD-SYMBOL(<Debit_target>).
        APPEND INITIAL LINE TO T_deudas ASSIGNING FIELD-SYMBOL(<T_deuda>).
        <T_deuda>-zbank_desc = <Debit_target>-DebitBankDescription.
        <T_deuda>-zcomm_val  = <Debit_target>-DebitAmount.
        <T_deuda>-zterm      = <Debit_target>-DebitTerm.
      ENDLOOP.
    ENDLOOP.

    " Recorrer Vehicles para agregar registros a T_vehiculos
    LOOP AT Vehicles ASSIGNING FIELD-SYMBOL(<Vehicle>).
      LOOP AT <Vehicle>-%target ASSIGNING FIELD-SYMBOL(<Vehicle_target>).
        APPEND INITIAL LINE TO T_vehiculos ASSIGNING FIELD-SYMBOL(<T_vehiculo>).
        <T_vehiculo>-zvehic      = <Vehicle_target>-VehicleEmbarcation.
        <T_vehiculo>-zvehic_numb = <Vehicle_target>-VehicleNumber.
        <T_vehiculo>-zcomm_val   = <Vehicle_target>-VehicleApproximateValue.
        <T_vehiculo>-zmort_val   = <Vehicle_target>-VehicleBalance.
      ENDLOOP.
    ENDLOOP.

    " Recorrer Others para agregar registros a T_otros_ingresos
    LOOP AT Others ASSIGNING FIELD-SYMBOL(<Other>).
      LOOP AT <Other>-%target ASSIGNING FIELD-SYMBOL(<Other_target>).
        APPEND INITIAL LINE TO T_otros_ingresos ASSIGNING FIELD-SYMBOL(<T_otro>).
        <T_otro>-zconcept  = <Other_target>-OtherConcept.
        <T_otro>-zcomm_val = <Other_target>-OtherMonthlyIncome.
      ENDLOOP.
    ENDLOOP.

    " Recorrer Values para agregar registros a T_Valores
    LOOP AT values ASSIGNING FIELD-SYMBOL(<Value>).
      LOOP AT <Value>-%target ASSIGNING FIELD-SYMBOL(<Value_target>).
        APPEND INITIAL LINE TO T_Valores ASSIGNING FIELD-SYMBOL(<T_Valor>).
        <T_Valor>-zdescription = <Value_target>-ValueBankDescription.
        <T_Valor>-zcomm_val2   = <Value_target>-ValueTypeBank.
      ENDLOOP.
    ENDLOOP.

    " Crear nueva declaración patrimonial
    declaration_patrimonial = NEW #( ).

    " Establecer la información de declaración y obtener mensajes
    DATA(Mensajes) = declaration_patrimonial->set_declaration_pat_inf9308( employernumber = dec_pat-EmployeeNumber
                                                                           depositos      = t_depositos
                                                                           inmuebles      = t_inmuebles
                                                                           vehiculos      = t_vehiculos
                                                                           valores        = t_valores
                                                                           otros_ingresos = t_otros_ingresos
                                                                           deudas         = t_deudas ).

    " Iterar a través de los mensajes devueltos y procesarlos
    LOOP AT Mensajes INTO DATA(Mensaje).
      CASE Mensaje-msgtyp.
        WHEN 'I'.
          DATA(message_type) = ms-success.
        WHEN OTHERS.
          message_type = ms-error.
      ENDCASE.

      APPEND VALUE #( %msg = new_message( id       = 'ZHCM_RAP_PE'
                                          number   = '016'
                                          v1       = mensaje-text(50)
                                          v2       = mensaje-text+50(50)
                                          v3       = mensaje-text+100(50)
                                          v4       = mensaje-text+150(50)
                                          severity = message_type ) ) TO reported-zi_hcm_declaration_pat.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_hcm_debits_dec_pat DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_hcm_debits_dec_pat.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_hcm_debits_dec_pat.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_hcm_debits_dec_pat RESULT result.

    METHODS rba_declaration FOR READ
      IMPORTING keys_rba FOR READ zi_hcm_debits_dec_pat\_declaration FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zi_hcm_debits_dec_pat IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_declaration.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_hcm_deposits_dec_pat DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_hcm_deposits_dec_pat.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_hcm_deposits_dec_pat.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_hcm_deposits_dec_pat RESULT result.

    METHODS rba_declaration FOR READ
      IMPORTING keys_rba FOR READ zi_hcm_deposits_dec_pat\_declaration FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zi_hcm_deposits_dec_pat IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_declaration.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_hcm_immovables_dec_pat DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_hcm_immovables_dec_pat.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_hcm_immovables_dec_pat.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_hcm_immovables_dec_pat RESULT result.

    METHODS rba_declaration FOR READ
      IMPORTING keys_rba FOR READ zi_hcm_immovables_dec_pat\_declaration FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zi_hcm_immovables_dec_pat IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_declaration.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_hcm_others_dec_pat DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_hcm_others_dec_pat.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_hcm_others_dec_pat.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_hcm_others_dec_pat RESULT result.

    METHODS rba_declaration FOR READ
      IMPORTING keys_rba FOR READ zi_hcm_others_dec_pat\_declaration FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zi_hcm_others_dec_pat IMPLEMENTATION.
  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_declaration.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_hcm_values_dec_pat DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_hcm_values_dec_pat.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_hcm_values_dec_pat.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_hcm_values_dec_pat RESULT result.

    METHODS rba_declaration FOR READ
      IMPORTING keys_rba FOR READ zi_hcm_values_dec_pat\_declaration FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zi_hcm_values_dec_pat IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_declaration.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_hcm_vehicles_dec_pat DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE zi_hcm_vehicles_dec_pat.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE zi_hcm_vehicles_dec_pat.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_hcm_vehicles_dec_pat RESULT result.

    METHODS rba_declaration FOR READ
      IMPORTING keys_rba FOR READ zi_hcm_vehicles_dec_pat\_declaration FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_zi_hcm_vehicles_dec_pat IMPLEMENTATION.

  METHOD update.
  ENDMETHOD.

  METHOD delete.
  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_declaration.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_hcm_declaration_pat DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize          REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save              REDEFINITION.

    METHODS cleanup           REDEFINITION.

    METHODS cleanup_finalize  REDEFINITION.

ENDCLASS.

CLASS lsc_zi_hcm_declaration_pat IMPLEMENTATION.

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
