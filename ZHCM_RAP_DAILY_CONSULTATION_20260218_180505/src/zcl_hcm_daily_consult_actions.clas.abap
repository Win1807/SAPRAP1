CLASS zcl_hcm_daily_consult_actions DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: BEGIN OF gty_marcas,
             pernr TYPE pa0001-pernr, " Codigo
             ldate TYPE teven-ldate,  " Fe.marca
             satza TYPE teven-satza,  " P10->ingreso / P20->salida
             ltime TYPE teven-ltime,  " Hora INGRESO real
             terid TYPE p2011-terid,  " ID terminal
             sobeg TYPE t550a-sobeg,  " Hora INGRESO teorico
             soend TYPE t550a-soend.  " Hora SALIDA teorico
    TYPES: END OF gty_marcas.
* Registro final de marcas
    TYPES: BEGIN OF gty_regfinmar,
             pernr    TYPE pa0001-pernr, " Codigo
             ldate    TYPE teven-ldate,  " Fe.marca
             ltimei   TYPE teven-ltime,  " Hora INGRESO real
             ltimes   TYPE teven-ltime,  " Hora SALIDA real
             terid    TYPE p2011-terid,  " ID terminal
             sobeg    TYPE t550a-sobeg,  " Hora INGRESO teorico
             soend    TYPE t550a-soend,  " Hora SALIDA teorico
             tprog    TYPE t550a-tprog,  " Plan horario trabajo diario:LIBR,LIVI,LISA
* { +@0004 Marcas de pausas
             ltimeipa TYPE teven-ltime,  " Hora INGRESO MARCA
             ltimespa TYPE teven-ltime.  " Hora SALIDA MARCA
* } +@0004 Marcas de pausas
    TYPES: END OF gty_regfinmar.
* CC-nóminas
    TYPES: BEGIN OF gty_t511,
             molga TYPE t511-molga,
             lgart TYPE t511-lgart,
             endda TYPE t511-endda,
             modna TYPE t511-modna.
    TYPES: END OF gty_t511.
    TYPES: BEGIN OF gty_output,
             pernr     TYPE pa0001-pernr,            " Codigo
             nachn     TYPE pa0002-nachn,            " Apellido
             nach2     TYPE pa0002-nach2,            " Segundo apellido
             vorna     TYPE pa0002-vorna,            " Nombre de pila
             ldate     TYPE teven-ldate,             " Fe.marca
             sobeg     TYPE t550a-sobeg,             " Hora INGRESO teorico
             soend     TYPE t550a-soend,             " Hora SALIDA teorico
             ltimei    TYPE teven-ltime,             " Hora INGRESO real
             ltimes    TYPE teven-ltime,             " Hora SALIDA real
             difhor    TYPE t550a-sobeg,             " Diferencia en minutos u horas
             coshrh    TYPE p0008-bet01,             " Costo horas hombre
             awart     TYPE pa2001-awart,            " Tipo de ausentismos
             terid     TYPE p2011-terid,             " ID terminal
             txidt     TYPE ztterminal-znom_oficina, " Texto ID terminal
             atext     TYPE t554t-atext,             " Txt. clas.ausentismo
             nomcom    TYPE char62,                  " Nombres completos: Ap.Paterno + Ap.Materno + Nombres

* Estructura organizativa
             divisi    TYPE p0001-zz_division,       " Division
             area      TYPE p0001-zz_area,           " Area
             servi     TYPE p0001-zz_servicio,       " Servicio
             orgeh     TYPE p0001-orgeh,             " Unid.organizativa
             txdiv     TYPE t527x-orgtx,             " Texto Division
             txare     TYPE t527x-orgtx,             " Texto Area
             txser     TYPE t527x-orgtx,             " Texto servicio
             txorg     TYPE t527x-orgtx,             " Texto Unid. organizativa
             orige     TYPE char6,                   " Origen del dato: Marcas / IT2001 / ZL-CCNO

* { +@0004 Marcas de pausas
             ltimeipa  TYPE teven-ltime,             " Hora INGRESO MARCA
             ltimespa  TYPE teven-ltime,             " Hora SALIDA MARCA
* } +@0004 Marcas de pausas
* @006  inclusion nuevos campos dni ruc razon social
             dni       TYPE pa0185-icnum,
             ruc       TYPE t001z-paval,
             razon_soc TYPE t001-butxt.
    TYPES: END OF gty_output.
* Textos de absentismos y presencias
    TYPES:  gty_t554t TYPE t554t.
* Texto de terminales
    TYPES: BEGIN OF gty_texter,
             bukrs            TYPE ztterminal-bukrs,        " @0003
             zid_terminal_sap TYPE ztterminal-zid_terminal_sap,
             znom_oficina     TYPE ztterminal-znom_oficina.
    TYPES: END OF gty_texter.
*Plan de horario de trabajo mensual
    TYPES: BEGIN OF gty_t552a,
             tpr01 TYPE t552a-tpr01, tpr02 TYPE t552a-tpr02, tpr03 TYPE t552a-tpr03, tpr04 TYPE t552a-tpr04,
             tpr05 TYPE t552a-tpr05, tpr06 TYPE t552a-tpr06, tpr07 TYPE t552a-tpr07, tpr08 TYPE t552a-tpr08,
             tpr09 TYPE t552a-tpr09, tpr10 TYPE t552a-tpr10, tpr11 TYPE t552a-tpr11, tpr12 TYPE t552a-tpr12,
             tpr13 TYPE t552a-tpr13, tpr14 TYPE t552a-tpr14, tpr15 TYPE t552a-tpr15, tpr16 TYPE t552a-tpr16,
             tpr17 TYPE t552a-tpr17, tpr18 TYPE t552a-tpr18, tpr19 TYPE t552a-tpr19, tpr20 TYPE t552a-tpr20,
             tpr21 TYPE t552a-tpr21, tpr22 TYPE t552a-tpr22, tpr23 TYPE t552a-tpr23, tpr24 TYPE t552a-tpr24,
             tpr25 TYPE t552a-tpr25, tpr26 TYPE t552a-tpr26, tpr27 TYPE t552a-tpr27, tpr28 TYPE t552a-tpr28,
             tpr29 TYPE t552a-tpr29, tpr30 TYPE t552a-tpr30, tpr31 TYPE t552a-tpr31,
             pernr TYPE p_pernr, motpr TYPE motpr, tpr00 TYPE tprog.
    TYPES: END OF gty_t552a.
    TYPES:  gty_iscal_day TYPE iscal_day.
* @006 datos sociedad
    TYPES:BEGIN OF gty_soc,
            bukrs TYPE t001-bukrs,
            butxt TYPE t001-butxt,
            paval TYPE t001z-paval,
          END OF gty_soc.

* División / subdivisión de personal
    TYPES: BEGIN OF gty_t001p,
             werks TYPE t001p-werks,
             btrtl TYPE t001p-btrtl,
             mofid TYPE t001p-mofid,
             mosid TYPE t001p-mosid,
           END OF gty_t001p.
    DATA gtd_t001p TYPE STANDARD TABLE OF gty_t001p.

    DATA: gtd_t001p_aux LIKE gtd_t001p.

* Asignac. agrp. de sub.div.pers. planes hor.tr. para PHTD
    TYPES: BEGIN OF gty_t508z,
             mosid TYPE t508z-mosid,
             motpr TYPE t508z-motpr,
           END OF gty_t508z.
    DATA    gtd_t508z TYPE STANDARD TABLE OF  gty_t508z.
* Grupo personal/Área personal
    TYPES: BEGIN OF gty_t503,
             persg TYPE t503-persg,
             persk TYPE t503-persk,
             zeity TYPE t503-zeity,
           END OF gty_t503.
    DATA gtd_t503 TYPE STANDARD TABLE OF gty_t503.

* Plan horario trabajo diario
    TYPES: BEGIN OF gty_t550a ,
             motpr TYPE t550a-motpr,
             tprog TYPE t550a-tprog,
             pamod TYPE t550a-pamod,
             sobeg TYPE t550a-sobeg,
             soend TYPE t550a-soend,
           END OF gty_t550a.
    DATA  gtd_t550a TYPE STANDARD TABLE OF  gty_t550a.
    TYPES: gtt_t550a TYPE STANDARD TABLE OF t550a.
    TYPES: BEGIN OF gty_tbindbw,
             seqnr(3) TYPE c,                        "sequence number
             include  TYPE ptbindbw.
    TYPES: END OF gty_tbindbw.
    DATA gtd_tbindbw TYPE STANDARD TABLE OF  zhcms_tbindbw.
    "Tabla para fechas por semana
    TYPES: BEGIN OF gty_date_w,
             begda TYPE teven-ldate,
             endda TYPE teven-ldate.
    TYPES: END OF gty_date_w,
    gtty_date_w TYPE STANDARD TABLE OF gty_date_w.
* Calendario Festivo
    TYPES:  gtt_iscal_day TYPE STANDARD TABLE OF iscal_day.



    TYPES ty_hcm_detail  TYPE zc_hcm_dailyc_detail.
    TYPES tty_hcm_detail TYPE STANDARD TABLE OF ty_hcm_detail.
    TYPES ty_hcm_resumm  TYPE zc_hcm_dailyc_resumm.
    TYPES tty_hcm_resumm TYPE STANDARD TABLE OF ty_hcm_resumm.
    TYPES:
      gth_t554t_1  TYPE HASHED   TABLE OF gty_t554t     WITH UNIQUE KEY sprsl moabw awart,
      gty_t511_aux TYPE HASHED TABLE OF gty_t511 WITH UNIQUE KEY molga lgart endda,

      gtd_texter_1 TYPE STANDARD TABLE OF gty_texter    WITH NON-UNIQUE KEY zid_terminal_sap.


    TYPES: gty_p0008  TYPE TABLE OF p0008,
           gty_pa0007 TYPE TABLE OF p0007,
           gty_pa0001 TYPE TABLE OF p0001.

    DATA: gtd_output    TYPE STANDARD TABLE OF gty_output,
          gtd_output2   TYPE STANDARD TABLE OF gty_output,  "+@0015
          gth_t554t     TYPE HASHED   TABLE OF gty_t554t     WITH UNIQUE KEY sprsl moabw awart,
          gtd_texter    TYPE STANDARD TABLE OF gty_texter    WITH NON-UNIQUE KEY zid_terminal_sap,
          gtd_marcas    TYPE STANDARD TABLE OF gty_marcas,
          gt_date_week  TYPE STANDARD TABLE OF  gty_date_w,
          gts_pausas    TYPE SORTED TABLE OF gty_marcas WITH NON-UNIQUE KEY pernr  ldate, " +@0004
          gtd_regfinmar TYPE STANDARD TABLE OF gty_regfinmar,
          gtd_t552a     TYPE STANDARD TABLE OF gty_t552a,
*          gtd_t511      TYPE HASHED   TABLE OF gty_t511      WITH UNIQUE KEY molga lgart endda,ZC_HCM_DETAIL
          gtd_t511      TYPE  zhcmtt_t511_dc,
          gtd_iscal_day TYPE STANDARD TABLE OF gty_iscal_day WITH KEY date,
          gtd_pc2bf     TYPE STANDARD TABLE OF pc2bf,
          gtd_t512t     TYPE STANDARD TABLE OF t512t,
          gts_pc2bf     TYPE SORTED   TABLE OF pc2bf WITH NON-UNIQUE KEY lgart,
          gtd_soc       TYPE STANDARD TABLE OF gty_soc.

*  infotypes
    DATA p2011         TYPE tim_tmw_teven_tab.

    DATA planned_working_times         TYPE TABLE OF p0007.
    DATA: personnel_actions        TYPE TABLE OF i_hcmpersonnelaction,
          personnel_action         TYPE i_hcmpersonnelaction,
*          p0001 TYPE TABLE OF i_hcmorganizationalassignment,
          gwa_p0001                TYPE p0001,

          org_unit_texts           TYPE TABLE OF i_orgunittext,
          org_unit_text            TYPE i_orgunittext,

          companies_code           TYPE TABLE OF i_acmcompanycodestdvh,
          company_code             TYPE  i_acmcompanycodestdvh,
          identity_documents       TYPE TABLE OF pa0185,
          identity_document        TYPE pa0185,

          personal_informations    TYPE TABLE OF i_hcmpersonaldata,
          personal_information     TYPE i_hcmpersonaldata,
          planned_working_time     TYPE p0007,
          time_recording_infotypes TYPE TABLE OF p2001,
          p0008                    TYPE TABLE OF p0008,
          p0001                    TYPE TABLE OF p0001,
          p0000                    TYPE TABLE OF p0000,
          p0041                    TYPE TABLE OF p0041,
          gwa_p0041                TYPE p0041.

    DATA start_date TYPE sydatum.
    DATA end_date   TYPE sydatum.
    DATA results TYPE STANDARD TABLE OF zc_hcm_dailyc_detail.
    DATA result  TYPE zc_hcm_dailyc_detail.

    DATA results_res TYPE STANDARD TABLE OF zc_hcm_dailyc_resumm.
    DATA result_res  TYPE zc_hcm_dailyc_resumm.

*De las estructuras del control
    DATA:
      gwa_output_aux TYPE gty_output,
      gwa_marcas     TYPE gty_marcas,
      gwa_t552a      TYPE gty_t552a,
      gwa_layout     TYPE lvc_s_layo,
      gwa_fieldcat   TYPE lvc_t_fcat,
      gwa_p0008      TYPE p0008.

*De las estructuras del control
    DATA gwa_output    TYPE gty_output.

*Variables de uso general de la aplicación
    DATA gs_okmolga    TYPE boole_d ##NEEDED.
    DATA gs_molga      TYPE molga.
    DATA gs_btrtl      TYPE pa0001-btrtl.
    DATA gn_moabw      TYPE t001p-moabw.

*Variables de uso general de la aplicación
    DATA: ok_code   TYPE syucomm,
          gi_return TYPE sysubrc,
          gi_totreg TYPE sysubrc,

          gs_werks  TYPE pa0001-werks,


          gs_werkss TYPE t001p-werks,
          gs_btrtll TYPE t001p-btrtl.

    DATA: ls_week  TYPE scal-week,
          ls_mond  TYPE sy-datum,
          ls_sund  TYPE sy-datum,
          gv_begda TYPE sy-datum,
          gv_endda TYPE sy-datum,
          gv_ndate TYPE sy-datum.
    DATA: " wt_output_res     TYPE gty_output_res,
      wt_date_week TYPE gty_date_w,
      p_txj        TYPE char03,
      p_fxj        TYPE char03.


    "Tabla para infotipo 2011
    TYPES: BEGIN OF gty_teven,
             pernr TYPE teven-pernr,
             ldate TYPE teven-ldate,
             satza TYPE teven-satza,
             dallf TYPE teven-dallf.
    TYPES: END OF gty_teven.
    "Tabla para infotipo 2001
    TYPES: BEGIN OF gty_pa2001_res,
             pernr TYPE pa2001-pernr,
             subty TYPE pa2001-subty,
             endda TYPE pa2001-endda,
             begda TYPE pa2001-begda,
             alldf TYPE pa2001-alldf.
    TYPES: END OF gty_pa2001_res.
    "Tabla para infotipo 0007
    TYPES: BEGIN OF gty_pa0007_res,
             pernr TYPE pa0007-pernr,
             endda TYPE pa0007-endda,
             begda TYPE pa0007-begda,
             wkwdy TYPE pa0007-wkwdy.
    TYPES: END OF gty_pa0007_res.

    DATA:
*         gt_output_res     TYPE STANDARD TABLE OF  gty_output_res,
      gt_teven_res      TYPE STANDARD TABLE OF  gty_teven,
      gt_teven_res_aux  TYPE STANDARD TABLE OF  gty_teven,
*        gt_date_week      TYPE STANDARD TABLE OF  gty_date_w,
      gt_pa2001_res     TYPE STANDARD TABLE OF  gty_pa2001_res,
      gt_pa2001_res_aux TYPE STANDARD TABLE OF  gty_pa2001_res,
      gt_pa0007_res     TYPE STANDARD TABLE OF  gty_pa0007_res,
      gt_pa0007_res_aux TYPE STANDARD TABLE OF  gty_pa0007_res,
      gtd_iscal_day_aux TYPE STANDARD TABLE OF gty_iscal_day WITH KEY date.
*        wt_output_res     TYPE gty_output_res.
*        wt_date_week      TYPE gty_date_w.
    DATA: ls_valida TYPE c,
          gs_profl  TYPE profl,
          gr_relat  TYPE RANGE OF pa2001-subty.
    CONSTANTS gc_true        TYPE char1        VALUE 'X'.
    CONSTANTS gc_marking     TYPE char3        VALUE 'P10'.
    CONSTANTS gc_marksali    TYPE char3        VALUE 'P20'.
* { +@0004 Marcas de pausas
    CONSTANTS gc_marking_pa  TYPE char3        VALUE 'P15'.
    CONSTANTS gc_marksali_pa TYPE char3        VALUE 'P25'.
* } +@0004
    CONSTANTS gc_tiempo1     TYPE sy-uzeit     VALUE '000700'.
    CONSTANTS gc_tiempo2     TYPE sy-uzeit     VALUE '005900'.        " Se pone 59 x q.006000 no es permitido
    CONSTANTS gc_tiempo3     TYPE sy-uzeit     VALUE '000000'.
    CONSTANTS gc_awart1      TYPE pa2001-awart VALUE 'TXJ '.          " Tardanza por Justificar
    CONSTANTS gc_awart2      TYPE pa2001-awart VALUE 'FXJ '.          " Falta por justificar
    CONSTANTS gc_idtconst    TYPE zrangeid     VALUE '0000000007'.    " Id. de constantes
    CONSTANTS gc_feinicio    TYPE d            VALUE '20010101'.      " P.filtro: HASTA HOY
    CONSTANTS gc_abwtg       TYPE p2001-abwtg  VALUE '1.00'.          " Valor minimo dia de ausentimos
    CONSTANTS gc_capmark     TYPE pa0007-zterf VALUE '1'.             " Trab.que marca
    CONSTANTS gc_container   TYPE char11       VALUE 'CCCONTAINER'.
    CONSTANTS gc_tabout      TYPE char10       VALUE 'GTD_OUTPUT'.
    CONSTANTS gc_tabout_res  TYPE char13       VALUE 'GT_OUTPUT_RES'. "+@0019
    CONSTANTS gc_lgart       TYPE pc2bf-lgart  VALUE '2P38'.
    CONSTANTS gc_lgart_su1   TYPE pc2bf-lgart  VALUE '0440'.
    CONSTANTS gc_lgart_su2   TYPE pc2bf-lgart  VALUE '0465'.
    CONSTANTS gc_origen1     TYPE char6        VALUE 'MARCAS'.
    CONSTANTS gc_origen2     TYPE char6        VALUE 'IT2001'.
    CONSTANTS gc_origen3     TYPE char6        VALUE 'ZL-CCN'.        " Cc-nomina

    CONSTANTS gc_bukrs       TYPE bukrs        VALUE '100'.

