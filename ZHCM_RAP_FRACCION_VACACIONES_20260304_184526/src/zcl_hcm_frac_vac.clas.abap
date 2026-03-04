"! <strong> Clase Principal que ejecuta al APP Fraccionamiento Vacaciones </strong><br>
"!Clase de la App Fraccionamiento de Vacaciones
CLASS zcl_hcm_frac_vac DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .

    TYPES:
      BEGIN OF absenteeism_class_struct,
        value TYPE awart,
        text  TYPE atext,
      END OF absenteeism_class_struct .
    TYPES:
      "! Tipo Para devolver el parametro del metodo  {@link .METH:get_absenteeism_types}
      absenteeism_class_tt   TYPE STANDARD TABLE OF absenteeism_class_struct .
    TYPES vacation_split_struct TYPE zhcms_fractionation_data .
    TYPES hcm_vh_absenteeism TYPE zc_hcm_vh_absenteeism .
    TYPES hcm_notif_view_cab TYPE STANDARD TABLE OF zc_hcm_notif_view_cab .
    TYPES hcm_notif_view_det TYPE STANDARD TABLE OF zc_hcm_notif_view_det .
    TYPES:
      initial_check_politics TYPE STANDARD TABLE OF zc_hcm_initial_check_politics .

    "! Chequea si el usuario puede fraccionar sus vacaciones y si ya ha aprobado antes
    "! los terminos y condiciones.
    "! @parameter user_name      | Nombre del usuario final
    "! @parameter employeenumber | Número de Empleado
    "! @parameter results        | Lista de mensajes generados al evaluar las políticas
    "! del fraccionamiento
    "! @parameter vacationdate   | Fecha de Vacaciones
    "! @parameter flag_message |
    METHODS initial_policy_check
      IMPORTING
        VALUE(user_name)    TYPE sy-uname DEFAULT sy-uname
      EXPORTING
        !employeenumber     TYPE pernr_d
        !results            TYPE bapiret2_t
        !vacationdate       TYPE sy-datum
        VALUE(flag_message) TYPE char1 .
    "! Aprueba o rechaza las politicas del fraccionamiento de vacaciones <br>
    "! Realiza una validación si existen datos de tiempo {@link .METH:Personal_time_recordings}
    "! utilizando el número del personal
    "! @parameter employeenumber | Número de Empleado
    "! @parameter approve_reject | Indicador para aprobar o rechazar ( 1: Aprueba 2: Rechaza )
    "! @parameter result         | Mensaje de error si este ocurriera
    METHODS approve_policy
      IMPORTING
        !employeenumber TYPE pernr_d
        !approve_reject TYPE char01
      RETURNING
        VALUE(result)   TYPE bapiret2 .
*                begda_right_vacation TYPE sydatum
    "! Chequea si el usuario puede fraccionar sus vacaciones
    "! @parameter user_name      | Nombre del usuario final
    "! @parameter vacationdate |
    "! @parameter vacation_split | Información del fraccionamiento de vacaciones
    "! @parameter results        | Lista de mensajes generados al evaluar el
    "! fraccionamiento de vacaciones
    METHODS initial_splitting_check
      IMPORTING
        !user_name          TYPE sy-uname DEFAULT sy-uname
        VALUE(vacationdate) TYPE sy-datum OPTIONAL
      EXPORTING
        !vacation_split     TYPE vacation_split_struct
        !results            TYPE bapiret2_t .
    "! Método para obtener la Lista las clases de absentismo autorizados para el personal
    "! @parameter employeenumber       | Número de Empleado
    "! @parameter begda_right_vacation | Fecha de inicio de derecho a vacaciones
    "! @parameter endda_right_vacation | Fecha fin de derecho a vacaciones
    "! @parameter ABSENTEEISMS_CLASS   | Lista de clases de absentismo
    "! @parameter return               | Retorna un mensaje en caso de excepciones
    METHODS get_absenteeism_types
      IMPORTING
        !employeenumber       TYPE pernr_d
        !begda_right_vacation TYPE begda OPTIONAL
        !endda_right_vacation TYPE endda OPTIONAL
      EXPORTING
        !absenteeisms_class   TYPE absenteeism_class_tt
        !return               TYPE bapiret2 .
    "! Envia la informacion del fraccionamiento de vacaciones
    "! @parameter absenteeism_class   | Clase de absentismo
    "! @parameter begda_vacation      | Fecha de inicio de vacaciones
    "! @parameter endda_vacation      | Fecha fin de vacaciones
    "! @parameter employeenumber      | Número de Empleado
    "! @parameter notice              | Nota para el autorizador
    "! @parameter weekly_working_days | Dias de trabajado por semana
    "! @parameter fractionation_data  | Informacion del fraccionamiento de vacaciones
    "! @parameter result              | Lista de mensajes generados al realizar el envío
    METHODS send_vacation_request
      IMPORTING
        !absenteeism_class    TYPE awart
        !begda_vacation       TYPE begda
        !endda_vacation       TYPE endda
        VALUE(employeenumber) TYPE pernr_d OPTIONAL
        !notice               TYPE string
        !weekly_working_days  TYPE wkwdy
      EXPORTING
        !fractionation_data   TYPE vacation_split_struct
        !result               TYPE bapiret2 .
    METHODS get_notif_view_cab
      IMPORTING
        !employee_number_boss TYPE p_pernr OPTIONAL
      EXPORTING
        !out_notif_view_cab   TYPE hcm_notif_view_cab .
    METHODS get_notif_view_det
      IMPORTING
        !employee_number_boss TYPE p_pernr
        !employee_number      TYPE p_pernr
      EXPORTING
        !out_notif_view_det   TYPE hcm_notif_view_det .
  PRIVATE SECTION.
    DATA ls_constants TYPE REF TO zbc_constants_admin_n.
    DATA error        TYPE char1                        VALUE 'E' ##NO_TEXT.
    DATA information  TYPE char1                        VALUE 'I' ##NO_TEXT.
    DATA sucessfull   TYPE char1                        VALUE 'S' ##NO_TEXT.

    "! Evalua las politicas del fraccionamiento de vacaciones
    "! @parameter organization_unit    | Unidad organizativa del personal
    "! @parameter employeenumber       | Código del personal
    "! @parameter begda_right_vacation | Fecha inicio de derecho a vacaciones
    "! @parameter Validation           | Retorna un codigo de excepción
    METHODS validar_poli
      IMPORTING organization_unit    TYPE orgeh
                employeenumber       TYPE pernr_d
      CHANGING  begda_right_vacation TYPE begda
                !validation          TYPE char01.

    "! Evalua que los datos ingresados para la solicitud de vaciones sean correctas
    "! @parameter absenteeism_class   | Clase de absentismo
    "! @parameter begda_vacation      | Fecha inicio de vacaciones
    "! @parameter endda_vacation      | Fecha fin de vacaciones
    "! @parameter employeenumber      | Codigo del personal
    "! @parameter notice              | Nota para el autorizador
    "! @parameter weekly_working_days | Dias de trabajado por semana
    "! @parameter vacation_split      | Informacion del fraccionamiento de vacaciones
    "! @parameter result              | Lista de mensajes generados al realizar el envío
    METHODS on_revisar
      IMPORTING absenteeism_class   TYPE awart
                begda_vacation      TYPE begda
                endda_vacation      TYPE endda
                employeenumber      TYPE pernr_d
                notice              TYPE string
                weekly_working_days TYPE wkwdy
      EXPORTING vacation_split      TYPE vacation_split_struct
                !result             TYPE bapiret2.

    "! Ejecuta el envio de la solcitud mediante el workflow
    "! @parameter request_id | Id de la solicitud
    "! @parameter employeenumber |
    "! @parameter result     | Lista de mensajes generados al realizar el envío
    METHODS on_enviar
      IMPORTING request_id     TYPE tim_req_id
                employeenumber TYPE pernr_d
      EXPORTING !result        TYPE bapiret2.

    "!
    "! @parameter begda_vacation      | Fecha inicio de vacaciones
    "! @parameter endda_vacation      | Fecha fin de vacaciones
    "! @parameter weekly_working_days | Dias de trabajado por semana
    "! @parameter vacation_split      | Informacion del fraccionamiento de vacaciones
    "! @parameter validation          | Retorna un codigo de excepción
    METHODS validar_frac
      IMPORTING begda_vacation      TYPE begda
                endda_vacation      TYPE endda
                weekly_working_days TYPE wkwdy
      CHANGING  vacation_split      TYPE vacation_split_struct
                !validation         TYPE char01.
ENDCLASS.



CLASS ZCL_HCM_FRAC_VAC IMPLEMENTATION.


  METHOD initial_policy_check.
