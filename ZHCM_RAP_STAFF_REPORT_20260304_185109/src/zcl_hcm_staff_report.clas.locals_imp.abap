*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
CLASS lcl_staff_report DEFINITION.

  PUBLIC SECTION.
    TYPES t_staffreport    TYPE zc_hcm_staffreport.
    TYPES tt_staffreport   TYPE STANDARD TABLE OF zc_hcm_staffreport.
    TYPES t_matrix_report  TYPE zc_hcm_matrixreport.
    TYPES tt_matrix_report TYPE STANDARD TABLE OF t_matrix_report.
    TYPES t_matrix_report_tree  TYPE zc_hcm_matrixreporttree.
    TYPES tt_matrix_report_tree TYPE STANDARD TABLE OF t_matrix_report_tree.

    METHODS constructor.

    METHODS proces_staff_report
      IMPORTING io_request TYPE REF TO if_rap_query_request
      CHANGING  !results   TYPE tt_staffreport.

    METHODS proces_matrix_report
      IMPORTING io_request TYPE REF TO if_rap_query_request
      CHANGING  results    TYPE  tt_matrix_report.
    METHODS proces_matrix_report_tree
      IMPORTING
        io_request TYPE REF TO if_rap_query_request
      CHANGING
        results    TYPE tt_matrix_report_tree.

  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS gc_constrol TYPE zrangeid      VALUE '0000001662'.
    CONSTANTS gc_zeity    TYPE t508s-zeity   VALUE '2'.
    CONSTANTS gc_mosid    TYPE t508s-mosid   VALUE '30'.
    CONSTANTS gc_a930     TYPE hrp1001-subty VALUE 'A930'.
    CONSTANTS gc_a970     TYPE hrp1001-subty VALUE 'A970'.
    CONSTANTS gc_a971     TYPE hrp1001-subty VALUE 'A971'.

    TYPES: BEGIN OF gty_itemp,
             rsign TYPE hrp1001-rsign,
             objid TYPE hrp1001-objid,
             sobid TYPE hrp1001-sobid,
             begda TYPE hrp1001-begda,
             endda TYPE hrp1001-endda,
           END OF gty_itemp.
    TYPES: BEGIN OF gty_ity,
             pernr TYPE pa0001-pernr,
             subty TYPE pa0001-subty,
             objps TYPE pa0001-objps,
             sprps TYPE pa0001-sprps,
             endda TYPE pa0001-endda,
             begda TYPE pa0001-begda,
             seqnr TYPE pa0001-seqnr,
             bukrs TYPE pa0001-bukrs,
             werks TYPE pa0001-werks,
             persg TYPE pa0001-persg,
             persk TYPE pa0001-persk,
             orgeh TYPE pa0001-orgeh,
             plans TYPE pa0001-plans,
             stell TYPE pa0001-stell,
             stltx TYPE t513s-stltx,
             nachn TYPE pa0002-nachn,
             nach2 TYPE pa0002-nach2,
             vorna TYPE pa0002-vorna,
           END OF gty_ity,
           tty_ity TYPE STANDARD TABLE OF gty_ity.
    TYPES: BEGIN OF gty_hrp1001_,
             otype TYPE hrp1001-otype,
             objid TYPE hrp1001-objid,
             plvar TYPE hrp1001-plvar,
             rsign TYPE hrp1001-rsign,
             relat TYPE hrp1001-relat,
             istat TYPE hrp1001-istat,
             priox TYPE hrp1001-priox,
             begda TYPE hrp1001-begda,
             endda TYPE hrp1001-endda,
             seqnr TYPE hrp1001-seqnr,
             varyf TYPE hrp1001-varyf,
             subty TYPE hrp1001-subty,
             sobid TYPE hrp1001-sobid,
           END OF gty_hrp1001_.
    TYPES: BEGIN OF gty_hrp1000_,
             plvar TYPE hrp1000-plvar,
             otype TYPE hrp1000-otype,
             objid TYPE hrp1000-objid,
             istat TYPE hrp1000-istat,
             begda TYPE hrp1000-begda,
             endda TYPE hrp1000-endda,
             langu TYPE hrp1000-langu,
             seqnr TYPE hrp1000-seqnr,
             stext TYPE hrp1000-stext,
           END OF gty_hrp1000_.

    " Denominaciones de estado civil
    TYPES:
      BEGIN OF gty_t502t,
        famst TYPE t502t-famst,
        ftext TYPE t502t-ftext,
      END OF gty_t502t.

    " Ubicaciones Geográficas (UBIGEOS)
    TYPES:
      BEGIN OF gty_ztbubig,
        depa TYPE ztbubig-depa,
        prov TYPE ztbubig-prov,
        dist TYPE ztbubig-dist,
        nomb TYPE ztbubig-nomb,
      END OF gty_ztbubig.

    " Títulos
    TYPES:
      BEGIN OF gty_t519t,
        slabs TYPE t519t-slabs,
        stext TYPE t519t-stext,
      END OF gty_t519t.

    " Denominaciones de formación
    TYPES:
      BEGIN OF gty_t518b,
        ausbi TYPE t518b-ausbi,
        atext TYPE t518b-atext,
      END OF gty_t518b.

    " Sociedades
    TYPES:
      BEGIN OF gty_t001,
        bukrs TYPE t001-bukrs,
        butxt TYPE t001-butxt,
      END OF gty_t001.

    " Divisiones
    TYPES:
      BEGIN OF gty_t500p,
        persa TYPE t500p-persa,
        molga TYPE t500p-molga,
        name1 TYPE t500p-name1,
      END OF gty_t500p.

    " Subdivision
    TYPES:
      BEGIN OF gty_t001p,
        werks TYPE t001p-werks,
        btrtl TYPE t001p-btrtl,
        btext TYPE t001p-btext,
        mofid TYPE t001p-mofid,
      END OF gty_t001p.

    " Unidad Organizativa
    TYPES:
      BEGIN OF gty_t527x,
        orgeh TYPE t527x-orgeh,
        endda TYPE t527x-endda,
        begda TYPE t527x-begda,
        orgtx TYPE t527x-orgtx,
      END OF gty_t527x.

    " Clases de contrato
    TYPES:
      BEGIN OF gty_t547s,
        cttyp TYPE t547s-cttyp,
        cttxt TYPE t547s-cttxt,
      END OF gty_t547s.

    " Categorias internas, tipo de poder
    TYPES:
      BEGIN OF gty_t591s,
        infty TYPE t591s-infty,
        subty TYPE t591s-subty,
        stext TYPE t591s-stext,
      END OF gty_t591s.

    " Area de personal
    TYPES:
      BEGIN OF gty_t503t,
        persk TYPE t503t-persk,
        ptext TYPE t503t-ptext,
      END OF gty_t503t.

    " Grupo personal
    TYPES:
      BEGIN OF gty_t501t,
        persg TYPE t501t-persg,
        ptext TYPE t501t-ptext,
      END OF gty_t501t.

    " Relación laboral
    TYPES:
      BEGIN OF gty_t542t,
        molga TYPE t542t-molga,
        ansvh TYPE t542t-ansvh,
        atx   TYPE t542t-atx,
      END OF gty_t542t.

    " Descripcion marcas
    TYPES:
      BEGIN OF gty_t555v,
        zterf TYPE t555v-zterf,
        ztext TYPE t555v-ztext,
      END OF gty_t555v.

    " Posiciones
    TYPES:
      BEGIN OF gty_t528t,
        plans TYPE t528t-plans,
        endda TYPE t528t-endda,
        begda TYPE t528t-begda,
        plstx TYPE t528t-plstx,
      END OF gty_t528t.

    " Funciones
    TYPES:
      BEGIN OF gty_t513s,
        stell TYPE t513s-stell,
        endda TYPE t513s-endda,
        begda TYPE t513s-begda,
        stltx TYPE t513s-stltx,
      END OF gty_t513s.

    " Maestro de Administradoras de fondos de Pensiones
    TYPES:
      BEGIN OF gty_ztbmafp,
        afpkl TYPE ztbmafp-afpkl,
        afpds TYPE ztbmafp-afpds,
      END OF gty_ztbmafp.

    " Denominaciones de paises
    TYPES:
      BEGIN OF gty_t005t,
        land1 TYPE t005t-land1,
        landx TYPE t005t-landx,
        natio TYPE t005t-natio,
      END OF gty_t005t.

    " Posiciiones de responsables
    TYPES:
      BEGIN OF gty_hrp1001,
        objid TYPE hrp1001-objid,
        sobid TYPE hrp1001-sobid,
        pernr TYPE pa0002-pernr,
        orgeh TYPE pa0001-orgeh,
        obji2 TYPE hrp1001-objid,
        begda TYPE pa0001-begda,
        endda TYPE pa0001-endda,
        delet TYPE flag,
      END OF gty_hrp1001.

    " Nombres de jefatura
    TYPES:
      BEGIN OF gty_pa0002,
        pernr TYPE pa0002-pernr,
        subty TYPE pa0002-subty,
        objps TYPE pa0002-objps,
        sprps TYPE pa0002-sprps,
        endda TYPE pa0002-endda,
        begda TYPE pa0002-begda,
        seqnr TYPE pa0002-seqnr,
        nachn TYPE pa0002-nachn,
        nach2 TYPE pa0002-nach2,
        vorna TYPE pa0002-vorna,
      END OF gty_pa0002.

    " Identificación de jefatura
    TYPES:
      BEGIN OF gty_pa0185,
        pernr TYPE pa0185-pernr,
        subty TYPE pa0185-subty,
        objps TYPE pa0185-objps,
        sprps TYPE pa0185-sprps,
        endda TYPE pa0185-endda,
        begda TYPE pa0185-begda,
        seqnr TYPE pa0185-seqnr,
        ictyp TYPE pa0185-ictyp,
        icnum TYPE pa0185-icnum,
      END OF gty_pa0185.

    TYPES:
      BEGIN OF gty_rango,
        sign   TYPE bu_sign,
        option TYPE bu_option,
        low    TYPE ekko-bsart,
        high   TYPE ekko-bsart,
      END OF gty_rango.

    " Valores de status
    TYPES:
      BEGIN OF gty_t529u,
        statv TYPE t529u-statv,
        text1 TYPE t529u-text1,
      END OF gty_t529u.

    " Textos de horarios
    TYPES:
      BEGIN OF gty_t508s,
        zeity TYPE t508s-zeity,
        mofid TYPE t508s-mofid,
        mosid TYPE t508s-mosid,
        schkz TYPE t508s-schkz,
        rtext TYPE t508s-rtext,
        werks TYPE t001p-werks,
        btrtl TYPE t001p-btrtl,
      END OF gty_t508s.

    " CC-nóminas
    TYPES:
      BEGIN OF gty_t511,
        molga TYPE t511-molga,
        lgart TYPE t511-lgart,
        endda TYPE t511-endda,
        modna TYPE t511-modna,
      END OF gty_t511.

    " Tabla de BD del infotipo 1028
    TYPES:
      BEGIN OF gty_hrp1028,
        plvar TYPE hrp1028-plvar,
        otype TYPE hrp1028-otype,
        objid TYPE hrp1028-objid,
        subty TYPE hrp1028-subty,
        istat TYPE hrp1028-istat,
        begda TYPE hrp1028-begda,
        endda TYPE hrp1028-endda,
        stras TYPE hrp1028-stras,
        ort01 TYPE hrp1028-ort01,
        strs2 TYPE hrp1028-strs2,
      END OF gty_hrp1028.

    TYPES:
      BEGIN OF gty_hrp1000,
        otype TYPE hrp1000-otype,
        objid TYPE hrp1000-objid,
        begda TYPE hrp1000-begda,
        endda TYPE hrp1000-endda,
        stext TYPE hrp1000-stext,
      END OF gty_hrp1000.

    " Tabla para gastos indirectos
    TYPES:
      BEGIN OF gty_tbindbw,
        seqnr TYPE c LENGTH 3,
        lgart TYPE lgart,
        opken TYPE opken,
        betrg TYPE hr_curr_17_s,
        waers TYPE waers,
        indbw TYPE indbw,
        anzhl TYPE anzhl,
        modna TYPE modib,
        mod01 TYPE modko,
        zeinh TYPE pt_zeinh,
      END OF gty_tbindbw.

    TYPES tty_t005t                  TYPE HASHED TABLE OF gty_t005t WITH UNIQUE KEY land1.
    TYPES tty_t502t                  TYPE HASHED TABLE OF gty_t502t WITH UNIQUE KEY famst.
    TYPES ttsy_ztbubig               TYPE SORTED TABLE OF gty_ztbubig WITH NON-UNIQUE KEY depa prov dist.
    TYPES tty_t519t                  TYPE HASHED TABLE OF gty_t519t WITH UNIQUE KEY slabs.
    TYPES tty_t518b                  TYPE HASHED TABLE OF gty_t518b WITH UNIQUE KEY ausbi.
    TYPES tty_t001                   TYPE HASHED TABLE OF gty_t001 WITH UNIQUE KEY bukrs.
    TYPES tty_t500p                  TYPE HASHED TABLE OF gty_t500p WITH UNIQUE KEY persa.
    TYPES tty_hrp1000                TYPE STANDARD TABLE OF gty_hrp1000.
    TYPES tty_t001p                  TYPE HASHED TABLE OF gty_t001p WITH UNIQUE KEY werks btrtl.
    TYPES ttsy_t555v                 TYPE SORTED TABLE OF gty_t555v WITH UNIQUE KEY zterf.
    TYPES tty_t547s                  TYPE HASHED TABLE OF gty_t547s WITH UNIQUE KEY cttyp.
    TYPES tty_t542t                  TYPE HASHED TABLE OF gty_t542t WITH UNIQUE KEY molga ansvh.
    TYPES tty_t503t                  TYPE HASHED TABLE OF gty_t503t WITH UNIQUE KEY persk.
    TYPES tty_t501t                  TYPE HASHED TABLE OF gty_t501t WITH UNIQUE KEY persg.
    TYPES tty_ztbmafp                TYPE HASHED TABLE OF gty_ztbmafp WITH UNIQUE KEY afpkl.
    TYPES tty_codres                 TYPE STANDARD TABLE OF gty_hrp1001.
    TYPES tty_pa0002                 TYPE STANDARD TABLE OF gty_pa0002.
    TYPES tty_posres                 TYPE STANDARD TABLE OF gty_hrp1001.
    TYPES tty_pa0185                 TYPE STANDARD TABLE OF gty_pa0185.
    TYPES tty_t591s                  TYPE HASHED TABLE OF gty_t591s WITH UNIQUE KEY infty subty.
    TYPES tty_t508s                  TYPE STANDARD TABLE OF gty_t508s.
    TYPES tty_t508s_h                TYPE HASHED TABLE OF gty_t508s WITH UNIQUE KEY zeity mofid mosid schkz.
    TYPES tty_t5evp                  TYPE HASHED TABLE OF t5evp WITH UNIQUE KEY strds.

    TYPES gtty_t511                  TYPE HASHED TABLE OF gty_t511 WITH UNIQUE KEY molga lgart endda.
    TYPES gtty_tbindbw               TYPE STANDARD TABLE OF gty_tbindbw.
    TYPES ty_personnel_actions       TYPE STANDARD TABLE OF i_hcmpersonnelaction WITH DEFAULT KEY.
    TYPES ty_p0001                   TYPE STANDARD TABLE OF p0001 WITH DEFAULT KEY.
    TYPES ty_p0007                   TYPE STANDARD TABLE OF p0007 WITH DEFAULT KEY.
    TYPES ty_p0008                   TYPE STANDARD TABLE OF p0008 WITH DEFAULT KEY.
    TYPES ty_personal_informations   TYPE STANDARD TABLE OF i_hcmpersonaldata WITH DEFAULT KEY.
    TYPES ty_p0185                   TYPE STANDARD TABLE OF pa0185 WITH DEFAULT KEY.
    TYPES ty_p0016                   TYPE STANDARD TABLE OF pa0016 WITH DEFAULT KEY.
    TYPES ty_p0041                   TYPE STANDARD TABLE OF pa0041 WITH DEFAULT KEY.
    TYPES ty_p0006                   TYPE STANDARD TABLE OF pa0006 WITH DEFAULT KEY.
    TYPES ty_p0009                   TYPE STANDARD TABLE OF pa0009 WITH DEFAULT KEY.
    TYPES ty_p0021                   TYPE STANDARD TABLE OF pa0021 WITH DEFAULT KEY.
    TYPES ty_p0030                   TYPE STANDARD TABLE OF pa0030 WITH DEFAULT KEY.
    TYPES ty_p0034                   TYPE STANDARD TABLE OF pa0034 WITH DEFAULT KEY.
    TYPES ty_p2001                   TYPE STANDARD TABLE OF pa2001 WITH DEFAULT KEY.
    TYPES ty_p9205                   TYPE STANDARD TABLE OF pa9205 WITH DEFAULT KEY.
    TYPES ty_p0022                   TYPE STANDARD TABLE OF pa0022 WITH DEFAULT KEY.
    TYPES ty_p0105                   TYPE STANDARD TABLE OF pa0105 WITH DEFAULT KEY.
    TYPES ty_p0167                   TYPE STANDARD TABLE OF pa0167.
    TYPES ty_personnel_actions_1     TYPE STANDARD TABLE OF i_hcmpersonnelaction WITH DEFAULT KEY.
    TYPES ty_p0001_1                 TYPE STANDARD TABLE OF p0001 WITH DEFAULT KEY.
    TYPES ty_p0007_1                 TYPE STANDARD TABLE OF p0007 WITH DEFAULT KEY.
    TYPES ty_p0008_1                 TYPE STANDARD TABLE OF p0008 WITH DEFAULT KEY.
    TYPES ty_personal_informations_1 TYPE STANDARD TABLE OF i_hcmpersonaldata WITH DEFAULT KEY.
    TYPES ty_p0185_1                 TYPE STANDARD TABLE OF pa0185 WITH DEFAULT KEY.
    TYPES ty_p0016_1                 TYPE STANDARD TABLE OF pa0016 WITH DEFAULT KEY.
    TYPES ty_p0041_1                 TYPE STANDARD TABLE OF pa0041 WITH DEFAULT KEY.
    TYPES ty_p0006_1                 TYPE STANDARD TABLE OF pa0006 WITH DEFAULT KEY.
    TYPES ty_p0009_1                 TYPE STANDARD TABLE OF pa0009 WITH DEFAULT KEY.
    TYPES ty_p0021_1                 TYPE STANDARD TABLE OF pa0021 WITH DEFAULT KEY.
    TYPES ty_p0030_1                 TYPE STANDARD TABLE OF pa0030 WITH DEFAULT KEY.
    TYPES ty_p0034_1                 TYPE STANDARD TABLE OF pa0034 WITH DEFAULT KEY.
    TYPES ty_p2001_1                 TYPE STANDARD TABLE OF pa2001 WITH DEFAULT KEY.
    TYPES ty_p9205_1                 TYPE STANDARD TABLE OF pa9205 WITH DEFAULT KEY.
    TYPES ty_p0022_1                 TYPE STANDARD TABLE OF pa0022 WITH DEFAULT KEY.
    TYPES ty_p0105_1                 TYPE STANDARD TABLE OF pa0105 WITH DEFAULT KEY.

    DATA gr_sobida    TYPE RANGE OF hrp1001-sobid.
    DATA gr_sobidb    TYPE RANGE OF hrp1001-sobid.
    DATA gr_objid     TYPE RANGE OF hrp1001-objid.
    DATA gr_pernr     TYPE RANGE OF pa0001-pernr.
    DATA gr_plans     TYPE RANGE OF pa0001-plans.
    DATA gtd_itemp    TYPE STANDARD TABLE OF gty_itemp.
    DATA gtd_hrp1001_ TYPE STANDARD TABLE OF gty_hrp1001_.
    DATA gtd_tribus   TYPE STANDARD TABLE OF gty_hrp1001_.
    DATA gwa_ityo  TYPE gty_ity.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA gtd_hrp1000_ TYPE STANDARD TABLE OF gty_hrp1000_.

    METHODS build_report
      IMPORTING i_hire_date_filter           TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_contract_start_date_filter TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_contract_end_date_filter   TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_organizationalunit_filter  TYPE if_rap_query_filter=>ty_name_range_pairs-range
      CHANGING  c_results                    TYPE lcl_staff_report=>tt_staffreport
                c_personnel_actions          TYPE ty_personnel_actions_1
                c_p0001                      TYPE ty_p0001_1
                c_p0007                      TYPE ty_p0007_1
                c_p0008                      TYPE ty_p0008_1
                c_personal_informations      TYPE ty_personal_informations_1
                c_p0185                      TYPE ty_p0185_1
                c_p0016                      TYPE ty_p0016_1
                c_p0041                      TYPE ty_p0041_1
                c_p0006                      TYPE ty_p0006_1
                c_p0009                      TYPE ty_p0009_1
                c_p0021                      TYPE ty_p0021_1
                c_p0030                      TYPE ty_p0030_1
                c_p0034                      TYPE ty_p0034_1
                c_p2001                      TYPE ty_p2001_1
                c_p9205                      TYPE ty_p9205_1
                c_p0022                      TYPE ty_p0022_1
                c_p0105                      TYPE ty_p0105_1
                c_p0167                      TYPE ty_p0167.



    METHODS leer_infotipos
      IMPORTING i_personnelnumber_filter     TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_hire_date_filter           TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_organizationalunit_filter  TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_service_filter             TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_area_filter                TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_division_filter            TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_division_code_filter       TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_sub_division_code_filter   TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_personnel_group_filter     TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_personnel_area_filter      TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_employment_relation_filter TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_contract_start_date_filter TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_contract_end_date_filter   TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_function_code_filter       TYPE if_rap_query_filter=>ty_name_range_pairs-range
                i_company_code_filter        TYPE bukrs
      EXPORTING e_personnel_actions          TYPE ty_personnel_actions
                e_p0001                      TYPE ty_p0001
                e_p0007                      TYPE ty_p0007
                e_p0008                      TYPE ty_p0008
                e_personal_informations      TYPE ty_personal_informations
                e_p0185                      TYPE ty_p0185
                e_p0016                      TYPE ty_p0016
                e_p0041                      TYPE ty_p0041
                e_p0006                      TYPE ty_p0006
                e_p0009                      TYPE ty_p0009
                e_p0021                      TYPE ty_p0021
                e_p0030                      TYPE ty_p0030
                e_p0034                      TYPE ty_p0034
                e_p2001                      TYPE ty_p2001
                e_p9205                      TYPE ty_p9205
                e_p0022                      TYPE ty_p0022
                e_p0105                      TYPE ty_p0105
                e_p0167                      TYPE ty_p0167.

    DATA gth_t529u      TYPE HASHED TABLE OF gty_t529u WITH UNIQUE KEY statv.
    DATA t_sittrab      TYPE STANDARD TABLE OF zthr_sittrab.
    DATA t_sittrab_text TYPE STANDARD TABLE OF dd07t.
    DATA gs_profl       TYPE profl.
    DATA go_constantsn  TYPE REF TO zbc_constants_admin_n.
    DATA gwa_p0001      TYPE pa0001.
    DATA gtd_suebas     TYPE STANDARD TABLE OF gty_rango.
    DATA gtd_subeco     TYPE STANDARD TABLE OF gty_rango.
    DATA gtd_subsi      TYPE STANDARD TABLE OF gty_rango.
    DATA gtd_licen      TYPE STANDARD TABLE OF gty_rango.

    METHODS leer_constantes
      IMPORTING companycode TYPE bukrs OPTIONAL.

    METHODS get_user CHANGING organizationalunit_filter TYPE  if_rap_query_filter=>tt_range_option.

    METHODS lee_unidades_new
      EXPORTING pi_uname TYPE syst_uname
      CHANGING  pt_orgeh TYPE if_rap_query_filter=>tt_range_option
                pe_pernr TYPE pernr_d.

    METHODS calcula_periodo
      EXPORTING pi_begda  TYPE begda
                pi_ctedt  TYPE ctedt
      CHANGING  po_plavig TYPE ze_plavig.

    METHODS obtiene_sueldo_subvencion
      IMPORTING p0008   TYPE p0008_tab
                p0001   TYPE p0001_tab
                p0007   TYPE p0007_tab
      CHANGING  !result TYPE t_staffreport.

    METHODS get_molga
      IMPORTING pi_pernr   TYPE pernr_d
                pi_werks   TYPE persa
      CHANGING  po_okmolga TYPE boole_d
                po_molga   TYPE molga.

    METHODS obtiene_emolumentos_basicos
      IMPORTING pi_p0001   TYPE p0001_tab
                pi_p0007   TYPE p0007_tab
                pi_p0008   TYPE p0008
                pi_molga   TYPE molga
                pi_endda   TYPE endda
      CHANGING  pi_t511    TYPE gtty_t511
                pt_tbindbw TYPE gtty_tbindbw.

    METHODS leer_constantes_bukrs
      IMPORTING pp_bukrs TYPE bukrs.

    METHODS ini_matricial
      CHANGING ip_pernr TYPE pernr_d

               it_ity   TYPE tty_ity.

    METHODS exe_matricial
      CHANGING it_ity  TYPE tty_ity

               results TYPE tt_matrix_report.
    METHODS suplay_data
      CHANGING
        results TYPE tt_matrix_report
        it_ity  TYPE tty_ity.
    METHODS exe_matricial_tree
      CHANGING
        it_ity  TYPE tty_ity
        results TYPE tt_matrix_report_tree.
    METHODS suplay_data_tree
      CHANGING
        results TYPE tt_matrix_report_tree
        it_ity  TYPE tty_ity.