*Declaracion para tablas de Constantes
    DATA: go_constants TYPE REF TO zbc_constants_admin.

    DATA: s_awart TYPE RANGE OF pa2001-awart.
    DATA: s_awart_new TYPE RANGE OF pa2001-awart.

    METHODS proces_detail_data IMPORTING io_request  TYPE REF TO if_rap_query_request
                               CHANGING  hcm_details TYPE tty_hcm_detail.
    METHODS proces_resumm_data IMPORTING io_request  TYPE REF TO if_rap_query_request
                               CHANGING  hcm_resumms TYPE tty_hcm_resumm.


    METHODS infotipo_registro_de_marca CHANGING hcm_detail  TYPE ty_hcm_detail
                                                hcm_details TYPE tty_hcm_detail.

    METHODS obtiene_ingreso_salida_real CHANGING hcm_detail  TYPE ty_hcm_detail
                                                 hcm_details TYPE tty_hcm_detail.

    METHODS obtiene_calendario_festivo.
    METHODS calcula_con_registros_mark.
    METHODS calcula_sin_registros_mark.
    METHODS valida_unica_marca .
    METHODS nuevo_calculo_faltas.
    METHODS calcula_las_faltas.
    METHODS valida_cesados.
    METHODS adicionar_marcas_refrigerio.

    METHODS obtiene_horario_teorico IMPORTING p_fecha TYPE ldate
                                    CHANGING  p_sobeg TYPE sobeg
                                              p_soend TYPE soend.
    METHODS constructor.

    METHODS calendario_festivo_x_pernr  IMPORTING pi_werks     TYPE persa
                                                  pi_btrtl     TYPE btrtl_001p
                                                  pi_begda     TYPE begda
                                                  pi_endda     TYPE endda
                                        CHANGING  po_iscal_day TYPE gtt_iscal_day.
    METHODS conversion_a_minutos  IMPORTING pi_valdecimal TYPE abstd
                                  CHANGING  po_difhor     TYPE sobeg
                                            po_totmin     TYPE sysubrc.
    METHODS verif_ausentis_en_tab_constan  IMPORTING p_awart TYPE awart
                                           CHANGING  p_range TYPE char1.
    METHODS convierte_tiempo_en_minutos  IMPORTING p_difhor TYPE sobeg "HHMMSS
                                         CHANGING  p_totmin TYPE sysubrc.
*    methods obtiene_emolumentos_basicos  importing  pt_tbindbw type gtd_tbindbw
*                                         pi_p0001   type p0001
*                                         pi_p0007   type gty_pa0007"#EC NEEDED
*                                         pi_p0008   TYPE      gty_p0008"#EC NEEDED
*                                         pi_molga   TYPE molga
*                                         pi_endda   TYPE endda
*                                CHANGING pi_t511    TYPE gty_t511_aux.

    METHODS texto_clase_ausentismo  IMPORTING pi_werks TYPE persa
                                              pi_btrtl TYPE btrtl
                                              pi_awart TYPE awart
                                    CHANGING  po_atext TYPE abwtxt.
    METHODS tabla_cc_nomina
      IMPORTING
        pi_molga TYPE molga
        pi_endda TYPE endda
      CHANGING
        po_t511  TYPE zhcmtt_t511_dc.
    METHODS summary_process
      CHANGING
        hcm_resumm  TYPE ty_hcm_resumm
        hcm_resumms TYPE tty_hcm_resumm.
    METHODS f_calcular_semanas
      IMPORTING
        ip_begda     TYPE sydatum
        ip_endda     TYPE sydatum
      CHANGING
        ct_date_week TYPE gtty_date_w.
    METHODS f_traer_tablas.
    METHODS f_procesa_data_res
      CHANGING
        hcm_resumm  TYPE ty_hcm_resumm
        hcm_resumms TYPE tty_hcm_resumm.
    METHODS f_obtener_marcas
      IMPORTING
        fs_date_week_res_begda TYPE begda
        fs_date_week_res_endda TYPE endda
      CHANGING
        p_wt_output_res_satza  TYPE retyp
        p_wt_output_res_subty  TYPE subty
        p_wt_output_res_wkwdy  TYPE warst.
    METHODS revisar_tiempos_reales
      CHANGING
        hcm_details TYPE tty_hcm_detail.

  PROTECTED SECTION.
private section.

  types:
    ty_ltd_t550a TYPE STANDARD TABLE OF t550a WITH DEFAULT KEY .

  methods SET_INITIAL_TIME
    changing
      !C_LWA_RESULT type TY_HCM_DETAIL .
  methods OBTENER_PLANES_NO_LABORALES
    changing
      !C_LTD_T550A type TY_LTD_T550A .
  methods CALCULAR_PLAN_HORARIO
    exporting
      !P_DATE type D
    changing
      !CP_T552A type ZCL_HCM_DAILY_CONSULT_ACTIONS=>GTY_T552A .
  methods VALIDAR_FECHAS_LABORABLES
    exporting
      !P_DAY type N
      !P_PROG type TABLE
      !P_T552A type ZCL_HCM_DAILY_CONSULT_ACTIONS=>GTY_T552A
    changing
      !C_VAL type C .
  methods GET_FILTERS_UNITORG
    changing
      !ORGUNIT_FILTER type IF_RAP_QUERY_FILTER=>TT_RANGE_OPTION .
  methods GET_VALIDATE_USER
    changing
      !EMPLOYEE_FILTER type IF_RAP_QUERY_FILTER=>TT_RANGE_OPTION .
ENDCLASS.



CLASS ZCL_HCM_DAILY_CONSULT_ACTIONS IMPLEMENTATION.


  METHOD constructor.

    SELECT * INTO TABLE gth_t554t
            FROM t554t
            WHERE sprsl EQ sy-langu.
* Texto de terminales
    SELECT bukrs zid_terminal_sap znom_oficina INTO TABLE gtd_texter
           FROM ztterminal.




  ENDMETHOD.


  METHOD infotipo_registro_de_marca.
* Se leen los registros de ingreso y salida real y se agrupa en un solo registro
* La Tab.Int. gtd_regfinmar nos devuelve los datos consolidados de marcacion
    me->obtiene_ingreso_salida_real( CHANGING hcm_detail = hcm_detail hcm_details = hcm_details ).

*.Se obtiene Tab.Int. con feriados dentro del periodo consultado x/cada trabajador
*.valido tanto p.evaluar registros con marcacion y sin marcacion (solo ausentismos)
*.Si el trabajador tiene la misma Div.y Sub.Divi.entonces se reusa la misma Tab.Interna
    me->obtiene_calendario_festivo( ).

* Si hay marcas e IT2001, Se mantiene el reg.de marcas pero a la columna Cost.Hora, se pone en 0.00 y blanquea
* texto de clase de ausentismo
* Si hay marcas y registro en ZL, el registro de marcas se mantiene, el registro de ZL NO se muestra
* Si hay IT2001 y registro en ZL, el registro de marcas se mantiene, el registro de ZL NO se muestra  ZC_HCM_DAILY_CONSULTATION
    me->calcula_con_registros_mark(  ).
    me->calcula_sin_registros_mark(  ).   "Lectura al IT2001
*{+ @0005
    IF hcm_detail-company EQ gc_bukrs.
      me->valida_unica_marca( ).
    ENDIF.
* }
*{+ @0007
    IF hcm_detail-company EQ gc_bukrs.
      me->nuevo_calculo_faltas( ).
    ELSE.
      me->calcula_las_faltas(  ).
    ENDIF.
*}
*  PERFORM calcula_las_faltas.           "Lectura a CC-nomina ZL    "/ @0007
*{+ @0009 - Lógica Cesados
    IF hcm_detail-company EQ gc_bukrs.
      me->valida_cesados(  ).
    ENDIF.
*}
    me->adicionar_marcas_refrigerio(  ).                    "+@0004
* Orden de salida del reporte (fe.descendiente)
*  SORT gtd_output BY ldate DESCENDING.

*{-@wvf ya no va la depuracion
*    IF gi_return = 0.
*      IF p_txj IS INITIAL.
*        DELETE results WHERE absencetype = gc_awart1.
*
*      ENDIF.
*      IF p_fxj IS INITIAL.
*        DELETE results WHERE absencetype = gc_awart2.
*      ENDIF.
*    ENDIF.
*}-@wvf

  ENDMETHOD.


  METHOD calcula_con_registros_mark.
    DATA:ls_in_range TYPE char1    VALUE space,
         lf_betrg    TYPE ptbindbw-betrg VALUE 0,
         li_totmin   TYPE sy-subrc VALUE 0,
         li_flg2001  TYPE sy-subrc VALUE 0,
         lr_abwtg    TYPE p2001-abwtg.
    DATA lwa_result TYPE  ty_hcm_detail.

    LOOP AT gtd_regfinmar ASSIGNING FIELD-SYMBOL(<fs_regfinmar>) where pernr = result-PersonnelNumber.
      CLEAR lwa_result.
      MOVE me->result TO lwa_result.

      MOVE: <fs_regfinmar>-ldate  TO lwa_result-markdate,  "Fe.marca
            <fs_regfinmar>-sobeg  TO lwa_result-theoreticalstarttime,  "Hora Ingreso Teorica
            <fs_regfinmar>-soend  TO lwa_result-theoreticalendtime,  "Hora Salida Teorica
            <fs_regfinmar>-ltimei TO lwa_result-actualstarttime, "Hora Ingreso Real
            <fs_regfinmar>-ltimes TO lwa_result-actualendtime. "Hora Salida Real

* {+@0004
      MOVE: <fs_regfinmar>-ltimeipa TO lwa_result-breakstarttime, "Hora Ingreso Real
            <fs_regfinmar>-ltimespa TO lwa_result-breakendtime. "Hora Salida Real
* }+@0004



*...Se indica el origen del dato
*    lwa_result-DataOrigin = gc_origen1.
      lwa_result-dataorigin = gc_origen1.

*...Se obtiene texto de ID Terminal
*    MOVE <fs_regfinmar>-terid TO lwa_result-TerminalID.
      MOVE <fs_regfinmar>-terid TO lwa_result-terminalid.

      IF NOT lwa_result-terminalid IS INITIAL.
*      PERFORM trae_texto_id_terminal USING lwa_result-TerminalID <fs_regfinmar>-pernr
*                                  CHANGING lwa_result-TerminalText.
        READ TABLE gtd_texter ASSIGNING FIELD-SYMBOL(<fs_texter>) WITH KEY zid_terminal_sap = lwa_result-terminalid
                                                                        bukrs = lwa_result-company.
        IF sy-subrc = 0.
          lwa_result-terminaltext = <fs_texter>-znom_oficina.
        ENDIF.

      ENDIF.

*...EVALUACION DEL INFOTIPO 2001 - Ausentismo
*...Obtencion de: Diferencia en minutos u horas
*...Si fe.de marca existe en Infotipo 2001 Ausentismo -> se toma datos del Infotipo
      li_flg2001 = 4.
      CLEAR lr_abwtg.
*    LOOP AT p2001 ASSIGNING <fs_p2001> WHERE begda <= lwa_result-MarkDate AND
*                                             endda >= lwa_result-MarkDate.
*      li_flg2001 = 0.
*      lr_abwtg = <fs_p2001>-abwtg.
*      EXIT.
*    ENDLOOP.

      LOOP AT time_recording_infotypes INTO DATA(lwa_p2001) WHERE begda <= lwa_result-markdate AND
                                                 endda >= lwa_result-markdate AND
                                                 pernr = lwa_result-personnelnumber.
        li_flg2001 = 0.
        lr_abwtg = lwa_p2001-abwtg.
        EXIT.
      ENDLOOP.

      IF li_flg2001 EQ 0.
*.....Se asigna campos: Tipo(clase) de Ausentismo y Diferencia en minutos
*      lwa_result-AbsenceType  = lwa_p2001-awart.
        lwa_result-absencetype = lwa_p2001-awart.

*.....Conversion de Formato Numerico a minutos y total minutos
        IF NOT lwa_p2001-stdaz IS INITIAL.
          CLEAR li_totmin.
*          PERFORM conversion_a_minutos USING    lwa_p2001-stdaz        "Input en formato decimal
*                                       CHANGING lwa_result-TimeDifference  "En formato hora 'HH:MM'
*                                                li_totmin.         "Total en minutos
          me->conversion_a_minutos(
            EXPORTING
              pi_valdecimal = lwa_p2001-stdaz
            CHANGING
              po_difhor     = lwa_result-theoreticalstarttime
              po_totmin     = li_totmin
          ).
        ENDIF.
*.....Verifica la existencia de Tipo(clase) de Ausentismo en tabla de Constantes
*.....p. saber si se procesa o no la valorizacion de las horas
        CLEAR ls_in_range.
*        PERFORM verif_ausentis_en_tab_constan USING lwa_result-AbsenceType  "Cod.ausentismo
*                                           CHANGING ls_in_range.
        me->verif_ausentis_en_tab_constan(
          EXPORTING
            p_awart = lwa_result-absencetype
          CHANGING
            p_range = ls_in_range
        ).
      ELSE.
*.....Si se ingreso valores p.filtro de Cla.Ausentismo en pantalla inicial y no se encontro
*.....registro en el Infotipo 2001 entonces no se debe considerar este registro
*.....Ya que el filtro debe mostrar solo registros contenidos en el Infotipo 2001
        IF NOT s_awart[] IS INITIAL.
*.......Se preparan datos de P0001 y P0002 para el sgte. registro
          CLEAR: lwa_result.

          CONTINUE.
        ENDIF.

*.....Si hora de Ingreso y Salida Teorico estan en blanco entonces se asume
*.....q.sea LIVI,LISA,LIBR en donde no hay horarios y el registro se agrega a Tab.Int
*.....los datos que fueron llenados y los demas en blanco
        IF ( lwa_result-theoreticalstarttime IS INITIAL AND lwa_result-theoreticalendtime IS INITIAL ) OR
           ( lwa_result-theoreticalstarttime = space AND lwa_result-theoreticalendtime = space ).
*.......Se agrega registro
*.......~~~~~~~~~~~~~~~~~~
          set_initial_time(
          CHANGING
          c_lwa_result = lwa_result ).

          APPEND lwa_result TO results.
*.......Se preparan datos de P0001 y P0002 para el sgte. registro
          gi_return = 0.
          CONTINUE.
        ENDIF.
*.....Se verifica contra la Tab.Int.de feriados del periodo de ejec.del reporte
*.....Se verifica si la fecha procesada existe en Tab.de feridos si existe el reg.se procesa
*.....de la misma forma q. si no se hubiera encontrado horario teorico de Entrada/salida.
        READ TABLE gtd_iscal_day ASSIGNING FIELD-SYMBOL(<fs_gtd_iscal_day>) WITH KEY date = lwa_result-markdate
                                                            BINARY SEARCH.
        IF sy-subrc EQ 0.
*.......Se agrega registro
*.......~~~~~~~~~~~~~~~~~~

*{+ @0005
          IF gwa_p0001-bukrs EQ gc_bukrs.
*          gwa_output-atext = text-t01.    "gwa_output-atext = 'Feriado'    "/@0015

            lwa_result-AbsenceType = 'FER'. "+WVF001 se asigna el codigo para poder ser filtrado
            lwa_result-absencetypetext = TEXT-t01.

          ENDIF.
* }
          set_initial_time(
          CHANGING
          c_lwa_result = lwa_result ).
          APPEND lwa_result TO results.
*.......Se preparan datos de P0001 y P0002 para el sgte. registro
*          CLEAR: gwa_output.
*          PERFORM asigna_campos_p0001.
*          PERFORM asigna_campos_p0002.
*          PERFORM asigna_campos_p0185.
          gi_return = 0.
          CONTINUE.
        ENDIF.

*.....Se calcula la diferencia de los minutos:Hor.Ingreso Real - Hora Ingreso Teorico.
        CLEAR: lwa_result-timedifference,li_totmin.
        IF lwa_result-actualstarttime > lwa_result-theoreticalstarttime.
          lwa_result-timedifference = lwa_result-actualstarttime - lwa_result-theoreticalstarttime.
        ENDIF.
*.....Se obtiene total de minutos
        IF lwa_result-timedifference NE gc_tiempo3.                   "00:00:00
*        PERFORM convierte_tiempo_en_minutos USING lwa_result-TimeDifference  "HHMMSS
*                                         CHANGING li_totmin.    "Formato decimal
          me->convierte_tiempo_en_minutos(
            EXPORTING
              p_difhor = lwa_result-timedifference
            CHANGING
              p_totmin = li_totmin
          ).

        ENDIF.
*.....Si la diferencia es < a 7 minutos no se procesan los demas campos
        IF lwa_result-timedifference <= gc_tiempo1.

*{+ @0005
          IF lwa_result-company EQ gc_bukrs.
            CLEAR: lwa_result-timedifference, lwa_result-laborcost, lwa_result-absencetypetext.
          ENDIF.
* }

*.......Se agrega registro
*.......~~~~~~~~~~~~~~~~~~
          set_initial_time(
          CHANGING
          c_lwa_result = lwa_result ).
          APPEND lwa_result TO results.
*.......Se preparan datos de P0001 y P0002 para el sgte. registro
*          CLEAR: gwa_output.
*          PERFORM asigna_campos_p0001.
*          PERFORM asigna_campos_p0002.
*          PERFORM asigna_campos_p0185.
          gi_return = 0.
          CONTINUE.
        ENDIF.

*.....La diferencia es entre 7 y 60 Minu -> asigna Ti.Ausentismo:TARDANZA POR JUSTIFICAR
        IF lwa_result-timedifference > gc_tiempo1 AND lwa_result-timedifference <= gc_tiempo2.
          lwa_result-absencetype  = gc_awart1. "TARDANZA POR JUSTIFICAR
        ELSEIF lwa_result-timedifference > gc_tiempo2.
*.......La diferencia es > 60 Minu. -> asigna Ti.Ausentismo:FALTA POR JUSTIFICAR
          lwa_result-absencetype  = gc_awart2. "FALTA POR JUSTIFICAR
        ENDIF.
*.....Si son los 2 Ti.Ausentismos forzados:TTXJ y FFXJ-> se fuerza valorizac.de horas
        CLEAR ls_in_range.
        IF lwa_result-absencetype = gc_awart1 OR lwa_result-absencetype = gc_awart2.
          ls_in_range = 'X'.
        ENDIF.
      ENDIF.
*...Si esta marcado se procesa Valorizacion
      IF ls_in_range = 'X'.
*Se realiza valoración
*Se obtiene la estructura del IT 0008 con el intervalo de fecha de marka p.el calculo
*de los emolumentos basicos
        REFRESH gtd_tbindbw.
        CLEAR: gwa_p0008.
*        PERFORM estruct_p0008_calc_emu_basico(zhru0001) TABLES   p0008
*                                                        USING    lwa_result-MarkDate
*                                                        CHANGING gwa_p0008.

        LOOP AT me->p0008 INTO gwa_p0008 WHERE begda <= lwa_result-markdate AND
                                     endda >= lwa_result-markdate AND
                                     pernr = result-personnelnumber.
        ENDLOOP.

*        PERFORM obtiene_emolumentos_basicos(zhru0001)  TABLES gtd_tbindbw
*                                                              p0001
*                                                              p0007
*                                                        USING gwa_p0008
*                                                              gs_molga
*                                                              gwa_p0001-endda
*                                                     CHANGING gtd_t511.
        CALL FUNCTION 'ZHCMF_GET_BASIC_EMOLUMENTS'
          EXPORTING
            pi_molga   = gs_molga
            pi_endda   = gwa_p0001-endda
          TABLES
            pt_tbindbw = gtd_tbindbw
            pi_p0001   = p0001
            pi_p0007   = planned_working_times
          CHANGING
            pi_p0008   = gwa_p0008
            pi_t511    = gtd_t511.
        IF NOT gtd_tbindbw[] IS INITIAL.
          CLEAR lf_betrg.
          LOOP AT gtd_tbindbw INTO DATA(lwa_tbindbw) WHERE lgart = gc_lgart_su1 OR lgart = gc_lgart_su2.
            ADD lwa_tbindbw-betrg TO lf_betrg.
          ENDLOOP.