*      IMPORTING user_name   TYPE sy-uname DEFAULT sy-uname
*      EXPORTING policy_data TYPE lty_policy_data
*                !results    TYPE bapiret2_t.
    " Constantes
    DATA ls_constants TYPE REF TO zbc_constants_admin_n.
    TYPES lty_awart TYPE RANGE OF t554t-awart.
    DATA lr_awart    TYPE lty_awart.
    DATA ls_mensaje  TYPE bapiret2.
    DATA lv_orgeh    TYPE orgeh.
    DATA sociedad    TYPE bukrs.
    DATA lv_frac_flg TYPE c LENGTH 1.
    DATA lv_fec_vac  TYPE sy-datum.
    DATA lv_acept    TYPE c LENGTH 1.

    FIELD-SYMBOLS <resultado> LIKE LINE OF results.

    " Obtener numero de empleado y verficar tiempo de validez del empleado
    CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
      EXPORTING
        id             = user_name
        begindate      = sy-datum
        enddate        = sy-datum
      IMPORTING
        return         = ls_mensaje
        employeenumber = employeenumber.

    IF ls_mensaje-type = error.
      results = VALUE #( ( ls_mensaje ) ).
      RETURN.
    ENDIF.

    TRY.
        ls_constants = NEW zbc_constants_admin_n( pi_repid = 'FRAC_VAC' ).
      CATCH zcx_programa_desconocido.
        INSERT INITIAL LINE INTO TABLE results ASSIGNING FIELD-SYMBOL(<result>).
        <result>-type = error.
        MESSAGE e002(zhcm_rap_pe) WITH 'FRAC_VAC' INTO <result>-message.
        RETURN.
    ENDTRY.

    " Obtener datos del empleado 0001.
    CALL FUNCTION 'Z_HR_RFC_GET_IT0001_DATA'
      EXPORTING
        ip_pernr = employeenumber
      IMPORTING
        bukrs    = sociedad
        orgeh    = lv_orgeh.

    " Tipo de absensismos fraccionamiento
    ls_constants->get_range_n( EXPORTING pi_rangeid = '0000091215'
                                         pi_bukrs   = sociedad
                               CHANGING  pt_range   = lr_awart ).

    IF lr_awart[] IS INITIAL.
      " La sociedad a la que pertenece no tiene habilitado este beneficio.
      results = VALUE #( ( type = error message = TEXT-007  ) ).
      RETURN.
    ENDIF.

    " Validar vacaciones pendientes
    CLEAR lv_frac_flg.
    validar_poli( EXPORTING employeenumber       = employeenumber
                            organization_unit    = lv_orgeh
                  CHANGING  validation           = lv_frac_flg
                            begda_right_vacation = lv_fec_vac ). " Fecha de inicio de rango de absentismos

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA result LIKE LINE OF results.
    CASE lv_frac_flg.
      WHEN '1' OR '2'.
        result-type = error.
        results = VALUE #( type = error
                           ( message = TEXT-018 )
                           ( message = TEXT-019 )
                           ( message = TEXT-020 )
                           ( message = TEXT-021 )
                           ( message = TEXT-022 ) ).
        flag_message = 'X'.
      WHEN '3'.
        result-type = error.
        " La unidad organizativa a la que pertenece no tiene habilitado este beneficio.
        results = VALUE #( ( type = error message = TEXT-008 ) ).

      WHEN '4'.
        result-type = error.
        results = VALUE #( ( type = error message = TEXT-017 ) ).
      WHEN OTHERS.

        SELECT SINGLE gener
          INTO ( lv_acept )
          FROM zthrfrcvac001
          WHERE pernr  = employeenumber
            AND endda >= sy-datum
            AND begda <= sy-datum.

        " no existe registro de aceptación
        IF sy-subrc <> 0.
          SELECT SINGLE gener INTO lv_acept
            FROM zthrfrcvac001
            WHERE pernr  = employeenumber
              AND begda >= sy-datum.
          IF sy-subrc <> 0.
            " no existe valor.
            lv_acept = 'N'.
          ENDIF.

        ENDIF.

        CASE lv_acept.
            " solicitar aprobación de politicas.
          WHEN 'N'.
            SELECT coment, tagfr FROM zthrfrcvac002
              INTO TABLE @DATA(lt_politica)
              WHERE endda >= @sy-datum
                AND begda <= @sy-datum.

            LOOP AT lt_politica INTO DATA(ls_politica).
              CASE ls_politica-tagfr.
                WHEN space OR 'P'.
                  INSERT INITIAL LINE INTO TABLE results ASSIGNING <resultado>.
                  <resultado> = VALUE #( type    = information
                                         message = | <p> { ls_politica-coment } </p>| ).
                WHEN 'PF'.
                  INSERT INITIAL LINE INTO TABLE results ASSIGNING <resultado>.
                  <resultado> = VALUE #( type    = information
                                         message = | <p> <strong> { ls_politica-coment } </strong> </p>| ).

                WHEN 'ZK'.
                  INSERT INITIAL LINE INTO TABLE results ASSIGNING <resultado>.
                  <resultado> = VALUE #( type    = information
                                         message = | <p> <em> { ls_politica-coment } </em> </p> | ).
              ENDCASE.

            ENDLOOP.

          WHEN 'X'. " continuar a la siguiente ventana
            " enviar datos a fraccionamiento
            INSERT INITIAL LINE INTO TABLE results ASSIGNING <resultado>.
            <resultado> = VALUE #( type = sucessfull ).
            lv_fec_vac = sy-datum. " PRUEBA 'S'
            employeenumber = employeenumber.
            vacationdate = lv_fec_vac.

*             VALUE #( EMPLOYEENUMBER              = EMPLOYEENUMBER
*                                       Start_date_right_vacation = lv_fec_vac ).

*                resultados = VALUE #( ( type = Sucessfull message = EMPLOYEENUMBER message_v1 = lv_fec_vac ) ).
          WHEN space. " salir de aplicación

            results = VALUE #( ( type = error message = TEXT-009  ) ).
        ENDCASE.

    ENDCASE.
  ENDMETHOD.


  METHOD validar_poli.
*      IMPORTING organization_unit    TYPE orgeh
*                employeenumber        TYPE pernr_d
*      CHANGING  begda_right_vacation TYPE sy-datum
*                !Validation          TYPE char01.

    TYPES: BEGIN OF lty_pa2006,
             pernr TYPE pa2006-pernr,
             subty TYPE pa2006-subty,
             objps TYPE pa2006-objps,
             sprps TYPE pa2006-sprps,
             endda TYPE pa2006-endda,
             begda TYPE pa2006-begda,
             seqnr TYPE pa2006-seqnr,
             kverb TYPE pa2006-kverb,
           END OF lty_pa2006.

    CONSTANTS c_subty TYPE c LENGTH 2 VALUE '35'.
    CONSTANTS c_1196  TYPE c LENGTH 4 VALUE '1196'.
    CONSTANTS c_1197  TYPE c LENGTH 4 VALUE '1197'.
    CONSTANTS c_1198  TYPE c LENGTH 4 VALUE '1198'.
    CONSTANTS c_1199  TYPE c LENGTH 4 VALUE '1199'.
    " -----------------
    DATA lv_dar01 TYPE c LENGTH 5 VALUE 'DAR01'.
    DATA lv_dat01 TYPE c LENGTH 5 VALUE 'DAT01'.
    DATA lv_index TYPE n LENGTH 2.
    DATA lv_acept TYPE c LENGTH 1.

    FIELD-SYMBOLS <fs_dar01> TYPE pa0041-dar01.
    FIELD-SYMBOLS <fs_dat01> TYPE pa0041-dat01.

    DATA ls_pa0041    TYPE pa0041.

    DATA lv_kverb     TYPE pa2006-kverb.
    DATA lv_fec_vac   TYPE sy-datum.
    DATA lv_fec_per   TYPE sy-datum.

    DATA lv_flag_year TYPE c LENGTH 1.
    DATA lv_year      TYPE n LENGTH 2.

    DATA lt_pa2006    TYPE TABLE OF lty_pa2006.
    DATA lw_pa2006    LIKE LINE OF lt_pa2006.

    DATA rg_endda     TYPE RANGE OF pa2006-endda.
    DATA rw_endda     LIKE LINE OF rg_endda.

    CLEAR Validation.

    SELECT COUNT( * ) FROM zthrfrcvac003
      WHERE orgeh = @organization_unit.
    IF sy-subrc = 0.
      Validation = '3'.
    ENDIF.

    IF Validation <> space.
      RETURN.
    ENDIF.

    rw_endda-sign   = 'I'.
    rw_endda-option = 'BT'.
    rw_endda-low    = |{ sy-datum(4) }0101|.

    rw_endda-high   = |{ sy-datum(4) }1231|.
    APPEND rw_endda TO rg_endda.

    SELECT pernr subty objps sprps endda begda seqnr kverb
      INTO CORRESPONDING FIELDS OF TABLE lt_pa2006
      FROM pa2006
      WHERE pernr  = employeenumber
        AND subty  = c_subty
        AND endda IN rg_endda.

    LOOP AT lt_pa2006 INTO lw_pa2006.
      lv_kverb = lw_pa2006-kverb.
      lv_flag_year = 'X'.
    ENDLOOP.

    IF lv_flag_year = 'X'.
      IF lv_kverb >= 30.
      ELSE.
        Validation = '1'.
      ENDIF.

    ELSE.
      CLEAR lv_flag_year.
      SELECT endda, anzhl, kverb INTO TABLE @DATA(pa2006)
        FROM pa2006
        WHERE pernr = @employeenumber
          AND subty = @c_subty.
      LOOP AT pa2006 ASSIGNING FIELD-SYMBOL(<pa2006>).
        lv_kverb = <pa2006>-kverb.
        lv_flag_year = 'X'.
      ENDLOOP.

      IF lv_flag_year <> 'X'.
        Validation = '4'.
      ENDIF.
    ENDIF.
    IF Validation <> space.
      RETURN.
    ENDIF.
    " validar mes de derecho a vacaciones

    SELECT SINGLE * INTO ls_pa0041
      FROM pa0041
      WHERE pernr  = employeenumber
        AND begda <= sy-datum
        AND endda >= sy-datum.

    IF sy-subrc = 0.
      DO 12 TIMES.
        lv_index = sy-index.    " 01, 02, 03, 04...
        lv_dar01+3(2) = lv_index.    " GWA_0008-LGA01, GWA_0008-LGA02 ...
        lv_dat01+3(2) = lv_index.   " GWA_0008-BET01, GWA_0008-BET02...

        ASSIGN COMPONENT lv_dar01 OF STRUCTURE ls_pa0041 TO <fs_dar01>.
        ASSIGN COMPONENT lv_dat01 OF STRUCTURE ls_pa0041 TO <fs_dat01>.
        CASE <fs_dar01>.
          WHEN '05'. " Fecha derecho a vacaciones
