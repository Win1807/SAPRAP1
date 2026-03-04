class ZCL_HCM_DECLARATION_PAT definition
  public
  final
  create public .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    TYPES hcm_personal_informations  TYPE STANDARD TABLE OF zc_hcm_personal_information.
    TYPES hcm_personal_relationships TYPE STANDARD TABLE OF zc_hcm_personal_relationship.
    TYPES hcm_pa9301                 TYPE STANDARD TABLE OF pa9301.
    TYPES hcm_pa9303                 TYPE STANDARD TABLE OF pa9303.
    TYPES hcm_pa9304                 TYPE STANDARD TABLE OF pa9304.
    TYPES hcm_pa9305                 TYPE STANDARD TABLE OF pa9305.
    TYPES hcm_pa9306                 TYPE STANDARD TABLE OF pa9306.
    TYPES hcm_pa9307                 TYPE STANDARD TABLE OF pa9307.
    TYPES tymensajes                 TYPE STANDARD TABLE OF zwlog_return WITH DEFAULT KEY.

    METHODS set_declaration_pat_inf9308
      IMPORTING VALUE(employernumber) TYPE pernr_d
                depositos             TYPE hcm_pa9301
                inmuebles             TYPE hcm_pa9303
                vehiculos             TYPE hcm_pa9304
                valores               TYPE hcm_pa9305
                otros_ingresos        TYPE hcm_pa9306
                deudas                TYPE hcm_pa9307
      RETURNING VALUE(mensajes)       TYPE tymensajes.

protected section.
  PRIVATE SECTION.
    TYPES ty_employee_list TYPE STANDARD TABLE OF hrwpc_s_objec.

    DATA c_error    TYPE char1 VALUE 'E' ##NO_TEXT.
    DATA c_sucefull TYPE char1 VALUE 'S' ##NO_TEXT.

    METHODS get_personal_information
      IMPORTING VALUE(username)               TYPE bapiusr01-uname
      EXPORTING VALUE(personal_informations)  TYPE hcm_personal_informations
                VALUE(personal_relationships) TYPE hcm_personal_relationships.
ENDCLASS.