*.......Si existe un valor entero p. campo: Dias ausentismo se calcula el valor x dia, siempre
*.......y cuando se haya encontrado registros en el IT 2001 dentro del rango evaluado, luego
*.......se limpia campo de dif.de horas. De lo CONTRARIO se calcula el valor por minuto
          IF ( li_flg2001 = 0 ) AND ( lwa_p2001-abwtg >= gc_abwtg ).
*.........Valorizacion del dia
            lf_betrg = ( lf_betrg / 30 ).
*.........Costo dias Hombre
            lwa_result-laborcost = lf_betrg * lr_abwtg. "lwa_p2001-abwtg.
            CLEAR lwa_result-timedifference.
          ELSE.
*.........Valorizacion del minuto de horas hombre segun el sueldo
            lf_betrg = ( ( lf_betrg / 30 ) / 8 ) / 60.
*.........Costo Horas Hombre
            lwa_result-laborcost = lf_betrg * li_totmin.
          ENDIF.
        ENDIF.
      ENDIF.
*...Texto Clas.Ausentismo
      IF NOT lwa_result-absencetype IS INITIAL.
        IF lwa_result-absencetype = gc_awart1 OR lwa_result-absencetype = gc_awart2.
*.......Se asigna Constante p.el campo texto
          lwa_result-absencetypetext = TEXT-m03.
          IF lwa_result-absencetype = gc_awart2.
            lwa_result-absencetypetext = TEXT-m04.
          ENDIF.
        ELSE.
*          PERFORM texto_clase_ausentismo   USING <fs_p0001>-werks
*                                                 <fs_p0001>-btrtl
*                                                 lwa_result-AbsenceType
*                                        CHANGING lwa_result-AbsenceTypeText.
          me->texto_clase_ausentismo(
            EXPORTING
              pi_werks = gwa_p0001-werks
              pi_btrtl = gwa_p0001-btrtl
              pi_awart = lwa_result-absencetype
            CHANGING
              po_atext = lwa_result-absencetypetext
          ).

        ENDIF.
      ENDIF.
*...Se agrega registro
*...~~~~~~~~~~~~~~~~~~

*{+ @0005
      IF gwa_p0001-bukrs EQ gc_bukrs.
        CLEAR: lwa_result-timedifference, lwa_result-laborcost. ", lwa_result-AbsenceTypeText.
        IF ( lwa_result-absencetype EQ gc_awart1 ) OR ( lwa_result-absencetype EQ gc_awart2 ). "+ @0007
          CLEAR: lwa_result-absencetype, lwa_result-absencetypetext. "+ @0007
        ENDIF.                                              "+ @0007
      ENDIF.
* }

*      APPEND gwa_output TO gtd_output.
*...Se preparan datos de P0001 y P0002 para el sgte. registro
*      CLEAR: gwa_output.
*      PERFORM asigna_campos_p0001.
*      PERFORM asigna_campos_p0002.
*      PERFORM asigna_campos_p0185.
      set_initial_time(
      CHANGING
      c_lwa_result = lwa_result ).
      APPEND lwa_result TO results.
      gi_return = 0.
    ENDLOOP.




  ENDMETHOD.


  METHOD calcula_sin_registros_mark.
    DATA:ls_in_range TYPE char1    VALUE space,
         lf_betrg    TYPE ptbindbw-betrg VALUE 0,
         li_totmin   TYPE sy-subrc VALUE 0.
*{INSERT 0001
    DATA: ltd_2001      TYPE STANDARD TABLE OF p2001,
          lwa_2001      TYPE p2001,
          li_diferencia TYPE i,
          li_index      TYPE i.
    DATA lwa_result TYPE ty_hcm_detail .
    DATA lwa_result_aux TYPE ty_hcm_detail .
    DATA resultsk TYPE TABLE OF ty_hcm_detail .
    DATA lwa_result3 TYPE ty_hcm_detail .
    REFRESH ltd_2001.
*}INSERT 0001
*+@0015{
    DATA: li_cont TYPE i.
*}+@0015
* Se ordena p. localizar registros anteriores y poder definir agregar el registro o no
*    SORT gtd_output BY pernr ldate orige.
    SORT results BY personnelnumber markdate dataorigin.
*{INSERT 0001
*  LOOP AT p2001 ASSIGNING <fs_p2001> WHERE ( begda >= start_date AND begda <= end_date ) AND         "/@0007
    LOOP AT time_recording_infotypes   ASSIGNING FIELD-SYMBOL(<fs_p2001>) WHERE ( ( begda >= start_date AND begda <= end_date ) OR "+@0007
                                             ( endda >= start_date AND endda <= end_date ) OR "+@0007
                                             ( begda < start_date AND endda > end_date ) ) AND
                                               awart IN s_awart[] and  "Cls.ausentismo de pantalla .      "+@0007
                                               pernr = result-PersonnelNumber.

      CLEAR: li_index,
             li_diferencia.
      li_diferencia = <fs_p2001>-endda - <fs_p2001>-begda.
      ADD 1 TO li_diferencia.
      DO  li_diferencia TIMES.
        MOVE-CORRESPONDING <fs_p2001> TO lwa_2001.
        lwa_2001-begda = lwa_2001-begda + li_index.
        li_index = li_index + 1.
        APPEND lwa_2001 TO ltd_2001.
        CLEAR lwa_2001.
      ENDDO.
    ENDLOOP.
*}INSERT 0001

*.Loop al Infotipo de Ausentismo
*{DELETE 0001
*  LOOP AT p2001 ASSIGNING <fs_p2001> WHERE ( begda >= start_date AND begda <= end_date ) AND
*                                             awart IN s_awart[]. "Cls.ausentismo de pantalla
*}DELETE 0001
    DATA: lv_flag TYPE c.                                   "+ @0005
    CLEAR lv_flag.                                          "+ @0005
    "@0008{
*    DATA:
**          gtd_outputbk TYPE STANDARD TABLE OF gty_output,
*      gwa_output2 TYPE gty_output,
*      gwa_output3 TYPE gty_output.



*    REFRESH: gtd_outputbk.                                  "+@0015
*    gtd_outputbk[] = gtd_output[].                          "+@0015
    resultsk = results.
    data lwa_results_aux like line of  me->results.
    LOOP AT ltd_2001 ASSIGNING <fs_p2001> WHERE ( begda >= start_date AND begda <= end_date )"INSERT 0001
                                                and pernr = result-PersonnelNumber.
* Si hay marcas e IT2001, Se mantiene el reg.de marcas pero a la columna Cost.Hora, se pone en 0.00 y blanquea
* texto de clase de ausentismo
* --> Si el registro existe entonces no se agrega el registro a la tab.int de salida
      CLEAR: gwa_output_aux, lv_flag.                       "/ @0005

      CLEAR lwa_result.
      MOVE me->result TO lwa_result.

      READ TABLE me->results WITH KEY PersonnelNumber = <fs_p2001>-pernr
                                     MarkDate = <fs_p2001>-begda
                                     DataOrigin = gc_origen1
                                     INTO lwa_results_aux
                                     BINARY SEARCH.
      IF sy-subrc EQ 0.
*        CLEAR: gwa_output_aux-coshrh.
          clear     lwa_result-LaborCost .                  "/ @0005
                                                            "{- @0011
*      CLEAR: gwa_output_aux-ltimei, gwa_output_aux-ltimes. "/ @0005
                                                            "} @0011
        MODIFY me->results FROM lwa_result INDEX sy-tabix.

*{+ @0005
        lv_flag = 'X'.
* }

      ENDIF.

*...Se verifica si la fecha procesada existe en Tab.de feridos,si existe el reg.no se procesa
      READ TABLE gtd_iscal_day ASSIGNING FIELD-SYMBOL(<fs_gtd_iscal_day>) WITH KEY date = <fs_p2001>-begda
                                                          BINARY SEARCH.
*    IF sy-subrc EQ 0.  @0008
*      CONTINUE.        @0008
*    ENDIF.             @0008
*...Se indica el origen del dato

      lwa_result-dataorigin = gc_origen2.

*...Al no tener marcaciones los sgtes.campos van en blanco
      CLEAR: lwa_result-markdate,  "Fe.marca
                                                            "{- @0011
*           gwa_output-ltimei, "Hora Ingreso Real
*           gwa_output-ltimes, "Hora Salida Real
                                                            "} @0011
             lwa_result-terminalid,  "ID Terminal
             lwa_result-terminaltext.  "Texto de ID Terminal

*...Se asigna Fe.del Dia a LDATE
      lwa_result-markdate = <fs_p2001>-begda.

      MOVE: <fs_p2001>-awart TO lwa_result-absencetype.
*...Texto Clas.Ausentismo
*    zrp-provide-from-las p0007 space <fs_p2001>-begda <fs_p2001>-endda <fs_p0007>.

*
*    PERFORM texto_clase_ausentismo   USING <fs_p0001>-werks
*                                           <fs_p0001>-btrtl
*                                           lwa_result-AbsenceType
*                                  CHANGING gwa_output-atext.

      texto_clase_ausentismo(
        EXPORTING
          pi_werks = gwa_p0001-werks
          pi_btrtl = gwa_p0001-btrtl
          pi_awart = lwa_result-absencetype
        CHANGING
          po_atext = lwa_result-absencetypetext
      ).

*    PERFORM obtiene_horario_teorico USING <fs_p2001>-begda
*                                 CHANGING lwa_result-TheoreticalStartTime  "Hora Ingreso Teorica
*                                          lwa_result-TheoreticalEndTime. "Hora Salida Teorica
      me->obtiene_horario_teorico(
        EXPORTING
          p_fecha = <fs_p2001>-begda
        CHANGING
          p_sobeg = lwa_result-theoreticalstarttime
          p_soend = lwa_result-theoreticalendtime
      ).
*...Si hora de Ingreso y Salida Teorico estan en blanco entonces se asume
*...q.sea LIVI,LISA,LIBR en donde no hay horarios -> el registro se agrega a Tab.Int
*...los datos que fueron llenados y los demas en blanco
      IF ( lwa_result-theoreticalstarttime IS INITIAL AND lwa_result-theoreticalendtime IS INITIAL ) OR
         ( lwa_result-theoreticalstarttime = space AND lwa_result-theoreticalendtime = space ).
*.....Se agrega registro
*.....~~~~~~~~~~~~~~~~~~
        set_initial_time(
        CHANGING
        c_lwa_result = lwa_result ).
*      APPEND gwa_output TO gtd_output.
        APPEND lwa_result TO results.
*.....Se preparan datos de P0001 y P0002 para el sgte. registro
        CLEAR: gwa_output.
*      PERFORM asigna_campos_p0001.
*      PERFORM asigna_campos_p0002.
*      PERFORM asigna_campos_p0185.
        CONTINUE.
      ENDIF.

*...Conversion de Formato Numerico a minutos y total minutos
      IF NOT <fs_p2001>-stdaz IS INITIAL.
        CLEAR li_totmin.
*        PERFORM conversion_a_minutos USING <fs_p2001>-stdaz   "Input en formato decimal
*                                  CHANGING lwa_result-TimeDifference  "En formato hora 'HH:MM'
*                                           li_totmin.         "Total en minutos
        me->conversion_a_minutos(
             EXPORTING
               pi_valdecimal = <fs_p2001>-stdaz
             CHANGING
               po_difhor     = lwa_result-timedifference
               po_totmin     = li_totmin
           ).
      ENDIF.
*...Verifica la existencia de Tipo(clase) de Ausentismo en tabla de Constantes
*...p. saber si se procesa o no la valorizacion de las horas
      CLEAR ls_in_range.
*      PERFORM verif_ausentis_en_tab_constan USING lwa_result-absencetype  "Cod.ausentismo
*                                         CHANGING ls_in_range.


      me->verif_ausentis_en_tab_constan(
            EXPORTING
              p_awart = lwa_result-absencetype
            CHANGING
              p_range = ls_in_range
            ).
*...Si esta marcado se procesa Valorizacion
      IF ls_in_range = 'X'.
*Se realiza valoración
*Se obtiene la estructura del IT 0008 con el intervalo de fecha de marka p.el calculo
*de los emolumentos basicos
        REFRESH gtd_tbindbw.
        CLEAR: gwa_p0008.
*        PERFORM estruct_p0008_calc_emu_basico(zhru0001) TABLES   p0008
*                                                        USING    lwa_result-markdate
*                                                        CHANGING gwa_p0008.

        LOOP AT me->p0008 INTO gwa_p0008 WHERE begda <= lwa_result-markdate AND
                                     endda >= lwa_result-markdate AND
                                     pernr = lwa_result-personnelnumber.
        ENDLOOP.

*        PERFORM obtiene_emolumentos_basicos(zhru0001)  TABLES gtd_tbindbw
*                                                              p0001
*                                                              p0007
*                                                        USING gwa_p0008
*                                                              gs_molga
*                                                              <fs_p0001>-endda
*                                                     CHANGING gtd_t511.

        CALL FUNCTION 'ZHCMF_GET_BASIC_EMOLUMENTS'
          EXPORTING
            pi_molga   = gs_molga
            pi_endda   = gwa_p0001-endda
          TABLES
            pt_tbindbw = gtd_tbindbw
            pi_p0001   = p0001
            pi_p0007   = planned_working_times
          CHANGING
            pi_p0008   = gwa_p0008
            pi_t511    = gtd_t511.

        IF NOT gtd_tbindbw[] IS INITIAL.
          CLEAR lf_betrg.
          LOOP AT gtd_tbindbw INTO DATA(lwa_tbindbw) WHERE lgart = gc_lgart_su1 OR lgart = gc_lgart_su2.
            ADD lwa_tbindbw-betrg TO lf_betrg.
          ENDLOOP.
*.......Si existe un valor entero p. campo: Dias ausentismo se calcula el valor x dia
*.......y se limpia campo de dif.de horas, De lo CONTRARIO se calcula el valor por minuto
          IF <fs_p2001>-abwtg >= gc_abwtg.
*.........Valorizacion del dia
            lf_betrg = ( lf_betrg / 30 ).
*.........Costo dias Hombre
            lwa_result-laborcost = lf_betrg * <fs_p2001>-abwtg.
            CLEAR lwa_result-timedifference.
          ELSE.
*.........Valorizacion del minuto de horas hombre segun el sueldo
            lf_betrg = ( ( lf_betrg / 30 ) / 8 ) / 60.
*.........Costo Horas Hombre
            lwa_result-laborcost = lf_betrg * li_totmin.
          ENDIF.
        ENDIF.
      ENDIF.

*{+ @0005
      IF gwa_p0001-bukrs EQ gc_bukrs.
        IF lv_flag IS INITIAL.
*.Se agrega registro
*.~~~~~~~~~~~~~~~~~~
          CLEAR: lwa_result-timedifference, lwa_result-laborcost.

*          APPEND gwa_output TO gtd_output.
          set_initial_time(
          CHANGING
          c_lwa_result = lwa_result ).
          APPEND lwa_result TO results.
        ELSE.
*. Modifica registro registro
*.~~~~~~~~~~~~~~~~~~
          CLEAR: lwa_result-timedifference, lwa_result-laborcost.

*          MODIFY gtd_output FROM gwa_output TRANSPORTING sobeg soend
**                                                       ltimei ltimes "/@0011
*                                                         difhor difhor
*                                                         coshrh awart terid txidt atext
*                                                   WHERE pernr EQ gwa_output-pernr
*                                                     AND nachn EQ gwa_output-nachn
*                                                     AND nach2 EQ gwa_output-nach2
*                                                     AND vorna EQ gwa_output-vorna
*                                                     AND ldate EQ lwa_result-markdate.

          MODIFY results FROM lwa_result TRANSPORTING theoreticalstarttime theoreticalendtime
                                                         timedifference
                                                         laborcost absencetype terminalid terminaltext absencetypetext
                                                   WHERE personnelnumber EQ lwa_result-personnelnumber
                                                     AND lastname EQ lwa_result-lastname
                                                     AND secondlastname EQ lwa_result-secondlastname
                                                     AND firstname EQ lwa_result-firstname
                                                     AND markdate EQ lwa_result-markdate.


        ENDIF.
      ELSE.
*        CLEAR gwa_output-atext.
*        APPEND gwa_output TO gtd_output.
        set_initial_time(
        CHANGING
        c_lwa_result = lwa_result ).
        APPEND lwa_result TO results.
      ENDIF.
* }
************
*    APPEND gwa_output TO gtd_output.       “- @0005


*...Se preparan datos de P0001 y P0002 para el sgte. registro
*      CLEAR: gwa_output.
*      PERFORM asigna_campos_p0001.
*      PERFORM asigna_campos_p0002.
*      PERFORM asigna_campos_p0185.
      set_initial_time(
        CHANGING
        c_lwa_result = lwa_result ).
      gi_return = 0.
      CLEAR lv_flag.                                        "+ @0005
    ENDLOOP.


*+@0015{
    CLEAR li_cont.
*    DESCRIBE TABLE gtd_outputbk LINES li_cont.
    DESCRIBE TABLE resultsk LINES li_cont.

    IF li_cont GT 1.
*}+@0015
      "@0008{
*      CLEAR: gwa_output2,gwa_output3.

*      LOOP AT gtd_outputbk INTO gwa_output3.
*        LOOP AT gtd_output INTO gwa_output2 WHERE pernr EQ gwa_output3-pernr .
*          IF gwa_output3-ldate EQ gwa_output2-ldate AND gwa_output3-orige NE gwa_output2-orige.
*            gwa_output2-ltimei = gwa_output3-ltimei.
*            gwa_output2-ltimes = gwa_output3-ltimes.
*            MODIFY gtd_output FROM gwa_output2.
*            DELETE gtd_output WHERE ldate = gwa_output3-ldate AND orige = gwa_output3-orige AND pernr EQ gwa_output3-pernr.
*          ENDIF.
*        ENDLOOP.
*      ENDLOOP.

      LOOP AT resultsk ASSIGNING FIELD-SYMBOL(<resultsk>) where PersonnelNumber = me->result-PersonnelNumber.
        LOOP AT results ASSIGNING FIELD-SYMBOL(<result>) WHERE personnelnumber EQ <resultsk>-personnelnumber AND
                                                               markdate EQ <resultsk>-markdate AND
                                                               dataorigin NE <resultsk>-dataorigin .
          <result>-actualstarttime = <resultsk>-actualstarttime.
          <result>-actualendtime = <resultsk>-actualendtime.
          DELETE results WHERE markdate EQ <resultsk>-markdate AND dataorigin = <resultsk>-dataorigin AND personnelnumber = <resultsk>-personnelnumber.
        ENDLOOP.
      ENDLOOP.
      "@0008}
    ENDIF.                                                  "+@0015




  ENDMETHOD.


  METHOD obtiene_calendario_festivo.
    DATA: l_femas7 TYPE d.  "Dia actual + 7 dias en el futuro
    clear gtd_iscal_day.
    IF gwa_p0001-werks NE gs_werkss OR
       gwa_p0001-btrtl NE gs_btrtll.
      REFRESH gtd_iscal_day.
      l_femas7 = sy-datum + 7.