*                  lv_fec_vac = <fs_dat01>.
            lv_year = sy-datum(4) - <fs_dat01>(4).
            CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
              EXPORTING
                date      = <fs_dat01>
                days      = '00'
                months    = '00'
                signum    = '+'
                years     = lv_year
              IMPORTING
                calc_date = lv_fec_vac.
            IF lv_fec_vac < sy-datum.
              CLEAR lv_fec_vac.
              lv_year += 1.
              CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
                EXPORTING
                  date      = <fs_dat01>
                  days      = '00'
                  months    = '00'
                  signum    = '+'
                  years     = lv_year
                IMPORTING
                  calc_date = lv_fec_vac.
            ENDIF.
          WHEN OTHERS.  " Fecha cese
        ENDCASE.
      ENDDO.
      " fechas rango de absentismo.
    ENDIF.
    IF lv_fec_vac IS NOT INITIAL.
      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
        EXPORTING
          date      = lv_fec_vac
          days      = '00'
          months    = '01'
          signum    = '-'
          years     = '00'
        IMPORTING
          calc_date = lv_fec_per.
    ENDIF.
    IF lv_fec_vac >= sy-datum AND lv_fec_per <= sy-datum.
      begda_right_vacation = lv_fec_vac.
    ELSE.
      " ----
      " validar absentismos en base a la fecha
      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
        EXPORTING
          date      = lv_fec_vac
          days      = '00'
          months    = '00'
          signum    = '+'
          years     = '01'
        IMPORTING
          calc_date = lv_fec_per.

      SELECT COUNT( * ) FROM pa2001
        WHERE pernr  = @employeenumber
          AND awart IN ( @c_1196, @c_1197, @c_1198, @c_1199 )
          AND begda >= @lv_fec_vac
          AND endda <= @lv_fec_per.
      IF sy-subrc = 0.
        begda_right_vacation = lv_fec_vac.
      ELSE.
        CLEAR lv_acept.
        SELECT SINGLE gener INTO lv_acept
          FROM zthrfrcvac001
          WHERE pernr  = employeenumber
            AND endda >= sy-datum
            AND begda <= sy-datum. " AND
        IF lv_acept <> 'X'.
          Validation = '2'.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD approve_policy.
*      IMPORTING EmployeeNumber  TYPE pernr_d
*                approve_reject TYPE char01
*      EXPORTING !result        TYPE bapiret2.

    " Aprobar o rechazar las politicas de Fraccionamiento de vacaciones

    DATA ls_frcvac001 TYPE zthrfrcvac001.
    DATA lv_anio      TYPE i.
    DATA lv_xanio     TYPE string.

    CONSTANTS c_2001  TYPE c LENGTH 4 VALUE '2006'.
    CONSTANTS c_subty TYPE c LENGTH 2 VALUE '35'.

    SELECT SINGLE pernr orgeh stell
      INTO ( ls_frcvac001-pernr, ls_frcvac001-orgeh, ls_frcvac001-stell )
      FROM pa0001
      WHERE pernr  = EmployeeNumber
        AND begda <= sy-datum
        AND endda >= sy-datum.

    CLEAR ls_frcvac001-endda.

    SELECT endda, begda, anzhl, kverb
      INTO TABLE @DATA(Personal_time_recordings)
      FROM pa2006
      WHERE pernr = @EmployeeNumber
        AND subty = @c_subty.

    IF sy-subrc <> 0.

      result = VALUE #( type    = error
                        message = TEXT-m08 ).
      RETURN.
    ENDIF.

    LOOP AT Personal_time_recordings ASSIGNING FIELD-SYMBOL(<Personal_time_recording>).
      IF ls_frcvac001-endda IS NOT INITIAL.
        EXIT.
      ENDIF.
      IF NOT (     ( <personal_time_recording>-endda(4) = sy-datum(4) OR <personal_time_recording>-begda(4) = sy-datum(4) )
               AND <personal_time_recording>-kverb >= 30 ).
        CONTINUE.
      ENDIF.

      lv_anio =  <personal_time_recording>-endda+0(4).
      lv_anio += 1.
      lv_xanio = lv_anio.

      lv_xanio = |{ lv_xanio } { <personal_time_recording>-endda+4(2) } { <personal_time_recording>-endda+6(2) }|.

      ls_frcvac001-endda = lv_xanio.

      CLEAR: lv_anio,
             lv_xanio.

      lv_anio =  <personal_time_recording>-begda+0(4).
      lv_anio += 1.
      lv_xanio = lv_anio.
      lv_xanio = |{ lv_xanio } { <personal_time_recording>-begda+4(2) } { <personal_time_recording>-begda+6(2) }|.

      ls_frcvac001-begda = lv_xanio.
      CLEAR: lv_anio,
             lv_xanio.

    ENDLOOP.

    DATA(ls_frcvac001_aux) = ls_frcvac001.
    DATA(pernr) = ls_frcvac001-pernr.
    DATA(orgeh) = ls_frcvac001-orgeh.
    DATA(stell) = ls_frcvac001-stell.
    DATA(begda) = sy-datum.
    DATA(endda) = sy-datum.

    ls_frcvac001 = VALUE #( pernr = ls_frcvac001_aux-pernr
                            orgeh = ls_frcvac001_aux-orgeh
                            stell = ls_frcvac001_aux-stell
                            begda = ls_frcvac001_aux-begda
                            endda = ls_frcvac001_aux-endda
                            subty = c_2001
                            aedtm = sy-datum
                            beguz = sy-uzeit
                            gener = SWITCH #( approve_reject
                                              WHEN '1' THEN abap_true
                                              WHEN '2' THEN abap_false
                                              ELSE          abap_undefined ) ).

    ls_frcvac001-pernr = pernr.
    ls_frcvac001-orgeh = orgeh.
    ls_frcvac001-stell = stell.
    ls_frcvac001-endda = endda.
    ls_frcvac001-begda = begda.

    IF ls_frcvac001-gener = abap_undefined.
      result = VALUE #( type    = error
                        message = TEXT-m09 ).
      RETURN.
    ENDIF.

    MODIFY zthrfrcvac001 FROM ls_frcvac001.

    IF sy-subrc = 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' DESTINATION 'NONE'.
      result-type = sucessfull.

    ENDIF.
  ENDMETHOD.


  METHOD initial_splitting_check.
*      IMPORTING user_name            TYPE sy-uname DEFAULT sy-uname
*                begda_right_vacation TYPE sydatum " Fecha de inicio de derecho a vaciones
*      EXPORTING fractionation_data   TYPE vacation_split_struct
*                !results             TYPE bapiret2_t.
    " typos
    TYPES: BEGIN OF lty_2001,
             awart TYPE pa2001-awart,
             abwtg TYPE pa2001-abwtg,
             stdaz TYPE pa2001-stdaz,
             abrtg TYPE pa2001-abrtg,
           END OF  lty_2001.
    TYPES: BEGIN OF lty_value,
             value TYPE string,
             text  TYPE string,
           END OF lty_value.

    " Constantes
    DATA lv_class_actor    TYPE REF TO ca_pt_req_actor.
    DATA lv_owner          TYPE REF TO if_pt_req_a_wf.

    DATA lv_app_id         TYPE pt_application_id VALUE 'ABSREQ'.
    DATA lv_next_processor TYPE REF TO if_pt_req_a_wf.

    " datos de personal
    DATA lv_pernr          TYPE persno.

    DATA lv_bukrs          TYPE bukrs.
    DATA ls_mensaje        TYPE bapiret2.

    DATA ls_0007           TYPE pa0007.
    DATA lv_fec_vac        TYPE sy-datum.
    DATA lv_fec_vac2       TYPE sy-datum.

    " y verificar tiempo de validez  del empleado
    CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
      EXPORTING
        id             = user_name