CLASS ZCL_HCM_DECLARATION_PAT IMPLEMENTATION.
  METHOD get_personal_information.
    DATA familys              TYPE STANDARD TABLE OF zit0021_basico.
    DATA dpcab                TYPE STANDARD TABLE OF pa9308.
    DATA depositos            TYPE STANDARD TABLE OF pa9301.
    DATA inmuebles            TYPE STANDARD TABLE OF pa9303.
    DATA vehiculos            TYPE STANDARD TABLE OF pa9304.
    DATA valores              TYPE STANDARD TABLE OF pa9305.
    DATA otros_ingresos       TYPE STANDARD TABLE OF pa9306.
    DATA deudas               TYPE STANDARD TABLE OF pa9307.

    DATA personal_information LIKE LINE OF personal_informations.
    DATA employeenumber       TYPE bapiusr01-employeeno.

    " Obtención del Nro Empleado
    CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
      EXPORTING id             = username
                begindate      = sy-datum
                enddate        = sy-datum
      IMPORTING employeenumber = employeenumber.

    CALL FUNCTION 'Z_BAPI_PA_GET_IT9308_DATA'
      EXPORTING ip_pernr_in      = employeenumber
      IMPORTING ep_appat         = personal_information-employeepatname
                ep_apmat         = personal_information-employeematname
                ep_names         = personal_information-employeename
                ep_icnum         = personal_information-employeedni
                ep_stras         = personal_information-taxadress
                ep_dist          = personal_information-district
                ep_prov          = personal_information-province
                ep_depa          = personal_information-department
                ep_nacdt         = personal_information-birthdate
                ep_stciv         = personal_information-martialstatus
                ep_fono          = personal_information-phone
      TABLES    t_family         = familys
                t_dpcab          = dpcab
                t_depositos      = depositos
                t_inmuebles      = inmuebles
                t_vehiculos      = vehiculos
                t_valores        = valores
                t_otros_ingresos = otros_ingresos
                t_deudas         = deudas.

    INSERT INITIAL LINE INTO TABLE personal_informations ASSIGNING FIELD-SYMBOL(<personal_information>).
    MOVE-CORRESPONDING personal_information TO <personal_information>.
    <personal_information>-employeenumber = employeenumber.
    <personal_information>-username       = username.

    LOOP AT familys INTO DATA(family).
      INSERT INITIAL LINE INTO TABLE personal_relationships ASSIGNING FIELD-SYMBOL(<personal_relationship>).
      <personal_relationship>-employeenumber     = employeenumber.
      <personal_relationship>-username           = username.
      <personal_relationship>-relationship       = family-parent.
      <personal_relationship>-familypaternalname = family-appater.
      <personal_relationship>-familymaternalname = family-apmater.
      <personal_relationship>-familynames        = family-nombre.
      <personal_relationship>-familytypedni      = family-txtid.
      <personal_relationship>-familynumberdni    = family-numid.
    ENDLOOP.
  ENDMETHOD.

  METHOD if_rap_query_provider~select.
    TRY.
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(lt_filter_cond) = io_request->get_parameters( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(filter_object) = io_request->get_filter( )->get_as_ranges( ).

        DATA(page_size) = io_request->get_paging( )->get_page_size( ).
        DATA(offset) = io_request->get_paging( )->get_offset( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(parameters) = io_request->get_parameters( ).

        CASE io_request->get_entity_id( ).

          WHEN 'ZC_HCM_PERSONAL_INFORMATION'.

            TRY.
                IF io_request->is_data_requested( ).
                  io_request->get_paging( ).

                  " Initialize values
                  DATA personal_informations TYPE hcm_personal_informations.
                  DATA personal_information  LIKE LINE OF personal_informations.

                  personal_information-username = sy-uname.

                  get_personal_information( EXPORTING username              = personal_information-username
                                            IMPORTING personal_informations = personal_informations ).

                  DATA i_personal_informations TYPE STANDARD TABLE OF zc_hcm_personal_information.
                  DATA i_personal_information  LIKE LINE OF i_personal_informations.

                  IF page_size > 0.
                    LOOP AT personal_informations ASSIGNING FIELD-SYMBOL(<personal_information>) FROM offset + 1 TO ( offset + page_size ).
                      MOVE-CORRESPONDING <personal_information> TO i_personal_information.
                      INSERT i_personal_information INTO TABLE i_personal_informations.
                    ENDLOOP.
                  ELSE.
                    LOOP AT personal_informations ASSIGNING <personal_information>.
                      MOVE-CORRESPONDING <personal_information> TO i_personal_information.
                      INSERT i_personal_information INTO TABLE i_personal_informations.
                    ENDLOOP.
                  ENDIF.

                  io_response->set_data( i_personal_informations ).

                  IF io_request->is_total_numb_of_rec_requested( ).
                    io_response->set_total_number_of_records( lines( i_personal_informations ) ).
                  ENDIF.
                ENDIF.
              CATCH cx_rfc_dest_provider_error INTO DATA(lx_dest).
                MESSAGE lx_dest->get_text( ) TYPE 'E'.
            ENDTRY.

          WHEN 'ZC_HCM_PERSONAL_RELATIONSHIP'.

            TRY.
                IF io_request->is_data_requested( ).
                  io_request->get_paging( ).

                  " Initialize values
                  DATA personal_relationships TYPE hcm_personal_relationships.
                  DATA personal_relationship  LIKE LINE OF personal_relationships.

                  personal_relationship-username = sy-uname.

                  get_personal_information( EXPORTING username               = personal_relationship-username
                                            IMPORTING personal_relationships = personal_relationships ).

                  DATA i_personal_relationships TYPE STANDARD TABLE OF zc_hcm_personal_relationship.
                  DATA i_personal_relationship  LIKE LINE OF i_personal_relationships.

                  IF page_size > 0.
                    LOOP AT personal_relationships ASSIGNING FIELD-SYMBOL(<personal_relationship>) FROM offset + 1 TO ( offset + page_size ).
                      MOVE-CORRESPONDING <personal_relationship> TO i_personal_relationship.
                      INSERT i_personal_relationship INTO TABLE i_personal_relationships.
                    ENDLOOP.
                  ELSE.
                    LOOP AT personal_relationships ASSIGNING <personal_relationship>.
                      MOVE-CORRESPONDING <personal_relationship> TO i_personal_relationship.
                      INSERT i_personal_relationship INTO TABLE i_personal_relationships.
                    ENDLOOP.
                  ENDIF.

                  io_response->set_data( i_personal_relationships ).

                  IF io_request->is_total_numb_of_rec_requested( ).
                    io_response->set_total_number_of_records( lines( i_personal_relationships ) ).
                  ENDIF.
                ENDIF.
              CATCH cx_rfc_dest_provider_error INTO lx_dest.
                MESSAGE lx_dest->get_text( ) TYPE 'E'.
            ENDTRY.
        ENDCASE.
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_range).
        MESSAGE lx_no_range->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.

  METHOD set_declaration_pat_inf9308.
    DATA ep_text  TYPE t100-text.
    DATA ep_error TYPE bapi_mtype.

    CALL FUNCTION 'Z_HR_BATCH_INF9308' DESTINATION 'NONE'
      EXPORTING ip_pernr  = employernumber
      IMPORTING ep_text   = ep_text
                ep_error  = ep_error
      TABLES    t_pa9301  = depositos
                t_pa9303  = inmuebles
                t_pa9304  = vehiculos
                t_pa9305  = valores
                t_pa9306  = otros_ingresos
                t_pa9307  = deudas
                t_mensaje = mensajes.
    READ TABLE mensajes INTO DATA(mensaje) WITH KEY msgtyp = 'I'.
    IF sy-subrc IS INITIAL.
      REFRESH mensajes.
      INSERT INITIAL LINE INTO TABLE mensajes ASSIGNING FIELD-SYMBOL(<mensaje>).
      MOVE-CORRESPONDING mensaje TO <mensaje>.
*      <mensaje>-msgid = 'ZHCM_RAP_PE'.
*      <mensaje>-msgnr = '009'.
*      MESSAGE e011(zhcm_rap_pe) WITH employernumber INTO <mensaje>-text.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