*      PERFORM calendario_festivo_x_pernr(zhru0001) USING  <fs_p0001>-werks  "Division
*                                                          <fs_p0001>-btrtl  "Sub.division
*                                                          start_date
*                                                          l_femas7
*                                                CHANGING  gtd_iscal_day. "Tab.feriados
      me->calendario_festivo_x_pernr(
      EXPORTING
        pi_werks     = gwa_p0001-werks
        pi_btrtl     = gwa_p0001-btrtl
        pi_begda     = start_date
        pi_endda     = l_femas7
      CHANGING
        po_iscal_day = gtd_iscal_day
    ).
      SORT gtd_iscal_day BY date.
*...Se guarda valores p.el sgte.registro en caso sea igual p.reutilizar la Tab.Int.
      MOVE: gwa_p0001-werks TO gs_werkss,  "Division
            gwa_p0001-werks TO gs_btrtll.  "Sub division
    ENDIF.


  ENDMETHOD.


  METHOD obtiene_ingreso_salida_real.
    " TODO: parameter HCM_DETAILS is never used or assigned (ABAP cleaner)

    DATA li_sw1            LIKE sy-subrc.

                                                            " {+@0004
    DATA ltd_pausas_inicio TYPE STANDARD TABLE OF gty_marcas.
    DATA ltd_pausas_fin    TYPE STANDARD TABLE OF gty_marcas.
    FIELD-SYMBOLS <fs_pausas> TYPE gty_marcas.
                                                            " }+@0004

    CHECK p2011 IS NOT INITIAL.
    " Se obtiene en gtd_marcas los registros de marcación del trabajador
    " q.se esta procesando, para todos los registros contenidos en Infotipo 2011
    " hechos temporales. correspondiente tipo de marca: P10 o P20, p.luego conseguir
    " unicos registros de entrada y salida por cada fecha
clear gtd_marcas.
    LOOP AT p2011 ASSIGNING FIELD-SYMBOL(<fs_p2011>) WHERE ( teven-ldate >= start_date AND teven-ldate <= end_date )
                                                          and teven-pernr = hcm_detail-PersonnelNumber.
      IF <fs_p2011>-teven-satza = gc_marking OR <fs_p2011>-teven-satza = gc_marksali.
        APPEND INITIAL LINE TO me->gtd_marcas ASSIGNING FIELD-SYMBOL(<marcas>).
        <marcas>-pernr = hcm_detail-personnelnumber.
        <marcas>-ldate = <fs_p2011>-teven-ldate.
        <marcas>-satza = <fs_p2011>-teven-satza.
        <marcas>-ltime = <fs_p2011>-teven-ltime.
        <marcas>-terid = <fs_p2011>-teven-terid.

      ELSEIF <fs_p2011>-teven-satza = gc_marking_pa.
        APPEND INITIAL LINE TO ltd_pausas_inicio ASSIGNING <fs_pausas>.
        <fs_pausas>-pernr = <fs_p2011>-teven-pernr.
        <fs_pausas>-ldate = <fs_p2011>-teven-ldate.
        <fs_pausas>-satza = <fs_p2011>-teven-satza.
        <fs_pausas>-ltime = <fs_p2011>-teven-ltime.
        <fs_pausas>-terid = <fs_p2011>-teven-terid.
        UNASSIGN <fs_pausas>.
      ELSEIF <fs_p2011>-teven-satza = gc_marksali_pa.
        APPEND INITIAL LINE TO ltd_pausas_fin ASSIGNING <fs_pausas>.
        <fs_pausas>-pernr = <fs_p2011>-teven-pernr.
        <fs_pausas>-ldate = <fs_p2011>-teven-ldate.
        <fs_pausas>-satza = <fs_p2011>-teven-satza.
        <fs_pausas>-ltime = <fs_p2011>-teven-ltime.
        <fs_pausas>-terid = <fs_p2011>-teven-terid.
        UNASSIGN <fs_pausas>.
      ENDIF.
    ENDLOOP.

    " Borramos la información de varias marcas para las pausas.
    SORT ltd_pausas_inicio BY pernr
                              ldate
                              satza
                              ltime.
    DELETE ADJACENT DUPLICATES FROM ltd_pausas_inicio COMPARING pernr ldate satza.

    SORT ltd_pausas_fin BY pernr
                           ldate
                           satza
                           ltime DESCENDING.
    DELETE ADJACENT DUPLICATES FROM ltd_pausas_fin COMPARING pernr ldate satza.
                                                            " }+@0004

    SORT gtd_marcas BY ldate
                       satza
                       ltime.

    " .Loop que obtiene los registros finales de marca a procesarse
    " .en la tabla interna de datos
    CLEAR: gtd_regfinmar,
           li_sw1.
    " -->>LOOP
    DATA gwa_marcas    LIKE LINE OF gtd_marcas.
    DATA lwa_regfinmar LIKE LINE OF gtd_regfinmar.
    LOOP AT gtd_marcas ASSIGNING FIELD-SYMBOL(<fs_gtd_marcas>).
      CLEAR gwa_marcas.
      READ TABLE gtd_marcas INTO gwa_marcas INDEX sy-tabix.
      " ...Es el 1er.reg.de la fecha
      AT NEW ldate.
        li_sw1 = 1.
        lwa_regfinmar-ldate = gwa_marcas-ldate.
      ENDAT.
      " ...1er.registro para P10 = registro de Ingreso
      AT NEW satza.
        IF li_sw1 = 1 AND <fs_gtd_marcas>-satza = gc_marking.
          lwa_regfinmar-ltimei = gwa_marcas-ltime.
        ENDIF.
      ENDAT.

      " ...Ultimo registro para P20 = registro de Salida
      AT END OF satza.
        IF li_sw1 = 1 AND <fs_gtd_marcas>-satza = gc_marksali.
          lwa_regfinmar-ltimes = gwa_marcas-ltime.
        ENDIF.
      ENDAT.

      " ...Por fin de fecha, se agrega registro y se consigue hora de
      " ...ingreso y salida teorico x c/fecha registro a almacenarse
      AT END OF ldate.
        lwa_regfinmar-ldate = gwa_marcas-ldate.
        lwa_regfinmar-pernr = gwa_marcas-pernr.
        lwa_regfinmar-terid = gwa_marcas-terid.
        IF lwa_regfinmar-ldate IS NOT INITIAL.
*          zrp-provide-from-las p0007 space <fs_gtd_marcas>-ldate <fs_gtd_marcas>-ldate <fs_p0007>.
*        PERFORM obtiene_horario_teorico USING lwa_regfinmar-ldate
*                                     CHANGING lwa_regfinmar-sobeg
*                                              lwa_regfinmar-soend.
          READ TABLE planned_working_times INTO planned_working_time WITH KEY pernr = personnel_action-hcmpersonnelnumber.

          obtiene_horario_teorico( EXPORTING p_fecha = lwa_regfinmar-ldate
                                   CHANGING  p_sobeg = lwa_regfinmar-sobeg
                                             p_soend = lwa_regfinmar-soend ).

        ENDIF.
        " .....Se agrega registro
        " .....~~~~~~~~~~~~~~~~~~

        " {+@0004 Buscar información de las pausas y agregarlas
        READ TABLE ltd_pausas_inicio ASSIGNING <fs_pausas> WITH KEY pernr = lwa_regfinmar-ldate
                                                                    ldate = lwa_regfinmar-ldate
                                                                    satza = gc_marking_pa BINARY SEARCH.
        IF sy-subrc = 0.
          lwa_regfinmar-ltimeipa = <fs_pausas>-ltime.
          <fs_pausas>-sobeg = '9'.
        ENDIF.

        READ TABLE ltd_pausas_fin ASSIGNING <fs_pausas> WITH KEY pernr = lwa_regfinmar-ldate "#EC *
                                                                 ldate = lwa_regfinmar-ldate
                                                                 satza = gc_marksali_pa BINARY SEARCH.
        IF sy-subrc = 0.
          lwa_regfinmar-ltimespa = <fs_pausas>-ltime.
          <fs_pausas>-sobeg = '9'.
        ENDIF.
                                                            " }+@0004
        APPEND lwa_regfinmar TO gtd_regfinmar.
        CLEAR: lwa_regfinmar,
               li_sw1.
      ENDAT.
    ENDLOOP.

    " {+@0004 Guardar información aunque sólo exista marca de refrigerio
    CLEAR gts_pausas[].
    DELETE ltd_pausas_inicio WHERE sobeg = '9'.
    DELETE ltd_pausas_fin WHERE sobeg = '9'.
    INSERT LINES OF ltd_pausas_fin INTO TABLE ltd_pausas_inicio.
    SORT ltd_pausas_inicio BY pernr
                              ldate.
    gts_pausas = ltd_pausas_inicio.
                                                            " }+@0004
  ENDMETHOD.


  METHOD adicionar_marcas_refrigerio.
    DATA: lf_inicio TYPE teven-ltime,
          lf_fin    TYPE teven-ltime.

    FIELD-SYMBOLS: <fs_pausas> TYPE gty_marcas,
                   <fs_output> TYPE gty_output.

    LOOP AT gts_pausas ASSIGNING <fs_pausas> where pernr = me->result-PersonnelNumber.

      AT NEW ldate.
        CLEAR : lf_inicio, lf_fin.
      ENDAT.

      IF <fs_pausas>-satza = gc_marking_pa.
        lf_inicio = <fs_pausas>-ltime.
      ELSEIF <fs_pausas>-satza = gc_marksali_pa.
        lf_fin = <fs_pausas>-ltime.
      ENDIF.

      AT END OF ldate.

* Validar si esa fecha ya se encuentra
        READ TABLE results ASSIGNING FIELD-SYMBOL(<result>) WITH KEY personnelnumber = <fs_pausas>-pernr
                                                             markdate = <fs_pausas>-ldate.
        IF sy-subrc EQ 0.
          <result>-breakstarttime = lf_inicio.
          <result>-breakendtime = lf_fin.
        ELSE.

          APPEND INITIAL LINE TO results ASSIGNING <result>.
          MOVE result TO   <result>.
          MOVE: <fs_pausas>-ldate TO <result>-markdate,
                <fs_pausas>-pernr TO <result>-personnelnumber,
                <fs_pausas>-terid TO <result>-terminalid.

* Información de la estructura organizacional
          MOVE: gwa_p0001-pernr       TO <result>-personnelnumber,
                 gwa_p0001-zz_division TO <result>-division,
                 gwa_p0001-zz_area     TO <result>-area,
                 gwa_p0001-zz_servicio TO <result>-service,
                 gwa_p0001-orgeh       TO <result>-organizationalunit.  "Uni.organizativa

*        IF NOT <result>-Division IS INITIAL OR
*           NOT <result>-area   IS INITIAL OR
*           NOT <result>-Service  IS INITIAL OR
*           NOT <result>-OrganizationalUnit  IS INITIAL.
*          PERFORM textos_estruct_organica(zhru0001) USING <fs_output>-divisi
*                                                          <fs_output>-area
*                                                          <fs_output>-servi
*                                                          <fs_output>-orgeh
*                                                          pnpbegda
*                                                          pnpendda
*                                                 CHANGING <fs_output>-txdiv
*                                                          <fs_output>-txare
*                                                          <fs_output>-txser
*                                                          <fs_output>-txorg.
*        ENDIF.

** Datos personales.
*        MOVE: <fs_p0002>-nachn TO <fs_output>-nachn,
*            <fs_p0002>-nach2 TO <fs_output>-nach2,
*            <fs_p0002>-vorna TO <fs_output>-vorna.
** Apellidos y nombres concatenados
*        CONCATENATE <fs_output>-nachn <fs_output>-nach2 <fs_output>-vorna INTO
*                    <fs_output>-nomcom SEPARATED BY space.


* Por cada nueva fecha obtendremos información del horario
*        zrp-provide-from-las p0007 space <fs_pausas>-ldate <fs_pausas>-ldate <fs_p0007>.
*        PERFORM obtiene_horario_teorico USING <fs_output>-ldate
*                                     CHANGING <fs_output>-sobeg
*                                              <fs_output>-soend.

          obtiene_horario_teorico(
            EXPORTING
              p_fecha = <result>-markdate
            CHANGING
              p_sobeg = <result>-actualstarttime
              p_soend = <result>-actualendtime
          ).

* Asignar las marcas de refrigerio
          <result>-breakstarttime = lf_inicio.
          <result>-breakendtime = lf_fin.


*          UNASSIGN <fs_output>.
        ENDIF.

      ENDAT.

    ENDLOOP.
  ENDMETHOD.


  METHOD calcula_las_faltas.
    DATA:ls_in_range TYPE char1    VALUE space,
         lf_betrg    TYPE ptbindbw-betrg VALUE 0.
    DATA lwa_result LIKE LINE OF results.
    REFRESH: gtd_pc2bf,gtd_t512t.
    CLEAR:gtd_pc2bf,gtd_t512t.

* Se trae movimientos de horas de Lun a Domingos por dias trabajados
    CALL FUNCTION 'ZHR_LEER_ZL'
      EXPORTING
        p_pernr = gwa_p0001-pernr
        p_begda = start_date
        p_endda = end_date
      TABLES
        t_lgart = gtd_t512t
        t_zl    = gtd_pc2bf.

    IF NOT gtd_pc2bf[] IS INITIAL.
* Se asigna el contenido a una tabla de tipo SORT
      gts_pc2bf[] = gtd_pc2bf.
* Se ordena p. localizar registros anteriores y poder definir agregar el registro o no
*    SORT gtd_output BY pernr ldate orige.
      SORT results BY personnelnumber markdate dataorigin.
      LOOP AT gts_pc2bf ASSIGNING FIELD-SYMBOL(<fs_pc2bf>) WHERE lgart = gc_lgart.

* Si hay marcas e IT2001, Se mantiene el reg.de marcas pero a la columna Cost.Hora, se pone en 0.00
* Si hay marcas y registro en ZL, el registro de marcas se mantiene, el registro de ZL NO se muestra
* Si hay IT2001 y registro en ZL, el registro de marcas se mantiene, el registro de ZL NO se muestra
* --> Si el registro existe entonces no se agrega el registro a la tab.int de salida
        READ TABLE results WITH KEY personnelnumber = gwa_p0001-pernr
                                       markdate = <fs_pc2bf>-datum
                                       dataorigin = gc_origen1
                                       TRANSPORTING NO FIELDS
                                       BINARY SEARCH.
        IF sy-subrc EQ 0.
          CONTINUE.
        ENDIF.
        CLEAR: lf_betrg,ls_in_range.

        MOVE result TO lwa_result.
*...Se indica el origen del dato
        lwa_result-dataorigin = gc_origen3.

*Al estar falto los sgtes.campos van en blanco
        CLEAR: lwa_result-markdate,  "Fe.marca
               lwa_result-actualstarttime, "Hora Ingreso Real
               lwa_result-actualendtime, "Hora Salida Real
               lwa_result-terminalid,  "ID Terminal
               lwa_result-terminaltext.  "Texto de ID Terminal

*Dia de inasistencia
        lwa_result-markdate = <fs_pc2bf>-datum.
*Se asigna codigo y descripcion de: FALTA POR JUSTIFICAR
        lwa_result-absencetype  = gc_awart2.

*{+ @0005
        IF gwa_p0001-bukrs EQ gc_bukrs.
          lwa_result-absencetypetext = TEXT-m06.
        ELSE.
          lwa_result-absencetypetext = TEXT-m04.
        ENDIF.
* }

*.....Si el Ti.Ausentismos es FFXJ -> se fuerza valorizac.de horas
        ls_in_range = 'X'.

*Texto Clas.Ausentismo
*      PERFORM texto_clase_ausentismo   USING gwa_p0001-werks
*                                             gwa_p0001-btrtl
*                                             lwa_result-AbsenceType
*                                    CHANGING lwa_result-AbsenceTypeText.
        texto_clase_ausentismo(
          EXPORTING
            pi_werks = gwa_p0001-werks
            pi_btrtl = gwa_p0001-btrtl
            pi_awart = lwa_result-absencetype
          CHANGING
            po_atext = lwa_result-absencetypetext
        ).

*      zrp-provide-from-las p0007 space <fs_pc2bf>-datum <fs_pc2bf>-datum <fs_p0007>.

*      PERFORM obtiene_horario_teorico USING <fs_pc2bf>-datum
*                                   CHANGING gwa_output-sobeg  "Hora Ingreso Teorica
*                                            gwa_output-soend. "Hora Salida Teorica
*

        obtiene_horario_teorico(
          EXPORTING
            p_fecha = <fs_pc2bf>-datum
          CHANGING
            p_sobeg = lwa_result-actualstarttime
            p_soend = lwa_result-actualendtime
        ).
*Si hora de Ingreso y Salida Teorico estan en blanco entonces se asume
*q.sea LIVI,LISA,LIBR en donde no hay horarios -> el registro se agrega a Tab.Int
*los datos que fueron llenados y los demas en blanco
        IF ( lwa_result-theoreticalstarttime IS INITIAL AND lwa_result-theoreticalendtime IS INITIAL ) OR
           ( lwa_result-theoreticalstarttime = space AND lwa_result-theoreticalendtime = space ).
*Se agrega registro
*~~~~~~~~~~~~~~~~~~

          APPEND lwa_result TO results.
*Se preparan datos de P0001 y P0002 para el sgte. registro
          CLEAR: lwa_result.
*        PERFORM asigna_campos_p0001.
*        PERFORM asigna_campos_p0002.
*        PERFORM asigna_campos_p0185.
          CONTINUE.
        ENDIF.

*Si esta marcado se procesa Valorizacion
        IF ls_in_range = 'X'.
*Se realiza valoración
*Se obtiene la estructura del IT 0008 con el intervalo de fecha de marka p.el calculo
*de los emolumentos basicos
          REFRESH gtd_tbindbw.
          CLEAR: gwa_p0008.
*        PERFORM estruct_p0008_calc_emu_basico(zhru0001) TABLES   p0008
*                                                        USING    gwa_output-ldate
*                                                        CHANGING gwa_p0008.

          LOOP AT me->p0008 INTO gwa_p0008 WHERE begda <= lwa_result-markdate AND
                                       endda >= lwa_result-markdate AND
                                       pernr = lwa_result-personnelnumber.
          ENDLOOP.

*        PERFORM obtiene_emolumentos_basicos(zhru0001)  TABLES gtd_tbindbw
*                                                              p0001
*                                                              p0007
*                                                        USING gwa_p0008
*                                                              gs_molga
*                                                              <fs_p0001>-endda
*                                                     CHANGING gtd_t511.
          CALL FUNCTION 'ZHCMF_GET_BASIC_EMOLUMENTS'
            EXPORTING
              pi_molga   = gs_molga
              pi_endda   = gwa_p0001-endda
            TABLES
              pt_tbindbw = gtd_tbindbw
              pi_p0001   = p0001
              pi_p0007   = planned_working_times
            CHANGING
              pi_p0008   = gwa_p0008
              pi_t511    = gtd_t511.

          IF NOT gtd_tbindbw[] IS INITIAL.
            CLEAR lf_betrg.
            LOOP AT gtd_tbindbw ASSIGNING FIELD-SYMBOL(<fs_tbindbw>) WHERE lgart = gc_lgart_su1 OR lgart = gc_lgart_su2.
              ADD <fs_tbindbw>-betrg TO lf_betrg.
            ENDLOOP.
*Valorizacion del dia
            lf_betrg = ( lf_betrg / 30 ).
*Costo dias Hombre
            lwa_result-laborcost = lf_betrg * 1.
            CLEAR lwa_result-timedifference.
          ENDIF.
        ENDIF.