ENDCLASS.

CLASS lcl_staff_report IMPLEMENTATION.
  METHOD constructor.
  ENDMETHOD.

  METHOD leer_constantes.
* Tipos de estado de personal
    SELECT statv text1
      INTO TABLE gth_t529u
      FROM t529u
     WHERE sprsl = sy-langu
       AND statn = '2'.


* beg I@0002_ASS_20081205
    SELECT * INTO TABLE t_sittrab
    FROM zthr_sittrab.

    SELECT *
    INTO TABLE  t_sittrab_text
    FROM dd07t
    WHERE domname     = 'ZDHR_SITTRA'
      AND ddlanguage  = sy-langu
      AND as4local    = 'A'.


    TRY.
        CREATE OBJECT go_constantsn
          EXPORTING
            pi_repid = 'ZHRR0086'.
      CATCH cx_alert_unknown .
    ENDTRY.

    CALL METHOD go_constantsn->get_first_value_range_n
      EXPORTING
        pi_rangeid     = gc_constrol
        pi_bukrs       = companycode
      IMPORTING
        pe_first_value = gs_profl.
  ENDMETHOD.

  METHOD get_user.
*    CLEAR: gv_pernr,
*           gs_valida,
*           gs_auth.
*    REFRESH: gtd_p0001, gtd_p0105.

    DATA lv_pernr TYPE pernr_d.

    lee_unidades_new( IMPORTING pi_uname = sy-uname
                      CHANGING  pt_orgeh = organizationalunit_filter
                                pe_pernr = lv_pernr  ).
    IF lv_pernr IS NOT INITIAL.
      SELECT SINGLE pernr subty objps sprps endda begda seqnr werks persg persk vdsk1 plans kostl
        FROM pa0001
        INTO CORRESPONDING FIELDS OF gwa_p0001
        WHERE pernr  = lv_pernr
          AND begda <= sy-datum
          AND endda >= sy-datum.
    ENDIF.
  ENDMETHOD.

  METHOD proces_staff_report.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(sort_order) = io_request->get_sort_elements( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(params) = io_request->get_parameters( ).
    DATA(filters) = io_request->get_filter( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(sql_filters) = filters->get_as_sql_string( ).
    DATA(filters_range) = filters->get_as_ranges( ).

*    DATA(lv_sql_filter) = io_request->get_filter( )->get_as_sql_string( ).
    LOOP AT filters_range INTO DATA(filter_range).
      CASE filter_range-name.
        WHEN 'PERSONNELNUMBER'.
          DATA(personnelnumber_filter) = filter_range-range.
        WHEN 'HIREDATE'.
          DATA(hire_date_filter) = filter_range-range.
        WHEN 'ORGANIZATIONALUNIT'.
          DATA(organizationalunit_filter) = filter_range-range.
        WHEN 'SERVICE'.
          DATA(service_filter) = filter_range-range.
        WHEN 'AREA'.
          DATA(area_filter) = filter_range-range.
        WHEN 'DIVISION'.
          DATA(division_filter) = filter_range-range.
        WHEN 'DIVISIONCODE'.
          DATA(division_code_filter) = filter_range-range.
        WHEN 'SUBDIVISIONCODE'.
          DATA(sub_division_code_filter) = filter_range-range.
        WHEN 'PERSONNELGROUP'.
          DATA(personnel_group_filter) = filter_range-range.
        WHEN 'PERSONNELAREA'.
          DATA(personnel_area_filter) = filter_range-range.
        WHEN 'EMPLOYMENTRELATION'.
          DATA(employment_relation_filter) = filter_range-range.
        WHEN 'CONTRACTSTARTDATE'.
          DATA(contract_start_date_filter) = filter_range-range.
        WHEN 'CONTRACTENDDATE'.
          DATA(contract_end_date_filter) = filter_range-range.
        WHEN 'FUNCTIONCODE'.
          DATA(function_code_filter) = filter_range-range.
        WHEN 'COMPANYCODE'.
          DATA company_code_filter TYPE bukrs.
          company_code_filter = filter_range-range[ 1 ]-low.
      ENDCASE.
    ENDLOOP.

    leer_constantes( companycode = company_code_filter ).

    get_user( CHANGING organizationalunit_filter = organizationalunit_filter ).

    DATA personnel_actions     TYPE STANDARD TABLE OF i_hcmpersonnelaction.
    DATA p0001                 TYPE STANDARD TABLE OF p0001.
    DATA p0007                 TYPE STANDARD TABLE OF p0007.
    DATA p0008                 TYPE STANDARD TABLE OF p0008.
    DATA personal_informations TYPE STANDARD TABLE OF i_hcmpersonaldata.
    DATA p0185                 TYPE STANDARD TABLE OF pa0185.
    DATA p0016                 TYPE STANDARD TABLE OF pa0016.
    DATA p0041                 TYPE STANDARD TABLE OF pa0041.
    DATA p0006                 TYPE STANDARD TABLE OF pa0006.
    DATA p0009                 TYPE STANDARD TABLE OF pa0009.
    DATA p0021                 TYPE STANDARD TABLE OF pa0021.
    DATA p0030                 TYPE STANDARD TABLE OF pa0030.
    DATA p0034                 TYPE STANDARD TABLE OF pa0034.
    DATA p2001                 TYPE STANDARD TABLE OF pa2001.
    DATA p9205                 TYPE STANDARD TABLE OF pa9205.
    DATA p0022                 TYPE STANDARD TABLE OF pa0022.
    DATA p0105                 TYPE STANDARD TABLE OF pa0105.
    DATA p0167                 TYPE ty_p0167.               " p0167.

    leer_infotipos( EXPORTING i_personnelnumber_filter     = personnelnumber_filter
                              i_hire_date_filter           = hire_date_filter
                              i_organizationalunit_filter  = organizationalunit_filter
                              i_service_filter             = service_filter
                              i_area_filter                = area_filter
                              i_division_filter            = division_filter
                              i_division_code_filter       = division_code_filter
                              i_sub_division_code_filter   = sub_division_code_filter
                              i_personnel_group_filter     = personnel_group_filter
                              i_personnel_area_filter      = personnel_area_filter
                              i_employment_relation_filter = employment_relation_filter
                              i_contract_start_date_filter = contract_start_date_filter
                              i_contract_end_date_filter   = contract_end_date_filter
                              i_function_code_filter       = function_code_filter
                              i_company_code_filter        = company_code_filter
                    IMPORTING e_personnel_actions          = personnel_actions
                              e_p0001                      = p0001
                              e_p0007                      = p0007
                              e_p0008                      = p0008
                              e_personal_informations      = personal_informations
                              e_p0185                      = p0185
                              e_p0016                      = p0016
                              e_p0041                      = p0041
                              e_p0006                      = p0006
                              e_p0009                      = p0009
                              e_p0021                      = p0021
                              e_p0030                      = p0030
                              e_p0034                      = p0034
                              e_p2001                      = p2001
                              e_p9205                      = p9205
                              e_p0022                      = p0022
                              e_p0105                      = p0105
                              e_p0167 = p0167 ).

    build_report( EXPORTING  i_hire_date_filter           = hire_date_filter
                              i_contract_start_date_filter = contract_start_date_filter
                              i_contract_end_date_filter   = contract_end_date_filter
                              i_organizationalunit_filter  = organizationalunit_filter
                     CHANGING c_results               = results
                           c_personnel_actions     = personnel_actions
                           c_p0001                 = p0001
                           c_p0007                 = p0007
                           c_p0008                 = p0008
                           c_personal_informations = personal_informations
                           c_p0185                 = p0185
                           c_p0016                 = p0016
                           c_p0041                 = p0041
                           c_p0006                 = p0006
                           c_p0009                 = p0009
                           c_p0021                 = p0021
                           c_p0030                 = p0030
                           c_p0034                 = p0034
                           c_p2001                 = p2001
                           c_p9205                 = p9205
                           c_p0022                 = p0022
                           c_p0105                 = p0105
                           c_p0167 = p0167 ).



  ENDMETHOD.

  METHOD lee_unidades_new.
    " TODO: parameter PI_UNAME is never cleared or assigned (ABAP cleaner)

    DATA ls_uname  TYPE sysid.
    DATA ls_pernr  TYPE persno.
    DATA ls_respo  TYPE persno.
    DATA ln_orgeh  TYPE orgeh.
    DATA lwa_root  TYPE hrwpc_s_hrobject.
    DATA lwa_orgeh LIKE LINE OF pt_orgeh.

    DATA ltd_objec TYPE STANDARD TABLE OF hrwpc_s_objec.
    DATA ltd_struc TYPE STANDARD TABLE OF hrwpc_s_struc.

    FIELD-SYMBOLS <fs_objet> TYPE hrwpc_s_objec.

*  REFRESH: pt_orgeh.
    ls_uname = pi_uname.

    " Se obtiene el código de personal asociado al usuario que ejecuta
    CALL FUNCTION 'Z_HR_WF_LEE_PERSONA_CON_USUARI'
      EXPORTING
        ip_usrid = ls_uname
      IMPORTING
        ep_pernr = ls_pernr.
    IF ls_pernr IS INITIAL.
      RETURN.
    ENDIF.

    pe_pernr = ls_pernr.
    " Se obtiene la unidad de la persona
    CALL FUNCTION 'Z_HR_WF_LEE_UNIDAD_PERSONAL'
      EXPORTING
        ip_pernr = ls_pernr
      IMPORTING
        ep_orgeh = ln_orgeh.
    " Se obtiene el responsable de la unidad
    CALL FUNCTION 'Z_HR_WF_LEE_RESPONS_CON_UNIDAD'
      EXPORTING
        ip_orgeh = ln_orgeh
      IMPORTING
        ep_pernr = ls_respo.
    " Sólo si el empleado es el responsable de su área:
    IF ls_pernr = ls_respo.
      lwa_root-plvar = '01'.
      lwa_root-otype = 'O'.
      lwa_root-objid = ln_orgeh.
      CALL FUNCTION 'HRWPC_RFC_STRUCTURE_GET'
        EXPORTING
          root            = lwa_root
          evpath          = 'B002'
          authority_check = ''
        TABLES
          t_objec         = ltd_objec
          t_struc         = ltd_struc
        EXCEPTIONS
          nothing_found   = 1
          internal_error  = 2
          OTHERS          = 3.
      IF pt_orgeh IS INITIAL.
        LOOP AT ltd_objec ASSIGNING <fs_objet>.
          lwa_orgeh-sign   = 'I'.
          lwa_orgeh-option = 'EQ'.
          lwa_orgeh-low    = <fs_objet>-objid.
          APPEND lwa_orgeh TO pt_orgeh.
          CLEAR lwa_orgeh.
        ENDLOOP.
      ELSE.
        LOOP AT pt_orgeh ASSIGNING FIELD-SYMBOL(<orgunit_filter>).
          IF NOT line_exists( ltd_objec[ objid = <orgunit_filter>-low ] ).
            <orgunit_filter>-low = '0'.
          ENDIF.
        ENDLOOP.
        DELETE pt_orgeh WHERE low = '0'.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD calcula_periodo.
    CONSTANTS: lc_comas TYPE c VALUE ',',
               lc_y     TYPE c VALUE 'y'.

    DATA:
      li_dias     TYPE i,
      li_anios    TYPE i,
      li_meses    TYPE i,
      lc_dias(2)  TYPE c,
      lc_anios(4) TYPE c,
      lc_meses(2) TYPE c.

    CHECK pi_begda IS NOT INITIAL AND pi_ctedt IS NOT INITIAL.

    CALL FUNCTION 'HR_SGPBS_YRS_MTHS_DAYS'
      EXPORTING
        beg_da        = pi_begda
        end_da        = pi_ctedt
      IMPORTING
        no_day        = li_dias
        no_month      = li_meses
        no_year       = li_anios
      EXCEPTIONS
        dateint_error = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
    lc_dias  = li_dias.
    lc_meses = li_meses.
    lc_anios = li_anios.

    IF lc_anios IS NOT INITIAL AND lc_anios <> '0'.
      CONCATENATE lc_anios TEXT-t06
             INTO po_plavig
     SEPARATED BY space.
    ENDIF.

    IF lc_meses IS NOT INITIAL AND lc_meses <> '0'.
      IF NOT po_plavig IS INITIAL.
        CONCATENATE po_plavig lc_comas
             INTO po_plavig.
      ENDIF.

      CONCATENATE po_plavig lc_meses TEXT-t07
             INTO po_plavig
     SEPARATED BY space.
    ENDIF.

    IF lc_dias IS NOT INITIAL AND lc_dias <> '0'.
      IF NOT po_plavig IS INITIAL.
        CONCATENATE po_plavig lc_y
             INTO po_plavig
        SEPARATED BY space.
      ENDIF.

      CONCATENATE po_plavig lc_dias TEXT-t08
             INTO po_plavig
     SEPARATED BY space.
    ENDIF.

    CONDENSE po_plavig.

  ENDMETHOD.

  METHOD obtiene_sueldo_subvencion.
    DATA:
      lp_betrg   TYPE netwr_fp,
      ls_tipo(3) TYPE c.
    DATA lwa_p0008   TYPE p0008.
    DATA gs_okmolga  TYPE boole_d.
    DATA gs_molga    TYPE molga.
    DATA gtd_tbindbw TYPE STANDARD TABLE OF gty_tbindbw.
    DATA gth_t511    TYPE HASHED TABLE OF gty_t511 WITH UNIQUE KEY molga lgart endda.

    DATA lt_p0001    TYPE STANDARD TABLE OF p0001.
    DATA lt_p0007    TYPE STANDARD TABLE OF p0007.
    DATA lt_p0008    TYPE STANDARD TABLE OF p0008.

    lt_p0001 = p0001.
    lt_p0007 = p0007.
    lt_p0008 = p0008.
    DELETE lt_p0001 WHERE pernr <> result-personnelnumber.
    DELETE lt_p0007 WHERE pernr <> result-personnelnumber.
    DELETE lt_p0008 WHERE pernr <> result-personnelnumber.

    get_molga( EXPORTING pi_pernr   = result-personnelnumber
                         pi_werks   = result-divisioncode
               CHANGING  po_okmolga = gs_okmolga
                         po_molga   = gs_molga ).

    SORT lt_p0008 BY endda DESCENDING.
    READ TABLE lt_p0008 INTO lwa_p0008 INDEX 1.
    REFRESH gtd_tbindbw.
    obtiene_emolumentos_basicos( EXPORTING pi_p0001  = lt_p0001
                                           pi_p0007 = lt_p0007
                                           pi_p0008 = lwa_p0008
                                           pi_molga = gs_molga
                                           pi_endda = result-enddate
                                 CHANGING  pi_t511  = gth_t511
                                           pt_tbindbw = gtd_tbindbw ).

    IF NOT gtd_tbindbw[] IS INITIAL.
      CLEAR: lp_betrg.
      SORT gtd_tbindbw BY lgart.
      LOOP AT gtd_tbindbw INTO DATA(gwa_tbindbw).
*.......Datos de CC Nomina y texto de cc-nomina

        IF gwa_tbindbw-lgart IN gtd_subeco AND ( ls_tipo = 'SUB' OR ls_tipo = '' ).
          lp_betrg = lp_betrg + gwa_tbindbw-betrg.
          ls_tipo = 'SUB'.
        ENDIF.

        IF gwa_tbindbw-lgart IN gtd_suebas AND ( ls_tipo = 'SUE' OR ls_tipo = '' ).
          lp_betrg = lp_betrg + gwa_tbindbw-betrg.
          ls_tipo = 'SUE'.
        ENDIF.

      ENDLOOP.

      IF ls_tipo <> ''.
        result-currencycode  = lwa_p0008-waers.       " Moneda

        IF ls_tipo = 'SUB'.
*          gwa_out-subeco = lp_betrg.           " Subvención económica
          result-economicsubsidy = lp_betrg.           " Subvención económica
        ELSE.
*          gwa_out-suebas = lp_betrg.           " Sueldo básico
          result-basicsalary = lp_betrg.           " Sueldo básico
        ENDIF.

        CALL FUNCTION 'ZFI_CONVIERTE_IMPORTE_CADENA'
          EXPORTING
            monto          = lp_betrg
            moneda         = result-currencycode
            inc_moneda_ini = ''
            inc_decimales  = 'X'
            inc_moneda_fin = 'X'
            minusculas     = 'X'
          IMPORTING
            imp_textual    = result-amountinwords.     " Importe textual

        IF result-currencycode = 'PEN'.
          result-currencysymbol = 'S/.'.
        ELSEIF result-currencycode = 'USD'.
          result-currencysymbol = 'US$'.
        ELSE.
          result-currencysymbol = result-currencycode.
        ENDIF.
      ENDIF.
    ELSE.
      CLEAR result-currencycode.
    ENDIF.
  ENDMETHOD.

  METHOD get_molga.
    DATA l_pernr         TYPE pernr_d.
    DATA l_werks         TYPE persa.
    DATA l_molga         TYPE molga.
    DATA l_is_ok         TYPE boole_d.
    DATA message_handler TYPE REF TO if_hrpa_message_handler ##NEEDED.

    l_pernr = pi_pernr.
    l_werks = pi_werks.
    CALL FUNCTION 'HR_ECM_GET_EE_MOLGA'
      EXPORTING
        pernr           = l_pernr
        werks           = l_werks
        message_handler = message_handler
      IMPORTING
        molga           = l_molga  " Agrupac. de paises
        is_ok           = l_is_ok.
    IF l_is_ok = 'X'.
      po_okmolga = l_is_ok.
      po_molga = l_molga.
    ENDIF.
  ENDMETHOD.


  METHOD obtiene_emolumentos_basicos.

  ENDMETHOD.


  METHOD leer_constantes_bukrs.
    DATA:
      lo_constants TYPE REF TO zbc_constants_admin_n,
      ls_sincon(1) TYPE c.

    TRY.
        CREATE OBJECT lo_constants
          EXPORTING
            pi_repid = sy-repid.
      CATCH zcx_programa_desconocido.
        ls_sincon = 'X'.
    ENDTRY.

    IF ls_sincon = ''.
      CALL METHOD lo_constants->get_range_n
        EXPORTING
          pi_rangeid = '0000000019'
          pi_bukrs   = pp_bukrs
        CHANGING
          pt_range   = gtd_subsi.

      CALL METHOD lo_constants->get_range_n
        EXPORTING
          pi_rangeid = '0000000020'
          pi_bukrs   = pp_bukrs
        CHANGING
          pt_range   = gtd_licen.

      CALL METHOD lo_constants->get_range_n
        EXPORTING
          pi_rangeid = '0000000021'
          pi_bukrs   = pp_bukrs
        CHANGING
          pt_range   = gtd_suebas.

      CALL METHOD lo_constants->get_range_n
        EXPORTING
          pi_rangeid = '0000000022'
          pi_bukrs   = pp_bukrs
        CHANGING
          pt_range   = gtd_subeco.

    ENDIF.
  ENDMETHOD.

  METHOD leer_infotipos.
    SELECT hcmpersonnelnumber, hcmemploymentstatus
      INTO CORRESPONDING FIELDS OF TABLE @e_personnel_actions
      FROM i_hcmpersonnelaction
      WHERE hcmpersonnelnumber IN @i_personnelnumber_filter

        AND startdate          <= @sy-datum AND enddate >= @sy-datum.
    SORT e_personnel_actions BY hcmpersonnelnumber.
    DELETE ADJACENT DUPLICATES FROM e_personnel_actions COMPARING hcmpersonnelnumber.

    IF e_personnel_actions IS INITIAL.
      RETURN.
    ENDIF.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE @e_p0001
      FROM pa0001
      FOR ALL ENTRIES IN @e_personnel_actions
      WHERE pernr        = @e_personnel_actions-hcmpersonnelnumber
        AND bukrs        = @i_company_code_filter
        AND persg       IN @i_personnel_group_filter AND persg NE 'I'
        AND zz_division IN @i_division_filter
        AND zz_area     IN @i_area_filter
        AND zz_servicio IN @i_service_filter

        AND werks       IN @i_division_code_filter
        AND btrtl       IN @i_sub_division_code_filter
        AND persk       IN @i_personnel_area_filter
        AND ansvh       IN @i_employment_relation_filter
        AND stell       IN @i_function_code_filter

*        AND ( kostl = @gwa_p0001-kostl OR orgeh IN @i_organizationalunit_filter )
        AND orgeh IN @i_organizationalunit_filter
*        and kostl = @gwa_p0001-kostl
        AND begda <= @sy-datum AND endda >= @sy-datum.
    SELECT * INTO TABLE @e_p0016
      FROM pa0016
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr  = @e_personnel_actions-hcmpersonnelnumber
        AND begda <= @sy-datum AND endda >= @sy-datum
        AND begda IN @i_contract_start_date_filter
        AND ctedt IN @i_contract_end_date_filter.
    SELECT * INTO TABLE @e_p0041
      FROM pa0041
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr  = @e_personnel_actions-hcmpersonnelnumber
        AND dar02  = '02'
        AND dat02 IN @i_hire_date_filter
        AND begda <= @sy-datum AND endda >= @sy-datum.

    SELECT * INTO TABLE @e_personal_informations
      FROM i_hcmpersonaldata
      FOR ALL ENTRIES IN @e_personnel_actions
      WHERE hcmpersonnelnumber  = @e_personnel_actions-hcmpersonnelnumber
        AND hcmsubtype          = @space
        AND startdate          <= @sy-datum AND enddate >= @sy-datum
        AND hcmrecordislocked   = ''.

    SELECT * INTO TABLE @e_p0006
      FROM pa0006
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr  = @e_personnel_actions-hcmpersonnelnumber
        AND subty  = '1'
        AND begda <= @sy-datum AND endda >= @sy-datum.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE @e_p0007
      FROM pa0007
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr  = @e_personnel_actions-hcmpersonnelnumber
        AND begda <= @sy-datum AND endda >= @sy-datum.
    SELECT * INTO CORRESPONDING FIELDS OF TABLE @e_p0008
      FROM pa0008
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr  = @e_personnel_actions-hcmpersonnelnumber

        AND begda <= @sy-datum AND endda >= @sy-datum.

    SELECT * INTO TABLE @e_p0009
      FROM pa0009
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr = @e_personnel_actions-hcmpersonnelnumber
        AND ( subty = '0' OR subty = '5' )
        AND begda <= @sy-datum AND endda >= @sy-datum.

    SELECT * INTO TABLE @e_p0021
      FROM pa0021
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr  = @e_personnel_actions-hcmpersonnelnumber
        AND subty  = '3'
        AND begda <= @sy-datum AND endda >= @sy-datum.

    SELECT * INTO TABLE @e_p0030
      FROM pa0030
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr  = @e_personnel_actions-hcmpersonnelnumber

        AND begda <= @sy-datum AND endda >= @sy-datum.

    SELECT * INTO TABLE @e_p0034
      FROM pa0034
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr  = @e_personnel_actions-hcmpersonnelnumber
        AND begda <= @sy-datum AND endda >= @sy-datum.

    SELECT * INTO TABLE @e_p0185
      FROM pa0185
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr  = @e_personnel_actions-hcmpersonnelnumber
        AND begda <= @sy-datum AND endda >= @sy-datum.

    SELECT * INTO TABLE @e_p2001
      FROM pa2001
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr  = @e_personnel_actions-hcmpersonnelnumber
        AND begda <= @sy-datum AND endda >= @sy-datum.

    SELECT * INTO TABLE @e_p9205
      FROM pa9205
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr  = @e_personnel_actions-hcmpersonnelnumber
        AND begda <= @sy-datum AND endda >= @sy-datum.

    SELECT * INTO TABLE @e_p0167
      FROM pa0167
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr  = @e_personnel_actions-hcmpersonnelnumber
        AND begda <= @sy-datum AND endda >= @sy-datum.

    SELECT * INTO TABLE @e_p0022
      FROM pa0022
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr  = @e_personnel_actions-hcmpersonnelnumber
        AND begda <= @sy-datum AND endda >= @sy-datum.
    SORT e_p0022 BY pernr DESCENDING
                    begda DESCENDING slart DESCENDING slabs DESCENDING .

    SELECT * INTO TABLE @e_p0105
      FROM pa0105
      FOR ALL ENTRIES IN  @e_personnel_actions
      WHERE pernr  = @e_personnel_actions-hcmpersonnelnumber
        AND begda <= @sy-datum AND endda >= @sy-datum.
  ENDMETHOD.

  METHOD build_report.
    DATA ls_plvar    TYPE hrp1001-plvar.
    DATA gth_t005t   TYPE tty_t005t.
    DATA gth_t502t   TYPE tty_t502t.
    DATA gts_ztbubig TYPE ttsy_ztbubig.
    DATA gth_t519t   TYPE tty_t519t.
    DATA gth_t518b   TYPE tty_t518b.
    DATA gth_t001    TYPE tty_t001.
    DATA gth_t500p   TYPE tty_t500p.
    DATA gtd_hrp1000 TYPE tty_hrp1000.
    DATA gth_t001p   TYPE tty_t001p.
    DATA gts_t555v   TYPE ttsy_t555v.
    DATA gth_t547s   TYPE tty_t547s.
    DATA gth_t542t   TYPE tty_t542t.
    DATA gth_t503t   TYPE tty_t503t.
    DATA gth_t501t   TYPE tty_t501t.
    DATA gth_ztbmafp TYPE tty_ztbmafp.
    DATA gtd_codres  TYPE tty_codres.
    DATA gtd_pa0002  TYPE tty_pa0002.
    DATA gtd_posres  TYPE tty_posres.
    DATA gtd_pa0185  TYPE tty_pa0185.
    DATA gth_t591s   TYPE tty_t591s.
    DATA gtd_t508s   TYPE tty_t508s.
    DATA gth_t508s   TYPE tty_t508s_h.
    DATA gth_t5evp   TYPE tty_t5evp.

*    leer_textos( CHANGING c_personal_informations = c_personal_informations
*                          c_p0006                 = c_p0006
*                          c_p0022                 = c_p0022
*                          c_p0001                 = c_p0001
*                          c_p0007                 = c_p0007
*                          c_p0016                 = c_p0016
*                          c_p9205                 = c_p9205
*                          c_p0030 = c_p0030
*                          c_p0034 = c_p0034
*                          ct_t005t                = gth_t005t
*                          ct_t502t                = gth_t502t
*                          ct_ztbubig              = gts_ztbubig
*                          ct_t519t                = gth_t519t
*                          ct_t518b                = gth_t518b
*                          ct_t001                 = gth_t001
*                          ct_t500p                = gth_t500p
*                          ct_hrp1000              = gtd_hrp1000
*                          ct_t001p                = gth_t001p
*                          ct_t555v                = gts_t555v
*                          ct_t547s                = gth_t547s
*                          ct_t542t                = gth_t542t
*                          ct_t503t                = gth_t503t
*                          ct_t501t                = gth_t501t
*                          ct_ztbmafp              = gth_ztbmafp
*                          ct_codres               = gtd_codres
*                          ct_pa0002               = gtd_pa0002
*                          ct_posres               = gtd_posres
*                          ct_pa0185               = gtd_pa0185
*                          ct_t591s                = gth_t591s
*                          ct_t508s                = gtd_t508s
*                          ct_t5evp                = gth_t5evp  ).

    CALL FUNCTION 'RH_GET_ACTIVE_WF_PLVAR'
      IMPORTING
        act_plvar = ls_plvar.
    IF c_personal_informations IS NOT INITIAL.
      " Denominaciones de paises
      SELECT land1 landx natio INTO TABLE gth_t005t
        FROM t005t
        FOR ALL ENTRIES IN c_personal_informations
        WHERE land1 = c_personal_informations-hcmemployeenationality
          AND spras = sy-langu.

      " Denominaciones de estado civil
      SELECT famst ftext INTO TABLE gth_t502t
        FROM t502t
        FOR ALL ENTRIES IN c_personal_informations
        WHERE famst = c_personal_informations-hcmemployeemaritalstatus
          AND sprsl = sy-langu.
      " Códigos de via publica
      SELECT * INTO TABLE gth_t5evp
        FROM t5evp.
    ENDIF.

    IF c_p0006 IS NOT INITIAL.
      " Ubicaciones Geográficas (UBIGEOS)
      SELECT
        FROM ztbubig AS a
               INNER JOIN
                 @c_p0006 AS b ON  a~depa = b~zz_depa
                               AND a~prov = '00'
                               AND a~dist = '00'
        FIELDS depa, prov, dist, nomb
        WHERE depa <> '00'
        INTO TABLE @gts_ztbubig.

      SELECT
        FROM ztbubig AS a
               INNER JOIN
                 @c_p0006 AS b ON  a~depa = b~zz_depa
                               AND a~prov = b~zz_prov
                               AND a~dist = '00'
        FIELDS depa, prov, dist, nomb
        WHERE depa <> '00' AND prov <> '00'
        APPENDING TABLE @gts_ztbubig.

      SELECT
        FROM ztbubig AS a
               INNER JOIN
                 @c_p0006 AS b ON  a~depa = b~zz_depa
                               AND a~prov = b~zz_prov
                               AND a~dist = b~zz_dist
        FIELDS depa, prov, dist, nomb
        WHERE depa <> '00' AND prov <> '00' AND dist <> '00'
        APPENDING TABLE @gts_ztbubig.
    ENDIF.

    " Títulos
    IF c_p0022[] IS NOT INITIAL.
      SELECT slabs stext INTO TABLE gth_t519t
        FROM t519t
        FOR ALL ENTRIES IN c_p0022
        WHERE slabs = c_p0022-slabs
          AND sprsl = sy-langu.

      " Denominaciones de formación
      SELECT ausbi atext INTO TABLE gth_t518b
        FROM t518b
        FOR ALL ENTRIES IN c_p0022
        WHERE ausbi = c_p0022-ausbi
          AND langu = sy-langu.
    ENDIF.

    " Sociedades
    IF c_p0001[] IS NOT INITIAL.
      SELECT bukrs butxt INTO TABLE gth_t001
        FROM t001
        FOR ALL ENTRIES IN c_p0001
        WHERE bukrs = c_p0001-bukrs.

      " Divisiones
      SELECT persa molga name1 INTO TABLE gth_t500p
        FROM t500p
        FOR ALL ENTRIES IN c_p0001
        WHERE persa = c_p0001-werks.
      " Subdivisiones
      SELECT werks btrtl btext mofid INTO TABLE gth_t001p
        FROM t001p
        FOR ALL ENTRIES IN c_p0001
        WHERE werks = c_p0001-werks
          AND btrtl = c_p0001-btrtl.
    ENDIF.

    " Captura de Marca
    IF c_p0007[] IS NOT INITIAL.
      SELECT zterf ztext INTO TABLE gts_t555v
        FROM t555v
        FOR ALL ENTRIES IN c_p0007
        WHERE sprsl = sy-langu
          AND zterf = c_p0007-zterf.
    ENDIF.

    " Area, Servicio, division, unidad, posicion y funcion
    IF c_p0001[] IS NOT INITIAL.
      SELECT DISTINCT otype objid begda endda stext
        INTO TABLE gtd_hrp1000
        FROM hrp1000
        FOR ALL ENTRIES IN c_p0001
        WHERE plvar = ls_plvar
          AND otype = 'O'
          AND ( objid = c_p0001-zz_area OR objid = c_p0001-zz_division OR objid = c_p0001-zz_servicio OR objid = c_p0001-orgeh )
          AND istat  = '1'
          AND endda >= c_p0001-begda
          AND begda <= c_p0001-endda
          AND langu  = sy-langu.

      SELECT DISTINCT otype objid begda endda stext
        APPENDING TABLE gtd_hrp1000
        FROM hrp1000
        FOR ALL ENTRIES IN c_p0001
        WHERE plvar  = ls_plvar
          AND otype  = 'S'
          AND objid  = c_p0001-plans
          AND istat  = '1'
          AND endda >= c_p0001-begda
          AND begda <= c_p0001-endda
          AND langu  = sy-langu.

      SELECT DISTINCT otype objid begda endda stext
        APPENDING TABLE gtd_hrp1000
        FROM hrp1000
        FOR ALL ENTRIES IN c_p0001
        WHERE plvar  = ls_plvar
          AND otype  = 'C'
          AND objid  = c_p0001-stell
          AND istat  = '1'
          AND endda >= c_p0001-begda
          AND begda <= c_p0001-endda
          AND langu  = sy-langu.

      SORT gtd_hrp1000 BY otype
                          objid ASCENDING
                          endda DESCENDING.
      DELETE ADJACENT DUPLICATES FROM gtd_hrp1000 COMPARING otype objid.
    ENDIF.
* Direcciones de las unidades organizativas
*  IF gtd_t527x[] IS NOT INITIAL.
*    SELECT plvar otype objid subty istat begda endda stras ort01 strs2
*      INTO TABLE gtd_hrp1028
*      FROM hrp1028
*       FOR ALL ENTRIES IN gtd_t527x
*     WHERE plvar = ls_plvar
*       AND otype = 'O'
*       AND objid = gtd_t527x-orgeh
*       AND subty =  space
*       AND istat = '1'
*       AND endda >= gtd_t527x-begda
*       AND begda <= gtd_t527x-endda.
*    SORT gtd_hrp1028 BY endda DESCENDING.
*  ENDIF.

    " Clases de contrato
    IF c_p0016[] IS NOT INITIAL.
      SELECT cttyp cttxt INTO TABLE gth_t547s
        FROM t547s
        FOR ALL ENTRIES IN c_p0016
        WHERE cttyp = c_p0016-cttyp
          AND sprsl = sy-langu.
    ENDIF.

    " Relación laboral
    IF c_p0001[] IS NOT INITIAL.
      SELECT molga ansvh atx INTO TABLE gth_t542t
        FROM t542t
        FOR ALL ENTRIES IN c_p0001
        WHERE spras = sy-langu
          AND ansvh = c_p0001-ansvh.
    ENDIF.

    " Area de personal
    IF c_p0001[] IS NOT INITIAL.
      SELECT persk ptext INTO TABLE gth_t503t
        FROM t503t
        FOR ALL ENTRIES IN c_p0001
        WHERE persk = c_p0001-persk
          AND sprsl = sy-langu.
    ENDIF.

    " Grupos de personal
    IF c_p0001[] IS NOT INITIAL.
      SELECT persg ptext INTO TABLE gth_t501t
        FROM t501t
        FOR ALL ENTRIES IN c_p0001
        WHERE sprsl = sy-langu
          AND persg = c_p0001-persg.
    ENDIF.

    " Descripciones de AFP
    IF c_p9205[] IS NOT INITIAL.
      SELECT afpkl afpds INTO TABLE gth_ztbmafp
        FROM ztbmafp
        FOR ALL ENTRIES IN c_p9205
        WHERE afpkl = c_p9205-afpkl.
    ENDIF.

    DATA lr_priox TYPE RANGE OF hrp1001-priox.

    " Códigos de responsables
    IF c_p0001[] IS NOT INITIAL.
      SELECT objid sobid INTO TABLE gtd_posres
        FROM hrp1001
        FOR ALL ENTRIES IN c_p0001
        WHERE otype  = 'O'
          AND objid  = c_p0001-orgeh
          AND plvar  = '01'
          AND rsign  = 'B'
          AND relat  = '012'
          AND istat  = '1'
          AND sclas  = 'S'
          AND priox IN lr_priox
          AND begda <= sy-datum
          AND endda >= sy-datum.

      SORT gtd_posres BY endda DESCENDING.

      LOOP AT gtd_posres ASSIGNING FIELD-SYMBOL(<fs_posres>).
        ASSIGN gtd_posres[ obji2 = <fs_posres>-sobid
                           " TODO: variable is assigned but never used (ABAP cleaner)
                           orgeh = <fs_posres>-objid ] TO FIELD-SYMBOL(<fs_posres2>).
        IF sy-subrc <> 0.
          <fs_posres>-obji2 = <fs_posres>-sobid.
          <fs_posres>-orgeh = <fs_posres>-objid.
        ENDIF.
      ENDLOOP.

      DELETE gtd_posres WHERE obji2 IS INITIAL.

*    gts_posres[] = gtd_posres[].

      IF gtd_posres IS NOT INITIAL.
        SELECT objid sobid INTO TABLE gtd_codres
          FROM hrp1001
          FOR ALL ENTRIES IN gtd_posres
          WHERE otype  = 'S'
            AND objid  = gtd_posres-obji2
            AND plvar  = ls_plvar
            AND rsign  = 'A'
            AND relat  = '008'
            AND istat  = '1'
            AND sclas  = 'P'
            AND priox IN lr_priox
            AND begda <= sy-datum
            AND endda >= sy-datum.

        SORT gtd_codres BY endda DESCENDING.

        LOOP AT gtd_codres ASSIGNING FIELD-SYMBOL(<fs_codres>).
          " TODO: variable is assigned but never used (ABAP cleaner)
          ASSIGN gtd_codres[ pernr = <fs_codres>-sobid ] TO FIELD-SYMBOL(<fs_codres2>).
          IF sy-subrc <> 0.
            <fs_codres>-pernr = <fs_codres>-sobid.
          ENDIF.
        ENDLOOP.

        DELETE gtd_codres WHERE pernr IS INITIAL.

*      gts_codres[] = gtd_codres[].

        IF gtd_codres IS NOT INITIAL.
          SELECT pernr subty objps sprps endda begda seqnr nachn nach2 vorna
            INTO TABLE gtd_pa0002
            FROM pa0002
            FOR ALL ENTRIES IN gtd_codres
            WHERE pernr  = gtd_codres-pernr
              AND subty  = space
              AND objps  = space
              AND sprps  = space
              AND endda >= sy-datum
              AND begda <= sy-datum.
          SORT gtd_pa0002 BY endda DESCENDING.

          SELECT pernr subty objps sprps endda begda seqnr ictyp icnum
            INTO TABLE gtd_pa0185
            FROM pa0185
            FOR ALL ENTRIES IN gtd_codres
            WHERE pernr  = gtd_codres-pernr
              AND subty  = '01'
              AND objps  = space
              AND sprps  = space
              AND endda >= sy-datum
              AND begda <= sy-datum.
          SORT c_p0185 BY endda DESCENDING.
        ENDIF.
      ENDIF.
    ENDIF.

    " Tipo de poder, categoria jerarquica
    IF c_p0030[] IS NOT INITIAL.
      SELECT infty subty stext INTO TABLE gth_t591s
        FROM t591s
        FOR ALL ENTRIES IN c_p0030
        WHERE infty = '0030'
          AND subty = c_p0030-subty
          AND sprsl = sy-langu.
    ENDIF.
    IF c_p0034[] IS NOT INITIAL.
      SELECT infty subty stext APPENDING TABLE gth_t591s
        FROM t591s
        FOR ALL ENTRIES IN c_p0034
        WHERE infty = '0034'
          AND subty = c_p0034-subty
          AND sprsl = sy-langu.
    ENDIF.

    LOOP AT c_p0001 ASSIGNING FIELD-SYMBOL(<p0001_tmp>).
      APPEND INITIAL LINE TO gtd_t508s ASSIGNING FIELD-SYMBOL(<tr08s>).
      <tr08s>-werks = <p0001_tmp>-werks.
      <tr08s>-btrtl = <p0001_tmp>-btrtl.
      ASSIGN c_p0007[ pernr = <p0001_tmp>-pernr ] TO FIELD-SYMBOL(<p0007_tmp>).
      IF sy-subrc = 0.
        <tr08s>-schkz = <p0007_tmp>-schkz.
      ENDIF.
    ENDLOOP.
    " Texto de horarios
    LOOP AT gtd_t508s ASSIGNING FIELD-SYMBOL(<fs_t508s>).
      READ TABLE gth_t001p ASSIGNING FIELD-SYMBOL(<fs_t001p>) WITH TABLE KEY werks = <fs_t508s>-werks
                                                                             btrtl = <fs_t508s>-btrtl.
      IF sy-subrc = '0'.
        <fs_t508s>-mofid = <fs_t001p>-mofid.
      ENDIF.
    ENDLOOP.

    IF gtd_t508s[] IS NOT INITIAL.
      SELECT zeity mofid mosid schkz rtext
        INTO TABLE gth_t508s
        FROM t508s
        FOR ALL ENTRIES IN gtd_t508s
        WHERE zeity = gc_zeity
          AND mofid = gtd_t508s-mofid
          AND mosid = gc_mosid
          AND schkz = gtd_t508s-schkz
          AND sprsl = sy-langu.
    ENDIF.

    LOOP AT c_personnel_actions ASSIGNING FIELD-SYMBOL(<personnel_action>).
      ASSIGN c_p0001[ pernr = <personnel_action>-hcmpersonnelnumber ] TO FIELD-SYMBOL(<p0001>).
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.
      AUTHORITY-CHECK OBJECT 'P_ORGINCON'
                      ID 'PERSA' FIELD <p0001>-werks
                      ID 'PERSG' FIELD <p0001>-persg
                      ID 'PERSK' FIELD <p0001>-persk
                      ID 'VDSK1' FIELD <p0001>-vdsk1
                      ID 'PROFL' FIELD gs_profl.
      IF sy-subrc <> 0.
        RAISE EXCEPTION TYPE zcx_staff_report.
        EXIT.
      ENDIF.
      CHECK <p0001>-kostl EQ gwa_p0001-kostl OR <p0001>-orgeh IN i_organizationalunit_filter.

      leer_constantes_bukrs( pp_bukrs = <p0001>-bukrs ).
      ASSIGN c_p0016[ pernr = <personnel_action>-hcmpersonnelnumber ] TO FIELD-SYMBOL(<p0016>).
      IF sy-subrc <> 0 AND ( i_contract_end_date_filter IS NOT INITIAL OR i_contract_start_date_filter IS NOT INITIAL ).
        CONTINUE.
      ELSEIF sy-subrc = 0.

      ENDIF.
      ASSIGN c_p0041[ pernr = <personnel_action>-hcmpersonnelnumber ] TO FIELD-SYMBOL(<p0041>).
      IF sy-subrc <> 0 AND i_hire_date_filter IS NOT INITIAL.
        CONTINUE.
      ENDIF.

      APPEND INITIAL LINE TO c_results ASSIGNING FIELD-SYMBOL(<result>).
      <result>-personnelnumber = <p0001>-pernr.
      <result>-payrollarea     = <p0001>-abkrs.
      ASSIGN c_personal_informations[ hcmpersonnelnumber = <personnel_action>-hcmpersonnelnumber ] TO FIELD-SYMBOL(<personal_information>).
      IF sy-subrc = 0.
        <result>-firstname   = <personal_information>-hcmemployeefirstname.
        <result>-lastname1   = <personal_information>-hcmemployeelastname.
        <result>-lastname2   = <personal_information>-hcmemployeesecondname.
        <result>-fullname    = |{ <personal_information>-hcmemployeefirstname } { <personal_information>-hcmemployeelastname } { <personal_information>-hcmemployeesecondname }|.
        <result>-nationality = <personal_information>-hcmemployeenationality.
        <result>-dateofbirth = <personal_information>-hcmemployeebirthdate.
        DATA li_edad TYPE i.
        CALL FUNCTION 'HR_SGPBS_YRS_MTHS_DAYS'
          EXPORTING
            beg_da        = <personal_information>-hcmemployeebirthdate
            end_da        = sy-datum
          IMPORTING
            no_year       = li_edad              " Edad
          EXCEPTIONS
            dateint_error = 1
            OTHERS        = 2.

        <result>-age    = li_edad.
        <result>-gender = <personal_information>-hcmemployeegender.

        <result>-maritalstatus = <personal_information>-hcmemployeemaritalstatus.

      ENDIF.
      CASE <result>-gender.
        WHEN '1'.
          <result>-gentertext = TEXT-t03.
        WHEN '2'.
          <result>-gentertext = TEXT-t04.
        WHEN OTHERS.
          <result>-gentertext = TEXT-t05.
      ENDCASE.


      ASSIGN c_p0185[ pernr = <personnel_action>-hcmpersonnelnumber ] TO FIELD-SYMBOL(<p0185>).
      IF sy-subrc = 0.
        CASE <p0185>-subty.
          WHEN '01'.
            <result>-doctypename = TEXT-t01.
          WHEN '02'.
            <result>-doctypename = TEXT-t02.
        ENDCASE.
        <result>-documenttype   = <p0185>-subty.
        <result>-documentnumber = <p0185>-icnum.
        <result>-ipssnumber     = <p0185>-icnum.
      ENDIF.

      ASSIGN c_p0006[ pernr = <personnel_action>-hcmpersonnelnumber ] TO FIELD-SYMBOL(<p0006>).
      IF sy-subrc = 0.
        <result>-streettype     = <p0006>-strds.
        <result>-streetname     = <p0006>-stras.
        <result>-buildingnumber = <p0006>-hsnmr.
        <result>-postalcode     = <p0006>-posta.

        <result>-district       = <p0006>-zz_dist.
        <result>-department     = <p0006>-zz_depa.
        <result>-province       = <p0006>-zz_prov.

      ENDIF.

      ASSIGN c_p0022[ pernr = <personnel_action>-hcmpersonnelnumber ] TO FIELD-SYMBOL(<p0022>).
      IF sy-subrc = 0.
        <result>-university = <p0022>-insti.
        <result>-degree     = <p0022>-slabs.
        <result>-training   = <p0022>-ausbi.
      ENDIF.
      SORT c_p0105 BY begda DESCENDING.
      ASSIGN c_p0105[ pernr = <personnel_action>-hcmpersonnelnumber
                      usrty = '9000' ] TO FIELD-SYMBOL(<p0105>).
      IF sy-subrc = 0.
        <result>-username = <p0105>-usrid.

      ENDIF.
      ASSIGN c_p0041[ pernr = <personnel_action>-hcmpersonnelnumber ] TO <p0041>.
      IF sy-subrc = 0.
        IF <p0041>-dar02 = '02'.
          <result>-hiredate = <p0041>-dat02.
        ENDIF.
      ENDIF.
      ASSIGN c_p0016[ pernr = <personnel_action>-hcmpersonnelnumber ] TO <p0016>.
      IF sy-subrc = 0.
        <result>-contractstartdate = <p0016>-begda.
        <result>-contractenddate   = <p0016>-ctedt.

        calcula_periodo( IMPORTING pi_begda  = <p0016>-begda
                                   pi_ctedt  = <p0016>-ctedt
                         CHANGING  po_plavig = <result>-validityperiod ).
        <result>-contracttype = <p0016>-cttyp.
      ENDIF.

      <result>-startdate          = <p0001>-begda.
      <result>-enddate            = <p0001>-endda.
      <result>-companycode        = <p0001>-bukrs.
      <result>-divisioncode       = <p0001>-werks.
      <result>-subdivisioncode    = <p0001>-btrtl.
      <result>-organizationalunit = <p0001>-orgeh.
      <result>-service            = <p0001>-zz_servicio.
      <result>-area               = <p0001>-zz_area.
      <result>-division           = <p0001>-zz_division.

      <result>-personnelgroup     = <p0001>-persg.
      <result>-personnelarea      = <p0001>-persk.
      <result>-employmentrelation = <p0001>-ansvh.
      <result>-costcenter         = <p0001>-kostl.
      <result>-positioncode       = <p0001>-plans.
      <result>-functioncode       = <p0001>-stell.

      ASSIGN c_p0008[ pernr = <personnel_action>-hcmpersonnelnumber ] TO FIELD-SYMBOL(<p0008>).
      IF sy-subrc = 0.
        obtiene_sueldo_subvencion( EXPORTING p0008  = c_p0008
                                             p0001  = c_p0001
                                             p0007  = c_p0007
                                   CHANGING  result = <result>  ).
        <result>-salarygrade = <p0008>-trfgr.
      ENDIF.

      ASSIGN c_p0021[ pernr = <personnel_action>-hcmpersonnelnumber ] TO FIELD-SYMBOL(<p0021>).
      IF sy-subrc = 0.
        <result>-legalrepresentativeid   = <p0021>-zz_ndoc.
        <result>-legalrepresentativename = |{ <p0021>-fanam } { <p0021>-fnac2 } { <p0021>-favor }|.
      ENDIF.

      ASSIGN c_p0034[ pernr = <personnel_action>-hcmpersonnelnumber ] TO FIELD-SYMBOL(<p0034>).
      IF sy-subrc = 0.

        <result>-internalcategory = <p0034>-funkt.

      ENDIF.

      ASSIGN c_p0030[ pernr = <personnel_action>-hcmpersonnelnumber ] TO FIELD-SYMBOL(<p0030>).
      IF sy-subrc = 0.
        <result>-powertype = <p0030>-subty.
      ENDIF.
      ASSIGN c_p0009[ pernr = <personnel_action>-hcmpersonnelnumber
                      subty = '0' ] TO FIELD-SYMBOL(<p0009>). " h
      IF sy-subrc = 0.
        <result>-payrollaccounttype = <p0009>-bkont.
        <result>-payrollaccount     = <p0009>-bankn.
      ENDIF.
      ASSIGN c_p0009[ pernr = <personnel_action>-hcmpersonnelnumber
                      subty = '5' ] TO <p0009>. " c
      IF sy-subrc = 0.
        <result>-ctsaccounttype = <p0009>-bkont.
        <result>-ctsaccount     = <p0009>-bankn.
      ENDIF.

      <result>-employmentstatus = <personnel_action>-hcmemploymentstatus.

      " --------------------------------------      Situación del trabajador
      ASSIGN gth_t529u[ statv = <result>-employmentstatus ] TO FIELD-SYMBOL(<fs_t529u>).
      IF sy-subrc = 0.
        <result>-employeestatustext = <fs_t529u>-text1.
        IF <result>-employmentstatus = '3'.
          SORT c_p2001 BY endda DESCENDING.

          ASSIGN c_p2001[ 1 ] TO FIELD-SYMBOL(<fs_p2001>).
          IF sy-subrc = 0 AND ( <fs_p2001>-begda <= sy-datum AND sy-datum <= <fs_p2001>-endda ).
            IF t_sittrab[] IS NOT INITIAL.
              CLEAR t_sittrab.
              ASSIGN t_sittrab[ awart = <fs_p2001>-awart ] TO FIELD-SYMBOL(<sittrab>).
              IF sy-subrc = 0.
                CLEAR t_sittrab_text.
                DATA(li_situacion) = <sittrab>-situa.
                ASSIGN t_sittrab_text[ domvalue_l = li_situacion ] TO FIELD-SYMBOL(<sittrab_text>).
                IF sy-subrc = 0.
                  <result>-employeestatustext = <sittrab_text>-ddtext.
                ENDIF.
              ENDIF.
            ENDIF.

          ENDIF.
        ENDIF.
      ENDIF.

      ASSIGN c_p9205[ pernr = <result>-personnelnumber ] TO FIELD-SYMBOL(<p9205>).
      IF sy-subrc = 0.
        <result>-pensionsystem = <p9205>-afpkl.
      ENDIF.
      ASSIGN c_p0007[ pernr = <result>-personnelnumber ] TO FIELD-SYMBOL(<p0007>).
      IF sy-subrc = 0.
        <result>-workschedulecode = <p0007>-schkz.
        <result>-timestamp        = <p0007>-zterf.
      ENDIF.

      ASSIGN c_p0167[ pernr = <result>-personnelnumber ] TO FIELD-SYMBOL(<p0167>).
      IF sy-subrc = 0.
        IF <p0167>-pltyp = 'EPS0'.
          <result>-epsno = 'Si'.
        ELSE.
          <result>-epsno = 'No'.
        ENDIF.
      ELSE.
        <result>-epsno = 'No'.
      ENDIF.

      " Denominaciones de países
      ASSIGN gth_t005t[ land1 = <result>-nationality ] TO FIELD-SYMBOL(<fs_t005t>).
      IF sy-subrc = 0.
        <result>-nationalitytext = <fs_t005t>-natio.
      ENDIF.

      " Denominaciones de estado civil
      ASSIGN gth_t502t[ famst = <result>-maritalstatus ] TO FIELD-SYMBOL(<fs_t502t>).
      IF sy-subrc = 0.
        <result>-maritalstatustext = <fs_t502t>-ftext.
      ENDIF.

      " Direccion completa
      ASSIGN gth_t5evp[ strds = <result>-streettype ] TO FIELD-SYMBOL(<fs_t5evp>).
      IF sy-subrc = 0.
        DATA(ls_viapt) = <fs_t5evp>-viapt.
      ENDIF.
      CONCATENATE ls_viapt <result>-streetname <result>-buildingnumber <result>-postalcode
                  INTO <result>-completeaddress
                  SEPARATED BY space.
      CONDENSE <result>-completeaddress.

      " Departamento
      ASSIGN gts_ztbubig[ depa = <result>-department
                          prov = '00'
                          dist = '00' ] TO FIELD-SYMBOL(<fs_ztbubig>).
      IF sy-subrc = 0.
        <result>-departmentname = <fs_ztbubig>-nomb.
      ENDIF.

      " Provincia
      ASSIGN gts_ztbubig[ depa = <result>-department
                          prov = <result>-province
                          dist = '00' ] TO <fs_ztbubig>.
      IF sy-subrc = 0.
        <result>-provincename = <fs_ztbubig>-nomb.
      ENDIF.

      " Distrito
      ASSIGN gts_ztbubig[ depa = <result>-department
                          prov = <result>-province
                          dist = <result>-district ] TO <fs_ztbubig>.
      IF sy-subrc = 0.
        <result>-districtname = <fs_ztbubig>-nomb.
      ENDIF.

      " Títulos
      ASSIGN gth_t519t[ slabs = <result>-degree ] TO FIELD-SYMBOL(<fs_t519t>).
      IF sy-subrc = 0.
        <result>-degreetext = <fs_t519t>-stext.
      ENDIF.

      " Denominaciones de formación
      ASSIGN gth_t518b[ ausbi = <result>-training ] TO FIELD-SYMBOL(<fs_t518b>).
      IF sy-subrc = 0.
        <result>-trainingtext = <fs_t518b>-atext.
      ENDIF.

      " Sociedades
      ASSIGN gth_t001[ bukrs = <result>-companycode ] TO FIELD-SYMBOL(<fs_t001>).
      IF sy-subrc = 0.
        <result>-companyname = <fs_t001>-butxt.
      ENDIF.

      " Divisiones
      ASSIGN gth_t500p[ persa = <result>-divisioncode ] TO FIELD-SYMBOL(<fs_t500p>).
      IF sy-subrc = 0.
        <result>-divisionname = <fs_t500p>-name1.
        " Relación laboral
        ASSIGN gth_t542t[ molga = <fs_t500p>-molga
                          ansvh = <result>-employmentrelation ] TO FIELD-SYMBOL(<fs_t542t>).
        IF sy-subrc = 0.
          <result>-relationtext = <fs_t542t>-atx.
        ENDIF.
      ENDIF.

      " Subdivision
      ASSIGN gth_t001p[ werks = <result>-divisioncode
                        btrtl = <result>-subdivisioncode ] TO <fs_t001p>.
      IF sy-subrc = 0.
        <result>-subdivisiontext = <fs_t001p>-btext.
        <result>-holidaycalendar = <fs_t001p>-mofid.
      ENDIF.

      " Captura de Marca
      ASSIGN gts_t555v[ zterf = <result>-timestamp ] TO FIELD-SYMBOL(<fs_t555v>).
      IF sy-subrc = 0.
        <result>-timestamptext = <fs_t555v>-ztext.
      ENDIF.

*@{0001
**   Unidad Organizativa
*    LOOP AT gtd_t527x ASSIGNING <fs_t527x> WHERE orgeh = <fs_out>-orgeh.
*      <fs_out>-orgtx = <fs_t527x>-orgtx.
*      EXIT.
*    ENDLOOP.

*   Direccion de Unidad Organizativa
*    LOOP AT gtd_hrp1028 ASSIGNING <fs_hrp1028> WHERE objid = <result>-OrganizationalUnit.
*      CONCATENATE <fs_hrp1028>-stras <fs_hrp1028>-strs2 <fs_hrp1028>-ort01
*             INTO <result>-OrganizationAddress SEPARATED BY space.
*      CONDENSE <fs_out>-dirorg.
*      EXIT.
*    ENDLOOP.

      " Area de personal
      ASSIGN gth_t503t[ persk = <result>-personnelarea ] TO FIELD-SYMBOL(<fs_t503t>).
      IF sy-subrc = 0.
        <result>-personnelareatext = <fs_t503t>-ptext.
      ENDIF.

      " Grupo de personal
      ASSIGN gth_t501t[ persg = <result>-personnelgroup ] TO FIELD-SYMBOL(<fs_t501t>).
      IF sy-subrc = 0.
        <result>-personnelgrouptext = <fs_t501t>-ptext.
      ENDIF.

      " Tipo de contrato
      ASSIGN gth_t547s[ cttyp = <result>-contracttype ] TO FIELD-SYMBOL(<fs_t547s>).
      IF sy-subrc = 0.
        <result>-contracttext = <fs_t547s>-cttxt.
      ENDIF.

      SORT gtd_hrp1000 BY endda DESCENDING.

      READ TABLE gtd_hrp1000 INTO DATA(lwa_hrp1000) WITH  KEY otype = 'O '
                                                              objid = <result>-area.
      IF sy-subrc = 0.
        <result>-areatext = lwa_hrp1000-stext.
      ENDIF.

      READ TABLE gtd_hrp1000 INTO lwa_hrp1000 WITH KEY otype = 'O '
                                                       objid = <result>-division.
      IF sy-subrc = 0.
        <result>-divisiontext = lwa_hrp1000-stext.
      ENDIF.

      READ TABLE gtd_hrp1000 INTO lwa_hrp1000 WITH KEY otype = 'O '
                                                       objid = <result>-service.
      IF sy-subrc = 0.
        <result>-servicetext = lwa_hrp1000-stext.
      ENDIF.

      READ TABLE gtd_hrp1000 INTO lwa_hrp1000 WITH KEY otype = 'S '
                                                       objid = <result>-positioncode.
      IF sy-subrc = 0.
        <result>-positiontext = lwa_hrp1000-stext.
      ENDIF.

      READ TABLE gtd_hrp1000 INTO lwa_hrp1000 WITH KEY otype = 'C '
                                                       objid = <result>-functioncode.
      IF sy-subrc = 0.
        <result>-functiontext = lwa_hrp1000-stext.
      ENDIF.

      READ TABLE gtd_hrp1000 INTO lwa_hrp1000 WITH  KEY otype = 'O '
                                                        objid = <result>-organizationalunit.
      IF sy-subrc = 0.
        <result>-orgunittext = lwa_hrp1000-stext.
      ENDIF.

                                                            " @}0001

      " Textos de AFP
      ASSIGN gth_ztbmafp[ afpkl = <result>-pensionsystem ] TO FIELD-SYMBOL(<fs_ztbmafp>).
      IF sy-subrc = 0.
        <result>-pensionsystemname = <fs_ztbmafp>-afpds.
      ENDIF.

      " Categoria interna
      ASSIGN gth_t591s[ infty = '0034'
                        subty = <result>-internalcategory ] TO FIELD-SYMBOL(<fs_t591s>).
      IF sy-subrc = 0.
        <result>-internalcategorytext = <fs_t591s>-stext.
      ENDIF.

      " Tipo de poder
      ASSIGN gth_t591s[ infty = '0030'
                        subty = <result>-powertype ] TO <fs_t591s>.
      IF sy-subrc = 0.
        <result>-powertypetext = <fs_t591s>-stext.
      ENDIF.

      " Texto de horario
      ASSIGN gth_t508s[ zeity = gc_zeity
                        mofid = <result>-holidaycalendar
                        mosid = gc_mosid
                        schkz = <result>-workschedulecode ] TO <fs_t508s>.
      IF sy-subrc = 0.
        <result>-workscheduletext = <fs_t508s>-rtext.
      ENDIF.

      " Se lee el código de la posicion
      ASSIGN gtd_posres[ orgeh = <result>-organizationalunit ] TO <fs_posres>.
      IF sy-subrc = 0.
        ASSIGN gtd_codres[ objid = <fs_posres>-obji2 ] TO <fs_codres>.
        IF sy-subrc = 0.
          " Nombres de jefatura

          <result>-managerpersonnelid = <fs_codres>-pernr.
          LOOP AT gtd_pa0002 ASSIGNING FIELD-SYMBOL(<fs_pa0002>) WHERE pernr = <fs_codres>-pernr.
            CONCATENATE <fs_pa0002>-nachn <fs_pa0002>-nach2 <fs_pa0002>-vorna
                        INTO <result>-managername
                        SEPARATED BY space.
            CONDENSE <result>-managername.
            EXIT.
          ENDLOOP.

          LOOP AT gtd_pa0185 ASSIGNING FIELD-SYMBOL(<fs_pa0185>) WHERE pernr = <fs_codres>-pernr.
            IF <fs_pa0185>-subty = '01'.
              <result>-managerdoctype = TEXT-t01.
            ELSEIF <fs_pa0185>-subty = '02'.
              <result>-managerdoctype = TEXT-t02.
            ENDIF.
            <result>-managerdocumentnumber = <fs_pa0185>-icnum.
            EXIT.
          ENDLOOP.

        ENDIF.
      ENDIF.


    ENDLOOP.
  ENDMETHOD.





  METHOD proces_matrix_report.

    DATA: lv_pernr TYPE pernr_d,
          ldt_ity  TYPE tty_ity.

    ini_matricial( CHANGING ip_pernr = lv_pernr it_ity = ldt_ity ).
    exe_matricial( CHANGING  it_ity = ldt_ity results = results ).


  ENDMETHOD.

  METHOD ini_matricial.
    DATA gs_pernr TYPE pernr_d.

    CALL FUNCTION 'Z_HR_WF_LEE_PERSONA_CON_USUARI' DESTINATION 'NONE'
      EXPORTING
        ip_usrid = sy-uname
      IMPORTING
        ep_pernr = ip_pernr.

    IF ip_pernr IS INITIAL.
      RETURN.
    ENDIF.

    SELECT DISTINCT i1~pernr,
                    i1~subty,
                    i1~objps,
                    i1~sprps,
                    i1~endda,
                    i1~begda,
                    i1~seqnr,
                    i1~bukrs,
                    i1~werks,
                    i1~persg,
                    i1~persk,
                    i1~orgeh,
                    i1~plans,
                    i1~stell,
                    ts~stltx,
                    i2~nachn,
                    i2~nach2,
                    i2~vorna
      INTO CORRESPONDING FIELDS OF TABLE @it_ity
      FROM pa0001 AS i1
             INNER JOIN
               pa0002 AS i2 ON i2~pernr = i1~pernr AND i1~begda <= @sy-datum AND i1~endda >= @sy-datum
                 LEFT JOIN
                   t513s AS ts ON ts~stell = i1~stell AND ts~sprsl = @sy-langu AND ts~endda >= @sy-datum
      WHERE i1~pernr  = @ip_pernr
        AND i1~endda >= @sy-datum.
    SORT it_ity BY begda DESCENDING.
  ENDMETHOD.

  METHOD exe_matricial.


    DATA gwa_objid    LIKE LINE OF gr_objid.
    DATA gwa_plans    LIKE LINE OF gr_plans.

    READ TABLE it_ity INTO gwa_ityo INDEX 1.
    IF sy-subrc = 0.
      DATA(gv_plans) = gwa_ityo-plans.

      " Se obtiene la posición del jefe del chapter (cod. pos.: SOBID)
      SELECT 'I'   AS sign,
             'EQ'  AS option,
             sobid AS low
        FROM hrp1001
        INTO TABLE @gr_sobida
        WHERE objid  = @gv_plans
          AND otype  = 'S'
          AND sclas  = 'S'
          AND rsign  = 'A'
          AND begda <= @sy-datum
          AND endda >= @sy-datum.

      " Se obtienen las pos. de subordinados del chapter (cod. pos.: SOBID)
      SELECT 'I'   AS sign,
             'EQ'  AS option,
             sobid AS low
        FROM hrp1001
        INTO TABLE @gr_sobidb
        WHERE objid  = @gv_plans
          AND otype  = 'S'
          AND sclas  = 'S'
          AND rsign  = 'B'
          AND begda <= @sy-datum
          AND endda >= @sy-datum.

      IF gr_sobidb[] IS NOT INITIAL. " Rango de códigos de pos. (sub)
        SELECT 'B'   AS rsign,
               objid,
               sobid,
               begda,
               endda
          FROM hrp1001
          INTO CORRESPONDING FIELDS OF TABLE @gtd_itemp
          WHERE hrp1001~otype  = 'S'
            AND hrp1001~sclas  = 'P'
            AND begda         <= @sy-datum "+cft
            AND endda         >= @sy-datum "+cft
            AND hrp1001~objid IN @gr_sobidb.
        IF gtd_itemp[] IS INITIAL.

          MESSAGE TEXT-e01 TYPE 'S' DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.
      ELSE.
        MESSAGE TEXT-e01 TYPE 'S' DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      IF gr_sobida[] IS NOT INITIAL. " Rango de códigos de pos (sup)
        SELECT 'A'   AS rsign,
               objid,
               sobid,
               begda,
               endda
          FROM hrp1001
          APPENDING CORRESPONDING FIELDS OF TABLE @gtd_itemp
          WHERE hrp1001~otype  = 'S'
            AND hrp1001~sclas  = 'P'
            AND hrp1001~objid IN @gr_sobida
            AND begda         <= @sy-datum
            AND endda         >= @sy-datum.
      ENDIF.

      IF gtd_itemp[] IS NOT INITIAL. " Tabla con los códigos de personal: SOBID(8)
        gr_pernr = VALUE #( FOR lwa_p IN gtd_itemp
                            ( sign = 'I' option = 'EQ' low = lwa_p-sobid(8) ) ).

*        PERFORM get_infotipos TABLES gtd_ityd USING gr_pernr.
        IF gr_pernr IS NOT INITIAL.
          SELECT DISTINCT i1~pernr,
                          i1~subty,
                          i1~objps,
                          i1~sprps,
                          i1~endda,
                          i1~begda,
                          i1~seqnr,
                          i1~bukrs,
                          i1~werks,
                          i1~persg,
                          i1~persk,
                          i1~orgeh,
                          i1~plans,
                          i1~stell,
                          ts~stltx,
                          i2~nachn,
                          i2~nach2,
                          i2~vorna
            INTO CORRESPONDING FIELDS OF TABLE @it_ity
            FROM pa0001 AS i1
                   INNER JOIN
                     pa0002 AS i2 ON i2~pernr = i1~pernr AND i1~begda <= @sy-datum AND i1~endda >= @sy-datum
                       LEFT JOIN
                         t513s AS ts ON ts~stell = i1~stell AND ts~sprsl = @sy-langu AND ts~endda >= @sy-datum
            WHERE i1~pernr IN @gr_pernr
              AND i1~endda >= @sy-datum.
        ENDIF.

        IF it_ity[] IS NOT INITIAL.
          gr_plans = VALUE #( FOR lwa_ps IN it_ity
                              ( sign = 'I' option = 'EQ' low = lwa_ps-plans ) ).
          gwa_plans = 'IEQ'.
          gwa_plans-low = gv_plans.
          APPEND gwa_plans TO gr_plans.

          CLEAR gwa_plans.

          DELETE gr_plans WHERE low IS INITIAL.
          SORT gr_plans BY low.
          DELETE ADJACENT DUPLICATES FROM gr_plans COMPARING low.
        ENDIF.

        IF gr_plans[] IS NOT INITIAL.
          SELECT otype objid plvar rsign relat istat priox begda endda seqnr varyf subty sobid
            FROM hrp1001
            INTO CORRESPONDING FIELDS OF TABLE gtd_hrp1001_
            WHERE otype  = 'S'
              AND objid IN gr_plans
              AND ( subty = gc_a970 OR subty = gc_a971 ) "+@0009 Se obtienen 2 Squads
              AND begda <= sy-datum
              AND endda >= sy-datum
              AND plvar  = '01'.
          IF gtd_hrp1001_[] IS NOT INITIAL.
            gr_objid = VALUE #( FOR lwa_x IN gtd_hrp1001_
                                ( sign = 'I' option = 'EQ' low = CONV hrobjid( lwa_x-sobid ) ) ).

            DELETE gr_objid WHERE low IS INITIAL.
            SORT gr_objid BY low.
            DELETE ADJACENT DUPLICATES FROM gr_objid COMPARING low.

            " Nueva consulta para obtener las Tribus
            SELECT otype objid plvar rsign relat istat priox begda endda seqnr varyf subty sobid
              FROM hrp1001
              INTO CORRESPONDING FIELDS OF TABLE gtd_tribus
              WHERE otype  = 'O'
                AND objid IN gr_objid
                AND plvar  = '01'
                AND rsign  = 'A'
                AND relat  = '002'
                AND begda <= sy-datum
                AND endda >= sy-datum
                AND sclas  = 'O'.
            LOOP AT gtd_tribus INTO DATA(gwa_tribu).
              IF gwa_tribu-sobid IS NOT INITIAL.
                CLEAR gwa_objid-low.
                gwa_objid = 'IEQ'.
                gwa_objid-low = CONV hrobjid( gwa_tribu-sobid ).
                APPEND gwa_objid TO gr_objid.
              ENDIF.
            ENDLOOP.
            SORT gr_objid BY low.
            DELETE ADJACENT DUPLICATES FROM gr_objid COMPARING low.
                                                            " }+@0009
          ENDIF.
        ENDIF.

        IF gr_objid[] IS NOT INITIAL.
          SELECT plvar otype objid istat begda endda langu seqnr stext
            FROM hrp1000
            INTO CORRESPONDING FIELDS OF TABLE gtd_hrp1000_
            WHERE plvar  = '01'
              AND otype  = 'O'
              AND objid IN gr_objid
              AND begda <= sy-datum
              AND endda >= sy-datum.
        ENDIF.
      ENDIF.

      SORT gtd_itemp BY rsign ASCENDING.

