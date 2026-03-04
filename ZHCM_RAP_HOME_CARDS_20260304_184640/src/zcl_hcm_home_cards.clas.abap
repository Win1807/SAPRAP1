"! <p class="shorttext synchronized">Clase ZCL_HCM_HOME_CARDS</p>
"! Clase principal que utiliza la app HOME CARDS
CLASS zcl_hcm_home_cards DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_sadl_exit.
    INTERFACES if_sadl_exit_calc_element_read.
    INTERFACES if_rap_query_provider.

    TYPES zi_hcm_contact_details1 TYPE zi_hcm_contact_details_pv.
    TYPES hcm_calendar            TYPE STANDARD TABLE OF zc_hcm_calendar.
    TYPES:
      BEGIN OF BossDetails,
        bossname TYPE emnam,
        bossmail TYPE comm_id_long,
      END OF BossDetails.

    CLASS-DATA gt_testflag TYPE abap_boolean.

  PROTECTED SECTION.
    "! Recupera el número de empleado según el nombre de usuario y fecha
    "! @parameter user_name | Nombre de usuario
    "! @parameter reference_date | Fecha de referencia
    "! @parameter Result | Número de empleado
    METHODS get_employee_number
      IMPORTING user_name      TYPE uname      DEFAULT sy-uname
                reference_date TYPE syst_datum DEFAULT sy-datum
      RETURNING VALUE(result)  TYPE persno.

  PRIVATE SECTION.
    TYPES ty_zc_hcm_calendars TYPE STANDARD TABLE OF zc_hcm_calendar.
    TYPES ty_psp              TYPE STANDARD TABLE OF pdpsp WITH DEFAULT KEY.

    "! Establece el nombre y mail del jefe del empleado
    "! @parameter employeenumber | Número de empleado
    "! @parameter Result         | Detalle de Jefe, Nombre y correo
    METHODS get_boss_employee
      IMPORTING employeenumber TYPE persno
      RETURNING VALUE(result)  TYPE bossdetails.

    "! Obtiene la foto del empleado
    "! @parameter i_pernr | Número de empleado
    "! @parameter Result  | Foto en formato xstring
    METHODS get_photo_employee
      IMPORTING i_pernr       TYPE persno
      RETURNING VALUE(result) TYPE xstring.

    "! Obtiene el horario de trabajo de un empleado
    "! @parameter i_hcm_calendar | Calendario empleado
    "! @parameter Result         | Horario de trabajo
    METHODS get_work_schedule
      IMPORTING i_hcm_calendar TYPE hcm_calendar
      RETURNING VALUE(result)  TYPE ty_psp.

    "! Determina los días de calendarización que caen en feriados
    "! @parameter i_psp            | Planificación de horarios de trabajo
    "! @parameter cc_hcm_calendars | Calendarios modificados con días feriados
    METHODS get_calendar_holidays
      IMPORTING i_psp                   TYPE ty_psp
      CHANGING  VALUE(cc_hcm_calendars) TYPE ty_zc_hcm_calendars.
ENDCLASS.