*Se agrega registro
*~~~~~~~~~~~~~~~~~~
        APPEND lwa_result TO results.
*Se preparan datos de P0001 y P0002 para el sgte. registro
        CLEAR: lwa_result.
*      PERFORM asigna_campos_p0001.
*      PERFORM asigna_campos_p0002.
*      PERFORM asigna_campos_p0185.
        gi_return = 0.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.


  METHOD nuevo_calculo_faltas.
    DATA: "ls_dia(2) TYPE c,    "-0015
      ls_val  TYPE c,
      li_dias TYPE i,
*        ls_tage(200) TYPE c,   "-0015
      ls_date TYPE d.

    DATA: lwa_t552a TYPE gty_t552a,
          ltd_t550a TYPE TABLE OF t550a.

    DATA lr_prog TYPE RANGE OF t550a-tprog.
    DATA lwa_result LIKE LINE OF results.

* Calculamos los planes de horario de trabajo no válidos.
*  PERFORM obtener_planes_no_laborables TABLES ltd_t550a.
    obtener_planes_no_laborales(
    CHANGING
    c_ltd_t550a = ltd_t550a ).

*obtener_planes_no_laborales( changing ltd_t550a ).
* Creamos cursor de planes
    LOOP AT ltd_t550a ASSIGNING FIELD-SYMBOL(<t500a>).

      APPEND INITIAL LINE TO lr_prog ASSIGNING FIELD-SYMBOL(<prog>).
      <prog>-sign = 'I'.
      <prog>-option = 'EQ'.
      <prog>-low = <t500a>-tprog.
    ENDLOOP.

* Calculamos la cantidad de dias entre la fecha de incio y fin.
    CALL FUNCTION 'HR_99S_INTERVAL_BETWEEN_DATES'
      EXPORTING
        begda = start_date
        endda = end_date
      IMPORTING
        days  = li_dias.
*  li_dias = ls_tage.
*  li_dias = li_dias + 1.

    SORT results BY personnelnumber markdate dataorigin.
    ls_date = start_date.
    DO li_dias TIMES.
      CLEAR lwa_t552a.
* Verificamos si es un feriado

* Obtenemos el plan de horario de trabajo para dicha fecha
*    PERFORM calcular_plan_horario USING ls_date
*                                  CHANGING lwa_t552a.

      calcular_plan_horario( IMPORTING p_date = ls_date CHANGING cp_t552a = lwa_t552a ).

* Validamos si la fecha es laborable
      CLEAR ls_val.
*      PERFORM validar_fechas_laborables USING ls_date+6(2)
*                                              lr_prog[]
*                                              lwa_t552a
*                                      CHANGING ls_val.
      validar_fechas_laborables( IMPORTING p_day = ls_date+6(2) p_prog = lr_prog p_t552a = lwa_t552a
                                 CHANGING c_val = ls_val ).

      IF ls_val EQ 'T'.
        READ TABLE results  WITH KEY personnelnumber = gwa_p0001-pernr
                                       markdate = ls_date
                                       dataorigin = gc_origen1
                                       TRANSPORTING NO FIELDS.
        IF sy-subrc NE 0. " Si no lo encuentra, puede ser una falta
          READ TABLE results WITH KEY personnelnumber = gwa_p0001-pernr
                                       markdate = ls_date
                                       dataorigin = gc_origen2
                                       TRANSPORTING NO FIELDS.
          IF sy-subrc NE 0. " Si no lo encuentra, es una falta
            READ TABLE gtd_iscal_day ASSIGNING FIELD-SYMBOL(<fs_gtd_iscal_day>) WITH KEY date = ls_date.
            IF sy-subrc EQ 0. " es feriado
              MOVE result TO lwa_result.
              lwa_result-AbsenceType = 'FER'. "+WVF001 se asigna el codigo para poder ser filtrado
              lwa_result-absencetypetext = TEXT-t01.   "gwa_output-atext = 'Feriado'.    "/@0015
              lwa_result-markdate = ls_date.
              CLEAR: lwa_result-theoreticalstarttime,lwa_result-theoreticalendtime.
              APPEND lwa_result TO results.
              CLEAR: lwa_result.
*              PERFORM asigna_campos_p0001.
*              PERFORM asigna_campos_p0002.
*              PERFORM asigna_campos_p0185.
            ELSE.
              MOVE result TO lwa_result.
              lwa_result-dataorigin = gc_origen3.
*Al estar falto los sgtes.campos van en blanco
              CLEAR: lwa_result-markdate,  "Fe.marca
                     lwa_result-actualstarttime, "Hora Ingreso Real
                     lwa_result-actualendtime, "Hora Salida Real
                     lwa_result-terminalid,  "ID Terminal
                     lwa_result-terminaltext.  "Texto de ID Terminal

*Dia de inasistencia
              lwa_result-markdate = ls_date.
*Se asigna codigo y descripcion de: FALTA POR JUSTIFICAR
              lwa_result-absencetype  = gc_awart2.
              lwa_result-absencetypetext = TEXT-m06.
              APPEND lwa_result TO results.
              CLEAR: lwa_result.
*              PERFORM asigna_campos_p0001.
*              PERFORM asigna_campos_p0002.
*              PERFORM asigna_campos_p0185.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
*    ENDIF.
* Se incrementa un dia
      CALL FUNCTION 'CALCULATE_DATE'
        EXPORTING
          days        = '1'
          start_date  = ls_date
        IMPORTING
          result_date = ls_date.

    ENDDO.
  ENDMETHOD.


  METHOD valida_cesados.
    DATA: lv_dat TYPE pa0041-dat03.
*  zrp-provide-from-las p0000 space pn-begda pn-endda <fs_p0000>.
    IF personnel_action-hcmemploymentstatus EQ 0. " Quiere decir que se encuentra cesado.
* Buscamos fecha de cese.

*    zrp-provide-from-las p0041 space pn-begda pn-endda gwa_P0041.
      IF gwa_p0041-dar01 EQ '03'.
        lv_dat = gwa_p0041-dat01.
      ELSE.
        IF gwa_p0041-dar02 EQ '03'.
          lv_dat = gwa_p0041-dat02.
        ELSE.
          IF gwa_p0041-dar03 EQ '03'.
            lv_dat = gwa_p0041-dat03.
          ELSE.
            IF gwa_p0041-dar04 EQ '03'.
              lv_dat = gwa_p0041-dat04.
            ELSE.
              IF gwa_p0041-dar05 EQ '03'.
                lv_dat = gwa_p0041-dat05.
              ELSE.
                IF gwa_p0041-dar06 EQ '03'.
                  lv_dat = gwa_p0041-dat06.
                ELSE.
                  IF gwa_p0041-dar07 EQ '03'.
                    lv_dat = gwa_p0041-dat07.
                  ELSE.
                    IF gwa_p0041-dar08 EQ '03'.
                      lv_dat = gwa_p0041-dat08.
                    ELSE.
                      IF gwa_p0041-dar09 EQ '03'.
                        lv_dat = gwa_p0041-dat09.
                      ELSE.
                        IF gwa_p0041-dar10 EQ '03'.
                          lv_dat = gwa_p0041-dat10.
                        ELSE.
                          IF gwa_p0041-dar11 EQ '03'.
                            lv_dat = gwa_p0041-dat11.
                          ELSE.
                            IF gwa_p0041-dar12 EQ '03'.
                              lv_dat = gwa_p0041-dat12.
                            ENDIF.
                          ENDIF.
                        ENDIF.
                      ENDIF.
                    ENDIF.
                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
      CHECK NOT lv_dat IS INITIAL.
*    DELETE gtd_output WHERE ldate > lv_dat.  " Borra aquellos registros mayores a la fecha de cese.     "DELETE GTD_OUTPUT WHERE ldate >= lv_dat.   "/@0010    "-@0013
*{+@0013
      DELETE results WHERE " PersonnelNumber EQ pernr-pernr
                          markdate GT lv_dat.
*}+@0013
    ENDIF.


  ENDMETHOD.


  METHOD valida_unica_marca.
    FIELD-SYMBOLS: <fs_output> TYPE gty_output.
    DATA: l_pdsnr  TYPE teven-pdsnr.

    TYPES: BEGIN OF lty_even ,
             pdsnr TYPE teven-pdsnr,
             pernr TYPE teven-pernr,
             ldate TYPE teven-ldate,
             satza TYPE teven-satza,
*          count TYPE sy-tabix,
           END OF lty_even.
    "@0018 insert
    DATA: lt_even  TYPE TABLE OF lty_even,
          ls_even  TYPE lty_even,
          lv_count TYPE sy-tabix.

    data ltd_results type tty_hcm_detail.
      ltd_results = results.
      delete ltd_results where PersonnelNumber <> me->result-PersonnelNumber.
*    IF NOT results IS INITIAL.
    IF NOT ltd_results IS INITIAL.

      SELECT pdsnr pernr ldate satza
      INTO TABLE lt_even
      FROM teven
      FOR ALL ENTRIES IN ltd_results
      WHERE pernr EQ ltd_results-personnelnumber
            AND ldate EQ ltd_results-markdate
            AND stokz EQ ''
            AND ( satza EQ 'P20' OR satza EQ 'P10' ).

    ENDIF.
    SORT lt_even.
    DELETE ADJACENT DUPLICATES FROM lt_even COMPARING pernr ldate satza.
    "@0018 end
    LOOP AT results ASSIGNING FIELD-SYMBOL(<result>) where PersonnelNumber = me->result-PersonnelNumber.
      "@0018 insert
      CLEAR lv_count.
      LOOP AT lt_even INTO ls_even  WHERE pernr EQ <result>-personnelnumber AND
                                          ldate EQ <result>-markdate.
        CASE ls_even-satza.
          WHEN 'P10'.
            ADD 1 TO lv_count.
          WHEN 'P20'.
            ADD 1 TO lv_count.
        ENDCASE.
      ENDLOOP.

      IF lv_count LT 2 AND  <result>-absencetypetext IS INITIAL.
        <result>-AbsenceType = 'M1V'. "+wvf001 asignar el codigo para el filtro
        <result>-absencetypetext = TEXT-t02.
      ELSEIF lv_count GT 2 AND <result>-absencetypetext IS INITIAL.
        <result>-absencetypetext = TEXT-t04.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD obtiene_horario_teorico.
    DATA: ls_tpr00(15).
    FIELD-SYMBOLS: <lfs_tpr00> TYPE tprog.

    REFRESH: gtd_t001p,gtd_t001p_aux,gtd_t508z,gtd_t503,gtd_t550a.
    CLEAR:   gtd_t001p,gtd_t001p_aux,gtd_t508z,gtd_t503,gtd_t550a.

* Informacion de División / subdivisión de personal
    SELECT werks btrtl mofid mosid INTO TABLE gtd_t001p
           FROM t001p
           WHERE werks EQ gwa_p0001-werks AND
                 btrtl EQ gwa_p0001-btrtl.
    IF NOT gtd_t001p[] IS INITIAL.
      SORT gtd_t001p BY werks btrtl .
*...Hallar la relacion entre el plan de trabajo y el plan de trabajo diario
      MOVE gtd_t001p[] TO gtd_t001p_aux[].
      DELETE ADJACENT DUPLICATES FROM gtd_t001p_aux COMPARING mosid.
      SELECT mosid motpr INTO TABLE gtd_t508z
             FROM t508z
             FOR ALL ENTRIES IN gtd_t001p_aux
             WHERE mosid EQ gtd_t001p_aux-mosid.
      IF NOT gtd_t508z[] IS INITIAL.
        SORT gtd_t508z BY mosid.
*.....Informacion de Grupo personal/Área personal
        SELECT persg persk zeity INTO TABLE gtd_t503
               FROM t503
               WHERE persg EQ gwa_p0001-persg AND
                     persk EQ gwa_p0001-persk.
        IF NOT gtd_t503[] IS INITIAL.
          SORT gtd_t503 BY persg persk.
*........Informacion de División / subdivisión de personal
          DATA lwa_t001p LIKE LINE OF gtd_t001p.
          READ TABLE gtd_t001p INTO lwa_t001p WITH KEY werks = gwa_p0001-werks
                                        btrtl = gwa_p0001-btrtl
                              BINARY SEARCH.
*.......Informacion de Grupo personal/Área personal
          DATA lwa_t503 LIKE LINE OF gtd_t503.
          READ TABLE gtd_t503 INTO lwa_t503 WITH KEY persg = gwa_p0001-persg
                                       persk = gwa_p0001-persk
                             BINARY SEARCH.
*.......Hallare la informacion de Planes de Horario de Trabajo Diario
          REFRESH: gtd_t552a.
          CLEAR:   gtd_t552a,gwa_t552a.
          SELECT SINGLE tpr01 tpr02 tpr03 tpr04 tpr05 tpr06
                        tpr07 tpr08 tpr09 tpr10 tpr11 tpr12
                        tpr13 tpr14 tpr15 tpr16 tpr17 tpr18
                        tpr19 tpr20 tpr21 tpr22 tpr23 tpr24
                        tpr25 tpr26 tpr27 tpr28 tpr29 tpr30
                        tpr31
           INTO gwa_t552a
           FROM t552a
           WHERE zeity EQ lwa_t503-zeity  AND
                 mofid EQ lwa_t001p-mofid AND
                 mosid EQ lwa_t001p-mosid AND
                 schkz EQ planned_working_time-schkz    AND
                 kjahr EQ p_fecha+0(4)   AND
                 monat EQ p_fecha+4(2).
          gwa_t552a-pernr = gwa_p0001-pernr.
*.......Informacion del plan de trabajo diario
          DATA lwa_t508z LIKE LINE OF gtd_t508z.

          READ TABLE gtd_t508z INTO lwa_t508z WITH KEY mosid = lwa_t001p-mosid
                              BINARY SEARCH.
          IF sy-subrc EQ 0.
*.........Agrupacion para plan de trabajo
            gwa_t552a-motpr = lwa_t508z-motpr.
*.........Hallare el plan de trabajo de la fecha
            CONCATENATE 'GWA_T552A-TPR' p_fecha+6(2) INTO ls_tpr00.
            ASSIGN (ls_tpr00) TO <lfs_tpr00>.
            MOVE <lfs_tpr00> TO gwa_t552a-tpr00.
            APPEND gwa_t552a TO gtd_t552a.
          ENDIF.
          IF NOT gtd_t552a[] IS INITIAL.
            SORT gtd_t552a BY motpr tpr00.
            DELETE ADJACENT DUPLICATES FROM gtd_t552a COMPARING motpr tpr00.
*.........Hallare la informacion de las horas del plan normal
            SELECT motpr tprog pamod sobeg soend APPENDING TABLE gtd_t550a
                   FROM t550a
                   FOR ALL ENTRIES IN gtd_t552a
                   WHERE motpr EQ gtd_t552a-motpr AND
                         tprog EQ gtd_t552a-tpr00.
            IF NOT gtd_t550a[] IS INITIAL.
              DATA lwa_t550a LIKE LINE OF gtd_t550a.
              READ TABLE gtd_t550a INTO lwa_t550a  INDEX 1.
              IF sy-subrc EQ 0.
                MOVE: lwa_t550a-sobeg TO p_sobeg,
                      lwa_t550a-soend TO p_soend.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD proces_detail_data.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(page_size) = io_request->get_paging( )->get_page_size( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(offset) = io_request->get_paging( )->get_offset( ).

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(parameters) = io_request->get_parameters( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(sort_order)    = io_request->get_sort_elements( ).
    DATA(search_string) = io_request->get_search_expression( ).

    IF search_string IS NOT INITIAL AND search_string <> '*'.
      DATA(search_sql) = |*{ cl_abap_dyn_prg=>escape_quotes( search_string ) }*|.
    ELSE.
      search_sql = '*'.
    ENDIF.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(params) = io_request->get_parameters( ).
    DATA(filters) = io_request->get_filter( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(sql_filters) = filters->get_as_sql_string( ).
    DATA(filters_range) = filters->get_as_ranges( ).

    LOOP AT filters_range INTO DATA(filter_range).
      CASE filter_range-name.
        WHEN 'PERSONNELNUMBER'.
          DATA(personnelnumber_filter) = filter_range-range.
        WHEN 'SELECTIONPERIOD'.
          start_date = filter_range-range[ 1 ]-low.
          IF filter_range-range[ 1 ]-high IS INITIAL.
            end_date = filter_range-range[ 1 ]-low.
          ELSE.
            end_date = filter_range-range[ 1 ]-high.
          ENDIF.
        WHEN 'OCCUPATIONSTATUS'.
          DATA(occupationstatus_filter) = filter_range-range.
        WHEN 'COMPANY'.
          DATA(company_filter) = filter_range-range.
          IF company_filter[ 1 ]-low = '200'.
            gs_molga = 'BO'.
          ELSE.
            gs_molga = '99'.
          ENDIF.

        WHEN 'HCMEMPLOYEEGROUP'.
          DATA(hcmemployeegroup_filter) = filter_range-range.
        WHEN 'ABSENCETYPE'.

          DATA(absencetype_filter) = filter_range-range.
          s_awart = VALUE #( FOR data IN filter_range-range
                             ( option = data-option sign = data-sign low = data-low high = data-high )  ).
*{ +@wvf001
        WHEN 'ABSENCENEW'.

          absencetype_filter = filter_range-range.

          me->s_awart = VALUE #( FOR data IN absencetype_filter
                                 ( option = data-option sign = data-sign low = data-low high = data-high )  ).
           delete me->s_awart where low eq 'FER'.
          delete me->s_awart where low eq 'FXJ'.
          delete me->s_awart where low eq 'TXJ'.
          delete me->s_awart where low eq 'M1V'.
*} +@wvf001
        WHEN 'DIVISION'.
          DATA(division_filter) = filter_range-range.
        WHEN 'AREA'.
          DATA(area_filter) = filter_range-range.
        WHEN 'SERVICE'.
          DATA(service_filter) = filter_range-range.
        WHEN 'ORGANIZATIONALUNIT'.
          DATA(organizationalunit_filter) = filter_range-range.
        WHEN 'PERIODO'.
          DATA(periodo) = filter_range-range[ 1 ]-low.

        WHEN 'REPORTTYPE'.
          " TODO: variable is assigned but never used (ABAP cleaner)
          DATA(report_type) = filter_range-range[ 1 ]-low.
        WHEN 'JUSTIFABLEABSENTEEISM'.
          " select SINGLE a~low into @data(p_txj) from @filter_range-range as a
          " where low = 'TXJ' .
          LOOP AT filter_range-range ASSIGNING FIELD-SYMBOL(<range>).
            CASE <range>-low.
              WHEN 'TXJ'.
                p_txj = <range>-low.
              WHEN 'FXJ'.
                p_fxj = <range>-low.
            ENDCASE.
          ENDLOOP.

      ENDCASE.
    ENDLOOP.
"{+wvf001 Se lee el nuevo universo de absentismos del usuario
if absencetype_filter is INITIAL.
    SELECT FROM ZTF_Absencetype
      FIELDS 'I'   AS sign,
             'EQ'  AS option,
             awart AS low
      INTO TABLE @absencetype_filter.
    IF sy-subrc = 0.
      s_awart = VALUE #( FOR data IN absencetype_filter
                         ( option = data-option sign = data-sign low = data-low high = data-high )  ).
    ENDIF.
  endif.