*       BEGINDATE      = SY-DATUM
*       ENDDATE        = SY-DATUM
      IMPORTING
        return         = ls_mensaje
        employeenumber = lv_pernr.

    IF ls_mensaje-type = 'E'.
      results = VALUE #( ( ls_mensaje ) ).
      RETURN.
    ENDIF.

    " validar fechas
    lv_fec_vac = vacationdate.
    IF lv_fec_vac IS INITIAL.
      SELECT SINGLE begda INTO lv_fec_vac
        FROM zthrfrcvac001
        WHERE pernr  = lv_pernr
          AND endda >= sy-datum
          AND begda <= sy-datum. " AND

      " no existe registro de aceptación
      IF sy-subrc <> 0.
        SELECT SINGLE begda INTO lv_fec_vac
          FROM zthrfrcvac001
          WHERE pernr  = lv_pernr
            AND begda >= sy-datum. " AND

        IF sy-subrc = 0.
          vacation_split-begda_right_vacation = lv_fec_vac.
        ENDIF.
      ELSE.
        vacation_split-begda_right_vacation = lv_fec_vac.
      ENDIF.
    ENDIF.

    " Obtener datos del empleado 0001.
    CALL FUNCTION 'Z_HR_RFC_GET_IT0001_DATA'
      EXPORTING
        ip_pernr = lv_pernr
      IMPORTING
        bukrs    = lv_bukrs.
*                orgeh    = lv_orgeh.

    SELECT SINGLE * INTO ls_0007
      FROM pa0007
      WHERE pernr  = lv_pernr
        AND endda >= sy-datum
        AND begda <= sy-datum.

    IF lv_fec_vac IS NOT INITIAL.
      " validar absentismos en base a la fecha
      CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
        EXPORTING
          date      = lv_fec_vac
          days      = '00'
          months    = '00'
          signum    = '+'
          years     = '01'
        IMPORTING
          calc_date = lv_fec_vac2.

      vacation_split-endda_right_vacation = lv_fec_vac2.
    ENDIF.

    " buscar el aprobador

    lv_class_actor = ca_pt_req_actor=>agent.

    lv_class_actor->create_actor( EXPORTING  im_actor_type      = 'P'
                                             im_otype           = 'P'
                                             im_objid           = lv_pernr
                                  IMPORTING  ex_actor           = lv_owner
                                  EXCEPTIONS missing_parameter  = 1
                                             pernr_not_existing = 2
                                             application_error  = 3
                                             OTHERS             = 4 ).

    IF sy-subrc <> 0.
      APPEND CORRESPONDING #( sy MAPPING
        id = msgid
        type = msgty
        number = msgno
        message_v1 = msgv1
        message_v2 = msgv2
        message_v3 = msgv3
        message_v4 = msgv4 )
             TO results.
      RETURN.
    ENDIF.

    ca_pt_req_header=>get_manager_next_processor( EXPORTING im_request_type   = lv_app_id
                                                            im_owner          = lv_owner
                                                            im_date           = sy-datum
                                                  IMPORTING ex_next_processor = lv_next_processor ).

    IF lv_next_processor IS NOT INITIAL.
      vacation_split-lead_person_code = lv_next_processor->pernr.
      vacation_split-lead_person_name = lv_next_processor->name.
    ENDIF.

    vacation_split-weekly_working_days = ls_0007-wkwdy.
    vacation_split-personal_code       = lv_pernr.
    vacation_split-company             = lv_bukrs.

    IF vacation_split-lead_person_code IS INITIAL.
      results = VALUE #( ( type       = 'E'
                           message    = TEXT-004
                           message_v1 = 'ICON_SYSTEM_CANCEL' ) ).

    ENDIF.

    results = VALUE #( ( type       = 'S'
                         message    = TEXT-005
                         message_v1 = 'ICON_SYSTEM_CANCEL' ) ).
  ENDMETHOD.


  METHOD on_revisar.
*      IMPORTING absenteeism_class   TYPE awart
*                begda_vacation      TYPE sydatum
*                endda_vacation      TYPE sydatum
*                employeenumber       TYPE pernr_d
*                notice              TYPE string
*                weekly_working_days TYPE wkwdy
*      EXPORTING vacation_split      TYPE vacation_split_struct
*                !result             TYPE bapiret2.

    CONSTANTS c_cmd_create       TYPE ptreq_command VALUE cl_pt_req_const=>c_cmd_create ##NEEDED.
    CONSTANTS c_cmd_check_create TYPE ptreq_command VALUE cl_pt_req_const=>c_cmd_check_create.
    CONSTANTS c_2001             TYPE c LENGTH 4    VALUE '2001'.
    CONSTANTS c_hora             TYPE c LENGTH 5    VALUE 'Horas' ##NEEDED.

    DATA lv_request_id          TYPE tim_req_id.
    DATA lv_modus               TYPE pt_req_mode.
    DATA lv_req                 TYPE ptarq_uia_request.
    DATA lt_ex_comm             TYPE ptarq_uia_command_tab.
    DATA lt_messages            TYPE ptarq_uia_messages_tab.
    DATA ls_messages            TYPE bapiret2.
    DATA lv_checked_request     TYPE ptarq_uia_request.
    DATA lv_deduction           TYPE ptarq_uia_deduct_struc.
    DATA lv_wi_id               TYPE sww_wiid.
    DATA lv_debug               TYPE boolean.
    DATA lv_ex_data_read_only   TYPE ptreq_change_flag ##NEEDED.
    DATA lv_ex_notice_read_only TYPE ptreq_change_flag ##NEEDED.
    DATA lv_ex_notice_visible   TYPE boolean ##NEEDED.
    DATA lv_ex_approv_permitted TYPE ptreq_change_flag ##NEEDED.
    DATA lv_ex_approver_visible TYPE boolean ##NEEDED.
    DATA lv_ex_changed          TYPE boolean ##NEEDED.
    DATA lv_ex_has_errors       TYPE ptreq_has_error_flag ##NEEDED.

    DATA lv_dura                TYPE c LENGTH 60.
    DATA lv_mess_det            TYPE string.

    lv_modus = 'R'.
    lv_request_id = 0.

    CALL FUNCTION 'PT_ARQ_REQUEST_PREPARE' DESTINATION 'NONE'
      EXPORTING
        im_request_id       = lv_request_id
        im_wi_id            = lv_wi_id
        im_command          = c_cmd_create
        im_pernr            = employeenumber
        im_modus            = lv_modus
*       IM_RECURR_COUNT     = 0
      IMPORTING
        ex_request          = lv_req
        ex_data_read_only   = lv_ex_data_read_only
        ex_notice_read_only = lv_ex_notice_read_only
        ex_changed          = lv_ex_changed
        ex_has_errors       = lv_ex_has_errors
      TABLES
        ex_messages         = lt_messages
        ex_commands         = lt_ex_comm.

    lv_req-ins_item-infotype = c_2001.
    lv_req-ins_item-subty    = absenteeism_class.
    lv_req-ins_item-endda    = endda_vacation.
    lv_req-ins_item-begda    = begda_vacation.
    lv_req-curr_notice = notice.

    CALL FUNCTION 'PT_ARQ_REQUEST_CHECK' DESTINATION 'NONE'
      EXPORTING
        im_request    = lv_req
        im_command    = c_cmd_check_create
        im_pernr      = employeenumber
        im_modus      = lv_modus
        im_debug      = lv_debug
      IMPORTING
        ex_has_errors = lv_ex_has_errors
        ex_request    = lv_checked_request
      TABLES
        ex_messages   = lt_messages
        ex_commands   = lt_ex_comm.

    DATA c_newline   TYPE c LENGTH 1 VALUE cl_abap_char_utilities=>newline.
    DATA lv_frac_flg TYPE char01.
    DATA lv_err_flg  TYPE char01.
    sort lt_messages by type ID NUMBER.
    DELETE ADJACENT DUPLICATES FROM lt_messages COMPARING TYPE ID NUMBER.
    LOOP AT lt_messages INTO ls_messages.
      CLEAR lv_frac_flg.

      CASE ls_messages-type.
        WHEN 'E' OR 'A'.

          IF lv_mess_det IS INITIAL.
            lv_mess_det = ls_messages-message.
          ELSE.
            CONCATENATE lv_mess_det c_newline ls_messages-message INTO lv_mess_det.
          ENDIF.

          lv_err_flg = 'E'.

        WHEN 'I' OR 'S'.
          IF lv_mess_det IS INITIAL.
            lv_mess_det = ls_messages-message.
          ELSE.
            CONCATENATE lv_mess_det c_newline ls_messages-message INTO lv_mess_det.
          ENDIF.
          CLEAR: lv_err_flg,
                 lv_mess_det.
          validar_frac( EXPORTING begda_vacation      = begda_vacation
                                  endda_vacation      = endda_vacation
                                  weekly_working_days = weekly_working_days
                        CHANGING  vacation_split      = vacation_split
                                  validation          = lv_frac_flg  ).
        WHEN 'W'.

          IF lv_mess_det IS INITIAL.
            lv_mess_det = ls_messages-message.
          ELSE.
            CONCATENATE lv_mess_det c_newline ls_messages-message INTO lv_mess_det.
          ENDIF.
          CLEAR: lv_err_flg,
                 lv_mess_det.

          validar_frac( EXPORTING begda_vacation      = begda_vacation
                                  endda_vacation      = endda_vacation
                                  weekly_working_days = weekly_working_days
                        CHANGING  vacation_split      = vacation_split
                                  validation          = lv_frac_flg  ).

        WHEN OTHERS.
          CLEAR: lv_err_flg,
                 lv_mess_det.
          validar_frac( EXPORTING begda_vacation      = begda_vacation
                                  endda_vacation      = endda_vacation
                                  weekly_working_days = weekly_working_days
                        CHANGING  vacation_split      = vacation_split
                                  validation          = lv_frac_flg  ).

      ENDCASE.
    ENDLOOP.

    CASE lv_frac_flg.
      WHEN '1'.
        lv_mess_det = TEXT-013.
        CLEAR lv_err_flg.
      WHEN '2'.
        lv_err_flg = 'E'.
        lv_mess_det = TEXT-014.
      WHEN '3'.
        lv_err_flg = 'E'.
        lv_mess_det = TEXT-015.
      WHEN '4'.
        lv_err_flg = 'E'.
        lv_mess_det = TEXT-016.
      WHEN OTHERS.

    ENDCASE.

    IF lv_err_flg IS INITIAL.
      lv_mess_det = TEXT-006.
      lv_err_flg = 'S'.
    ENDIF.

    result = VALUE #( type    = lv_err_flg
                      message = lv_mess_det ).

    READ TABLE lv_checked_request-deduction INTO lv_deduction  INDEX 1.
    IF sy-subrc = 0.
      vacation_split-util = lv_deduction.
    ENDIF.

    lv_dura = lv_checked_request-ins_item-abrst.
    lv_dura = condense( lv_dura ).
    vacation_split-duration   = |{ lv_dura } { c_hora }|.
    vacation_split-request_id = lv_req-request_id.
  ENDMETHOD.


  METHOD on_enviar.
    " TODO: parameter EMPLOYEENUMBER is never used (ABAP cleaner)

