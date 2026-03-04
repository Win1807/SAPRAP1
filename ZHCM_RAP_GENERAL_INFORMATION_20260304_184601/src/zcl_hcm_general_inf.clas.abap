CLASS zcl_hcm_general_inf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
    CLASS-METHODS get_photo_employee
      IMPORTING
        hcm_personnel TYPE persno
      CHANGING
        picture       TYPE hrfio_rawstring
        mimetype      TYPE w3conttype
        filename      TYPE char30.
ENDCLASS.



CLASS zcl_hcm_general_inf IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    DATA lt_original_data TYPE STANDARD TABLE OF zc_hcm_generalinf_employee WITH DEFAULT KEY.
    lt_original_data = CORRESPONDING #( it_original_data ).


*    DATA(lo_hcmfab_employee_api) = NEW cl_hcmfab_employee_api(  ).
    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<original_data>).

      SELECT SINGLE
        FROM ztf_hcm_employeemanager( employeenumber = @<original_data>-personalnumber  )
        FIELDS numbermanager, namemanager, useridmanager, mailmanager
        INTO @DATA(manageremployee).

      SELECT SINGLE
      FROM pa0032
      FIELDS tel01, tel02, gebnr, zimnr
      WHERE pernr = @manageremployee-numbermanager AND
            begda <= @sy-datum AND
            endda >= @sy-datum AND
            sprps = ''
         INTO @DATA(internal_data).


      <original_data>-manageremployeenumber = manageremployee-numbermanager.
      <original_data>-manageremployeename = manageremployee-namemanager.
      <original_data>-managercommunicationlongid = manageremployee-mailmanager.

      <original_data>-managertelephone01 = internal_data-tel01.
      <original_data>-managertelephone02 = internal_data-tel02.
      <original_data>-managerbuildingnumber = internal_data-gebnr.
      <original_data>-managerroomnumber = internal_data-zimnr.


      DATA mimetype TYPE w3conttype .
      zcl_hcm_general_inf=>get_photo_employee( EXPORTING hcm_personnel =   <original_data>-personalnumber
                                           CHANGING picture = <original_data>-attachment
                                           mimetype = <original_data>-mimetype
                                           filename = <original_data>-filename ).

*      DATA(Start_Date_ISO) = |{ <original_data>-StartDate Date = ISO  }|.
*      DATA(End_Date_ISO) = |{ <original_data>-EndDate Date = ISO  }|.
      DATA(lv_btp) = '/3ddcf68c-1b8c-48c0-b1de-fcc549290327.sigabcpcompersonalsearch.sigabcpcompersonalsearch/~b9121314-5733-45e6-b278-993a4915d033~'.
      <original_data>-foto = |/sap/opu/odata/sap/ZUI_GENERAL_INFORMATION_O2/Employee(PersonalNumber='{ <original_data>-personalnumber }')/$value|.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_original_data ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.

  METHOD get_photo_employee.

    DATA: ls_connect               TYPE toav0,
          lv_doc_type              TYPE saedoktyp,
          ls_photo                 TYPE tbl1024,
          lv_line                  TYPE string,
          lv_user_pernr            TYPE pernr_d,
          lv_own_pernr             TYPE pernr_d,
          lt_own_pernrs            TYPE pccet_pernr,
          lv_picture_content       TYPE string,
          lv_hide_employee_picture TYPE boole_d,
          lt_photo_archive_out     TYPE TABLE OF tbl1024.


    CALL FUNCTION 'HR_CHECK_AUTHORITY_PERNR'
      EXPORTING
        tclas                      = cl_hrpa_tclas=>tclas_employee
        pernr                      = hcm_personnel
        begda                      = sy-datum
        endda                      = sy-datum
        uname                      = sy-uname
      EXCEPTIONS
        no_authorization_for_pernr = 1
        OTHERS                     = 2.
    IF sy-subrc = 0.
*   read employee photo
      CALL FUNCTION 'HR_IMAGE_EXISTS'
        EXPORTING
          p_pernr               = hcm_personnel
        IMPORTING
          p_connect_info        = ls_connect
        EXCEPTIONS
          error_connectiontable = 1
          OTHERS                = 2.
      IF sy-subrc = 0.
        DATA lv_binlength TYPE num12.
        DATA lv_length TYPE num12.
*     function module to get the binary mime object of the photo
        CALL FUNCTION 'ARCHIVOBJECT_GET_TABLE'
          EXPORTING
            archiv_id                = ls_connect-archiv_id
            document_type            = lv_doc_type
            archiv_doc_id            = ls_connect-arc_doc_id
          IMPORTING
            binlength                = lv_binlength
            length                   = lv_length
          TABLES
            binarchivobject          = lt_photo_archive_out
          EXCEPTIONS
            error_archiv             = 1
            error_communicationtable = 2
            error_kernel             = 3
            OTHERS                   = 4.
        IF sy-subrc EQ 0.
          LOOP AT lt_photo_archive_out INTO ls_photo.
            lv_line = ls_photo-line.
            lv_picture_content = lv_picture_content && lv_line.
          ENDLOOP.
          picture = lv_picture_content.

*       retrieve the pictures MIME type
          lv_doc_type = ls_connect-reserve.
          cl_alink_services=>get_mimetype_from_doctype(
            EXPORTING
              im_documentclass = lv_doc_type
            IMPORTING
              ex_mimetype      = mimetype
            EXCEPTIONS
              not_found        = 1
              OTHERS           = 2
          ).
          IF sy-subrc <> 0.
            CALL FUNCTION 'SDOK_MIMETYPE_GET'
              EXPORTING
                extension = ls_connect-reserve
              IMPORTING
                mimetype  = mimetype.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.


    filename = |{ hcm_personnel }.{ lv_doc_type }|.

    filename =  escape( val = to_lower( filename ) format = cl_abap_format=>e_url ).

* if for the employee no photo exists retrieve dummy photo from the server
    IF picture IS INITIAL.
      cl_hcmfab_utilities=>get_default_employee_photo(
        EXPORTING
          iv_pernr            = hcm_personnel
        IMPORTING
          ev_photo_bytestring = picture
          ev_mime_type        = mimetype
      ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.