"}+wvf001

    CASE periodo.
      WHEN '1'. " Today
        start_date = sy-datum.
        end_date = sy-datum.
      WHEN '2'. " Current month
        start_date = |{ sy-datum+0(6) }01|.

        CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
          EXPORTING day_in            = start_date
          IMPORTING last_day_of_month = end_date.

      WHEN '3'. " current year
        start_date = |{ sy-datum+0(4) }0101|.
        end_date = |{ sy-datum+0(4) }1201|.
        CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
          EXPORTING day_in            = end_date
          IMPORTING last_day_of_month = end_date.

      WHEN '4'. " Up to today
        start_date = |18000101|.
        end_date = sy-datum.
      WHEN '5'. " From today
        start_date = sy-datum.
        end_date = |99991231|.
      WHEN '6'. " Other Period

    ENDCASE.

    get_validate_user( CHANGING employee_filter = personnelnumber_filter ).
    " pa0000
    SELECT HCMPersonnelNumber, HCMEmploymentStatus
      INTO CORRESPONDING FIELDS OF TABLE @personnel_actions
      FROM I_HCMPersonnelAction
      WHERE HCMPersonnelNumber  IN @personnelnumber_filter
        AND HCMEmploymentStatus IN @occupationstatus_filter
        AND StartDate           <= @end_date AND EndDate >= @start_date.

    SORT personnel_actions BY HCMPersonnelNumber.
    DELETE ADJACENT DUPLICATES FROM personnel_actions COMPARING hcmpersonnelnumber.

    IF personnel_actions IS INITIAL.
      RETURN.
    ENDIF.
    get_filters_unitorg( CHANGING orgunit_filter = organizationalunit_filter ).
    " pa0001
    SELECT * INTO CORRESPONDING FIELDS OF TABLE @p0001
      FROM pa0001
      FOR ALL ENTRIES IN @personnel_actions
      WHERE pernr        = @personnel_actions-HCMPersonnelNumber
        AND bukrs       IN @company_filter
        AND persg       IN @hcmemployeegroup_filter
        AND zz_division IN @division_filter
        AND zz_area     IN @area_filter
        AND zz_servicio IN @service_filter
        AND orgeh       IN @organizationalunit_filter
        AND begda       <= @end_date AND endda >= @start_date.

    SELECT OrganizationalUnit, OrganizationalUnitName
      INTO CORRESPONDING FIELDS OF TABLE @org_unit_texts
      FROM I_OrgUnitText
      FOR ALL ENTRIES IN @p0001
      WHERE OrganizationalUnit = @p0001-zz_division.

    SELECT OrganizationalUnit, OrganizationalUnitName
      APPENDING CORRESPONDING FIELDS OF TABLE @org_unit_texts
      FROM I_OrgUnitText
      FOR ALL ENTRIES IN @p0001
      WHERE OrganizationalUnit = @p0001-zz_area.
    SELECT OrganizationalUnit, OrganizationalUnitName
      APPENDING CORRESPONDING FIELDS OF TABLE @org_unit_texts
      FROM I_OrgUnitText
      FOR ALL ENTRIES IN @p0001
      WHERE OrganizationalUnit = @p0001-zz_servicio.

    SELECT OrganizationalUnit, OrganizationalUnitName
      APPENDING CORRESPONDING FIELDS OF TABLE @org_unit_texts
      FROM I_OrgUnitText
      FOR ALL ENTRIES IN @p0001
      WHERE OrganizationalUnit = @p0001-orgeh.

    SELECT CompanyCode, CompanyCodeName
      INTO TABLE @companies_code
      FROM I_ACMCompanyCodeStdVH
      FOR ALL ENTRIES IN @p0001
      WHERE CompanyCode = @p0001-bukrs.

    SELECT CompanyCode, CompanyCodeParameterValue
      FROM I_AddlCompanyCodeInformation AS a
             INNER JOIN
               @p0001 AS b ON a~CompanyCode = b~bukrs
      WHERE CompanyCodeParameterType = 'ZRUC'
      INTO TABLE @DATA(companies_ruc).

*      WHERE companycode = @p0001-bukrs.

    SELECT pernr, icnum INTO CORRESPONDING FIELDS OF TABLE @identity_documents
      FROM pa0185
      FOR ALL ENTRIES IN @personnel_actions
      WHERE pernr  = @personnel_actions-HCMPersonnelNumber
        AND begda <= @end_date AND endda >= @start_date.
    " pa0002
    SELECT * INTO TABLE @personal_informations
      FROM I_HCMPersonalData
      FOR ALL ENTRIES IN @personnel_actions
      WHERE HCMPersonnelNumber  = @personnel_actions-HCMPersonnelNumber
        AND StartDate          <= @end_date AND EndDate >= @start_date
        AND HCMRecordIsLocked   = ''.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE @planned_working_times
      FROM pa0007
      FOR ALL ENTRIES IN @personnel_actions
      WHERE pernr  = @personnel_actions-HCMPersonnelNumber
        AND begda <= @end_date AND endda >= @start_date.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE @time_recording_infotypes
      FROM pa2001
      FOR ALL ENTRIES IN @personnel_actions
      WHERE pernr  = @personnel_actions-HCMPersonnelNumber
        AND awart IN @absencetype_filter
        AND begda <= @end_date AND endda >= @start_date.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE @p0008
      FROM pa0008
      FOR ALL ENTRIES IN @personnel_actions
      WHERE pernr  = @personnel_actions-HCMPersonnelNumber
        AND begda <= @end_date AND endda >= @start_date.
    " data lwa_p0001 like line of p0001.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE @p0041
      FROM pa0041
      FOR ALL ENTRIES IN @personnel_actions
      WHERE pernr  = @personnel_actions-HCMPersonnelNumber
        AND begda <= @end_date AND endda >= @start_date.

    tabla_cc_nomina( EXPORTING pi_molga = gs_molga
                               pi_endda = '99991231'
                     CHANGING  po_t511  = gtd_t511 ).

    LOOP AT personnel_actions INTO personnel_action.
      CLEAR: result,
             results.
      result-personnelnumber = personnel_action-HCMPersonnelNumber.

      READ TABLE p0001 INTO gwa_p0001 WITH KEY pernr = personnel_action-HCMPersonnelNumber.
      IF sy-subrc = 0.
        result-division           = gwa_p0001-zz_division. " division.
        result-area               = gwa_p0001-zz_area.
        result-service            = gwa_p0001-zz_servicio.
        result-organizationalunit = gwa_p0001-orgeh.

        READ TABLE org_unit_texts
             INTO org_unit_text
             WITH KEY OrganizationalUnit = gwa_p0001-zz_division.

        IF sy-subrc = 0.
          result-divisiontext = org_unit_text-OrganizationalUnitName.
        ENDIF.

        READ TABLE org_unit_texts
             INTO org_unit_text
             WITH KEY OrganizationalUnit = gwa_p0001-zz_area.

        IF sy-subrc = 0.
          result-areatext = org_unit_text-OrganizationalUnitName.
        ENDIF.

        READ TABLE org_unit_texts
             INTO org_unit_text
             WITH KEY OrganizationalUnit = gwa_p0001-zz_servicio.

        IF sy-subrc = 0.
          result-servicetext = org_unit_text-OrganizationalUnitName.
        ENDIF.

        READ TABLE org_unit_texts
             INTO org_unit_text
             WITH KEY OrganizationalUnit = gwa_p0001-orgeh.

        IF sy-subrc = 0.
          result-organizationalunittext = org_unit_text-OrganizationalUnitName.
        ENDIF.

        READ TABLE companies_code
             INTO company_code
             WITH KEY CompanyCode = gwa_p0001-bukrs.

        IF sy-subrc = 0.
          result-companyname = company_code-CompanyCodeName.
          result-company     = company_code-CompanyCode.
          READ TABLE companies_ruc INTO DATA(company_ruc) WITH KEY CompanyCode = gwa_p0001-bukrs.
          IF sy-subrc = 0.
            result-ruc = company_ruc-CompanyCodeParameterValue.
          ENDIF.
        ENDIF.
      ELSE.
        CONTINUE.
      ENDIF.

      READ TABLE identity_documents
           INTO identity_document
           WITH KEY pernr = personnel_action-HCMPersonnelNumber.

      IF sy-subrc = 0.
        result-dni = identity_document-icnum.
      ENDIF.

      READ TABLE personal_informations
           INTO personal_information
           WITH KEY HCMPersonnelNumber = personnel_action-HCMPersonnelNumber.

      IF sy-subrc = 0.
        result-lastname       = personal_information-HCMEmployeeLastName.
        result-secondlastname = personal_information-HCMEmployeeSecondName.
        result-firstname      = personal_information-HCMEmployeeFirstName.
        result-fullname       = |{ personal_information-HCMEmployeeLastName } { personal_information-HCMEmployeeSecondName } { personal_information-HCMEmployeeFirstName }|.
      ENDIF.

      READ TABLE p0041 INTO gwa_p0041 WITH KEY pernr = personnel_action-HCMPersonnelNumber.

      IF result-fullname NP search_sql.
        CONTINUE.
      ENDIF.

      CALL FUNCTION 'HR_TMW_DB_READ_TEVENT'
        EXPORTING pernr    = personnel_action-HCMPersonnelNumber
                  fromdate = start_date
                  todate   = end_date
        IMPORTING result   = p2011.

      result-selectionperiod = end_date.
      result-markdate        = start_date.

      READ TABLE planned_working_times INTO planned_working_time WITH KEY pernr = personnel_action-HCMPersonnelNumber.

      infotipo_registro_de_marca( CHANGING hcm_detail  = result
                                           hcm_details = results  ).

      revisar_tiempos_reales( CHANGING hcm_details = results ).
    "{+wvf001 se aplica el filtro generico
      loop at results ASSIGNING FIELD-SYMBOL(<result>) where AbsenceType in absencetype_filter.
        append <result> to hcm_details.
      endloop.
    "}+wvf001
*      APPEND LINES OF results TO hcm_details.-@WVF001
      CLEAR: gwa_p0001,
             org_unit_text,
             company_code,
             company_ruc,
             identity_document,
             personal_information,
             gwa_p0041,
             p2011,
             planned_working_time.
    ENDLOOP.

*    data lt_filter type TTY_HCM_DETAIL.
*    lt_filter = FILTER #( hcm_details where AbsenceType in s_awart_new ).
*
  ENDMETHOD.


  METHOD calendario_festivo_x_pernr.
    SELECT SINGLE mofid INTO @DATA(lv_mofid)
           FROM t001p
           WHERE werks = @pi_werks AND
                 btrtl = @pi_btrtl.
    IF sy-subrc EQ 0.
      CALL FUNCTION 'HOLIDAY_GET'
        EXPORTING
          holiday_calendar           = lv_mofid
          date_from                  = pi_begda
          date_to                    = pi_endda
*     IMPORTING
*         YEAR_OF_VALID_FROM         =
*         YEAR_OF_VALID_TO           =
*         RETURNCODE                 =
        TABLES
          holidays                   = po_iscal_day
        EXCEPTIONS                                             "#EC *
          factory_calendar_not_found = 1
          holiday_calendar_not_found = 2
          date_has_invalid_format    = 3
          date_inconsistency         = 4
          OTHERS                     = 5.
    ENDIF.

  ENDMETHOD.


  METHOD conversion_a_minutos.
    DATA: lp_valor    TYPE p DECIMALS 2,
          lp_valor2   TYPE p DECIMALS 0,
          li_hora     TYPE i,
          li_minuto   TYPE i,
          lc_hora     TYPE char2,
          lc_minuto   TYPE char2,
          ln_resul(6) TYPE n.

    lp_valor  = ( pi_valdecimal * 60 ) / 100.
    lp_valor2 = lp_valor * 100.
    li_hora   = lp_valor2 DIV 60.
    li_minuto = lp_valor2 - ( li_hora * 60 ).
*.Total minutos
    po_totmin = ( li_hora * 60 ) + li_minuto.
    UNPACK: li_hora   TO lc_hora,
            li_minuto TO lc_minuto.
    CONCATENATE lc_hora lc_minuto '00' INTO ln_resul.
    MOVE: ln_resul TO po_difhor.
  ENDMETHOD.


  METHOD verif_ausentis_en_tab_constan.
    "Instanciamiento de la clase de Ad. constantes
    TRY.
        CREATE OBJECT go_constants
          EXPORTING
*           ps_repid = sy-repid.
            ps_repid = 'ZHRR0006'.
      CATCH zcx_programa_desconocido .                  "#EC NO_HANDLER
    ENDTRY.

    CALL METHOD go_constants->value_in_range
      EXPORTING
        ps_rangeid  = gc_idtconst
        ps_value    = p_awart
      IMPORTING
        ps_in_range = p_range.

  ENDMETHOD.


  METHOD convierte_tiempo_en_minutos.

  ENDMETHOD.


  METHOD texto_clase_ausentismo.
* Se guarda valor para sacar el campo: MOABW p. el registro anterior
* p.q.la 2da.vez ya no lo haga
    IF pi_werks NE gs_werks AND
       pi_btrtl NE gs_btrtl.
      SELECT SINGLE moabw INTO gn_moabw
             FROM t001p
             WHERE werks = pi_werks AND
                   btrtl = pi_btrtl.
      IF sy-subrc EQ 0.
*.....Se guardan valores en variables globales
        MOVE: pi_werks TO gs_werks,
              pi_btrtl TO gs_btrtl.
      ENDIF.
    ENDIF.
* Se lee desde la Tab.de memoria
    READ TABLE gth_t554t ASSIGNING FIELD-SYMBOL(<fs_gth_t554t>) WITH TABLE KEY sprsl = sy-langu
                                                                 moabw = gn_moabw
                                                                 awart = pi_awart.
    IF sy-subrc EQ 0.
      po_atext = <fs_gth_t554t>-atext.
    ENDIF.
  ENDMETHOD.


  METHOD set_initial_time.

    IF c_lwa_result-theoreticalstarttime IS INITIAL OR  c_lwa_result-theoreticalstarttime = space.
      MOVE '000000' TO c_lwa_result-theoreticalstarttime.
    ENDIF.
    IF c_lwa_result-theoreticalendtime IS INITIAL OR c_lwa_result-theoreticalendtime = space.
      MOVE '000000' TO c_lwa_result-theoreticalendtime.
    ENDIF.

  ENDMETHOD.


  METHOD obtener_planes_no_laborales.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE c_ltd_t550a
      FROM t550a
      WHERE motpr EQ '30'.

    DELETE c_ltd_t550a WHERE sobeg NE ''.

  ENDMETHOD.


  METHOD calcular_plan_horario.
    REFRESH: gtd_t001p,gtd_t001p_aux,gtd_t508z,gtd_t503,gtd_t550a.
    CLEAR:   gtd_t001p,gtd_t001p_aux,gtd_t508z,gtd_t503,gtd_t550a.

* Informacion de División / subdivisión de personal
    SELECT werks btrtl mofid mosid INTO TABLE gtd_t001p
           FROM t001p
           WHERE werks EQ gwa_p0001-werks AND
                 btrtl EQ gwa_p0001-btrtl.
    IF NOT gtd_t001p[] IS INITIAL.
      SORT gtd_t001p BY werks btrtl .
*...Hallar la relacion entre el plan de trabajo y el plan de trabajo diario
      MOVE gtd_t001p[] TO gtd_t001p_aux[].
      DELETE ADJACENT DUPLICATES FROM gtd_t001p_aux COMPARING mosid.
      SELECT mosid motpr INTO TABLE gtd_t508z
             FROM t508z
             FOR ALL ENTRIES IN gtd_t001p_aux
             WHERE mosid EQ gtd_t001p_aux-mosid.
      IF NOT gtd_t508z[] IS INITIAL.
        SORT gtd_t508z BY mosid.
*.....Informacion de Grupo personal/Área personal
        SELECT persg persk zeity INTO TABLE gtd_t503
               FROM t503
               WHERE persg EQ gwa_p0001-persg AND
                     persk EQ gwa_p0001-persk.
        IF NOT gtd_t503[] IS INITIAL.
          SORT gtd_t503 BY persg persk.
*........Informacion de División / subdivisión de personal
          READ TABLE gtd_t001p INTO DATA(lwa_t001p) WITH KEY werks = gwa_p0001-werks
                                        btrtl = gwa_p0001-btrtl
                              BINARY SEARCH.
*.......Informacion de Grupo personal/Área personal
          READ TABLE gtd_t503 INTO DATA(lwa_t503) WITH KEY persg = gwa_p0001-persg
                                       persk = gwa_p0001-persk
                             BINARY SEARCH.
*.......Hallare la informacion de Planes de Horario de Trabajo Diario
          REFRESH: gtd_t552a.
          CLEAR:   gtd_t552a,gwa_t552a.
          SELECT SINGLE tpr01 tpr02 tpr03 tpr04 tpr05 tpr06
                        tpr07 tpr08 tpr09 tpr10 tpr11 tpr12
                        tpr13 tpr14 tpr15 tpr16 tpr17 tpr18
                        tpr19 tpr20 tpr21 tpr22 tpr23 tpr24
                        tpr25 tpr26 tpr27 tpr28 tpr29 tpr30
                        tpr31
           INTO cp_t552a
           FROM t552a
           WHERE zeity EQ lwa_t503-zeity  AND
                 mofid EQ lwa_t001p-mofid AND
                 mosid EQ lwa_t001p-mosid AND
                 schkz EQ planned_working_time-schkz    AND
                 kjahr EQ p_date+0(4)   AND
                 monat EQ p_date+4(2).
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD validar_fechas_laborables.
    CLEAR  c_val .
    CASE p_day .
      WHEN '01'.
        IF p_t552a-tpr01 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '02'.
        IF p_t552a-tpr02 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '03'.
        IF p_t552a-tpr03 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '04'.
        IF p_t552a-tpr04 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '05'.
        IF p_t552a-tpr05 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '06'.
        IF p_t552a-tpr06 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '07'.
        IF p_t552a-tpr07 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '08'.
        IF p_t552a-tpr08 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '09'.
        IF p_t552a-tpr09 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '10'.
        IF p_t552a-tpr10 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '11'.
        IF p_t552a-tpr11 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '12'.
        IF p_t552a-tpr12 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '13'.
        IF p_t552a-tpr13 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '14'.
        IF p_t552a-tpr14 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '15'.
        IF p_t552a-tpr15 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '16'.
        IF p_t552a-tpr16 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '17'.
        IF p_t552a-tpr17 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '18'.
        IF p_t552a-tpr18 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '19'.
        IF p_t552a-tpr19 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '20'.
        IF p_t552a-tpr20 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '21'.
        IF p_t552a-tpr21 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '22'.
        IF p_t552a-tpr22 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '23'.
        IF p_t552a-tpr23 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '24'.
        IF p_t552a-tpr24 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '25'.
        IF p_t552a-tpr25 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '26'.
        IF p_t552a-tpr26 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '27'.
        IF p_t552a-tpr27 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '28'.
        IF p_t552a-tpr28 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '29'.
        IF p_t552a-tpr29 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '30'.
        IF p_t552a-tpr30 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
      WHEN '31'.
        IF p_t552a-tpr31 IN p_prog.
          c_val = 'F'.
        ELSE.
          c_val = 'T'.
        ENDIF.
    ENDCASE.

  ENDMETHOD.


  METHOD tabla_cc_nomina.
    DATA: lr_lgart  TYPE RANGE OF t511-lgart,
          lwa_lgart LIKE LINE OF lr_lgart.