CLASS ZCL_HCM_HOME_CARDS IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    CONSTANTS photoemployee TYPE string VALUE 'PHOTOEMPLOYEE'.
    CONSTANTS bossname      TYPE string VALUE 'BOSSNAME'.
    CONSTANTS bossmail      TYPE string VALUE 'BOSSMAIL'.

    IF it_requested_calc_elements IS INITIAL.
      EXIT.
    ENDIF.

    DATA hcm_contact_details TYPE STANDARD TABLE OF zi_hcm_contact_details1.
    hcm_contact_details = CORRESPONDING #( it_original_data ).

    ASSIGN hcm_contact_details[ 1 ] TO FIELD-SYMBOL(<fs_contact_det>).
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    DATA(bossdetail) = get_boss_employee( employeenumber = <fs_contact_det>-employeenumber ).

    LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<fs_request_calc>).

      CASE <fs_request_calc>.
        WHEN photoemployee.
          <fs_contact_det>-photoemployee = get_photo_employee( i_pernr = <fs_contact_det>-employeenumber ).
        WHEN bossname.
          <fs_contact_det>-bossname = bossdetail-bossname.
        WHEN bossmail.
          <fs_contact_det>-bossmail = bossdetail-bossmail.
      ENDCASE.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( hcm_contact_details ).
  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    IF iv_entity = 'ZI_HCM_CONTACT_DETAILS_PV'.
      LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<fs_calc_element>).
        CASE <fs_calc_element>.
          WHEN 'PHOTOEMPLOYEE'.
        ENDCASE.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD get_boss_employee.
    DATA e_nombre_jefe TYPE smnam.
    DATA e_correo_jefe TYPE comm_id_long.

    CALL FUNCTION 'Z_HR_WF_LEE_JEFE_JEFE_SUP'
      EXPORTING  i_pernr                = employeenumber
      IMPORTING  e_nombre_jefe          = e_nombre_jefe
                 e_correo_jefe          = e_correo_jefe
      EXCEPTIONS unidad_maxima_superada = 1
                 no_encontrado          = 2
                 unidad_sin_jerarquia   = 3
                 OTHERS                 = 4.

    Result-bossname = e_nombre_jefe.
    Result-bossmail = e_correo_jefe.
  ENDMETHOD.

  METHOD get_photo_employee.
    DATA ls_connect  TYPE toav0.
    DATA lv_length   TYPE i.
    DATA lt_document TYPE TABLE OF tbl1024.
    DATA lv_buffer   TYPE xstring.

    CALL FUNCTION 'HR_IMAGE_EXISTS'
      EXPORTING  p_pernr        = i_pernr
      IMPORTING  p_connect_info = ls_connect
      EXCEPTIONS OTHERS         = 2.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    CALL FUNCTION 'ALINK_RFC_TABLE_GET'
      EXPORTING im_docid    = ls_connect-arc_doc_id
                im_crepid   = ls_connect-archiv_id
      IMPORTING ex_length   = lv_length
      TABLES    ex_document = lt_document.

    IF lv_length IS INITIAL.
      RETURN.
    ENDIF.

    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
      EXPORTING  input_length = lv_length
      IMPORTING  buffer       = lv_buffer
      TABLES     binary_tab   = lt_document
      EXCEPTIONS failed       = 1
                 OTHERS       = 2.

    Result = lv_buffer.
  ENDMETHOD.

  METHOD get_employee_number.
    CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
      EXPORTING id             = user_name
                begindate      = reference_date
                enddate        = reference_date
      IMPORTING employeenumber = Result.
  ENDMETHOD.

  METHOD if_rap_query_provider~select.
    TRY.
        DATA(filter_object) = io_request->get_filter( )->get_as_ranges( ).
        DATA(page_size) = io_request->get_paging( )->get_page_size( ).
        DATA(offset) = io_request->get_paging( )->get_offset( ).

        CASE io_request->get_entity_id( ).

          WHEN 'ZC_HCM_CALENDAR'.

            CONSTANTS type08 TYPE char6 VALUE 'Type08'.
            DATA psps             TYPE STANDARD TABLE OF pdpsp.

            DATA calendars        TYPE hcm_calendar.
            DATA zc_hcm_calendars TYPE STANDARD TABLE OF zc_hcm_calendar.

            TRY.
                IF io_request->is_data_requested( ).

                  REFRESH: zc_hcm_calendars, calendars.

                  INSERT INITIAL LINE INTO TABLE zc_hcm_calendars ASSIGNING FIELD-SYMBOL(<hcm_calendar>).
                  LOOP AT filter_object ASSIGNING FIELD-SYMBOL(<fs_filter>).
                    CASE <fs_filter>-name.
                      WHEN 'INPUTSTARTDATE'.
                        <hcm_calendar>-inputstartdate = <fs_filter>-range[ 1 ]-low.
                      WHEN 'INPUTENDDATE'.
                        <hcm_calendar>-inputenddate = <fs_filter>-range[ 1 ]-low.
                      WHEN 'TYPE'.
                        <hcm_calendar>-type = <fs_filter>-range[ 1 ]-low.
                    ENDCASE.
                  ENDLOOP.

                  psps = get_work_schedule( i_hcm_calendar = zc_hcm_calendars ).

                  SELECT zlow, zhigh FROM zi_hcm_calendar_types
                    INTO TABLE @DATA(hcm_calendar_types).

                  LOOP AT hcm_calendar_types ASSIGNING FIELD-SYMBOL(<hcm_calendar_type>).
                    CASE <hcm_calendar_type>-zlow.
                      WHEN type08.
                        get_calendar_holidays( EXPORTING i_psp            = psps
                                               CHANGING  cc_hcm_calendars = zc_hcm_calendars ).
                    ENDCASE.
                  ENDLOOP.

                  DATA calendar LIKE LINE OF calendars.

                  IF page_size > 0.
                    LOOP AT zc_hcm_calendars ASSIGNING <hcm_calendar> FROM offset + 1 TO ( offset + page_size ).
                      MOVE-CORRESPONDING <hcm_calendar> TO calendar.
                      INSERT calendar INTO TABLE calendars.
                    ENDLOOP.
                  ELSE.
                    LOOP AT zc_hcm_calendars ASSIGNING <hcm_calendar>.
                      MOVE-CORRESPONDING <hcm_calendar> TO calendar.
                      INSERT calendar INTO TABLE calendars.
                    ENDLOOP.
                  ENDIF.

                  io_response->set_data( calendars ).
                  io_response->set_total_number_of_records( lines( calendars ) ).
                ENDIF.
              CATCH cx_rfc_dest_provider_error INTO DATA(lx_dest).
                MESSAGE lx_dest->get_text( ) TYPE 'E'.
            ENDTRY.
        ENDCASE.
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_range).
        MESSAGE lx_no_range->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

  METHOD get_calendar_holidays.
    CONSTANTS feriado TYPE c LENGTH 1 VALUE '1'.

    DATA psp      TYPE STANDARD TABLE OF pdpsp.
    DATA holidays TYPE STANDARD TABLE OF iscal_day.
    DATA modif    TYPE t001p-mofid.

    FIELD-SYMBOLS <hcm_calendar> TYPE zc_hcm_calendar.

    DATA(cc_hcm_calendars_aux) = cc_hcm_calendars.
    REFRESH cc_hcm_calendars.
    ASSIGN cc_hcm_calendars_aux[ 1 ] TO FIELD-SYMBOL(<hcm_calendar_aux>).
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    psp[] = i_psp[].
    SORT psp ASCENDING BY ftkla.
    DELETE psp WHERE ftkla <> feriado.

    LOOP AT psp ASSIGNING FIELD-SYMBOL(<fs_psp>).

      CALL FUNCTION 'Z_HR_RFC_TIME_WORK_SCHEDULE'
        EXPORTING ip_pernr   = <fs_psp>-pernr
                  ip_valdate = <fs_psp>-datum
        IMPORTING ep_mofid   = modif.

      IF modif IS INITIAL.
        CONTINUE.
      ENDIF.

      CALL FUNCTION 'HOLIDAY_GET'
        EXPORTING  holiday_calendar           = modif
                   date_from                  = <fs_psp>-datum
                   date_to                    = <fs_psp>-datum
        TABLES     holidays                   = holidays
        EXCEPTIONS factory_calendar_not_found = 1
                   holiday_calendar_not_found = 2
                   date_has_invalid_format    = 3
                   date_inconsistency         = 4
                   OTHERS                     = 5.

      ASSIGN holidays[ 1 ] TO FIELD-SYMBOL(<holiday>).
      IF sy-subrc IS INITIAL.
        INSERT INITIAL LINE INTO TABLE cc_hcm_calendars ASSIGNING <hcm_calendar>.
        <hcm_calendar>-inputstartdate     = <hcm_calendar_aux>-InputStartDate.
        <hcm_calendar>-InputEndDate       = <hcm_calendar_aux>-InputEndDate.
        <hcm_calendar>-outputstartdate    = <holiday>-date.
        <hcm_calendar>-outpuenddate       = <holiday>-date.
        <hcm_calendar>-type               = 'Type08'.
        <hcm_calendar>-holidaytext        = <holiday>-txt_long.
        <hcm_calendar>-hcmpersonnelnumber = <fs_psp>-pernr.
      ENDIF.
      REFRESH holidays.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_work_schedule.
    DATA pernr_tabs TYPE STANDARD TABLE OF pdpnr.
    DATA day_psps   TYPE STANDARD TABLE OF pdsppsp.

    ASSIGN i_hcm_calendar[ 1 ] TO FIELD-SYMBOL(<fs_calendar>).
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    INSERT INITIAL LINE INTO TABLE pernr_tabs ASSIGNING FIELD-SYMBOL(<pernr_tab>).

    " Método obtener pernr
    <pernr_tab>-pernr = get_employee_number( user_name      = sy-uname
                                             reference_date = sy-datum ).

    CALL FUNCTION 'HR_PERSON_READ_WORK_SCHEDULE'
      EXPORTING  begin_date         = <fs_calendar>-inputstartdate
                 end_date           = <fs_calendar>-inputenddate
      TABLES     pernr_tab          = pernr_tabs
                 psp                = Result
                 day_psp            = day_psps
      EXCEPTIONS error_in_build_psp = 1
                 OTHERS             = 2.
  ENDMETHOD.
ENDCLASS.