*      PERFORM display_fullscreen.
      suplay_data( CHANGING results = results it_ity = it_ity ).
    ELSE.
      RETURN.
      MESSAGE TEXT-e03 TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ENDMETHOD.

  METHOD suplay_data.
    DATA gv_pernr_ TYPE pernr_d.
    DATA gv_tabix  TYPE sytabix.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA gv_sub    TYPE sytabix.
    DATA gv_objid  TYPE objid.
    DATA gwa_ity   LIKE LINE OF it_ity.
    DATA gwa_tribu LIKE LINE OF gtd_tribus.

    DATA(gv_plans) = gwa_ityo-plans.
    LOOP AT gtd_itemp ASSIGNING FIELD-SYMBOL(<fs_tmp>).
      CLEAR: gv_pernr_,
             gwa_ity.
      CLEAR: gv_objid,
             gwa_tribu.
      gv_tabix += 1.
      gv_pernr_ = <fs_tmp>-sobid(8).

      READ TABLE it_ity  INTO gwa_ity WITH KEY pernr = gv_pernr_.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      APPEND INITIAL LINE TO results ASSIGNING FIELD-SYMBOL(<fs_rpt>).
      <fs_rpt>-rolesignsuperiorsubordinate = <fs_tmp>-rsign.
      <fs_rpt>-positionenddate             = <fs_tmp>-endda.
      <fs_rpt>-recordnumber                = gv_tabix.
      IF <fs_tmp>-rsign = 'A'. " Superior.
        <fs_rpt>-supervisorpersonnelnumber   = gwa_ity-pernr.
        <fs_rpt>-supervisorfunction          = gwa_ity-stell.
        <fs_rpt>-supervisorpositionnumber    = gwa_ity-plans.
        <fs_rpt>-supervisorlastnamepaternal  = gwa_ity-nachn.
        <fs_rpt>-supervisorlastnamematernal  = gwa_ity-nach2.
        <fs_rpt>-supervisorfirstname         = gwa_ity-vorna.
        <fs_rpt>-supervisorfunctiontext      = gwa_ity-stltx.

        <fs_rpt>-subordinatepersonnelnumber  = <fs_rpt>-supervisorpersonnelnumber.
        <fs_rpt>-subordinatefunction         = <fs_rpt>-supervisorfunction.
        <fs_rpt>-subordinatepositionnumber   = <fs_rpt>-supervisorpositionnumber.
        <fs_rpt>-subordinatelastnamepaternal = <fs_rpt>-supervisorlastnamepaternal.
        <fs_rpt>-subordinatelastnamematernal = <fs_rpt>-supervisorlastnamematernal.
        <fs_rpt>-subordinatefirstname        = <fs_rpt>-supervisorfirstname.
        <fs_rpt>-subordinatefunctiontext     = <fs_rpt>-supervisorfunctiontext.
        <fs_rpt>-subordinatetribecode        = <fs_rpt>-supervisortribecode.
        <fs_rpt>-subordinatetribetext        = <fs_rpt>-supervisortribetext.
      ELSE.
        gv_sub += 1.
        <fs_rpt>-subordinatepersonnelnumber  = gwa_ity-pernr.
        <fs_rpt>-subordinatefunction         = gwa_ity-stell.
        <fs_rpt>-subordinatepositionnumber   = gwa_ity-plans.
        <fs_rpt>-subordinatelastnamepaternal = gwa_ity-nachn.
        <fs_rpt>-subordinatelastnamematernal = gwa_ity-nach2.
        <fs_rpt>-subordinatefirstname        = gwa_ity-vorna.
        <fs_rpt>-subordinatefunctiontext     = gwa_ity-stltx.
        " Leyendo SQUAD del subordinado
        ASSIGN gtd_hrp1001_[ objid = <fs_tmp>-objid
                             subty = gc_a970 ] TO FIELD-SYMBOL(<fs_hrp1001_>).
        IF sy-subrc = 0.
          <fs_rpt>-subordinatesquadcode = <fs_hrp1001_>-sobid.
          ASSIGN gtd_hrp1000_[ objid = <fs_hrp1001_>-sobid ] TO FIELD-SYMBOL(<fs_hrp1000_>).
          IF sy-subrc = 0.
            <fs_rpt>-subordinatesquadtext = <fs_hrp1000_>-stext.
          ENDIF.
        ENDIF.

        " Leyendo SQUAD 2 del subordinado
        ASSIGN gtd_hrp1001_[ objid = <fs_tmp>-objid
                             subty = gc_a971 ] TO <fs_hrp1001_>.
        IF sy-subrc = 0.
          <fs_rpt>-subordinatesquadcode2 = <fs_hrp1001_>-sobid.
          ASSIGN gtd_hrp1000_[ objid = <fs_hrp1001_>-sobid ] TO <fs_hrp1000_>.
          IF sy-subrc = 0.
            <fs_rpt>-subordinatesquad2text = <fs_hrp1000_>-stext.
          ENDIF.
        ENDIF.
        " Leyendo Tribu del subordinado
        IF <fs_rpt>-subordinatesquadcode IS NOT INITIAL. " Si Squad 1 no es vacio
          gv_objid = <fs_rpt>-subordinatesquadcode.
        ELSE.
          gv_objid = <fs_rpt>-subordinatesquadcode2.
        ENDIF.

        IF gv_objid IS NOT INITIAL.
          READ TABLE gtd_tribus INTO gwa_tribu WITH KEY objid = gv_objid.
          IF sy-subrc = 0.
            <fs_rpt>-subordinatetribecode = gwa_tribu-sobid.
            ASSIGN gtd_hrp1000_[ objid = gwa_tribu-sobid ] TO <fs_hrp1000_>.
            IF sy-subrc = 0.
              <fs_rpt>-subordinatetribetext = <fs_hrp1000_>-stext.
            ENDIF.
          ENDIF.
        ENDIF.

        <fs_rpt>-supervisorpersonnelnumber  = gwa_ityo-pernr.
        <fs_rpt>-supervisorfunction         = gwa_ityo-stell.
        <fs_rpt>-supervisorpositionnumber   = gwa_ityo-plans.
        <fs_rpt>-supervisorlastnamepaternal = gwa_ityo-nachn.
        <fs_rpt>-supervisorlastnamematernal = gwa_ityo-nach2.
        <fs_rpt>-supervisorfirstname        = gwa_ityo-vorna.
        <fs_rpt>-supervisorfunctiontext     = gwa_ityo-stltx.
        " Leyendo SQUAD del user
        ASSIGN gtd_hrp1001_[ objid = gv_plans
                             subty = gc_a970 ] TO <fs_hrp1001_>.
        IF sy-subrc = 0.
          <fs_rpt>-supervisorsquadcode = <fs_hrp1001_>-sobid.
          ASSIGN gtd_hrp1000_[ objid = <fs_hrp1001_>-sobid ] TO <fs_hrp1000_>.
          IF sy-subrc = 0.
            <fs_rpt>-supervisorsquadtext = <fs_hrp1000_>-stext.
          ENDIF.
        ENDIF.
                                                            " +@0009{
        CLEAR: gv_objid,
               gwa_tribu.
        " Leyendo SQUAD 2 del user
        ASSIGN gtd_hrp1001_[ objid = gv_plans
                             subty = gc_a971 ] TO <fs_hrp1001_>.
        IF sy-subrc = 0.
          <fs_rpt>-subordinatesquadcode2 = <fs_hrp1001_>-sobid.
          ASSIGN gtd_hrp1000_[ objid = <fs_hrp1001_>-sobid ] TO <fs_hrp1000_>.
          IF sy-subrc = 0.
            <fs_rpt>-subordinatesquad2text = <fs_hrp1000_>-stext.
          ENDIF.
        ENDIF.
        " Leyendo Tribu del subordinado
        IF <fs_rpt>-supervisorsquadcode IS NOT INITIAL. " Si Squad 1 no es vacio
          gv_objid = <fs_rpt>-supervisorsquadcode.
        ELSE.
          gv_objid = <fs_rpt>-subordinatesquadcode2.
        ENDIF.

        IF gv_objid IS NOT INITIAL.
          READ TABLE gtd_tribus INTO gwa_tribu WITH KEY objid = gv_objid.
          IF sy-subrc = 0.
            <fs_rpt>-supervisortribecode = gwa_tribu-sobid.
            ASSIGN gtd_hrp1000_[ objid = gwa_tribu-sobid ] TO <fs_hrp1000_>.
            IF sy-subrc = 0.
              <fs_rpt>-supervisortribetext = <fs_hrp1000_>-stext.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD proces_matrix_report_tree.
    DATA: lv_pernr TYPE pernr_d,
          ldt_ity  TYPE tty_ity.

    ini_matricial( CHANGING ip_pernr = lv_pernr it_ity = ldt_ity ).
    exe_matricial_tree( CHANGING  it_ity = ldt_ity results = results ).

  ENDMETHOD.


  METHOD exe_matricial_tree.
    DATA gwa_objid    LIKE LINE OF gr_objid.
    DATA gwa_plans    LIKE LINE OF gr_plans.

    READ TABLE it_ity INTO gwa_ityo INDEX 1.
    IF sy-subrc = 0.
      DATA(gv_plans) = gwa_ityo-plans.

      " Se obtiene la posición del jefe del chapter (cod. pos.: SOBID)
      SELECT 'I'   AS sign,
             'EQ'  AS option,
             sobid AS low
        FROM hrp1001
        INTO TABLE @gr_sobida
        WHERE objid  = @gv_plans
          AND otype  = 'S'
          AND sclas  = 'S'
          AND rsign  = 'A'
          AND begda <= @sy-datum
          AND endda >= @sy-datum.

      " Se obtienen las pos. de subordinados del chapter (cod. pos.: SOBID)
      SELECT 'I'   AS sign,
             'EQ'  AS option,
             sobid AS low
        FROM hrp1001
        INTO TABLE @gr_sobidb
        WHERE objid  = @gv_plans
          AND otype  = 'S'
          AND sclas  = 'S'
          AND rsign  = 'B'
          AND begda <= @sy-datum
          AND endda >= @sy-datum.

      IF gr_sobidb[] IS NOT INITIAL. " Rango de códigos de pos. (sub)
        SELECT 'B'   AS rsign,
               objid,
               sobid,
               begda,
               endda
          FROM hrp1001
          INTO CORRESPONDING FIELDS OF TABLE @gtd_itemp
          WHERE hrp1001~otype  = 'S'
            AND hrp1001~sclas  = 'P'
            AND begda         <= @sy-datum "+cft
            AND endda         >= @sy-datum "+cft
            AND hrp1001~objid IN @gr_sobidb.
        IF gtd_itemp[] IS INITIAL.

          MESSAGE TEXT-e01 TYPE 'S' DISPLAY LIKE 'E'.
          RETURN.
        ENDIF.
      ELSE.
        MESSAGE TEXT-e01 TYPE 'S' DISPLAY LIKE 'E'.
        RETURN.
      ENDIF.

      IF gr_sobida[] IS NOT INITIAL. " Rango de códigos de pos (sup)
        SELECT 'A'   AS rsign,
               objid,
               sobid,
               begda,
               endda
          FROM hrp1001
          APPENDING CORRESPONDING FIELDS OF TABLE @gtd_itemp
          WHERE hrp1001~otype  = 'S'
            AND hrp1001~sclas  = 'P'
            AND hrp1001~objid IN @gr_sobida
            AND begda         <= @sy-datum
            AND endda         >= @sy-datum.
      ENDIF.

      IF gtd_itemp[] IS NOT INITIAL. " Tabla con los códigos de personal: SOBID(8)
        gr_pernr = VALUE #( FOR lwa_p IN gtd_itemp
                            ( sign = 'I' option = 'EQ' low = lwa_p-sobid(8) ) ).