*      IMPORTING request_id TYPE tim_req_id
*      EXPORTING !result    TYPE bapiret2.

    CONSTANTS c_cmd_execute_send TYPE ptreq_command VALUE cl_pt_req_const=>c_cmd_execute_send ##NEEDED.
    DATA lv_request_id     TYPE tim_req_id.
    DATA lv_modus          TYPE pt_req_mode.
    DATA lt_messages       TYPE ptarq_uia_messages_tab.
    DATA ls_messages       TYPE bapiret2.
    DATA lv_ex_has_errors  TYPE ptreq_has_error_flag ##NEEDED.
    DATA lv_ex_show_change TYPE boolean ##NEEDED.
    DATA lt_ex_commands    TYPE ptarq_uia_command_tab.

    lv_modus = 'R'.
    lv_request_id = request_id.
    CALL FUNCTION 'PT_ARQ_REQUEST_EXECUTE' DESTINATION 'NONE'
      EXPORTING
        im_request_id  = lv_request_id
        im_command     = c_cmd_execute_send
*       im_pernr       = EMPLOYEENUMBER
        im_modus       = lv_modus
*       im_debug       = im_debug
      IMPORTING
*       ex_request     = lv_exec_req
        ex_has_errors  = lv_ex_has_errors
        ex_show_change = lv_ex_show_change
      TABLES
        ex_messages    = lt_messages
        ex_commands    = lt_ex_commands.

    READ TABLE lt_messages INTO ls_messages INDEX 1.
    IF sy-subrc = 0.

      CASE ls_messages-type.
        WHEN 'E' OR 'A'.
          result-message = ls_messages-message.
          result-type    = 'E'.
        WHEN 'I' OR 'S'.
          result-message = ls_messages-message.
          result-type    = 'S'.
        WHEN 'W'.
          result-message = ls_messages-message.
          result-type    = 'W'.
        WHEN OTHERS.
          result-message = TEXT-003.
          result-type    = 'S'.
      ENDCASE.
    ELSE.

      result-message = TEXT-003.
      result-type    = 'S'.
    ENDIF.
  ENDMETHOD.


  METHOD get_absenteeism_types.
*      IMPORTING employeenumber        TYPE pernr_d
*                begda_right_vacation TYPE sy-datum OPTIONAL
*                endda_right_vacation TYPE sy-datum OPTIONAL
*      exporting  !ABSENTEEISMS_CLASS             TYPE ltt_value
*                 return   type bapiret2 .

    CONSTANTS c_1196 TYPE c LENGTH 4 VALUE '1196'.
    CONSTANTS c_1197 TYPE c LENGTH 4 VALUE '1197'.
    CONSTANTS c_1198 TYPE c LENGTH 4 VALUE '1198'.
    CONSTANTS c_1199 TYPE c LENGTH 4 VALUE '1199'.
    " y verificar tiempo de validez  del empleado
    DATA lr_awart TYPE RANGE OF t554t-awart.

    DATA lv_bukrs TYPE bukrs.

    TRY.
        ls_constants = NEW #( pi_repid = 'FRAC_VAC' ).
      CATCH zcx_programa_desconocido.

        return = VALUE #( type       = 'E'
                          id         = 'ZHCM_RAP_PE'
                          number     = '002'
                          message_v1 = 'FRAC_VAC' ).
        RETURN.
    ENDTRY.

    " Obtener datos del empleado 0001.
    CALL FUNCTION 'Z_HR_RFC_GET_IT0001_DATA'
      EXPORTING
        ip_pernr = employeenumber
      IMPORTING
        bukrs    = lv_bukrs.
*                orgeh    = lv_orgeh.

    DATA ls_0007 TYPE pa0007.

    SELECT SINGLE * INTO ls_0007
      FROM pa0007
      WHERE pernr  = employeenumber
        AND endda >= sy-datum
        AND begda <= sy-datum.
    IF sy-subrc = 0.
      " Tipo de absensismos fraccionamiento

      CASE ls_0007-wkwdy.
        WHEN 5.
          ls_constants->get_range_n( EXPORTING pi_rangeid = '0000091222'
                                               pi_bukrs   = lv_bukrs
                                     CHANGING  pt_range   = lr_awart ).
        WHEN 6.
          ls_constants->get_range_n( EXPORTING pi_rangeid = '0000091223'
                                               pi_bukrs   = lv_bukrs
                                     CHANGING  pt_range   = lr_awart ).

      ENDCASE.
    ELSE.
      ls_constants->get_range_n( EXPORTING pi_rangeid = '0000091222'
                                           pi_bukrs   = lv_bukrs
                                 CHANGING  pt_range   = lr_awart ).

    ENDIF.
    " exportar dias de trabajo

    IF lr_awart[] IS NOT INITIAL.

      SELECT awart AS value,
             atext AS text
        INTO TABLE @absenteeisms_class
        FROM t554t
        WHERE awart IN @lr_awart.

      IF begda_right_vacation IS NOT INITIAL AND endda_right_vacation IS NOT INITIAL.
        " validar absentismos en base a la fecha
        SELECT awart, abwtg, stdaz, abrtg
          INTO TABLE @DATA(lt_2001)
          FROM pa2001
          WHERE pernr  = @employeenumber
            AND awart IN @lr_awart
            AND begda >= @begda_right_vacation
            AND endda <= @endda_right_vacation.

        LOOP AT lt_2001 ASSIGNING FIELD-SYMBOL(<ls_2001>).
          CASE <ls_2001>-awart.
            WHEN c_1196.
              DELETE absenteeisms_class WHERE value <> c_1196.
            WHEN c_1197.
              DELETE absenteeisms_class WHERE value <> c_1197.
            WHEN c_1198.
              " se elimina el 99
              DELETE absenteeisms_class WHERE value <> c_1199.
            WHEN c_1199.
              " se elimina el 98
              DELETE absenteeisms_class WHERE value <> c_1198.
          ENDCASE.
        ENDLOOP.

*        ENDSELECT.

      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD validar_frac.
