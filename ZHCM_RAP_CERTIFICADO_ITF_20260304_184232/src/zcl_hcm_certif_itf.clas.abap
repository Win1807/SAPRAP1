class ZCL_HCM_CERTIF_ITF definition
  public
  final
  create public .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    TYPES hcm_data_certif_itf TYPE STANDARD TABLE OF zc_hcm_data_certif_itf WITH DEFAULT KEY.

    METHODS get_pdf
      IMPORTING employee_itf_data TYPE zhcmt_certificate_itf
      EXPORTING pdf               TYPE fpformoutput.

    METHODS get_data
      IMPORTING user_name         TYPE uname DEFAULT sy-uname
                employeeyear      TYPE char4 OPTIONAL
      EXPORTING employeenumber    TYPE pernr_d
                employee_itf_data TYPE zhcmt_certificate_itf
                !return           TYPE bapiret2.

    METHODS get_employee_number
      IMPORTING  user_name              TYPE uname      DEFAULT sy-uname
                 reference_date         TYPE syst_datum DEFAULT sy-datum
      RETURNING  VALUE(employee_number) TYPE persno
      EXCEPTIONS query_error.

    METHODS get_error_messages
      EXPORTING error_message TYPE bapiret2_tab.

  PROTECTED SECTION.

    DATA employee_record TYPE pa0001 .
    DATA error_messages TYPE bapiret2_tab .
private section.

  methods GET_IMAGE_URL
    importing
      !IMAGE_INPUT type TDOBNAME optional
    exporting
      !IMAGE_OUTPUT type XSTRING .
ENDCLASS.