*        PERFORM get_infotipos TABLES gtd_ityd USING gr_pernr.
        IF gr_pernr IS NOT INITIAL.
          SELECT DISTINCT i1~pernr,
                          i1~subty,
                          i1~objps,
                          i1~sprps,
                          i1~endda,
                          i1~begda,
                          i1~seqnr,
                          i1~bukrs,
                          i1~werks,
                          i1~persg,
                          i1~persk,
                          i1~orgeh,
                          i1~plans,
                          i1~stell,
                          ts~stltx,
                          i2~nachn,
                          i2~nach2,
                          i2~vorna
            INTO CORRESPONDING FIELDS OF TABLE @it_ity
            FROM pa0001 AS i1
                   INNER JOIN
                     pa0002 AS i2 ON i2~pernr = i1~pernr AND i1~begda <= @sy-datum AND i1~endda >= @sy-datum
                       LEFT JOIN
                         t513s AS ts ON ts~stell = i1~stell AND ts~sprsl = @sy-langu AND ts~endda >= @sy-datum
            WHERE i1~pernr IN @gr_pernr
              AND i1~endda >= @sy-datum.
        ENDIF.

        IF it_ity[] IS NOT INITIAL.
          gr_plans = VALUE #( FOR lwa_ps IN it_ity
                              ( sign = 'I' option = 'EQ' low = lwa_ps-plans ) ).
          gwa_plans = 'IEQ'.
          gwa_plans-low = gv_plans.
          APPEND gwa_plans TO gr_plans.

          CLEAR gwa_plans.

          DELETE gr_plans WHERE low IS INITIAL.
          SORT gr_plans BY low.
          DELETE ADJACENT DUPLICATES FROM gr_plans COMPARING low.
        ENDIF.

        IF gr_plans[] IS NOT INITIAL.
          SELECT otype objid plvar rsign relat istat priox begda endda seqnr varyf subty sobid
            FROM hrp1001
            INTO CORRESPONDING FIELDS OF TABLE gtd_hrp1001_
            WHERE otype  = 'S'
              AND objid IN gr_plans
              AND ( subty = gc_a970 OR subty = gc_a971 ) "+@0009 Se obtienen 2 Squads
              AND begda <= sy-datum
              AND endda >= sy-datum
              AND plvar  = '01'.
          IF gtd_hrp1001_[] IS NOT INITIAL.
            gr_objid = VALUE #( FOR lwa_x IN gtd_hrp1001_
                                ( sign = 'I' option = 'EQ' low = CONV hrobjid( lwa_x-sobid ) ) ).

            DELETE gr_objid WHERE low IS INITIAL.
            SORT gr_objid BY low.
            DELETE ADJACENT DUPLICATES FROM gr_objid COMPARING low.

            " Nueva consulta para obtener las Tribus
            SELECT otype objid plvar rsign relat istat priox begda endda seqnr varyf subty sobid
              FROM hrp1001
              INTO CORRESPONDING FIELDS OF TABLE gtd_tribus
              WHERE otype  = 'O'
                AND objid IN gr_objid
                AND plvar  = '01'
                AND rsign  = 'A'
                AND relat  = '002'
                AND begda <= sy-datum
                AND endda >= sy-datum
                AND sclas  = 'O'.
            LOOP AT gtd_tribus INTO DATA(gwa_tribu).
              IF gwa_tribu-sobid IS NOT INITIAL.
                CLEAR gwa_objid-low.
                gwa_objid = 'IEQ'.
                gwa_objid-low = CONV hrobjid( gwa_tribu-sobid ).
                APPEND gwa_objid TO gr_objid.
              ENDIF.
            ENDLOOP.
            SORT gr_objid BY low.
            DELETE ADJACENT DUPLICATES FROM gr_objid COMPARING low.
                                                            " }+@0009
          ENDIF.
        ENDIF.

        IF gr_objid[] IS NOT INITIAL.
          SELECT plvar otype objid istat begda endda langu seqnr stext
            FROM hrp1000
            INTO CORRESPONDING FIELDS OF TABLE gtd_hrp1000_
            WHERE plvar  = '01'
              AND otype  = 'O'
              AND objid IN gr_objid
              AND begda <= sy-datum
              AND endda >= sy-datum.
        ENDIF.
      ENDIF.

      SORT gtd_itemp BY rsign ASCENDING.