*      IMPORTING begda_vacation      TYPE sy-datum
*                endda_vacation      TYPE sy-datum
*                weekly_working_days TYPE wkwdy
*      CHANGING  vacation_split      TYPE vacation_split_struct
*                !validation         TYPE char01.

    TYPES: BEGIN OF lty_2001,
             awart TYPE pa2001-awart,
             abwtg TYPE pa2001-abwtg,
             stdaz TYPE pa2001-stdaz,
             abrtg TYPE pa2001-abrtg,
           END OF  lty_2001.

    CONSTANTS c_req_sent        TYPE tim_req_status            VALUE cl_pt_req_const=>c_reqstat_sent.
    CONSTANTS c_req_withdrawn   TYPE tim_req_status            VALUE cl_pt_req_const=>c_reqstat_withdrawn.
    CONSTANTS c_req_posted      TYPE tim_req_status            VALUE cl_pt_req_const=>c_reqstat_posted.
    CONSTANTS c_type_absence    TYPE pt_arq_request_or_att_abs VALUE cl_pt_arq_const=>c_datakind_absence.
    CONSTANTS c_type_attendance TYPE pt_arq_request_or_att_abs VALUE cl_pt_arq_const=>c_datakind_attendance.

    CONSTANTS c_1196            TYPE c LENGTH 4                VALUE '1196'.
    CONSTANTS c_1197            TYPE c LENGTH 4                VALUE '1197'.
    CONSTANTS c_1198            TYPE c LENGTH 4                VALUE '1198'.
    CONSTANTS c_1199            TYPE c LENGTH 4                VALUE '1199'.

    TYPES: BEGIN OF arq_items_strukt,
             request_id          TYPE ptreq_header-request_id,
             status              TYPE tim_req_status,
             item_id             TYPE guid_32,
             operation           TYPE ioper,
             infotype            TYPE infty,
             begin_time          TYPE begti,
             end_time            TYPE endti,
             attabs_hours        TYPE abstd.
             INCLUDE TYPE pakey.
             INCLUDE TYPE ptarq_attabs_timedata_struc.
             INCLUDE TYPE ptarq_extra_info_struc.
             INCLUDE TYPE ptarq_atts_info_struc.
             INCLUDE TYPE ptarq_continued_pay_struc.
             INCLUDE TYPE ptreq_customer_struc.
    TYPES:   subtype_description TYPE sbttx,
           END OF arq_items_strukt.

    TYPES arq_items_tab TYPE TABLE OF arq_items_strukt.
    DATA lv_duration  TYPE f.
    DATA lv_dura_str  TYPE p LENGTH 8 DECIMALS 2.
    DATA lv_indicator TYPE scal-indicator.
    DATA ls_mensaje   TYPE bapiret2.

    DATA lt_list      TYPE ptarq_reqlist_tab_flat.

    DATA status_range TYPE rseloption.
    DATA reqlist      TYPE REF TO cl_pt_arq_reqs_list.
    DATA pernr_tab    TYPE ptim_pernr_tab.
    DATA read_it_data TYPE boolean.

    DATA status       TYPE LINE OF rseloption.
    DATA lv_begda     TYPE sy-datum.
    DATA lv_endda     TYPE sy-datum.
    DATA lv_begda_im  TYPE sy-datum.
    DATA lv_endda_im  TYPE sy-datum.
    DATA lv_pernr     TYPE pa0001-pernr.
    DATA lv_abrtg     TYPE pa2001-abrtg.
    DATA lv_dias_cons TYPE pa2001-abrtg.
    DATA lv_dias_sab  TYPE pa2001-abrtg.
    DATA lv_startime  TYPE sy-uzeit VALUE '000001'.
    DATA lv_endtime   TYPE sy-uzeit VALUE '235959'.

    DATA lt_2001      TYPE TABLE OF lty_2001.
    DATA ls_2001      TYPE lty_2001.

    DATA attabs_alv   TYPE arq_items_tab.

    lv_begda = vacation_split-begda_right_vacation.
    lv_pernr = vacation_split-personal_code.

    IF lv_pernr IS INITIAL.
      CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
        EXPORTING
          id             = sy-uname
        IMPORTING
          return         = ls_mensaje
          employeenumber = lv_pernr.
    ENDIF.
    IF lv_begda IS INITIAL.
      SELECT SINGLE begda INTO lv_begda
        FROM zthrfrcvac001
        WHERE pernr  = lv_pernr
          AND endda >= sy-datum
          AND begda <= sy-datum.

      " no existe registro de aceptación
      IF sy-subrc <> 0.
        SELECT SINGLE begda INTO lv_begda
          FROM zthrfrcvac001
          WHERE pernr  = lv_pernr
*                endda GE sy-datum AND
            AND begda >= sy-datum. " AND
        IF sy-subrc = 0.
          vacation_split-begda_right_vacation = lv_begda.
          vacation_split-personal_code        = lv_pernr.
        ENDIF.
      ELSE.
        vacation_split-begda_right_vacation = lv_begda.
        vacation_split-personal_code        = lv_pernr.
      ENDIF.
    ENDIF.

    " validar absentismos ya aprobados y cantidad de dias.
    CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
      EXPORTING
        date      = lv_begda
        days      = '00'
        months    = '00'
        signum    = '+'
        years     = '01'
      IMPORTING
        calc_date = lv_endda.

    " validar que el contigente no pase del periodo que le corresponde
    lv_begda_im = begda_vacation.
    lv_endda_im = endda_vacation.
    IF lv_begda_im >= lv_begda AND lv_begda_im <= lv_endda.
    ELSE.
      validation = '4'.
    ENDIF.

    IF lv_endda_im >= lv_begda AND lv_endda_im <= lv_endda.
    ELSE.
      validation = '4'.
    ENDIF.

    IF validation <> space.
      RETURN.
    ENDIF.

    APPEND lv_pernr TO pernr_tab.

    SELECT awart abwtg stdaz abrtg INTO TABLE lt_2001
      FROM pa2001
      WHERE pernr  = lv_pernr
        AND awart IN ( c_1196, c_1197, c_1198, c_1199 )
        AND begda >= lv_begda
        AND endda <= lv_endda.

    LOOP AT lt_2001 INTO ls_2001.
      lv_abrtg += ls_2001-abwtg.
    ENDLOOP.

    CALL FUNCTION 'DURATION_DETERMINE'
      EXPORTING
*       UNIT                       =
        factory_calendar           = 'PE'
      IMPORTING
        duration                   = lv_duration
      CHANGING
        start_date                 = lv_begda_im
        start_time                 = lv_startime
        end_date                   = lv_endda_im
        end_time                   = lv_endtime
      EXCEPTIONS
        factory_calendar_not_found = 1
        date_out_of_calendar_range = 2
        date_not_valid             = 3
        unit_conversion_error      = 4
        si_unit_missing            = 5
        parameters_not_valid       = 6
        OTHERS                     = 7.
    IF sy-subrc = 0.

      " validar dias consumidos
      lv_dura_str = lv_duration.

      lv_dias_cons = lv_dura_str.
      lv_dias_cons += lv_abrtg.

      CASE vacation_split-weekly_working_days.
        WHEN 5.
          IF lv_dias_cons > 11.
            validation = '2'.
          ENDIF.
        WHEN 6.
          " validar la cantidad de dias sabados que existen en el rango de fechas para incluirlos como dias laborables
          CLEAR lv_dias_sab.
          WHILE lv_begda_im <= lv_endda_im.
            CLEAR lv_indicator.
            CALL FUNCTION 'DATE_COMPUTE_DAY'
              EXPORTING
                date = lv_begda_im
              IMPORTING
                day  = lv_indicator.
            CASE lv_indicator.
              WHEN '6'.
                lv_dias_sab += 1.
              WHEN OTHERS.
            ENDCASE.
            lv_begda_im += 1.
          ENDWHILE.
          lv_dias_cons += lv_dias_sab.
          IF lv_dias_cons > 13.
            validation = '3'.
          ENDIF.
      ENDCASE.

    ENDIF.
    IF validation <> space.
      RETURN.
    ENDIF.
    " si existe error ya no validar mas
    reqlist = cl_pt_arq_reqs_list=>instance_get( ).

    " required status

    status-sign   = 'I'.
    status-option = 'EQ'.
    status-low    = c_req_sent.
    status-high   = ''.
    APPEND status TO status_range.

    " just a single employee
    reqlist->sel_reqs_attsabs_for_owner( EXPORTING im_status_range    = status_range
                                                   im_pernr_tab       = pernr_tab
                                                   im_selection_begin = lv_begda
                                                   im_selection_end   = lv_endda
                                                   im_read_it_data    = read_it_data
                                         IMPORTING ex_all_my_reqs     = lt_list ).

    IF lt_list IS NOT INITIAL.
      DATA wa_attasbs_data TYPE ptarq_reqlist_struc_flat.
      DATA wa_absences     TYPE ptarq_p2001_struc.
      DATA wa_attendances  TYPE ptarq_p2002_struc.
      DATA wa_alvdata      TYPE arq_items_strukt.
      DATA wa_item_data    TYPE ptreq_items_struc_flat.
      DATA wa_attribs      TYPE name2value.
      DATA field_string    TYPE string.

      FIELD-SYMBOLS <fieldname> TYPE any.

      LOOP AT lt_list INTO wa_attasbs_data.

        IF     wa_attasbs_data-version-status  = c_req_withdrawn
           AND wa_attasbs_data-version-status <> c_req_posted.
          CONTINUE.
        ENDIF.

        wa_alvdata-request_id = wa_attasbs_data-request_id.
        wa_alvdata-status     = wa_attasbs_data-version-status.

        IF wa_attasbs_data-request_or_attabs = c_type_absence.

          READ TABLE wa_attasbs_data-absences INDEX 1
               INTO wa_absences.

          wa_alvdata-item_id      = wa_absences-item_id.
          wa_alvdata-infotype     = wa_absences-p2001-infty.
          wa_alvdata-begin_time   = wa_absences-p2001-beguz.
          wa_alvdata-end_time     = wa_absences-p2001-enduz.
          wa_alvdata-attabs_hours = wa_absences-p2001-stdaz.

          MOVE-CORRESPONDING wa_absences-p2001 TO wa_alvdata.

          APPEND wa_alvdata TO attabs_alv.

        ELSEIF wa_attasbs_data-request_or_attabs = c_type_attendance.

          READ TABLE wa_attasbs_data-attendances INDEX 1
               INTO wa_attendances.
          wa_alvdata-item_id      = wa_attendances-item_id.
          wa_alvdata-infotype     = wa_attendances-p2002-infty.
          wa_alvdata-begin_time   = wa_attendances-p2002-beguz.
          wa_alvdata-end_time     = wa_attendances-p2002-enduz.
          wa_alvdata-attabs_hours = wa_attendances-p2002-stdaz.

          MOVE-CORRESPONDING wa_attendances-p2002 TO wa_alvdata.

          APPEND wa_alvdata TO attabs_alv.

        ELSEIF wa_attasbs_data-request_or_attabs = 'R'.

          CLEAR wa_alvdata.

          wa_alvdata-request_id = wa_attasbs_data-request_id.
          wa_alvdata-status     = wa_attasbs_data-version-status.

          LOOP AT wa_attasbs_data-version-item_tab
               INTO wa_item_data.

            wa_alvdata-item_id = wa_item_data-item_id.

            LOOP AT wa_item_data-attribs_tab
                 INTO wa_attribs.

              CONCATENATE 'wa_alvdata-' wa_attribs-name
                          INTO field_string.

              ASSIGN (field_string) TO <fieldname>.

              <fieldname> = wa_attribs-value.

            ENDLOOP.
            APPEND wa_alvdata TO attabs_alv.
            CLEAR wa_alvdata.
          ENDLOOP.
        ENDIF.

      ENDLOOP.
      DELETE attabs_alv WHERE     subty <> c_1196
                              AND subty <> c_1197
                              AND subty <> c_1198
                              AND subty <> c_1199.
      IF attabs_alv[] IS NOT INITIAL.
        validation = '1'. " Existen solicitudes de fraccionamiento a  futuro
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD send_vacation_request.
*      IMPORTING absenteeism_class   TYPE awart
*                begda_vacation      TYPE sydatum
*                endda_vacation      TYPE sydatum
*                cod_personal        TYPE pernr_d
*                notice              TYPE string
*                weekly_working_days TYPE wkwdy
*      EXPORTING fractionation_data  TYPE vacation_split_struct
*                !result             TYPE bapiret2.

    " Obtener numero de empleado y verficar tiempo de validez del empleado
    CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
      EXPORTING
        id             = sy-uname
        begindate      = sy-datum
        enddate        = sy-datum
      IMPORTING
        return         = result
        employeenumber = employeenumber.