CLASS ZCL_HCM_CERTIF_ITF IMPLEMENTATION.


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
        "PAGINACION
        DATA(page_size) = io_request->get_paging( )->get_page_size( ).
        DATA(offset) = io_request->get_paging( )->get_offset( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(parameters) = io_request->get_parameters( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(search_string) = io_request->get_search_expression( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(skip_rows_number) = io_request->get_paging( )->get_offset( ).
        DATA(sort_order)    = io_request->get_sort_elements( ).

        DATA return TYPE  bapiret2.
        DATA employes_itf           TYPE zhcmt_certificate_itf.
        DATA interface_employes_itf TYPE hcm_data_certif_itf.

***    Se agregan a la estructura donde se guardará toda la información
        DATA: employeenumber TYPE pernr_d,
              employeeyear   TYPE char4.

        CASE io_request->get_entity_id( ).

          WHEN 'ZC_HCM_DATA_CERTIF_ITF'.

            TRY.
                DATA(employes_itf_filter) = io_request->get_filter( )->get_as_ranges( ).
                DATA(filtro) = io_request->get_search_expression( ).
                LOOP AT employes_itf_filter ASSIGNING FIELD-SYMBOL(<fs_filter>).
                  CASE <fs_filter>-name.
                    WHEN 'EMPLOYEEYEAR'.
                      READ TABLE <fs_filter>-range ASSIGNING FIELD-SYMBOL(<fs_range>) INDEX 1.
                      IF sy-subrc IS INITIAL.
                        employeeyear = <fs_range>-low.
                      ENDIF.
                    WHEN OTHERS.
                  ENDCASE.
                ENDLOOP.

                get_data( EXPORTING user_name         = sy-uname
                                    employeeyear      = employeeyear
                        IMPORTING employee_itf_data = employes_itf
                                  return            = return ).

                DATA interface_employee_itf LIKE LINE OF interface_employes_itf.

                IF page_size > 0.
                  LOOP AT employes_itf INTO DATA(employee_itf) FROM offset + 1 TO ( offset + page_size ).
                    MOVE-CORRESPONDING employee_itf TO interface_employee_itf.
                    APPEND interface_employee_itf TO interface_employes_itf.
                  ENDLOOP.
                ELSE.
                  LOOP AT employes_itf INTO employee_itf.
                    MOVE-CORRESPONDING employee_itf TO interface_employee_itf.
                    APPEND interface_employee_itf TO interface_employes_itf.
                  ENDLOOP.
                ENDIF.

                io_response->set_data( interface_employes_itf ).

                IF io_request->is_total_numb_of_rec_requested( ).
                  io_response->set_total_number_of_records( lines( interface_employes_itf ) ).
                ENDIF.
              CATCH cx_rap_query_filter_no_range INTO DATA(lx_rfc).
            ENDTRY.
          WHEN 'ZC_HCM_CERTIF_PDF'.
            "DISPLAYPDFGET

            DATA pdf TYPE fpformoutput.
            DATA certif_pdf TYPE TABLE OF ZC_HCM_CERTIF_PDF.
***    Datos Solicitados
            IF io_request->is_data_requested(  ).

              TRY.
                  employes_itf_filter = io_request->get_filter( )->get_as_ranges( ).
                  filtro = io_request->get_search_expression( ).
                  LOOP AT employes_itf_filter ASSIGNING <fs_filter>.
                    CASE <fs_filter>-name.
                      WHEN 'EMPLOYEEYEAR'.
                        READ TABLE <fs_filter>-range ASSIGNING <fs_range> INDEX 1.
                        IF sy-subrc IS INITIAL.
                          employeeyear = <fs_range>-low.
                        ENDIF.
                      WHEN OTHERS.
                    ENDCASE.
                  ENDLOOP.

                  get_data( EXPORTING user_name         = sy-uname
                                      employeeyear      = employeeyear
                            IMPORTING employee_itf_data = employes_itf
                                      return            = return ).

                  get_pdf( EXPORTING employee_itf_data  = employes_itf
                           IMPORTING pdf                = pdf ).

*                  ELSE.
                  "MENSAJE ERROR
*                  ENDIF.
                  APPEND INITIAL LINE TO certif_pdf ASSIGNING FIELD-SYMBOL(<fs_pdf>).
                  <fs_pdf>-employeenumber = employeenumber.
                  <fs_pdf>-pdf_data = pdf-pdf.

                  io_response->set_total_number_of_records( lines( certif_pdf ) ).
                  io_response->set_data( certif_pdf ).

                CATCH cx_rap_query_filter_no_range INTO lx_rfc.
              ENDTRY.
            ENDIF.
        ENDCASE.
      CATCH cx_rap_query_provider.
*        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ) ##NEEDED.
    ENDTRY.

  ENDMETHOD.


  METHOD get_data.
*   IMPORTING USER_NAME  TYPE uname
*             EMPLOYEE_ITF_DATA Type  ZHCMS_EMPLOYEE_ITF_DATA
*   EXPORTING SUBORDINATE_EMPLOYEES TYPE pa9302.
*             EMPLOYEENUMBER  Type  PERNR
*             YEAR  Type  CHAR4
*             STARTDATE Type  CHAR6
*             ENDDATE Type  CHAR6
*             DOCUMENTTYPE  Type  CHAR2
*             DOCUMENTNUMBER  Type  CHAR30
*             EMPLOYEENAME  Type  CHAR120
*             CURRENCY  Type  CHAR5
*             TOTALIMPORT Type  ZE_TOTRET
*             COMPANYNAME Type  BUTXT
*             COMPANYERUC Type  PAVAL
*             DIRECTION Type  CHAR120
*             TAXRCREDIT  Type  ZE_IMPRA
*             TAXRCHARGES Type  ZE_IMPRC
*             TAXRRESERVALS Type  ZE_IMPED
*             STARDATETEXT  Type  CHAR50
*             ENDDATEXT Type  CHAR50


    DATA ltd_pa9302 TYPE STANDARD TABLE OF pa9302.
    DATA lwa_return TYPE  bapiret2.

    DATA: butxt          TYPE zhcms_employee_itf_data-companyname,
          paval          TYPE zhcms_employee_itf_data-companyeruc,
          ename          TYPE zhcms_employee_itf_data-employeename,
          icnum          TYPE zhcms_employee_itf_data-documentnumber,
          direc          TYPE zhcms_employee_itf_data-direction,
          simbolo_moneda TYPE char5,
          ictyp          TYPE ictyp,
          ictxt          TYPE ictxt.
    DATA: lv_mes_i TYPE fcltx,
          lv_mes_f TYPE fcltx.

*&----------------------------------------------------------------------------&
*&-----------------1.Obtener Número de Personal del usuario ------------------&
*&----------------------------------------------------------------------------&

    me->get_employee_number(
      EXPORTING  user_name       = user_name
                 reference_date  = sy-datum
      RECEIVING  employee_number = employeenumber
      EXCEPTIONS query_error     = 1
                 OTHERS          = 2 ).

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

*&----------------------------------------------------------------------------&
*&----------------------------2.Obtener subordinados&-------------------------&
*&----------------------------------------------------------------------------&

    CALL FUNCTION 'Z_BAPI_PA_GET_IT9302_DATA'
      EXPORTING
        ip_pernr_in = employeenumber
      IMPORTING
        ep_butxt    = butxt
        ep_paval    = paval
        ep_ename    = ename
        ep_icnum    = icnum
        ep_ictyp    = ictyp
        ep_direc    = direc
        ew_return   = return
      TABLES
        t_pa9302    = ltd_pa9302.

    IF return-message IS INITIAL.

      SELECT SINGLE ictxt INTO ictxt
        FROM t5r06
        WHERE molga EQ '99'
        AND ictyp EQ ictyp.

      IF employeeyear IS NOT INITIAL.
        DATA lv_endda TYPE endda.
        CONCATENATE employeeyear '12' '31' INTO lv_endda.

        READ TABLE ltd_pa9302 INTO DATA(lwa_pa9302) WITH KEY endda = lv_endda.
        IF sy-subrc IS INITIAL.
          APPEND INITIAL LINE TO employee_itf_data ASSIGNING FIELD-SYMBOL(<employee_itf>).
          <employee_itf>-employeenumber = employeenumber.
          <employee_itf>-username       = user_name.
          <employee_itf>-companyname    = butxt.
          <employee_itf>-companyeruc    = paval.
          <employee_itf>-employeename   = ename.
          <employee_itf>-documentnumber = icnum.
          <employee_itf>-direction      = direc.
          <employee_itf>-documenttype   = ictxt.
          <employee_itf>-employeeyear   = lwa_pa9302-begda(4).
          <employee_itf>-startdate      = lwa_pa9302-begda.
          <employee_itf>-enddate        = lwa_pa9302-endda.
          <employee_itf>-totalimport    = lwa_pa9302-totret.
          IF lwa_pa9302-moneda EQ 'PEN'.
            <employee_itf>-currency  = 'S/.'.
          ENDIF.
          <employee_itf>-taxrcredit     = lwa_pa9302-imprab.
          <employee_itf>-taxrcharges    = lwa_pa9302-imprcr.
          <employee_itf>-taxrreservals  = lwa_pa9302-impedv.

          SELECT  mnr, ltx FROM t247 INTO TABLE @DATA(ldt_mes)
            WHERE spras EQ 'S' AND
            ( mnr EQ @lwa_pa9302-begda+4(2) OR mnr EQ @lwa_pa9302-endda+4(2) ).

          LOOP AT ldt_mes ASSIGNING FIELD-SYMBOL(<fs_mes>).
            CASE <fs_mes>-mnr.
              WHEN lwa_pa9302-begda+4(2).
                lv_mes_i = <fs_mes>-ltx.
              WHEN lwa_pa9302-endda+4(2).
                lv_mes_f = <fs_mes>-ltx.
              WHEN OTHERS.
            ENDCASE.
          ENDLOOP.

          CONCATENATE lwa_pa9302-begda+6(2) 'de' lv_mes_i 'de' lwa_pa9302-begda(4) INTO <employee_itf>-stardatetext SEPARATED BY space.
          CONCATENATE lwa_pa9302-endda+6(2) 'de' lv_mes_f 'de' lwa_pa9302-endda(4) INTO <employee_itf>-enddatext SEPARATED BY space.
        ENDIF.
      ELSE.

        SELECT spras, mnr, ltx FROM t247 INTO TABLE @DATA(ltd_t247)
          FOR ALL ENTRIES IN @ltd_pa9302
          WHERE mnr   EQ @ltd_pa9302-begda+4(2)
            AND spras EQ 'S'.

        LOOP AT ltd_pa9302 INTO lwa_pa9302.
          APPEND INITIAL LINE TO employee_itf_data ASSIGNING <employee_itf>.
          <employee_itf>-employeenumber = employeenumber.
          <employee_itf>-username       = user_name.
          <employee_itf>-companyname    = butxt.
          <employee_itf>-companyeruc    = paval.
          <employee_itf>-employeename   = ename.
          <employee_itf>-documentnumber = icnum.
          <employee_itf>-direction      = direc.
          <employee_itf>-documenttype   = ictxt.
          <employee_itf>-employeeyear   = lwa_pa9302-begda(4).
          <employee_itf>-startdate      = lwa_pa9302-begda.
          <employee_itf>-enddate        = lwa_pa9302-endda.
          <employee_itf>-totalimport    = lwa_pa9302-totret.
          IF lwa_pa9302-moneda EQ 'PEN'.
            <employee_itf>-currency  = 'S/.'.
          ENDIF.
          <employee_itf>-taxrcredit     = lwa_pa9302-imprab.
          <employee_itf>-taxrcharges    = lwa_pa9302-imprcr.
          <employee_itf>-taxrreservals  = lwa_pa9302-impedv.

          LOOP AT ldt_mes ASSIGNING <fs_mes>.
            CASE <fs_mes>-mnr.
              WHEN lwa_pa9302-begda+4(2).
                lv_mes_i = <fs_mes>-ltx.
              WHEN lwa_pa9302-endda+4(2).
                lv_mes_f = <fs_mes>-ltx.
              WHEN OTHERS.
            ENDCASE.
          ENDLOOP.
          CONCATENATE lwa_pa9302-begda+6(2) 'de' lv_mes_i 'de' lwa_pa9302-begda(4) INTO <employee_itf>-stardatetext.
          CONCATENATE lwa_pa9302-endda+6(2) 'de' lv_mes_f 'de' lwa_pa9302-endda(4) INTO <employee_itf>-enddatext.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_pdf.

*   EMPLOYEE_ITF_DATA  Type  ZCHMS_EMPLOYEE_ITF_DATA
*   EMPLOYEENUMBER  Type  PERNR
*   YEAR  Type  CHAR4
*   FILE Type  XSTRING
*&--------------------------------------------------------------------&
*  Declarations
*&--------------------------------------------------------------------&

    CONSTANTS: lc_certif_itf TYPE fpname VALUE 'ZAFF_CERTIFICADO_ITF',
               lc_langu      TYPE spras VALUE 'S',
               lc_country    TYPE land1 VALUE 'PE',
               formu         TYPE  tdform VALUE 'CERT_ITF'.

    DATA ltd_firmas TYPE STANDARD TABLE OF  ztlog_firmas.

    DATA: lwa_outputparams TYPE sfpoutputparams,
          lwa_docparams    TYPE sfpdocparams,
          lwa_formoutput   TYPE fpformoutput.

    DATA: fm_name TYPE rs38l_fnam.

    DATA: lv_nombre_firma1 TYPE ze_nombre,
          lv_cargo1        TYPE ze_cargo,
          lv_nombre_firma2 TYPE ze_nombre,
          lv_cargo2        TYPE ze_cargo,
          image_input      TYPE tdobname,
          firma1           TYPE xstring,
          firma2           TYPE xstring,
          logo_bcp         TYPE xstring.
*&----------------------------------------------------------------------------&
*&-----------------1.Obtener Número de Personal del usuario ------------------&
*&----------------------------------------------------------------------------&

    CALL FUNCTION 'Z_HR_RFC_GET_LOG_FIRM'
      EXPORTING
        ip_formu = formu
      TABLES
        t_data   = ltd_firmas.


    LOOP AT ltd_firmas INTO DATA(lwa_firmas) WHERE zformu EQ 'CERT_ITF'.
      CASE lwa_firmas-ztipo.
        WHEN 'F'.
          IF lwa_firmas-zconta = '01'.
            lv_nombre_firma1  = lwa_firmas-zname.
            lv_cargo1 = lwa_firmas-zcargo.
            image_input = lwa_firmas-fielname.
            get_image_url( EXPORTING image_input = image_input
                           IMPORTING image_output = firma1 ).

          ELSEIF lwa_firmas-zconta = '02'.
            lv_nombre_firma2  = lwa_firmas-zname.
            lv_cargo2 = lwa_firmas-zcargo.

            get_image_url( EXPORTING image_input = image_input
                           IMPORTING image_output = firma2 ).

          ENDIF.
        WHEN 'L'.
          image_input = lwa_firmas-fielname.

          get_image_url( EXPORTING image_input = image_input
                          IMPORTING image_output = logo_bcp ).

        WHEN OTHERS.
      ENDCASE.
    ENDLOOP.

**&--------------------------------------------------------------------&
**  CALL PDF
**&--------------------------------------------------------------------&

*  Llamar para generear el modulo de funciones
    " Se obtiene el nomre del formulario
    CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
      EXPORTING
        i_name     = lc_certif_itf
      IMPORTING
        e_funcname = fm_name.
    IF sy-subrc <> 0.
      "<error handling>
    ENDIF.

    " Sets the output parameters and opens the spool job
    lwa_outputparams-nopreview = abap_true.
    lwa_outputparams-noprint  = abap_true.
    lwa_outputparams-nodialog  = abap_true.
    lwa_outputparams-getpdf  = abap_true.

    CALL FUNCTION 'FP_JOB_OPEN'
      CHANGING
        ie_outputparams = lwa_outputparams
      EXCEPTIONS
        cancel          = 1
        usage_error     = 2
        system_error    = 3
        internal_error  = 4
        OTHERS          = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(ld_msg).
    ENDIF.

    lwa_docparams-langu   = lc_langu.
    lwa_docparams-country = lc_country.

    CALL FUNCTION fm_name
      EXPORTING
        /1bcdwb/docparams  = lwa_docparams
        certificate_itf    = employee_itf_data
        nombre_firma1      = lv_nombre_firma1
        cargo1             = lv_cargo1
        img_firma1         = firma1
        nombre_firma2      = lv_nombre_firma2
        cargo2             = lv_cargo2
        img_firma2         = firma2
        logo_bcp           = logo_bcp
      IMPORTING
        /1bcdwb/formoutput = pdf
      EXCEPTIONS
        usage_error        = 1
        system_error       = 2
        internal_error     = 3.
    IF sy-subrc IS NOT INITIAL.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO DATA(ld_msg2).
    ENDIF.
    " Close the spool job
    CALL FUNCTION 'FP_JOB_CLOSE'
      EXCEPTIONS
        usage_error    = 1
        system_error   = 2
        internal_error = 3
        OTHERS         = 4.
    IF sy-subrc <> 0.
      " <error handling>
    ENDIF.

  ENDMETHOD.


  METHOD get_employee_number.
*      IMPORTING  reference_date         TYPE syst_datum DEFAULT sy-datum
*                 user_name              TYPE uname      DEFAULT sy-uname
*      RETURNING  VALUE(employee_number) TYPE persno
*      EXCEPTIONS error_code .

    CLEAR me->error_messages.
    DATA return_struct TYPE bapiret2.

    CALL FUNCTION 'BAPI_USR01DOHR_GETEMPLOYEE'
      EXPORTING
        id             = !user_name
        begindate      = !reference_date
        enddate        = !reference_date
      IMPORTING
        return         = return_struct
        employeenumber = !employee_number.

    IF return_struct IS NOT INITIAL.
      APPEND return_struct TO me->error_messages.
      RAISE query_error.
    ENDIF.
  ENDMETHOD.


  METHOD get_error_messages.
    error_message = me->error_messages.
  ENDMETHOD.


  METHOD get_image_url.

    CONSTANTS: object TYPE tdobjectgr VALUE 'GRAPHICS',
               id     TYPE TDIDGR VALUE 'BMAP',
               btype  TYPE TDBTYPE VALUE 'BMON'.

    CALL METHOD cl_ssf_xsf_utilities=>get_bds_graphic_as_bmp
      EXPORTING
        p_object       = object
        p_name         = image_input
        p_id           = id
        p_btype        = btype
      RECEIVING
        p_bmp          = image_output
      EXCEPTIONS
        not_found      = 1
        internal_error = 2
        OTHERS         = 3.



*    DATA: lv_url TYPE char255.
*    DATA: lv_content  TYPE xstring.
*    DATA: lv_repid TYPE sy-repid.
*
*    DATA: lt_data TYPE STANDARD TABLE OF x255.
*
*    DATA: lo_docking TYPE REF TO cl_gui_docking_container.
*    DATA: lo_picture TYPE REF TO cl_gui_picture.
*
*    DATA: p_path TYPE string VALUE '/usr/sap/S4D/D00/igs/data/gfwchart/22000.bmp'.
*
** Create controls
*    CREATE OBJECT lo_docking
*      EXPORTING
*        repid     = lv_repid
*        dynnr     = sy-dynnr
*        side      = lo_docking->dock_at_left
*        extension = 200.
*
*    CREATE OBJECT lo_picture
*      EXPORTING
*        parent = lo_docking.
*
** Read it from application server
*    OPEN DATASET p_path FOR INPUT IN BINARY MODE.
*    READ DATASET p_path INTO lv_content .
*    CLOSE DATASET p_path.
*
** Convert
*    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
*      EXPORTING
*        buffer     = lv_content
*      TABLES
*        binary_tab = lt_data.
*
** CReate URL
*    CALL FUNCTION 'DP_CREATE_URL'
*      EXPORTING
*        type    = 'IMAGE'
*        subtype = 'JPG'
*      TABLES
*        data    = lt_data
*      CHANGING
*        url     = lv_url.
*
** Load picture from URL
*    lo_picture->load_picture_from_url_async( lv_url ).
*    url = lv_url.
  ENDMETHOD.
ENDCLASS.
