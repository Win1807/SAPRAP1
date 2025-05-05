CLASS zcl_hcm_manager DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit_calc_element_read.


    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_employee_manager FOR TABLE FUNCTION ztf_hcm_employeemanager.
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



CLASS zcl_hcm_manager IMPLEMENTATION.
  METHOD get_employee_manager BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING hrp1001 pa0001 pa0105.

    declare lv_numbermanager "$ABAP.type( pernr_d )";
    declare lv_possitionmanager "$ABAP.type( sobid )";
    declare lv_nivelsup "$ABAP.type( sobid )";
    declare lv_userid "$ABAP.type( syuname )";
    declare lv_name_manager "$ABAP.type( smnam )";
    declare lv_email_manager "$ABAP.type( comm_id_long )";
    declare lv_sysubrc varchar( 1 ) default '0' ;
    declare lv_correo varchar( 1 ) default '' ;
    declare lv_caso2 varchar( 1 ) default '' ;

    lt_manager_position =   select p1.mandt, p1.orgeh, p1.pernr, hp.sobid

                                    from hrp1001 as hp
                                    inner join pa0001 as p1
                                    on hp.objid = p1.orgeh
                                    where p1.pernr = employeenumber
                                    AND hp.otype = 'O'
                                    AND hp.plvar = '01'
                                    AND hp.rsign = 'B'
                                    AND hp.relat = '012'
                                    AND hp.endda = '99991231'
                                    and p1.mandt = client;
           lv_possitionmanager = :lt_manager_position.sobid[ 1 ]  ;
          lt_managers = SELECT mandt, sobid
             FROM hrp1001
            WHERE otype = 'S'
            AND objid = :lv_possitionmanager
            AND rsign = 'A'
            AND relat = '008'
            AND istat = '1'
            AND endda >= current_date
            AND begda <= current_date
            and mandt = client;

            lv_numbermanager = :lt_managers.sobid[ 1 ];

            IF :lv_numbermanager = employeenumber AND lv_numbermanager != ''
            then lv_sysubrc = 1 ;
            ELSE lv_sysubrc = 0;
            END if;

        IF :lv_sysubrc = '0'  then lv_correo = 'X' ;
        ELSE lv_caso2 = 'X';
        END if;

   IF lv_caso2 = 'X' THEN
  lt_org_unit =   SELECT p1.mandt, p1.orgeh, p1.pernr
                        from hrp1001 as hp
                        inner join pa0001 as p1
                        on hp.objid = p1.orgeh
                        where p1.pernr = employeenumber and
                        p1.mandt = client;
                        lv_possitionmanager = :lt_org_unit.orgeh[ 1 ]  ;

    IF lv_possitionmanager != '' then
     lt_manager_manager = SELECT mandt, sobid
                         FROM hrp1001
                          WHERE otype = 'O'
                          AND objid = lv_possitionmanager
                          AND rsign = 'A'
                          AND relat = '002'
                          AND istat = '1'
                          AND endda >= current_date
                          AND begda <= current_date
                          and mandt = client;
            lv_nivelsup = :lt_manager_manager.sobid[ 1 ];
            IF  lv_nivelsup = '' then
            lv_numbermanager = lv_nivelsup;
            ELSE
               lt_jefe_nivelsup = SELECT mandt, sobid
                       FROM hrp1001
                      WHERE otype = 'O'
                      AND objid = lv_nivelsup
                      AND rsign = 'B'
                      AND relat = '012'
                      AND istat = '1'
                      AND endda >= current_date
                      AND begda <= current_date
                      and mandt = client;

                   lv_numbermanager = :lt_jefe_nivelsup.sobid[ 1 ];
                    IF :lv_numbermanager != '' then
                    lv_nivelsup = :lv_numbermanager;
                      lt_pos_jefe =  SELECT mandt,  sobid
                           FROM hrp1001
                          WHERE otype = 'S'
                          AND objid = lv_nivelsup
                          AND rsign = 'A'
                          AND relat = '008'
                          AND istat = '1'
                          AND endda >= current_date
                          AND begda <= current_date
                          and mandt = client;
                        lv_numbermanager = :lt_pos_jefe.sobid[ 1 ];

                          IF :lv_numbermanager !='' then lv_correo = 'X';
                          END if;
                    END if;
            END if;
    END if;
    END if;

