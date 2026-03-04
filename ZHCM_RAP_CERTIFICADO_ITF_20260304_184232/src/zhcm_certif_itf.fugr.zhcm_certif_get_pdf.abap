FUNCTION zhcm_certif_get_pdf.
*"----------------------------------------------------------------------
*"*"Interfase local
*"  IMPORTING
*"     VALUE(EMPLOYEE_ITF_DATA) TYPE  ZHCMT_CERTIFICATE_ITF OPTIONAL
*"  EXPORTING
*"     REFERENCE(PDF) TYPE  FPFORMOUTPUT
*"----------------------------------------------------------------------
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
        lv_img_firma1    TYPE localfile,
        lv_nombre_firma2 TYPE ze_nombre,
        lv_cargo2        TYPE ze_cargo,
        lv_img_firma2    TYPE localfile,
        lv_logo_bcp      TYPE localfile.
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
          lv_img_firma1 = lwa_firmas-fielname.
        ELSEIF lwa_firmas-zconta = '02'.
          lv_nombre_firma2  = lwa_firmas-zname.
          lv_cargo2 = lwa_firmas-zcargo.
          lv_img_firma2 = lwa_firmas-fielname.
        ENDIF.
      WHEN 'L'.
        lv_logo_bcp = lwa_firmas-fielname.
      WHEN OTHERS.
    ENDCASE.
  ENDLOOP.


*&--------------------------------------------------------------------&
*  CALL PDF
*&--------------------------------------------------------------------&

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
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO data(ld_msg).
  ENDIF.


  lwa_docparams-langu   = lc_langu.
  lwa_docparams-country = lc_country.

  CALL FUNCTION fm_name
    EXPORTING
      /1bcdwb/docparams  = lwa_docparams
      certificate_itf    = employee_itf_data
      nombre_firma1      = lv_nombre_firma1
      cargo1             = lv_cargo1
      img_firma1         = lv_img_firma1
      nombre_firma2      = lv_nombre_firma2
      cargo2             = lv_cargo2
      img_firma2         = lv_img_firma2
      logo_bcp           = lv_logo_bcp
    IMPORTING
      /1bcdwb/formoutput = pdf
    EXCEPTIONS
      usage_error        = 1
      system_error       = 2
      internal_error     = 3.
  IF sy-subrc IS NOT INITIAL.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 INTO data(ld_msg2).
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

ENDFUNCTION.