* CC-nomina
    lwa_lgart = 'ICP'.  lwa_lgart-low = '7*'.  APPEND lwa_lgart TO lr_lgart.
    lwa_lgart = 'ICP'.  lwa_lgart-low = '8*'.  APPEND lwa_lgart TO lr_lgart.
    lwa_lgart = 'ICP'.  lwa_lgart-low = '9*'.  APPEND  lwa_lgart TO lr_lgart.

* CC-nomina
    REFRESH po_t511.
    SELECT molga lgart endda modna
           INTO TABLE po_t511
           FROM t511
           WHERE molga =  pi_molga AND
                 lgart IN lr_lgart AND
                 endda =  pi_endda.


  ENDMETHOD.


  METHOD summary_process.
    IF gwa_p0001-bukrs EQ '100'.
      IF gt_date_week IS INITIAL.
        f_calcular_semanas( EXPORTING ip_begda = start_date ip_endda = end_date
                           CHANGING ct_date_week = gt_date_week  ).
      ENDIF.

      f_traer_tablas(  ).

      f_procesa_data_res(  CHANGING hcm_resumm =  hcm_resumm
             hcm_resumms  = hcm_resumms
           ).
    ENDIF.

  ENDMETHOD.


  METHOD f_calcular_semanas.
    DATA: gv_start      TYPE sy-datum,
          lv_mes        TYPE sy-datum,
          ls_mond_endda TYPE sy-datum,
          ls_sund_endda TYPE sy-datum,
          ls_flag       TYPE c.

    CLEAR ls_flag.

    gv_ndate = ip_begda.
    lv_mes = ip_begda+4(2).

    "Calcular semana del endda.
    CALL FUNCTION 'GET_WEEK_INFO_BASED_ON_DATE'          "@ATC_GET_WEEK_INFO_BASED_ON_DATE
      EXPORTING
        date   = ip_endda         " sy-datum
      IMPORTING
        week   = ls_week           " scal-week
        monday = ls_mond_endda     " sy-datum
        sunday = ls_sund_endda. " sy-datum
    "Calcular semana del endda.

    WHILE ls_flag NE 'X'.
      "Obtener la semana del del mes, según el día
      CALL FUNCTION 'GET_WEEK_INFO_BASED_ON_DATE'        "@ATC_GET_WEEK_INFO_BASED_ON_DATE
        EXPORTING
          date   = gv_ndate          " sy-datum
        IMPORTING
          week   = ls_week           " scal-week
          monday = ls_mond           " sy-datum
          sunday = ls_sund. " sy-datum

      "Almacenar fechas de semana
*    CLEAR: wt_output_res.
      wt_date_week-begda = ls_mond .
      wt_date_week-endda = ls_sund .
      APPEND wt_date_week TO gt_date_week.

      IF ls_mond EQ ls_mond_endda  AND ls_sund EQ ls_sund_endda.
        ls_flag = 'X'.
      ELSE.

        "Sumarle 7 días
        gv_start = gv_ndate .
        CLEAR: gv_ndate." wt_output_res.
        CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
          EXPORTING
            date      = gv_start
            days      = 07
            months    = 00
            signum    = '+'
            years     = 00
          IMPORTING
            calc_date = gv_ndate.
      ENDIF.

    ENDWHILE.
  ENDMETHOD.


  METHOD f_traer_tablas.
    DATA: lr_satza TYPE RANGE OF teven-satza,
          ls_fmond TYPE sy-datum,
          ls_lsund TYPE sy-datum,
          lv_lines TYPE i.
    TYPES: ltt_satza TYPE RANGE OF teven-satza.

    REFRESH: gt_pa2001_res,gt_teven_res,gt_pa0007_res,gtd_iscal_day.

    "Llenar rango satza.
    lr_satza = VALUE ltt_satza( sign = 'I' option = 'EQ' ( low = 'P10' ) ( low = 'P20' ) ).

    "Obtener día inicio y fin que abarcan las semanas.
    DESCRIBE TABLE gt_date_week LINES lv_lines.
    IF lv_lines EQ 1.
      LOOP AT gt_date_week ASSIGNING FIELD-SYMBOL(<fs_date_week_1>).
        ls_fmond = <fs_date_week_1>-begda.
        ls_lsund = <fs_date_week_1>-endda.
      ENDLOOP.
    ELSE.
      LOOP AT gt_date_week ASSIGNING FIELD-SYMBOL(<fs_date_week>).
        IF sy-tabix EQ 1.
          ls_fmond = <fs_date_week>-begda.
        ELSEIF sy-tabix EQ lv_lines.
          ls_lsund = <fs_date_week>-endda.
        ENDIF.
      ENDLOOP.
    ENDIF.

    "Traer constante de absentismos justificados
    SELECT zsign   AS sign
           zoption AS option
           zlow    AS low
     INTO TABLE gr_relat
     FROM zbcranv_n
   WHERE  rangeid EQ 91324
     AND  bukrs   EQ '100'.

    "Traer infotipo 2001
    SELECT pernr subty endda begda alldf
      FROM pa2001
      INTO TABLE gt_pa2001_res
    WHERE   pernr EQ personnel_action-hcmpersonnelnumber
      AND ( ( begda GE ls_fmond AND endda LE ls_lsund )
       OR   ( begda BETWEEN ls_fmond AND ls_lsund ) OR ( endda BETWEEN ls_fmond AND ls_lsund ) )
       and awart in me->s_awart."@wvf0001

    "Conultar infotipo 2011 x periodo
    SELECT pernr ldate satza dallf
      FROM teven
      INTO TABLE gt_teven_res
    WHERE ldate GE ls_fmond
      AND ldate LE ls_lsund
      AND satza IN lr_satza
      AND pernr EQ personnel_action-hcmpersonnelnumber.

    "Consultar IT 0007 x periodo.
    SELECT pernr endda begda wkwdy
      FROM pa0007
      INTO TABLE gt_pa0007_res
    WHERE pernr EQ personnel_action-hcmpersonnelnumber.
    SORT gt_pa0007_res BY begda DESCENDING.

    "Obtener feriados x pern
*  PERFORM calendario_festivo_x_pernr(zhru0001) USING  pernr-werks  "Division
*                                                      pernr-btrtl  "Sub.division
*                                                      ls_fmond
*                                                      ls_sund
*                                             CHANGING gtd_iscal_day. "Tab.feriados

    me->calendario_festivo_x_pernr(
    EXPORTING
      pi_werks     = gwa_p0001-werks
      pi_btrtl     = gwa_p0001-btrtl
      pi_begda     = ls_fmond
      pi_endda     = ls_sund
    CHANGING
      po_iscal_day = gtd_iscal_day
  ).



    SORT gtd_iscal_day BY date.

*  "Obtener datos del personal
*  zrp-provide-from-las p0002 space ls_fmond ls_lsund <fs_p0002>.
    SELECT SINGLE * INTO  @personal_information
      FROM i_hcmpersonaldata
      WHERE hcmpersonnelnumber  = @gwa_p0001-pernr
        AND startdate          <= @ls_fmond AND enddate >= @ls_lsund.
  ENDMETHOD.


  METHOD f_procesa_data_res.
    DATA: lv_decimal   TYPE string,
          ls_fecha1    TYPE string,
          lv_endda_aux TYPE pa0001-endda,                   "+@0020
          lwa_pa0007   TYPE gty_pa0007,                     "+@0020
          lv_wkwdy     TYPE pa0007-wkwdy,
*        ltd_pa0007_aux TYPE STANDARD TABLE of gty_pa0007,                     "+@0020
          ls_fecha2    TYPE string.

    DATA lwa_result LIKE LINE OF  hcm_resumms .
* "} +@0020
*  ltd_pa0007_aux[] = gt_pa0007_res[].
*  SORT ltd_pa0007_aux BY begda endda.
*  READ TABLE gt_pa0007_res INDEX 1 INTO lwa_pa0007. " Se lee el registro vigente del empleado para traer los dias laborables.
*  LOOP AT ltd_pa0007_aux ASSIGNING FIELD-SYMBOL(<fs_pa0007>) WHERE begda <= pn-begda AND endda >= pn-endda.
*    lv_wkwdy = <fs_pa0007>-wkwdy.
*    exit.
*  ENDLOOP.
    READ TABLE planned_working_times INTO planned_working_time WITH KEY pernr = personnel_action-hcmpersonnelnumber.
    lv_wkwdy = planned_working_time-wkwdy.

* "{ +@0020

    LOOP AT gt_date_week ASSIGNING FIELD-SYMBOL(<fs_date_week_res>).
      MOVE hcm_resumm TO lwa_result.
      REFRESH: gt_pa2001_res_aux,gt_teven_res_aux, gt_pa0007_res_aux.
      CLEAR: ls_fecha1, ls_fecha2.", lv_lines.
      gt_pa2001_res_aux[] = gt_pa2001_res[].
      gt_teven_res_aux[]  = gt_teven_res[].
      gt_pa0007_res_aux[]  = gt_pa0007_res[].
      gtd_iscal_day_aux[]  = gtd_iscal_day[].

      "Agregar personal
*    wt_output_res-pernr = pernr-pernr.

      "Agregar Nombre
*    CONCATENATE <fs_p0002>-nachn <fs_p0002>-nach2 <fs_p0002>-vorna INTO wt_output_res-nachn SEPARATED BY space.

      "Agregar Semana
      CONCATENATE <fs_date_week_res>-begda+6(2) '.' <fs_date_week_res>-begda+4(2) '.' <fs_date_week_res>-begda(4)
             INTO ls_fecha1.
      CONCATENATE <fs_date_week_res>-endda+6(2) '.' <fs_date_week_res>-endda+4(2) '.' <fs_date_week_res>-endda(4)
             INTO ls_fecha2.
      CONDENSE: ls_fecha1, ls_fecha2 NO-GAPS.
*    CONCATENATE ls_fecha1 '-' ls_fecha2 INTO wt_output_res-lweek SEPARATED BY space.
      CONCATENATE ls_fecha1 '-' ls_fecha2 INTO lwa_result-weekmonth SEPARATED BY space.

      IF lv_wkwdy IS NOT INITIAL .
        lv_endda_aux = <fs_date_week_res>-begda + lv_wkwdy - 1.
*      PERFORM f_obtener_marcas USING    <fs_date_week_res>-begda
*                                    lv_endda_aux
*                           CHANGING wt_output_res-satza
*                                    wt_output_res-subty
*                                    wt_output_res-wkwdy.
        f_obtener_marcas( EXPORTING fs_date_week_res_begda = <fs_date_week_res>-begda
                                    fs_date_week_res_endda = lv_endda_aux
                           CHANGING p_wt_output_res_satza = lwa_result-totalofrealmarks
                           p_wt_output_res_subty = lwa_result-totalofabsenteeismmarks
                           p_wt_output_res_wkwdy = lwa_result-totaloftheoreticalmarks ).

        CLEAR lv_endda_aux.
      ELSE.

*      PERFORM f_obtener_marcas USING    <fs_date_week_res>-begda
*                                         <fs_date_week_res>-endda
*                                CHANGING wt_output_res-satza
*                                         wt_output_res-subty
*                                         wt_output_res-wkwdy.

        f_obtener_marcas( EXPORTING fs_date_week_res_begda = <fs_date_week_res>-begda
                                    fs_date_week_res_endda =  <fs_date_week_res>-endda
                           CHANGING p_wt_output_res_satza = lwa_result-totalofrealmarks
                           p_wt_output_res_subty = lwa_result-totalofabsenteeismmarks
                           p_wt_output_res_wkwdy = lwa_result-totaloftheoreticalmarks ).
      ENDIF.


      "Obtener pocentaje según marcas

*    wt_output_res-lporc = ( ( wt_output_res-satza + wt_output_res-subty ) / wt_output_res-wkwdy * 100 ).
*      IF lwa_result-totaloftheoreticalmarks IS NOT INITIAL.
      try.
        lwa_result-percentage = ( ( lwa_result-totalofrealmarks + lwa_result-totalofabsenteeismmarks ) / lwa_result-totaloftheoreticalmarks * 100 ).

     catch cx_sy_zerodivide into data(cx_obj).
        lwa_result-percentage = 0.
     ENDTRY.


      CONDENSE lwa_result-percentage NO-GAPS.
      IF strlen( lwa_result-percentage ) LE 5.
        CONCATENATE  lwa_result-percentage '%' INTO lwa_result-percentage .
      ELSE.
        CONCATENATE  lwa_result-percentage+0(5) '%' INTO lwa_result-percentage .
      ENDIF.


      "Guardar
      APPEND lwa_result TO hcm_resumms.
    ENDLOOP.


  ENDMETHOD.


  METHOD f_obtener_marcas.
    DATA: lv_lines      TYPE i,
          lv_lines_2    TYPE i,
          lv_lines_fe   TYPE i,
          lv_lines_fe_2 TYPE sy-datum,
          lv_flag_abs   TYPE c.

    "Feriados
    DELETE gtd_iscal_day_aux WHERE date NOT BETWEEN fs_date_week_res_begda AND fs_date_week_res_endda.

    "Agregar total de marcas reales
    IF gt_teven_res_aux IS NOT INITIAL.
      DELETE gt_teven_res_aux WHERE ldate NOT BETWEEN fs_date_week_res_begda AND fs_date_week_res_endda.
    ENDIF.
    "Quitar los feriados de las marcas si lo hubiesen
    IF gtd_iscal_day_aux IS NOT INITIAL.
      LOOP AT gt_teven_res_aux ASSIGNING FIELD-SYMBOL(<fs_teven_fer>).
        LOOP AT gtd_iscal_day_aux ASSIGNING FIELD-SYMBOL(<fs_iscal_fer>) WHERE date EQ <fs_teven_fer>-ldate.
          lv_lines_fe = lv_lines_fe + 1.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

    IF gt_pa2001_res_aux IS NOT INITIAL.
      LOOP AT gt_teven_res_aux ASSIGNING FIELD-SYMBOL(<fs_teven_tot>).
        lv_lines = lv_lines + 1.
        LOOP AT gt_pa2001_res_aux ASSIGNING FIELD-SYMBOL(<fs_pa2001_tot>).
          IF ( <fs_pa2001_tot>-begda EQ <fs_teven_tot>-ldate AND <fs_pa2001_tot>-endda EQ <fs_teven_tot>-ldate )
          OR ( <fs_pa2001_tot>-begda EQ <fs_teven_tot>-ldate AND <fs_pa2001_tot>-endda NE <fs_teven_tot>-ldate )
          OR ( <fs_pa2001_tot>-begda NE <fs_teven_tot>-ldate AND <fs_pa2001_tot>-endda EQ <fs_teven_tot>-ldate )
          OR ( ( <fs_teven_tot>-ldate BETWEEN <fs_pa2001_tot>-begda AND <fs_pa2001_tot>-endda ) AND <fs_pa2001_tot>-begda NE <fs_teven_tot>-ldate AND <fs_pa2001_tot>-endda NE <fs_teven_tot>-ldate ).
            lv_lines = lv_lines - 1.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ELSE.
      DESCRIBE TABLE gt_teven_res_aux LINES lv_lines.
    ENDIF.
    p_wt_output_res_satza = lv_lines - lv_lines_fe.

    "Agregar total de absentismos justificados
    CLEAR lv_lines.
    DESCRIBE TABLE gtd_iscal_day_aux LINES lv_lines.
    "Quitar los feriados y ABSENTISMOS que sean iguales
    IF gtd_iscal_day_aux IS NOT INITIAL.
      LOOP AT gt_pa2001_res_aux ASSIGNING FIELD-SYMBOL(<fs_pa2001_fer>) WHERE subty IN gr_relat.
        LOOP AT gtd_iscal_day_aux ASSIGNING FIELD-SYMBOL(<fs_iscal_fer_abs>).
          IF ( <fs_iscal_fer_abs>-date BETWEEN <fs_pa2001_fer>-begda AND <fs_pa2001_fer>-endda )
          OR ( <fs_iscal_fer_abs>-date EQ <fs_pa2001_fer>-begda AND <fs_iscal_fer_abs>-date EQ <fs_pa2001_fer>-endda )
          OR ( <fs_iscal_fer_abs>-date EQ <fs_pa2001_fer>-begda OR <fs_iscal_fer_abs>-date EQ <fs_pa2001_fer>-endda ) .
            lv_lines = lv_lines - 1.
          ENDIF.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

    LOOP AT gt_pa2001_res_aux ASSIGNING FIELD-SYMBOL(<fs_pa2001>) WHERE subty IN gr_relat.
      CLEAR: lv_lines_fe_2, lv_flag_abs.
      IF ( <fs_pa2001>-begda BETWEEN fs_date_week_res_begda AND fs_date_week_res_endda ) AND <fs_pa2001>-begda EQ <fs_pa2001>-endda .
        lv_lines_2 = lv_lines_2 + 1.
*       ELSEIF ( ( <fs_pa2001>-begda BETWEEN fs_date_week_res_begda AND fs_date_week_res_endda ) AND
*                ( <fs_pa2001>-endda BETWEEN fs_date_week_res_begda AND fs_date_week_res_endda ) AND <fs_pa2001>-begda NE <fs_pa2001>-endda )
*           OR ( ( <fs_pa2001>-begda BETWEEN fs_date_week_res_begda AND fs_date_week_res_endda ) OR
*                ( <fs_pa2001>-endda BETWEEN fs_date_week_res_begda AND fs_date_week_res_endda ) ).
      ELSE.
        lv_lines_fe_2 = <fs_pa2001>-begda .
        WHILE lv_flag_abs NE 'X'.
          IF lv_lines_fe_2 BETWEEN fs_date_week_res_begda AND fs_date_week_res_endda .
            lv_lines_2 = lv_lines_2 + 1.
          ENDIF.
          IF lv_lines_fe_2 EQ <fs_pa2001>-endda.
            lv_flag_abs = 'X'.
          ELSE.
            "Sumarle 7 días
            CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
              EXPORTING
                date      = lv_lines_fe_2
                days      = 01
                months    = 00
                signum    = '+'
                years     = 00
              IMPORTING
                calc_date = lv_lines_fe_2.
          ENDIF.
        ENDWHILE.

      ENDIF.
    ENDLOOP.
    p_wt_output_res_subty = ( lv_lines_2 + lv_lines ) * 2.

    "Agregar total de marcas teóricas
    DELETE gt_pa0007_res_aux WHERE begda GT fs_date_week_res_begda.
    LOOP AT gt_pa0007_res_aux ASSIGNING FIELD-SYMBOL(<fs_pa0007_res>) WHERE endda GT fs_date_week_res_begda.
      p_wt_output_res_wkwdy = <fs_pa0007_res>-wkwdy * 2.
    ENDLOOP.
  ENDMETHOD.


  METHOD proces_resumm_data.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(page_size) = io_request->get_paging( )->get_page_size( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(offset) = io_request->get_paging( )->get_offset( ).

    DATA(parameters) = io_request->get_parameters( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(sort_order)    = io_request->get_sort_elements( ).
    DATA(search_string) = io_request->get_search_expression( ).

    IF search_string IS NOT INITIAL AND search_string <> '*'.
      DATA(search_sql) = |*{ cl_abap_dyn_prg=>escape_quotes( search_string ) }*|.
    ELSE.
      search_sql = '*'.
    ENDIF.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(params) = io_request->get_parameters( ).
    DATA(filters) = io_request->get_filter( ).
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA(sql_filters) = filters->get_as_sql_string( ).
    DATA(filters_range) = filters->get_as_ranges( ).

    LOOP AT filters_range INTO DATA(filter_range).
      CASE filter_range-name.
        WHEN 'PERSONNELNUMBER'.
          DATA(personnelnumber_filter) = filter_range-range.
        WHEN 'SELECTIONPERIOD'.
          start_date = filter_range-range[ 1 ]-low.
          IF filter_range-range[ 1 ]-high IS INITIAL.
            end_date = filter_range-range[ 1 ]-low.
          ELSE.
            end_date = filter_range-range[ 1 ]-high.
          ENDIF.
        WHEN 'OCCUPATIONSTATUS'.
          DATA(occupationstatus_filter) = filter_range-range.
        WHEN 'COMPANY'.
          DATA(company_filter) = filter_range-range.
          IF company_filter[ 1 ]-low = '200'.
            gs_molga = 'BO'.
          ELSE.
            gs_molga = '99'.
          ENDIF.

        WHEN 'HCMEMPLOYEEGROUP'.
          DATA(hcmemployeegroup_filter) = filter_range-range.
        WHEN 'ABSENCETYPE'.

          DATA(absencetype_filter) = filter_range-range.
*          APPEND LINES OF absencetype_filter to me->s_awart.gi_return
          me->s_awart = VALUE #( FOR data IN filter_range-range
                                 ( option = data-option sign = data-sign low = data-low high = data-high )  ).

*{ +@wvf001
        WHEN 'ABSENCENEW'.

          absencetype_filter = filter_range-range.
          delete absencetype_filter where low eq 'FER'.
          delete absencetype_filter where low eq 'FXJ'.
          delete absencetype_filter where low eq 'TXJ'.
          delete absencetype_filter where low eq 'M1V'.
          me->s_awart = VALUE #( FOR data IN absencetype_filter
                                 ( option = data-option sign = data-sign low = data-low high = data-high )  ).
*} +@wvf001
        WHEN 'DIVISION'.
          DATA(division_filter) = filter_range-range.
        WHEN 'AREA'.
          DATA(area_filter) = filter_range-range.
        WHEN 'SERVICE'.
          DATA(service_filter) = filter_range-range.
        WHEN 'ORGANIZATIONALUNIT'.
          DATA(organizationalunit_filter) = filter_range-range.
        WHEN 'PERIODO'.
          DATA(periodo) = filter_range-range[ 1 ]-low.

        WHEN 'REPORTTYPE'.
          DATA(report_type) = filter_range-range[ 1 ]-low.
        WHEN 'JUSTIFABLEABSENTEEISM'.