*      PERFORM display_fullscreen.
      suplay_data_tree( CHANGING results = results it_ity = it_ity ).
    ELSE.
      RETURN.
      MESSAGE TEXT-e03 TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ENDMETHOD.


  METHOD suplay_data_tree.
    DATA gv_pernr_ TYPE pernr_d.
    DATA gv_tabix  TYPE sytabix.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA gv_sub    TYPE sytabix.
    DATA gv_objid  TYPE objid.
    DATA gwa_ity   LIKE LINE OF it_ity.
    DATA gwa_tribu LIKE LINE OF gtd_tribus.

    DATA(gv_plans) = gwa_ityo-plans.
    LOOP AT gtd_itemp ASSIGNING FIELD-SYMBOL(<fs_tmp>).
      CLEAR: gv_pernr_,
             gwa_ity.
      CLEAR: gv_objid,
             gwa_tribu.
      gv_tabix += 1.
      gv_pernr_ = <fs_tmp>-sobid(8).

      READ TABLE it_ity  INTO gwa_ity WITH KEY pernr = gv_pernr_.
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      APPEND INITIAL LINE TO results ASSIGNING FIELD-SYMBOL(<fs_rpt>).
      <fs_rpt>-rolesignsuperiorsubordinate = <fs_tmp>-rsign.
      <fs_rpt>-positionenddate             = <fs_tmp>-endda.
      <fs_rpt>-recordnumber                = gv_tabix.
      IF <fs_tmp>-rsign = 'A'. " Superior.
        <fs_rpt>-supervisorpersonnelnumber   = gwa_ity-pernr.
        <fs_rpt>-supervisorfunction          = gwa_ity-stell.
        <fs_rpt>-supervisorpositionnumber    = gwa_ity-plans.
        <fs_rpt>-supervisorlastnamepaternal  = gwa_ity-nachn.
        <fs_rpt>-supervisorlastnamematernal  = gwa_ity-nach2.
        <fs_rpt>-supervisorfirstname         = gwa_ity-vorna.
        <fs_rpt>-supervisorfunctiontext      = gwa_ity-stltx.

        <fs_rpt>-subordinatepersonnelnumber  = <fs_rpt>-supervisorpersonnelnumber.
        <fs_rpt>-subordinatefunction         = <fs_rpt>-supervisorfunction.
        <fs_rpt>-subordinatepositionnumber   = <fs_rpt>-supervisorpositionnumber.
        <fs_rpt>-subordinatelastnamepaternal = <fs_rpt>-supervisorlastnamepaternal.
        <fs_rpt>-subordinatelastnamematernal = <fs_rpt>-supervisorlastnamematernal.
        <fs_rpt>-subordinatefirstname        = <fs_rpt>-supervisorfirstname.
        <fs_rpt>-subordinatefunctiontext     = <fs_rpt>-supervisorfunctiontext.
        <fs_rpt>-subordinatetribecode        = <fs_rpt>-supervisortribecode.
        <fs_rpt>-subordinatetribetext        = <fs_rpt>-supervisortribetext.
      ELSE.
        gv_sub += 1.
        <fs_rpt>-subordinatepersonnelnumber  = gwa_ity-pernr.
        <fs_rpt>-subordinatefunction         = gwa_ity-stell.
        <fs_rpt>-subordinatepositionnumber   = gwa_ity-plans.
        <fs_rpt>-subordinatelastnamepaternal = gwa_ity-nachn.
        <fs_rpt>-subordinatelastnamematernal = gwa_ity-nach2.
        <fs_rpt>-subordinatefirstname        = gwa_ity-vorna.
        <fs_rpt>-subordinatefunctiontext     = gwa_ity-stltx.
        " Leyendo SQUAD del subordinado
        ASSIGN gtd_hrp1001_[ objid = <fs_tmp>-objid
                             subty = gc_a970 ] TO FIELD-SYMBOL(<fs_hrp1001_>).
        IF sy-subrc = 0.
          <fs_rpt>-subordinatesquadcode = <fs_hrp1001_>-sobid.
          ASSIGN gtd_hrp1000_[ objid = <fs_hrp1001_>-sobid ] TO FIELD-SYMBOL(<fs_hrp1000_>).
          IF sy-subrc = 0.
            <fs_rpt>-subordinatesquadtext = <fs_hrp1000_>-stext.
          ENDIF.
        ENDIF.

        " Leyendo SQUAD 2 del subordinado
        ASSIGN gtd_hrp1001_[ objid = <fs_tmp>-objid
                             subty = gc_a971 ] TO <fs_hrp1001_>.
        IF sy-subrc = 0.
          <fs_rpt>-subordinatesquadcode2 = <fs_hrp1001_>-sobid.
          ASSIGN gtd_hrp1000_[ objid = <fs_hrp1001_>-sobid ] TO <fs_hrp1000_>.
          IF sy-subrc = 0.
            <fs_rpt>-subordinatesquad2text = <fs_hrp1000_>-stext.
          ENDIF.
        ENDIF.
        " Leyendo Tribu del subordinado
        IF <fs_rpt>-subordinatesquadcode IS NOT INITIAL. " Si Squad 1 no es vacio
          gv_objid = <fs_rpt>-subordinatesquadcode.
        ELSE.
          gv_objid = <fs_rpt>-subordinatesquadcode2.
        ENDIF.

        IF gv_objid IS NOT INITIAL.
          READ TABLE gtd_tribus INTO gwa_tribu WITH KEY objid = gv_objid.
          IF sy-subrc = 0.
            <fs_rpt>-subordinatetribecode = gwa_tribu-sobid.
            ASSIGN gtd_hrp1000_[ objid = gwa_tribu-sobid ] TO <fs_hrp1000_>.
            IF sy-subrc = 0.
              <fs_rpt>-subordinatetribetext = <fs_hrp1000_>-stext.
            ENDIF.
          ENDIF.
        ENDIF.

        <fs_rpt>-supervisorpersonnelnumber  = gwa_ityo-pernr.
        <fs_rpt>-supervisorfunction         = gwa_ityo-stell.
        <fs_rpt>-supervisorpositionnumber   = gwa_ityo-plans.
        <fs_rpt>-supervisorlastnamepaternal = gwa_ityo-nachn.
        <fs_rpt>-supervisorlastnamematernal = gwa_ityo-nach2.
        <fs_rpt>-supervisorfirstname        = gwa_ityo-vorna.
        <fs_rpt>-supervisorfunctiontext     = gwa_ityo-stltx.
        " Leyendo SQUAD del user
        ASSIGN gtd_hrp1001_[ objid = gv_plans
                             subty = gc_a970 ] TO <fs_hrp1001_>.
        IF sy-subrc = 0.
          <fs_rpt>-supervisorsquadcode = <fs_hrp1001_>-sobid.
          ASSIGN gtd_hrp1000_[ objid = <fs_hrp1001_>-sobid ] TO <fs_hrp1000_>.
          IF sy-subrc = 0.
            <fs_rpt>-supervisorsquadtext = <fs_hrp1000_>-stext.
          ENDIF.
        ENDIF.
                                                            " +@0009{
        CLEAR: gv_objid,
               gwa_tribu.
        " Leyendo SQUAD 2 del user
        ASSIGN gtd_hrp1001_[ objid = gv_plans
                             subty = gc_a971 ] TO <fs_hrp1001_>.
        IF sy-subrc = 0.
          <fs_rpt>-subordinatesquadcode2 = <fs_hrp1001_>-sobid.
          ASSIGN gtd_hrp1000_[ objid = <fs_hrp1001_>-sobid ] TO <fs_hrp1000_>.
          IF sy-subrc = 0.
            <fs_rpt>-subordinatesquad2text = <fs_hrp1000_>-stext.
          ENDIF.
        ENDIF.
        " Leyendo Tribu del subordinado
        IF <fs_rpt>-supervisorsquadcode IS NOT INITIAL. " Si Squad 1 no es vacio
          gv_objid = <fs_rpt>-supervisorsquadcode.
        ELSE.
          gv_objid = <fs_rpt>-subordinatesquadcode2.
        ENDIF.

        IF gv_objid IS NOT INITIAL.
          READ TABLE gtd_tribus INTO gwa_tribu WITH KEY objid = gv_objid.
          IF sy-subrc = 0.
            <fs_rpt>-supervisortribecode = gwa_tribu-sobid.
            ASSIGN gtd_hrp1000_[ objid = gwa_tribu-sobid ] TO <fs_hrp1000_>.
            IF sy-subrc = 0.
              <fs_rpt>-supervisortribetext = <fs_hrp1000_>-stext.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