IF :lv_correo = 'X' THEN
    lt_users_id =  SELECT mandt,  usrid
      FROM pa0105
     WHERE subty = '0001'
     AND endda >= current_date
     AND begda <= current_date
     AND pernr = lv_numbermanager
     and mandt = client;
     lv_userid = :lt_users_id.usrid[ 1 ];
 END if;

IF lv_numbermanager != '' then
    lt_personal_data = SELECT p1.mandt, p5.pernr, p1.sname, p1.ename, p5.usrid_long
       from pa0001 as p1
       inner join pa0105 as p5
       on p1.pernr = p5.pernr
          and p1.mandt = p5.mandt
       and p5.subty = '0010'
       and p5.endda = '99991231'
       where p1.pernr = lv_numbermanager
       and p1.mandt = client;
      lv_name_manager = :lt_personal_data.sname[ 1 ];
      lv_email_manager = :lt_personal_data.usrid_long[ 1 ];
END if;

      RETURN select :client as mandt, :lv_numbermanager as numbermanager, :lv_name_manager as namemanager, :lv_email_manager as mailmanager, :lv_userid as useridmanager
      from dummy;
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~calculate.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(lv_today) = cl_abap_context_info=>get_system_date( ).

    DATA lt_original_data TYPE STANDARD TABLE OF zc_hcm_personal WITH DEFAULT KEY.
    lt_original_data = CORRESPONDING #( it_original_data ).
    DATA(lo_hcm_home_cards) = NEW zcl_hcm_home_cards(  ).
    SELECT
      FROM pa0001 AS a
             INNER JOIN
               @lt_original_data AS b ON  a~pernr = b~hcmpersonnelnumber
                                      AND a~plans = b~hcmposition
      FIELDS pernr, endda, begda, plans
      ORDER BY pernr DESCENDING,
               endda DESCENDING
      INTO TABLE @DATA(posisions).
    DATA days         TYPE p LENGTH 8 DECIMALS 0.
    DATA months       TYPE p LENGTH 8 DECIMALS 0.
    DATA years        TYPE p LENGTH 8 DECIMALS 0.
    DATA days_total   TYPE p LENGTH 8 DECIMALS 0.
    DATA months_total TYPE p LENGTH 8 DECIMALS 0.
    DATA years_total  TYPE p LENGTH 8 DECIMALS 0.
    DATA result       TYPE p LENGTH 8 DECIMALS 0.
    DATA end_date     TYPE dats.
*    DATA(lo_hcmfab_employee_api) = NEW cl_hcmfab_employee_api(  ).
    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<original_data>).

      SELECT SINGLE
        FROM ztf_hcm_employeemanager( employeenumber = @<original_data>-hcmpersonnelnumber  )
        FIELDS numbermanager, namemanager, useridmanager, mailmanager
        INTO @DATA(manageremployee).
      <original_data>-hcmemployeemanagernumber = manageremployee-numbermanager.
      <original_data>-hcmemployeemanagername   = manageremployee-namemanager.
      DATA mimetype TYPE w3conttype .
      zcl_hcm_manager=>get_photo_employee( EXPORTING hcm_personnel =   <original_data>-hcmpersonnelnumber
                                           CHANGING picture = <original_data>-Attachment mimetype = <original_data>-mimetype
                                           filename = <original_data>-filename ).
      DATA(Start_Date_ISO) = |{ <original_data>-StartDate Date = ISO  }|.
      DATA(End_Date_ISO) = |{ <original_data>-EndDate Date = ISO  }|.