*         select SINGLE a~low into @data(p_txj) from @filter_range-range as a
*         where low = 'TXJ' .
          LOOP AT filter_range-range ASSIGNING FIELD-SYMBOL(<range>).
            CASE <range>-low.
              WHEN 'TXJ'.
                p_txj = <range>-low.
              WHEN 'FXJ'.
                p_fxj = <range>-low.
            ENDCASE.
          ENDLOOP.

      ENDCASE.
    ENDLOOP.
"{+wvf001 Se lee el nuevo universo de absentismos del usuario
if absencetype_filter is INITIAL or me->s_awart is INITIAL.
    SELECT FROM ZTF_Absencetype
      FIELDS 'I'   AS sign,
             'EQ'  AS option,
             awart AS low
      INTO TABLE @absencetype_filter.
    IF sy-subrc = 0.
      s_awart = VALUE #( FOR data IN absencetype_filter
                         ( option = data-option sign = data-sign low = data-low high = data-high )  ).
    ENDIF.
  endif.
"}+wvf001
    CASE periodo.
      WHEN '1'. " Today
        start_date = sy-datum.
        end_date = sy-datum.
      WHEN '2'. " Current month
        start_date = |{ sy-datum+0(6) }01|.

        CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
          EXPORTING
            day_in            = start_date
          IMPORTING
            last_day_of_month = end_date.

      WHEN '3'. " current year
        start_date = |{ sy-datum+0(4) }0101|.
        end_date = |{ sy-datum+0(4) }1201|.
        CALL FUNCTION 'RP_LAST_DAY_OF_MONTHS'
          EXPORTING
            day_in            = end_date
          IMPORTING
            last_day_of_month = end_date.

      WHEN '4'. " Up to today
        start_date = |18000101|.
        end_date = sy-datum.
      WHEN '5'. " From today
        start_date = sy-datum.
        end_date = |99991231|.
      WHEN '6'. " Other Period


    ENDCASE.

    GET_VALIDATE_USER(
       CHANGING
        employee_filter = personnelnumber_filter
    ).

                                                            " pa0000
    SELECT hcmpersonnelnumber, hcmemploymentstatus
     INTO CORRESPONDING FIELDS OF TABLE @personnel_actions
     FROM i_hcmpersonnelaction
     WHERE hcmpersonnelnumber  IN @personnelnumber_filter
       AND hcmemploymentstatus IN @occupationstatus_filter
       AND startdate           <=  @end_date  AND enddate >= @start_date.

    SORT personnel_actions BY hcmpersonnelnumber.
    DELETE ADJACENT DUPLICATES FROM personnel_actions COMPARING hcmpersonnelnumber.

    CHECK personnel_actions IS NOT INITIAL.
    get_filters_unitorg(
      CHANGING
        orgunit_filter = organizationalunit_filter
    ).
                                                            " pa0001
    SELECT * INTO CORRESPONDING FIELDS OF TABLE @p0001
      FROM pa0001
      FOR ALL ENTRIES IN @personnel_actions
      WHERE pernr        = @personnel_actions-hcmpersonnelnumber
        AND bukrs       IN @company_filter
        AND persg       IN @hcmemployeegroup_filter
        AND zz_division IN @division_filter
        AND zz_area     IN @area_filter
        AND zz_servicio IN @service_filter
        AND orgeh       IN @organizationalunit_filter
        AND begda       <= @end_date AND endda >= @start_date.

    SELECT organizationalunit, organizationalunitname
      INTO CORRESPONDING FIELDS OF TABLE @org_unit_texts
      FROM i_orgunittext
      FOR ALL ENTRIES IN @p0001
      WHERE organizationalunit = @p0001-zz_division.

    SELECT organizationalunit, organizationalunitname
      APPENDING CORRESPONDING FIELDS OF TABLE @org_unit_texts
      FROM i_orgunittext
      FOR ALL ENTRIES IN @p0001
      WHERE organizationalunit = @p0001-zz_area.

    SELECT organizationalunit, organizationalunitname
      APPENDING CORRESPONDING FIELDS OF TABLE @org_unit_texts
      FROM i_orgunittext
      FOR ALL ENTRIES IN @p0001
      WHERE organizationalunit = @p0001-zz_servicio.
    SELECT organizationalunit, organizationalunitname
      APPENDING CORRESPONDING FIELDS OF TABLE @org_unit_texts
      FROM i_orgunittext
      FOR ALL ENTRIES IN @p0001
      WHERE organizationalunit = @p0001-orgeh.

    SELECT companycode, companycodename
      INTO TABLE @companies_code
      FROM i_acmcompanycodestdvh
      FOR ALL ENTRIES IN @p0001
      WHERE companycode = @p0001-bukrs.

    SELECT companycode, companycodeparametervalue
      FROM i_addlcompanycodeinformation AS a
             INNER JOIN
               @p0001 AS b ON a~companycode = b~bukrs
      WHERE companycodeparametertype = 'ZRUC'
      INTO TABLE @DATA(companies_ruc).

*      WHERE companycode = @p0001-bukrs.

    SELECT pernr, icnum INTO CORRESPONDING FIELDS OF TABLE @identity_documents
      FROM pa0185
      FOR ALL ENTRIES IN @personnel_actions
      WHERE pernr  = @personnel_actions-hcmpersonnelnumber
        AND begda <= @end_date  AND endda >= @start_date.
                                                            " pa0002
    SELECT * INTO TABLE @personal_informations
      FROM i_hcmpersonaldata
      FOR ALL ENTRIES IN @personnel_actions
      WHERE hcmpersonnelnumber  = @personnel_actions-hcmpersonnelnumber
        AND startdate          <= @end_date  AND enddate >= @start_date AND
        hcmrecordislocked = ''.
     sort personal_informations by HCMPersonnelNumber ASCENDING EndDate DESCENDING.


    SELECT * INTO CORRESPONDING FIELDS OF TABLE @planned_working_times
      FROM pa0007
      FOR ALL ENTRIES IN @personnel_actions
      WHERE pernr  = @personnel_actions-hcmpersonnelnumber
        AND begda <= @end_date  AND endda >= @start_date.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE @time_recording_infotypes
      FROM pa2001
      FOR ALL ENTRIES IN @personnel_actions
      WHERE pernr  = @personnel_actions-hcmpersonnelnumber
*        AND awart IN @absencetype_filter -@wvf0001
        AND awart IN @me->s_awart
        AND begda <= @end_date AND endda >=  @start_date.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE @p0008
      FROM pa0008
      FOR ALL ENTRIES IN @personnel_actions
      WHERE pernr  = @personnel_actions-hcmpersonnelnumber
        AND begda <= @end_date  AND endda >= @start_date.
*    data lwa_p0001 like line of p0001.

    SELECT * INTO CORRESPONDING FIELDS OF TABLE @p0041
      FROM pa0041
      FOR ALL ENTRIES IN @personnel_actions
      WHERE pernr  = @personnel_actions-hcmpersonnelnumber
        AND begda <= @end_date  AND endda >= @start_date .

    tabla_cc_nomina(
      EXPORTING pi_molga = gs_molga
                pi_endda = '99991231'
      CHANGING  po_t511  = gtd_t511 ).

    LOOP AT personnel_actions INTO personnel_action.
      CLEAR: result_res, results_res.
      result_res-personnelnumber = personnel_action-hcmpersonnelnumber.

      READ TABLE p0001 INTO gwa_p0001 WITH KEY pernr = personnel_action-hcmpersonnelnumber.
      IF sy-subrc = 0.
        result_res-division           = gwa_p0001-zz_division. " division.
        result_res-area               = gwa_p0001-zz_area.
        result_res-service            = gwa_p0001-zz_servicio.
        result_res-organizationalunit = gwa_p0001-orgeh.

        READ TABLE org_unit_texts
             INTO org_unit_text
             WITH KEY organizationalunit = gwa_p0001-zz_division.

        IF sy-subrc = 0.
          result_res-divisiontext = org_unit_text-organizationalunitname.
        ENDIF.

        READ TABLE org_unit_texts
             INTO org_unit_text
             WITH KEY organizationalunit = gwa_p0001-zz_area.

        IF sy-subrc = 0.
          result_res-areatext = org_unit_text-organizationalunitname.
        ENDIF.

        READ TABLE org_unit_texts
             INTO org_unit_text
             WITH KEY organizationalunit = gwa_p0001-zz_servicio.

        IF sy-subrc = 0.
          result_res-servicetext = org_unit_text-organizationalunitname.
        ENDIF.

        READ TABLE org_unit_texts
             INTO org_unit_text
             WITH KEY organizationalunit = gwa_p0001-orgeh.

        IF sy-subrc = 0.
          result_res-organizationalunittext = org_unit_text-organizationalunitname.
        ENDIF.

        READ TABLE companies_code
             INTO company_code
             WITH KEY companycode = gwa_p0001-bukrs.

        IF sy-subrc = 0.
          result_res-companyname = company_code-companycodename.
          result_res-company     = company_code-companycode.
          READ TABLE companies_ruc INTO DATA(company_ruc) WITH KEY companycode = gwa_p0001-bukrs.
          IF sy-subrc = 0.
*            result_res-ruc = company_ruc-companycodeparametervalue.
          ENDIF.
        ENDIF.
      ELSE.
        CONTINUE.
      ENDIF.

      READ TABLE identity_documents
           INTO identity_document
           WITH KEY pernr = personnel_action-hcmpersonnelnumber.

      IF sy-subrc = 0.
*        result_res-dni = identity_document-icnum.
      ENDIF.

      READ TABLE personal_informations
           INTO personal_information
           WITH KEY hcmpersonnelnumber = personnel_action-hcmpersonnelnumber.

      IF sy-subrc = 0.
        result_res-lastname       = personal_information-hcmemployeelastname.
        result_res-secondlastname = personal_information-hcmemployeesecondname.
        result_res-firstname      = personal_information-hcmemployeefirstname.
        result_res-fullname       = |{ personal_information-hcmemployeelastname } { personal_information-hcmemployeesecondname } { personal_information-hcmemployeefirstname }|.
      ENDIF.

      READ TABLE p0041 INTO gwa_p0041 WITH KEY pernr = personnel_action-hcmpersonnelnumber.

      IF result_res-fullname NP search_sql.
        CONTINUE.
      ENDIF.

      CALL FUNCTION 'HR_TMW_DB_READ_TEVENT'
        EXPORTING
          pernr    = personnel_action-hcmpersonnelnumber
          fromdate = start_date
          todate   = end_date
        IMPORTING
          result   = p2011.


      result_res-selectionperiod = end_date.
*      result_res-markdate        = start_date.

*      CASE report_type.
*        WHEN '1'."Detail
*          WRITE: result-personnelnumber.
*          me->infotipo_registro_de_marca(
*            CHANGING hcm_detail  = result
*                     hcm_details = results  ).

*        WHEN '2'."Summary
      summary_process( CHANGING hcm_resumm  = result_res
                hcm_resumms = results_res ).

*      ENDCASE.
      APPEND LINES OF results_res TO hcm_resumms.
    ENDLOOP.
  ENDMETHOD.


  METHOD revisar_tiempos_reales.
    DATA: lr_p0007   TYPE RANGE OF pa0007-endda,
          lwar_p0007 LIKE LINE OF lr_p0007.



    lwar_p0007-sign   = 'I'.
    lwar_p0007-option = 'BT'.

    LOOP AT planned_working_times ASSIGNING FIELD-SYMBOL(<planned_working_times>) WHERE zterf EQ gc_capmark AND
                                                                                        pernr EQ result-personnelnumber.
      lwar_p0007-low  = <planned_working_times>-begda.
      lwar_p0007-high = <planned_working_times>-endda.

      APPEND  lwar_p0007 TO lr_p0007.
    ENDLOOP.
    IF lr_p0007[] IS INITIAL.
      DELETE  hcm_details  WHERE personnelnumber EQ result-personnelnumber.
    ELSE.
      DELETE  hcm_details  WHERE personnelnumber EQ result-personnelnumber
                      AND markdate NOT IN lr_p0007.
    ENDIF.
  ENDMETHOD.


  METHOD get_filters_unitorg.
    DATA:
      ls_uname  TYPE sysid,
      ls_pernr  TYPE persno,
      ls_respo  TYPE persno,
      ln_orgeh  TYPE orgeh,
      lwa_root  TYPE hrwpc_s_hrobject,
      lr_orgeh  TYPE RANGE OF hrp1000-objid,
      lwa_orgeh LIKE LINE OF orgunit_filter.
    DATA: ltd_objec TYPE STANDARD TABLE OF hrwpc_s_objec,
          ltd_struc TYPE STANDARD TABLE OF hrwpc_s_struc.
    CONSTANTS
      lc_vacio      TYPE char29 VALUE '@1F\QEstruc.org.@ Estruc.org.' .
    FIELD-SYMBOLS <fs_objet> TYPE hrwpc_s_objec.

    CALL FUNCTION 'Z_HR_WF_LEE_PERSONA_CON_USUARI' DESTINATION 'NONE'
      EXPORTING
        ip_usrid = sy-uname
      IMPORTING
        ep_pernr = ls_pernr.
    IF ls_pernr IS NOT INITIAL.
*     Se obtiene la unidad de la persona
      CALL FUNCTION 'Z_HR_WF_LEE_UNIDAD_PERSONAL'
        EXPORTING
          ip_pernr = ls_pernr
        IMPORTING
          ep_orgeh = ln_orgeh.
*     Se obtiene el responsable de la unidad
      CALL FUNCTION 'Z_HR_WF_LEE_RESPONS_CON_UNIDAD'
        EXPORTING
          ip_orgeh = ln_orgeh
        IMPORTING
          ep_pernr = ls_respo.
*     Sólo si el empleado es el responsable de su área:
      IF ls_pernr = ls_respo.
        lwa_root-plvar = '01'.
        lwa_root-otype = 'O'.
        lwa_root-objid = ln_orgeh.
        CALL FUNCTION 'HRWPC_RFC_STRUCTURE_GET' DESTINATION 'NONE'
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
        if orgunit_filter is initial.
            LOOP AT ltd_objec ASSIGNING <fs_objet>.
              lwa_orgeh-sign = 'I'.
              lwa_orgeh-option = 'EQ'.
              lwa_orgeh-low = <fs_objet>-objid.
              APPEND lwa_orgeh TO orgunit_filter.
              CLEAR lwa_orgeh.
            ENDLOOP.
         else.
         loop at orgunit_filter ASSIGNING FIELD-SYMBOL(<orgunit_filter>).
            read table ltd_objec TRANSPORTING NO FIELDS with key objid = <orgunit_filter>-low.
            if sy-subrc <> 0.
                <orgunit_filter>-low = '0'.
            endif.
         endloop.
         delete orgunit_filter where low = '0'.
        endif.
      ENDIF.

      IF orgunit_filter is initial.
        DATA: ls_orgeh like line of orgunit_filter.

              ls_orgeh-sign = 'I'.
              ls_orgeh-option = 'EQ'.
              ls_orgeh-low = ln_orgeh.
              APPEND ls_orgeh TO orgunit_filter.
              CLEAR ls_orgeh.

       ENDIF.

    ENDIF.
  ENDMETHOD."


  METHOD GET_VALIDATE_USER.
    DATA:
      ls_uname  TYPE sysid,
      ls_pernr  TYPE persno,
      ls_respo  TYPE persno,
      ln_orgeh  TYPE orgeh,
      lwa_root  TYPE hrwpc_s_hrobject,
      lr_orgeh  TYPE RANGE OF hrp1000-objid.
    DATA: ltd_objec TYPE STANDARD TABLE OF hrwpc_s_objec,
          ltd_struc TYPE STANDARD TABLE OF hrwpc_s_struc.
    CONSTANTS
      lc_vacio      TYPE char29 VALUE '@1F\QEstruc.org.@ Estruc.org.' .
    FIELD-SYMBOLS <fs_objet> TYPE hrwpc_s_objec.

    CALL FUNCTION 'Z_HR_WF_LEE_PERSONA_CON_USUARI' DESTINATION 'NONE'
      EXPORTING
        ip_usrid = sy-uname
      IMPORTING
        ep_pernr = ls_pernr.
    IF ls_pernr IS NOT INITIAL.
*     Se obtiene la unidad de la persona
      CALL FUNCTION 'Z_HR_WF_LEE_UNIDAD_PERSONAL'
        EXPORTING
          ip_pernr = ls_pernr
        IMPORTING
          ep_orgeh = ln_orgeh.
*     Se obtiene el responsable de la unidad
      CALL FUNCTION 'Z_HR_WF_LEE_RESPONS_CON_UNIDAD'
        EXPORTING
          ip_orgeh = ln_orgeh
        IMPORTING
          ep_pernr = ls_respo.
*     Sólo si el empleado es el responsable de su área:
      IF ls_pernr ne ls_respo.

        IF employee_filter is initial.
        DATA: ls_emplo like line of employee_filter.

              ls_emplo-sign = 'I'.
              ls_emplo-option = 'EQ'.
              ls_emplo-low = ls_pernr.
              APPEND ls_emplo TO employee_filter.
              CLEAR ls_emplo.

         ENDIF.
      ENDIF.

    ENDIF.

  ENDMETHOD."
ENDCLASS.