*    IF ls_mensaje-type = error.
*      results = VALUE #( ( ls_mensaje ) ).
*      RETURN.
*    ENDIF.

    on_revisar(
      EXPORTING absenteeism_class   = absenteeism_class
                begda_vacation      = begda_vacation
                endda_vacation      = endda_vacation
                employeenumber      = employeenumber
                notice              = notice
                weekly_working_days = weekly_working_days
      IMPORTING vacation_split      = fractionation_data
                result              = result ).
    IF result-type = 'E'.
      RETURN.
    ENDIF.
    CLEAR result.
    on_enviar(
      EXPORTING request_id = fractionation_data-request_id
                employeenumber       = employeenumber
      IMPORTING result     = result ).
  ENDMETHOD.


  METHOD if_rap_query_provider~select.
*  METHODS select IMPORTING io_request  TYPE REF TO if_rap_query_request
*                           io_response TYPE REF TO if_rap_query_response
*                 RAISING   cx_rap_query_prov_not_impl
*                           cx_rap_query_provider.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " @parameter io_request  | Request information which should be used as input for parameterizing the query implementation
    " @parameter io_response | Response receiver which has to be filled with the result output of the query implementation
    "
    " @raising cx_rap_query_prov_not_impl | Should be raised if the provider lacks the ability to fulfill the request at hand
    "                                       in its current state of implementation.
    " @raising cx_rap_query_provider      | General failure. Must be raised if an error prevents successful query processing.

    TRY.
        TRY.
            " TODO: variable is assigned but never used (ABAP cleaner)
            DATA(lt_filter_cond) = io_request->get_parameters( ).
            DATA(filter_object) = io_request->get_filter( )->get_as_ranges( ).

            DATA(page_size) = io_request->get_paging( )->get_page_size( ).
            DATA(offset) = io_request->get_paging( )->get_offset( ).
            " TODO: variable is assigned but never used (ABAP cleaner)
            DATA(parameters) = io_request->get_parameters( ).

            CASE io_request->get_entity_id( ).

              WHEN 'ZC_HCM_INITIAL_CHECK_POLITICS'.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).

                      " Initialize values
                      DATA employeenumber         TYPE pernr_d.
                      DATA results                TYPE bapiret2_t.
                      DATA vacationdate           TYPE sy-datum.

                      DATA initial_check_politics TYPE STANDARD TABLE OF zc_hcm_initial_check_politics.

                      initial_policy_check( EXPORTING user_name      = sy-uname
                                            IMPORTING employeenumber = employeenumber
                                                      vacationdate   = vacationdate
                                                      results        = results ).

                      LOOP AT results INTO DATA(result).
                        INSERT INITIAL LINE INTO TABLE initial_check_politics ASSIGNING FIELD-SYMBOL(<politics>).
                        <politics>-employeenumber = employeenumber.
                        <politics>-messagetype    = result-type.
                        CASE result-type.
                          WHEN error.
                            <politics>-messagetext = result-message.
                          WHEN information.
                            <politics>-politicsdetails = result-message.
                          WHEN sucessfull.
                            <politics>-vacationdate = vacationdate.
                          WHEN OTHERS.
                        ENDCASE.

                      ENDLOOP.

                      DATA hcm_initial_check_politics TYPE STANDARD TABLE OF zc_hcm_initial_check_politics.

                      IF page_size > 0.
                        LOOP AT initial_check_politics ASSIGNING <politics> FROM offset + 1 TO ( offset + page_size ).
                          INSERT INITIAL LINE INTO TABLE hcm_initial_check_politics ASSIGNING FIELD-SYMBOL(<hcm_politic>).
                          MOVE-CORRESPONDING <politics> TO <hcm_politic>.
                        ENDLOOP.
                      ELSE.
                        LOOP AT initial_check_politics ASSIGNING <politics>.
                          INSERT INITIAL LINE INTO TABLE hcm_initial_check_politics ASSIGNING <hcm_politic>.
                          MOVE-CORRESPONDING <politics> TO <hcm_politic>.
                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( hcm_initial_check_politics ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( hcm_initial_check_politics ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO DATA(lx_dest). " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.
              WHEN 'ZC_HCM_VACATION_FRACTION'.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).

                      DATA vacation_fractions     TYPE STANDARD TABLE OF zc_hcm_vacation_fraction.
                      DATA hcm_vacation_fractions TYPE STANDARD TABLE OF zc_hcm_vacation_fraction.

                      " Initialize values
                      DATA vacationstartdate      TYPE sy-datum.

                      LOOP AT filter_object ASSIGNING FIELD-SYMBOL(<fs_filter>).
                        CASE <fs_filter>-name.
                            " Fecha Inicio
                          WHEN 'VACATIONSTARTDATE'.
                            vacationstartdate = <fs_filter>-range[ 1 ]-low.
                        ENDCASE.
                      ENDLOOP.

                      initial_splitting_check( EXPORTING user_name      = sy-uname
                                                         vacationDate   = VacationStartDate
                                               " TODO: variable is assigned but never used (ABAP cleaner)
                                               IMPORTING results        = DATA(messages)
                                                         vacation_split = DATA(vacation_split) ).

                      INSERT INITIAL LINE INTO TABLE hcm_vacation_fractions ASSIGNING FIELD-SYMBOL(<vacation_fraction>).
                      <vacation_fraction>-authorizername = vacation_split-lead_person_name.
                      <vacation_fraction>-employeenumber = vacation_split-personal_code.

                      IF page_size > 0.
                        LOOP AT vacation_fractions ASSIGNING <vacation_fraction> FROM offset + 1 TO ( offset + page_size ).
                          INSERT INITIAL LINE INTO TABLE hcm_vacation_fractions ASSIGNING FIELD-SYMBOL(<hcm_vacation>).
                          MOVE-CORRESPONDING <vacation_fraction> TO <hcm_vacation>.
                        ENDLOOP.
                      ELSE.
                        LOOP AT vacation_fractions ASSIGNING <vacation_fraction>.
                          INSERT INITIAL LINE INTO TABLE hcm_vacation_fractions ASSIGNING <hcm_vacation>.
                          MOVE-CORRESPONDING <vacation_fraction> TO <hcm_vacation>.
                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( hcm_vacation_fractions ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( hcm_vacation_fractions ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO lx_dest. " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.
              WHEN 'ZC_HCM_VH_ABSENTEEISM'.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).
                      " Initialize values
                      DATA absenteeisms    TYPE STANDARD TABLE OF hcm_vh_absenteeism.
                      DATA vacationenddate TYPE sy-datum.

                      LOOP AT filter_object ASSIGNING <fs_filter>.
                        CASE <fs_filter>-name.
                            " Fecha Inicio
                          WHEN 'VACATIONSTARTDATE'.
                            " Fecha Fin
                            vacationstartdate = <fs_filter>-range[ 1 ]-low.
                          WHEN 'VACATIONENDDATE'.
                            vacationenddate = <fs_filter>-range[ 1 ]-low.
                        ENDCASE.
                      ENDLOOP.

                      CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
                        EXPORTING
                          id             = sy-uname
                          begindate      = sy-datum
                          enddate        = sy-datum
                        IMPORTING
                          employeenumber = employeenumber.
                      "
                      get_absenteeism_types( EXPORTING employeenumber       = employeenumber
                                                       begda_right_vacation = vacationstartdate
                                                       endda_right_vacation = vacationenddate
                                             IMPORTING absenteeisms_class   = DATA(absenteeisms_class) ).

                      LOOP AT absenteeisms_class INTO DATA(absenteeism_class).

                        INSERT INITIAL LINE INTO TABLE absenteeisms ASSIGNING FIELD-SYMBOL(<absenteeism>).
                        <absenteeism>-employeenumber         = employeenumber.
                        <absenteeism>-vacationstartdate      = vacationstartdate.
                        <absenteeism>-vacationenddate        = vacationenddate.
                        <absenteeism>-absenteeismclass       = absenteeism_class-value.
                        <absenteeism>-absenteeismdescription = absenteeism_class-text.
                      ENDLOOP.
                      "
                      DATA hcm_absenteeisms TYPE STANDARD TABLE OF zc_hcm_vh_absenteeism.

                      IF page_size > 0.
                        LOOP AT absenteeisms ASSIGNING <absenteeism> FROM offset + 1 TO ( offset + page_size ).
                          INSERT INITIAL LINE INTO TABLE hcm_absenteeisms ASSIGNING FIELD-SYMBOL(<hcm_absenteeisms>).
                          MOVE-CORRESPONDING <absenteeism> TO <hcm_absenteeisms>.
                        ENDLOOP.
                      ELSE.
                        LOOP AT absenteeisms ASSIGNING <absenteeism>.
                          INSERT INITIAL LINE INTO TABLE hcm_absenteeisms ASSIGNING <hcm_absenteeisms>.
                          MOVE-CORRESPONDING <absenteeism> TO <hcm_absenteeisms>.
                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( hcm_absenteeisms ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( hcm_absenteeisms ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO lx_dest. " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.
              WHEN 'ZC_HCM_NOTIF_VIEW_CAB'.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).
                      " Initialize values
                      DATA notif_view_cabs  TYPE hcm_notif_view_cab.
                      DATA interface_notif_view_cabs  TYPE hcm_notif_view_cab.
                      DATA employee_number_boss TYPE p_pernr.

                      LOOP AT filter_object ASSIGNING <fs_filter>.
                        CASE <fs_filter>-name.
                            " Empleado jefe
                          WHEN 'EMPLOYEENUMBERBOSS'.
                            " Numero de empleado
                            employee_number_boss = <fs_filter>-range[ 1 ]-low.
                        ENDCASE.
                      ENDLOOP.

                      "
                      get_notif_view_cab( EXPORTING employee_number_boss = employee_number_boss
                                          IMPORTING out_notif_view_cab   = notif_view_cabs ).

                      " Fill response
                      DATA interface_notif_view_cab LIKE LINE OF interface_notif_view_cabs.

                      IF page_size > 0.

                        LOOP AT notif_view_cabs INTO DATA(notif_view_cab) FROM offset + 1 TO ( offset + page_size ).

                          MOVE-CORRESPONDING notif_view_cab  TO interface_notif_view_cab.

                          APPEND interface_notif_view_cab TO interface_notif_view_cabs.
                        ENDLOOP.
                      ELSE.
                        LOOP AT notif_view_cabs INTO notif_view_cab.

                          MOVE-CORRESPONDING notif_view_cab  TO interface_notif_view_cab.

                          APPEND interface_notif_view_cab TO interface_notif_view_cabs.

                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( interface_notif_view_cabs ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( notif_view_cabs ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO lx_dest. " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.
              WHEN 'ZC_HCM_NOTIF_VIEW_DET'.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).
                      " Initialize values
                      DATA notif_view_dets  TYPE hcm_notif_view_det.
                      DATA interface_notif_view_dets  TYPE hcm_notif_view_det.
                      DATA employee_number_b TYPE p_pernr.
                      DATA employee_number TYPE p_pernr.

                      LOOP AT filter_object ASSIGNING <fs_filter>.
                        CASE <fs_filter>-name.
                            " Empleado jefe
                          WHEN 'EMPLOYEENUMBERBOSS'.
                            " Numero de empleado
                            employee_number_b = <fs_filter>-range[ 1 ]-low.
                          WHEN 'EMPLOYEENUMBER'.
                            " Numero de empleado
                            employee_number = <fs_filter>-range[ 1 ]-low.
                        ENDCASE.
                      ENDLOOP.

                      "
                      get_notif_view_det( EXPORTING employee_number_boss = employee_number_b
                                                    employee_number      = employee_number
                                          IMPORTING out_notif_view_det   = notif_view_dets ).

                      " Fill response
                      DATA interface_notif_view_det LIKE LINE OF interface_notif_view_dets.

                      IF page_size > 0.

                        LOOP AT notif_view_dets INTO DATA(notif_view_det) FROM offset + 1 TO ( offset + page_size ).

                          MOVE-CORRESPONDING notif_view_det  TO interface_notif_view_det.

                          APPEND interface_notif_view_det TO interface_notif_view_dets.
                        ENDLOOP.
                      ELSE.
                        LOOP AT notif_view_dets INTO notif_view_det.

                          MOVE-CORRESPONDING notif_view_det  TO interface_notif_view_det.

                          APPEND interface_notif_view_det TO interface_notif_view_dets.

                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( interface_notif_view_dets ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( notif_view_dets ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO lx_dest. " TODO: variable is assigned but never used (ABAP cleaner) " TODO: variable is assigned but only used in commented-out code (ABAP cleaner)
                ENDTRY.
            ENDCASE.
          CATCH cx_rap_query_filter_no_range.
        ENDTRY.
      CATCH cx_rap_query_provider.
    ENDTRY.
  ENDMETHOD.


  METHOD get_notif_view_cab.

    DATA: list_notification_cab TYPE ptarq_uia_reqlist_tab.
*    DATA: employee_boss TYPE p_pernr.
*
*    employee_boss = employee_number_boss.
*
*    IF employee_number_boss IS INITIAL.
*
*      CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
*        EXPORTING
*          id             = sy-uname
*          begindate      = sy-datum
*          enddate        = sy-datum
*        IMPORTING
*          employeenumber = employee_boss.
*
*    ENDIF.

    CALL FUNCTION 'PT_ARQ_REQLIST_GET' DESTINATION 'NONE'
      EXPORTING
        im_pernr        = employee_number_boss
        im_modus        = 'A'
*       im_command      = 'SHOW_REQLIST'
        im_command      = 'SHOW_WORKLIST'
        im_time_format  = '2'
      IMPORTING
        ex_request_list = list_notification_cab.

    DATA: line_hcm_not_cab LIKE LINE OF out_notif_view_cab.

    LOOP AT list_notification_cab INTO DATA(line_notification_cab).
      CLEAR: line_hcm_not_cab.

      line_hcm_not_cab-FirstSubmDate       = line_notification_cab-first_subm_date.
      line_hcm_not_cab-Sname               = line_notification_cab-owner-sname.
      line_hcm_not_cab-SubtypeDescription  = line_notification_cab-subtype_description.
      line_hcm_not_cab-Begdate             = line_notification_cab-begda.
      line_hcm_not_cab-Enddate             = line_notification_cab-endda.
      line_hcm_not_cab-Deduction           = line_notification_cab-deduction.
      line_hcm_not_cab-DeductionTooltip    = line_notification_cab-deduction_tooltip.
      line_hcm_not_cab-PastNotice          = line_notification_cab-past_notice.
      line_hcm_not_cab-CurrNotice          = line_notification_cab-curr_notice.
      line_hcm_not_cab-ReqId          = line_notification_cab-request_id.
      line_hcm_not_cab-EmployeeNumber = line_notification_cab-pernr.

      APPEND line_hcm_not_cab TO out_notif_view_cab.

    ENDLOOP.


  ENDMETHOD.


  METHOD get_notif_view_det.

    DATA: list_notification_det TYPE ptarq_uia_quota_status_all_tab.

    CALL FUNCTION 'PT_ARQ_ACCOUNTS_GET' DESTINATION 'NONE'
      EXPORTING
        im_pernr     = employee_number_boss
        im_sel_pernr = employee_number
        im_begda     = sy-datum
        im_endda     = '99991231'
        im_sel_begda = '18000101'
        im_sel_endda = '99991231'
        im_modus     = 'A'
      IMPORTING
        ex_accounts  = list_notification_det.

    DATA: line_hcm_not_det LIKE LINE OF out_notif_view_det.

    LOOP AT list_notification_det INTO DATA(line_notification_det).
      CLEAR: line_hcm_not_det.

      line_hcm_not_det-TimeType             = line_notification_det-time_type.
      line_hcm_not_det-TymeTypeText         = line_notification_det-time_type_text.
      line_hcm_not_det-DeductBegin          = line_notification_det-deduct_begin.
      line_hcm_not_det-DeductEnd            = line_notification_det-deduct_end.
      line_hcm_not_det-BeginDate            = line_notification_det-begin_date.
      line_hcm_not_det-EndDate              = line_notification_det-end_date.
      line_hcm_not_det-Entitle              = line_notification_det-entitle.
      line_hcm_not_det-DeductedReduced      = line_notification_det-deducted_reduced.
      line_hcm_not_det-DeductedReducedFut   = line_notification_det-deducted_reduced_fut.
      line_hcm_not_det-Requested            = line_notification_det-requested.
      line_hcm_not_det-DeductedReducedFutRequested = line_notification_det-deducted_reduced_fut_requested.
      line_hcm_not_det-RestUsed             = line_notification_det-rest_used.
      line_hcm_not_det-RestPosted           = line_notification_det-rest_posted.
      line_hcm_not_det-RestPostedRequested  = line_notification_det-rest_posted_requested.

      APPEND line_hcm_not_det TO out_notif_view_det.

    ENDLOOP.



  ENDMETHOD.
ENDCLASS.