data(lv_btp) = '/3ddcf68c-1b8c-48c0-b1de-fcc549290327.sigabcpcompersonalsearch.sigabcpcompersonalsearch/~b9121314-5733-45e6-b278-993a4915d033~'.
<original_data>-Foto = |/sap/opu/odata/sap/ZUI_PERSONAL_SEARCH_O2/Employee(HCMPersonnelNumber='{ <original_data>-hcmpersonnelnumber }',EndDate=datetime'{ End_Date_ISO }T00:00:00',StartDate=datetime'{ Start_Date_ISO }T00:00:00')/$value|.

      LOOP AT posisions ASSIGNING FIELD-SYMBOL(<position>) WHERE     pernr = <original_data>-hcmpersonnelnumber
                                                                 AND plans = <original_data>-hcmposition.
        AT FIRST.
          end_date = cl_abap_context_info=>get_system_date( ).
        ENDAT.
        IF end_date IS INITIAL.
          end_date = <position>-endda.
        ENDIF.
        CALL FUNCTION 'HR_GET_TIME_BETWEEN_DATES'
          EXPORTING
            beg_date = <position>-begda
            end_date = end_date
          IMPORTING
            days     = days
            months   = months
            years    = years.

        days_total += days.
        months_total += months.
        years_total += years.
        CLEAR: days,
               months,
               years,
               end_date.
      ENDLOOP.
      IF days_total >= 30.
        result = days_total DIV 30. " Get months in days
        months_total += result.
      ENDIF.

      IF months_total >= 12.
        result = months_total DIV 12. " Get years in months
        years_total += result.
        months_total = months_total MOD 12.
      ENDIF.

      <original_data>-hcmdurationposition = |{ years_total } / { months_total }|.
      CLEAR: days_total,
             months_total,
             years_total.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_original_data ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

  ENDMETHOD.


  METHOD get_photo_employee.
*    DATA:
*      ls_connect  TYPE toav0,
*      lv_length   TYPE i,
*      lt_document TYPE TABLE OF tbl1024,
*      lv_buffer   TYPE xstring,
*      lv_b64data  TYPE string.
*
*    CALL FUNCTION 'HR_IMAGE_EXISTS'
*      EXPORTING
*        p_pernr        =  hcm_personnel
*      IMPORTING
*        p_connect_info = ls_connect
*      EXCEPTIONS
*        OTHERS         = 2.
*    IF sy-subrc EQ 0.
*
*      CALL FUNCTION 'ALINK_RFC_TABLE_GET'
*        EXPORTING
*          im_docid    = ls_connect-arc_doc_id
*          im_crepid   = ls_connect-archiv_id
*        IMPORTING
*          ex_length   = lv_length
*        TABLES
*          ex_document = lt_document.
*
**      CHECK lv_length IS NOT INITIAL.
*
*      CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
*        EXPORTING
*          input_length = lv_length
*        IMPORTING
*          buffer       = lv_buffer
*        TABLES
*          binary_tab   = lt_document
*        EXCEPTIONS
*          failed       = 1
*          OTHERS       = 2.
*   endif.


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
      data lv_binlength type num12.
      data lv_length type num12.
*     function module to get the binary mime object of the photo
        CALL FUNCTION 'ARCHIVOBJECT_GET_TABLE'
          EXPORTING
            archiv_id                = ls_connect-archiv_id
            document_type            = lv_doc_type
            archiv_doc_id            = ls_connect-arc_doc_id
            IMPORTING
            binlength = lv_binlength
            length = lv_length
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



*data lsphot type string.
*lsphot = picture.
*
    DATA: lv_hex           TYPE xstring,
          lv_base64_encode TYPE string,
          lt_binary        TYPE TABLE OF tbl1024.
*
    lv_hex = picture.

*    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
*      EXPORTING
*        buffer     = lv_hex
*      IMPORTING
*        binary_tab = lt_binary.
*data li_length type i.
*li_length = lv_length.
*         CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
*           EXPORTING
*             buffer          = lv_hex
**             append_to_table = space
*           IMPORTING
*             output_length   = li_length
*           TABLES
*             binary_tab      = lt_binary
           .

**
*    DATA: lv_base64 TYPE string.
*    DATA lv_leng TYPE i.
*    lv_leng = lines( lt_binary ).
*
*    CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
*      EXPORTING
*        input_length = lv_leng
*        binary_tab   = lt_binary
*      IMPORTING
*        buffer       = lv_base64.
**
**     " Tiene que ser en Base64
**     CALL FUNCTION 'SCMS_BASE64_ENCODE'
**       EXPORTING
**         input  = lv_base64
**       IMPORTING
**         output = lv_base64.
**
**
**
**picture = lv_base64.
*
*
*
*    CALL FUNCTION 'SCMS_BASE64_ENCODE_STR'
*      EXPORTING
*        input  = lv_hex
*      IMPORTING
*        output = lv_base64_encode.
*    picture = lv_base64_encode.
  ENDMETHOD.

ENDCLASS.
