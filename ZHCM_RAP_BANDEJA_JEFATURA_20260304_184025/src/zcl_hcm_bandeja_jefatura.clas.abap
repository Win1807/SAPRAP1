class ZCL_HCM_BANDEJA_JEFATURA definition
  public
  final
  create public .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    TYPES:
      BEGIN OF range_option,
        sign   TYPE c LENGTH 1,
        option TYPE c LENGTH 2,
        low    TYPE string,
        high   TYPE string,
      END OF range_option.
    TYPES hcm_data_leadership_tray TYPE STANDARD TABLE OF zc_hcm_data_leadership_tray WITH DEFAULT KEY.
    TYPES hcm_data_task            TYPE STANDARD TABLE OF zc_hcm_get_task WITH DEFAULT KEY.
    TYPES hcm_data_personal        TYPE STANDARD TABLE OF zc_hcm_get_personal WITH DEFAULT KEY.
    TYPES pernr_range              TYPE STANDARD TABLE OF range_option.
    TYPES task_range               TYPE STANDARD TABLE OF range_option.

    METHODS get_constantes
      EXPORTING thrs1000 TYPE zhcmt_hrs1000.

    METHODS get_personal
      EXPORTING tpa0002 TYPE zhcmt_pa0002.

    METHODS get_tarea
      IMPORTING thrs1000 TYPE zhcmt_hrs1000
      EXPORTING !task    TYPE zhcmt_task.

    METHODS get_worklist
      IMPORTING pernr_filter   TYPE task_range
                task_filter    TYPE task_range
      EXPORTING worklist_table TYPE swr_wihdr_table.

protected section.
private section.
ENDCLASS.



CLASS ZCL_HCM_BANDEJA_JEFATURA IMPLEMENTATION.
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

        DATA(page_size) = io_request->get_paging( )->get_page_size( ).
        DATA(offset) = io_request->get_paging( )->get_offset( ).

        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(parameters) = io_request->get_parameters( ).
        DATA(sort_order)    = io_request->get_sort_elements( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(search_string) = io_request->get_search_expression( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(param) = io_request->get_parameters( ).

        CASE io_request->get_entity_id( ).

          WHEN 'ZC_HCM_DATA_LEADERSHIP_TRAY'.

            DATA worklist           TYPE swr_wihdr_table.
            DATA interface_worklist TYPE hcm_data_leadership_tray.

            "--- Get request filters

            DATA(filter_object) = io_request->get_filter( )->get_as_ranges( ).

            LOOP AT filter_object INTO DATA(filter_u).

              CASE filter_u-name.
                WHEN 'EMPLOYEENUMBER'.
                  DATA(filter_personal) = filter_u-range.
                WHEN 'TASK'.
                  DATA(filter_task) = filter_u-range.
                WHEN 'IDWORKITEM'.
                  DATA(filter_wi_id) = filter_u-range.
                WHEN 'TYPE'.
                  DATA(filter_wi_type) = filter_u-range.
                WHEN 'LANGUAJE'.
                  DATA(filter_wi_lang) = filter_u-range.
                WHEN 'TEXT'.
                  DATA(filter_wi_text) = filter_u-range.
                WHEN 'TASKTEXT'.
                  DATA(filter_wi_rhtext) = filter_u-range.
                WHEN 'DATECREATE'.
                  DATA(filter_wi_cd) = filter_u-range.
                WHEN 'CREATEAT'.
                  DATA(filter_wi_ct) = filter_u-range.
                WHEN 'LASTRESPONSABLE'.
                  DATA(filter_wi_aagent) = filter_u-range.
                WHEN 'ENDUSERCONFIRMATION'.
                  DATA(filter_wi_confirm) = filter_u-range.
                WHEN 'REJECTTABLE'.
                  DATA(filter_wi_recject) = filter_u-range.
                WHEN 'STATUSTEXT'.
                  DATA(filter_statustext) = filter_u-range.
                WHEN 'RESPONSABLE'.
                  DATA(filter_wi_aa_name) = filter_u-range.
              ENDCASE.

            ENDLOOP.

            " --- Request data
            IF io_request->is_data_requested( ).
              "-- Paging:
              " TODO: variable is assigned but never used (ABAP cleaner)
              DATA(skip_rows_number) = io_request->get_paging( )->get_offset( ).

              "--- List of WorkListItem

              get_worklist( EXPORTING pernr_filter   = filter_personal
                                      task_filter    = filter_task
                            IMPORTING worklist_table = worklist ).

              IF    filter_wi_id      IS NOT INITIAL OR filter_wi_type    IS NOT INITIAL OR filter_wi_lang    IS NOT INITIAL OR filter_wi_text    IS NOT INITIAL
                 OR filter_wi_rhtext  IS NOT INITIAL OR filter_wi_cd      IS NOT INITIAL OR filter_wi_ct      IS NOT INITIAL OR filter_wi_aagent  IS NOT INITIAL
                 OR filter_wi_confirm IS NOT INITIAL OR filter_wi_recject IS NOT INITIAL OR filter_statustext IS NOT INITIAL OR filter_wi_aa_name IS NOT INITIAL.

                DATA(worklist_auxiliar) = worklist.
                CLEAR worklist.

                LOOP AT worklist_auxiliar INTO DATA(worklist_auxiliar_u) WHERE     wi_id      IN filter_wi_id
                                                                               AND wi_type    IN filter_wi_type
                                                                               AND wi_lang    IN filter_wi_lang
                                                                               AND wi_text    IN filter_wi_text
                                                                               AND wi_rhtext  IN filter_wi_rhtext
                                                                               AND wi_cd      IN filter_wi_cd
                                                                               AND wi_ct      IN filter_wi_ct
                                                                               AND wi_aagent  IN filter_wi_aagent
                                                                               AND wi_confirm IN filter_wi_confirm
                                                                               AND wi_reject  IN filter_wi_recject
                                                                               AND statustext IN filter_statustext
                                                                               AND wi_aa_name IN filter_wi_aa_name.
                  APPEND worklist_auxiliar_u TO worklist.
                ENDLOOP.

              ENDIF.

              " -- SORT

              IF sort_order IS NOT INITIAL.

                DATA(element_name) = sort_order[ 1 ]-element_name.

                CASE element_name.
                  WHEN 'TASK'.
                    element_name = 'WI_RH_TASK'.
                  WHEN 'IDWORKITEM'.
                    element_name = 'WI_ID'.
                  WHEN 'TYPE'.
                    element_name = 'WI_TYPE'.
                  WHEN 'LANGUAJE'.
                    element_name = 'WI_LANG'.
                  WHEN 'TEXT'.
                    element_name = 'WI_TEXT'.
                  WHEN 'TASKTEXT'.
                    element_name = 'WI_RHTEXT'.
                  WHEN 'DATECREATE'.
                    element_name = 'WI_CD'.
                  WHEN 'CREATEAT'.
                    element_name = 'WI_CT'.
                  WHEN 'LASTRESPONSABLE'.
                    element_name = 'WI_AAGENT'.
                  WHEN 'ENDUSERCONFIRMATION'.
                    element_name = 'WI_CONFIRM'.
                  WHEN 'REJECTTABLE'.
                    element_name = 'WI_REJECT'.
                  WHEN 'STATUSTEXT'.
                    element_name = 'STATUSTEXT'.
                  WHEN 'RESPONSABLE'.
                    element_name = 'WI_AA_NAME'.
                ENDCASE.

                IF sort_order[ 1 ]-descending = 'X'.
                  SORT worklist BY (element_name) DESCENDING.
                ELSE.
                  SORT worklist BY (element_name).
                ENDIF.

              ENDIF.

              " Fill response
              DATA interface_worklist_u LIKE LINE OF interface_worklist.

              IF page_size > 0.
                LOOP AT worklist INTO DATA(worklist_u) FROM offset + 1 TO ( offset + page_size ).
                  interface_worklist_u-IdWorkItem          = worklist_u-wi_id.
                  interface_worklist_u-Type                = worklist_u-wi_type.
                  interface_worklist_u-Languaje            = worklist_u-wi_lang.
                  interface_worklist_u-Text                = worklist_u-wi_text.
                  interface_worklist_u-TaskText            = worklist_u-wi_rhtext.
                  interface_worklist_u-DateCreate          = worklist_u-wi_cd.
                  interface_worklist_u-CreatedAt           = worklist_u-wi_ct.
                  interface_worklist_u-LastResponsable     = worklist_u-wi_aagent.
                  interface_worklist_u-Task                = worklist_u-wi_rh_task.
                  interface_worklist_u-EndUserConfirmation = worklist_u-wi_confirm.
                  interface_worklist_u-Rejectable          = worklist_u-wi_reject.
                  interface_worklist_u-StatusText          = worklist_u-statustext.
                  interface_worklist_u-Responsable         = worklist_u-wi_aa_name.

                  APPEND interface_worklist_u TO interface_worklist.
                ENDLOOP.
              ELSE.
                LOOP AT worklist INTO worklist_u.
                  interface_worklist_u-IdWorkItem          = worklist_u-wi_id.
                  interface_worklist_u-Type                = worklist_u-wi_type.
                  interface_worklist_u-Languaje            = worklist_u-wi_lang.
                  interface_worklist_u-Text                = worklist_u-wi_text.
                  interface_worklist_u-TaskText            = worklist_u-wi_rhtext.
                  interface_worklist_u-DateCreate          = worklist_u-wi_cd.
                  interface_worklist_u-CreatedAt           = worklist_u-wi_ct.
                  interface_worklist_u-LastResponsable     = worklist_u-wi_aagent.
                  interface_worklist_u-Task                = worklist_u-wi_rh_task.
                  interface_worklist_u-EndUserConfirmation = worklist_u-wi_confirm.
                  interface_worklist_u-Rejectable          = worklist_u-wi_reject.
                  interface_worklist_u-StatusText          = worklist_u-statustext.
                  interface_worklist_u-Responsable         = worklist_u-wi_aa_name.

                  APPEND interface_worklist_u TO interface_worklist.
                ENDLOOP.
              ENDIF.

              io_response->set_data( interface_worklist ).

              IF io_request->is_total_numb_of_rec_requested( ).
                io_response->set_total_number_of_records( lines( worklist ) ).
              ENDIF.

            ENDIF.

          WHEN 'ZC_HCM_GET_TASK'.

            " --- Request data
            IF io_request->is_data_requested( ).

              DATA hrs1000        TYPE zhcmt_hrs1000.
              DATA task           TYPE zhcmt_task.
              DATA task_auxiliar  TYPE zhcmt_task.
              DATA interface_task TYPE hcm_data_task.

              DATA(filter_task_advanced) = io_request->get_filter( )->get_as_ranges( ).
              DATA(filter_task_string) = io_request->get_search_expression( ).

              get_constantes( IMPORTING thrs1000 = hrs1000 ).

              get_tarea( EXPORTING thrs1000 = hrs1000
                         IMPORTING task     = task ).

              " --- Filters
              IF filter_task_string IS NOT INITIAL.

                CONCATENATE '*' filter_task_string '*' INTO filter_task_string.

                task_auxiliar = task.
                CLEAR task.

                LOOP AT task_auxiliar INTO DATA(task_structure) WHERE otjid CP filter_task_string OR stext CP filter_task_string.
                  APPEND task_structure TO task.
                ENDLOOP.

              ENDIF.

              " --- Filters advanced
              IF filter_task_advanced IS NOT INITIAL.

                LOOP AT filter_task_advanced INTO DATA(filter_task_u).

                  CASE filter_task_u-name.
                    WHEN 'TASK'.
                      DATA(filter_otjid) = filter_task_u-range.
                    WHEN 'TEXT'.
                      DATA(filter_stext) = filter_task_u-range.
                  ENDCASE.

                ENDLOOP.

                task_auxiliar = task.
                CLEAR task.

                LOOP AT task_auxiliar INTO DATA(task_structure_2) WHERE otjid IN filter_otjid AND stext IN filter_stext.
                  APPEND task_structure_2 TO task.
                ENDLOOP.

              ENDIF.

              " -- SORT

              IF sort_order IS NOT INITIAL.

                DATA(element_name_task) = sort_order[ 1 ]-element_name.
                IF element_name_task = 'TASK'.
                  element_name_task = 'OTJID'.
                ENDIF.

                IF sort_order[ 1 ]-descending = 'X'.
                  SORT task BY (element_name_task) DESCENDING.
                ELSE.
                  SORT task BY (element_name_task).
                ENDIF.

              ENDIF.

              " Fill response
              DATA interface_task_u LIKE LINE OF interface_task.

              IF page_size > 0.
                LOOP AT task INTO DATA(task_u) FROM offset + 1 TO ( offset + page_size ).
                  interface_task_u-Task = task_u-otjid.
                  interface_task_u-Text = task_u-stext.
                  APPEND interface_task_u TO interface_task.
                ENDLOOP.
              ELSE.
                LOOP AT task INTO task_u.
                  interface_task_u-Task = task_u-otjid.
                  interface_task_u-Text = task_u-stext.
                  APPEND interface_task_u TO interface_task.
                ENDLOOP.
              ENDIF.

              io_response->set_data( interface_task ).

              IF io_request->is_total_numb_of_rec_requested( ).
                io_response->set_total_number_of_records( lines( task ) ).
              ENDIF.

            ENDIF.

          WHEN 'ZC_HCM_GET_PERSONAL'.

            " --- Request data
            IF io_request->is_data_requested( ).

              DATA personal_data      TYPE zhcmt_pa0002.
              DATA personal_data_aux  TYPE zhcmt_pa0002.
              DATA interface_personal TYPE hcm_data_personal.

              DATA(filter_personal_advanced) = io_request->get_filter( )->get_as_ranges( ).
              DATA(filter_personal_string) = io_request->get_search_expression( ).

              get_personal( IMPORTING tpa0002 = personal_data ).

              "--- Filters
              IF filter_personal_string IS NOT INITIAL.

                CONCATENATE '*' filter_personal_string '*' INTO filter_personal_string.

                personal_data_aux = personal_data.
                CLEAR personal_data.

                LOOP AT personal_data_aux INTO DATA(personal_structure) WHERE pernr CP filter_personal_string OR nachn CP filter_personal_string OR vorna CP filter_personal_string.
                  APPEND personal_structure TO personal_data.
                ENDLOOP.

              ENDIF.

              "--- Filters Advanced
              IF filter_personal_advanced IS NOT INITIAL.

                LOOP AT filter_personal_advanced INTO DATA(filter_personal_u).

                  CASE filter_personal_u-name.
                    WHEN 'EMPLOYEENUMBER'.
                      DATA(filter_employeeNumber) = filter_personal_u-range.
                    WHEN 'NAME'.
                      DATA(filter_vorna) = filter_personal_u-range.
                    WHEN 'LASTNAME'.
                      DATA(filter_nachn) = filter_personal_u-range.
                  ENDCASE.

                ENDLOOP.

                personal_data_aux = personal_data.
                CLEAR personal_data.

                LOOP AT personal_data_aux INTO DATA(personal_structure_2) WHERE pernr IN filter_employeeNumber AND nachn IN filter_nachn AND vorna IN filter_vorna.
                  APPEND personal_structure_2 TO personal_data.
                ENDLOOP.

              ENDIF.

              " -- SORT

              IF sort_order IS NOT INITIAL.

                DATA(element_name_employee) = sort_order[ 1 ]-element_name.

                IF element_name_employee = 'EMPLOYEENUMBER'.
                  element_name_employee = 'PERNR'.
                ENDIF.

                IF sort_order[ 1 ]-descending = 'X'.
                  SORT personal_data BY (element_name_employee) DESCENDING.
                ELSE.
                  SORT personal_data BY (element_name_employee).
                ENDIF.

              ENDIF.

              " Fill response
              DATA interface_personal_u LIKE LINE OF interface_personal.

              IF page_size > 0.
                LOOP AT personal_data INTO DATA(personal_u) FROM offset + 1 TO ( offset + page_size ).
                  interface_personal_u-EmployeeNumber = personal_u-pernr.
                  interface_personal_u-Name           = personal_u-vorna.
                  interface_personal_u-LastName       = personal_u-nachn.

                  APPEND interface_personal_u TO interface_personal.
                ENDLOOP.
              ELSE.
                LOOP AT personal_data INTO personal_u.
                  interface_personal_u-EmployeeNumber = personal_u-pernr.
                  interface_personal_u-Name           = personal_u-vorna.
                  interface_personal_u-LastName       = personal_u-nachn.

                  APPEND interface_personal_u TO interface_personal.
                ENDLOOP.
              ENDIF.

              io_response->set_data( interface_personal ).

              IF io_request->is_total_numb_of_rec_requested( ).
                io_response->set_total_number_of_records( lines( personal_data ) ).
              ENDIF.

            ENDIF.

        ENDCASE.

      CATCH cx_rap_query_provider.

    ENDTRY.
  ENDMETHOD.


  method GET_CONSTANTES.

    DATA:lo_constantes TYPE REF TO zbc_constants_admin,
         ls_sincon TYPE c.
    DATA: gr_tareas TYPE RANGE OF otjid.
    DATA: gwa_hrs1000 TYPE zhcms_hrs1000.

    "--- Start Constants
    TRY.
      CREATE OBJECT lo_constantes
        EXPORTING
          ps_repid = 'ZHRR0038'.
*         ps_repid = sy-repid.
      CATCH zcx_programa_desconocido.
      ls_sincon = 'X'.
    ENDTRY.

    CHECK ls_sincon IS INITIAL.

    " -- Tasks recorded in the constants table
    CALL METHOD lo_constantes->get_range
      EXPORTING
        ps_rangeid = '0000000177'
      CHANGING
        pt_range   = gr_tareas.

    FIELD-SYMBOLS
      <fs_tarea> LIKE LINE OF gr_tareas.

    LOOP AT gr_tareas ASSIGNING <fs_tarea>.

      gwa_hrs1000-otype = <fs_tarea>-low(2).
      gwa_hrs1000-objid = <fs_tarea>-low+2.
      APPEND gwa_hrs1000 TO thrs1000.

    ENDLOOP.

    SELECT otype objid stext
      INTO TABLE thrs1000
      FROM hrs1000
       FOR ALL ENTRIES IN thrs1000
     WHERE otype = thrs1000-otype
       AND objid = thrs1000-objid
       AND langu = sy-langu.

  endmethod.


  method GET_PERSONAL.

    TYPES:
      BEGIN OF gty_pa0105,
        pernr TYPE pa0105-pernr,
        subty TYPE pa0105-subty,
        objps TYPE pa0105-objps,
        sprps TYPE pa0105-sprps,
        endda TYPE pa0105-endda,
        begda TYPE pa0105-begda,
        seqnr TYPE pa0105-seqnr,
      END OF gty_pa0105.

    DATA:
      ls_id TYPE sysid,
      lr_pernr   TYPE RANGE OF pa0105-pernr,
      lr_seqnr   TYPE RANGE OF pa0105-seqnr,
      lt_object TYPE STANDARD TABLE OF hrwpc_s_objec,
      lwa_pa0105 TYPE gty_pa0105,
      ls_orgeh TYPE pa0001-orgeh,
      ls_plans TYPE pa0001-plans.

    FIELD-SYMBOLS:
      <fs_pa0002> LIKE LINE OF TPA0002.

    ls_id = sy-uname.

    SELECT SINGLE pernr subty objps sprps endda begda seqnr
       INTO lwa_pa0105
       FROM pa0105
      WHERE pernr IN lr_pernr
        AND subty = '0001'
        AND objps = space
        AND sprps = space
        AND endda >= sy-datum
        AND begda <= sy-datum
        AND seqnr IN lr_seqnr
        AND usrid = ls_id.

    SELECT SINGLE orgeh plans
      INTO (ls_orgeh, ls_plans)
      FROM pa0001
     WHERE pernr = lwa_pa0105-pernr
       AND subty = space
       AND objps = lwa_pa0105-objps
       AND sprps = lwa_pa0105-sprps
       AND endda = lwa_pa0105-endda.

    CHECK ls_orgeh IS NOT INITIAL.
    CHECK ls_plans IS NOT INITIAL.

    CALL FUNCTION 'Z_HR_RFC_GET_DATA_BY_UNIT_ORG'
      EXPORTING
        ip_flag  = 'T'
        ip_objid = ls_orgeh
      TABLES
        t_objec  = lt_object.

    CHECK lt_object[] IS NOT INITIAL.

    DELETE lt_object WHERE objid = lwa_pa0105-pernr. "is reconsidered

    CHECK lt_object[] IS NOT INITIAL.

    SELECT pernr vorna nachn
      INTO TABLE tpa0002
      FROM pa0002
       FOR ALL ENTRIES IN lt_object
     WHERE pernr = lt_object-objid
       AND subty = space
       AND objps = space
       AND sprps = space
       AND endda >= sy-datum
       AND begda <= sy-datum.

  endmethod.


  method GET_TAREA.

   DATA: ls_otjid TYPE otjid,
         ls_task TYPE ZHCMS_TASK.

   FIELD-SYMBOLS:
     <fs_hrs1000> LIKE LINE OF thrs1000.

  LOOP AT thrs1000 ASSIGNING <fs_hrs1000>.

    CLEAR: ls_task.

    CONCATENATE <fs_hrs1000>-otype <fs_hrs1000>-objid INTO ls_otjid.

    ls_task-otjid = ls_otjid.
    ls_task-stext = <fs_hrs1000>-stext.

    APPEND ls_task TO TASK.

  ENDLOOP.

  endmethod.

  METHOD get_worklist.
    TYPES:
      BEGIN OF emp_structure,
        user_id TYPE xubname,
      END OF emp_structure.

    DATA orgeh_text         TYPE pa0001-orgeh.
    DATA plans_text         TYPE pa0001-plans.
    DATA sobid_string       TYPE hrp1001-sobid.
    DATA worklist_structure TYPE swr_wihdr.

    DATA lt_object          TYPE STANDARD TABLE OF hrwpc_s_objec.
    DATA lt_userid          TYPE STANDARD TABLE OF sysid.

    DATA lt_emp             TYPE STANDARD TABLE OF emp_structure.

    DATA ls_id              TYPE sysid.
    DATA ls_user            TYPE syuname.
    DATA ls_plvar           TYPE objec-plvar.
    DATA ls_realo           TYPE objec-realo.
    DATA ls_stext           TYPE p1000-stext.

    TYPES:
      BEGIN OF gty_pa0105,
        pernr TYPE pa0105-pernr,
        subty TYPE pa0105-subty,
        objps TYPE pa0105-objps,
        sprps TYPE pa0105-sprps,
        endda TYPE pa0105-endda,
        begda TYPE pa0105-begda,
        seqnr TYPE pa0105-seqnr,
      END OF gty_pa0105.

    TYPES:
      BEGIN OF lty_headwi,
        wi_id         TYPE swwwihead-wi_id,
        wi_type       TYPE swwwihead-wi_type,
        wi_cd         TYPE swwwihead-wi_cd,
        wi_ct         TYPE swwwihead-wi_ct,
        wi_stat       TYPE swwwihead-wi_stat,
        wi_aagent     TYPE swwwihead-wi_aagent,
        wi_wi_rh_task TYPE swwwihead-wi_rh_task,
        wi_dh_stat    TYPE swwwihead-wi_dh_stat,
      END OF lty_headwi.

    TYPES:
      BEGIN OF lty_userwi,
        user_id TYPE swwuserwi-user_id,
        wi_id   TYPE swwuserwi-wi_id,
      END OF lty_userwi.

    DATA lr_pernr   TYPE RANGE OF pa0105-pernr.
    DATA lr_seqnr   TYPE RANGE OF pa0105-seqnr.
    DATA ltd_userwi TYPE STANDARD TABLE OF lty_userwi.
    DATA lts_headwi TYPE SORTED TABLE OF swwwihead WITH NON-UNIQUE KEY wi_stat.
    DATA lwa_pa0105 TYPE gty_pa0105.
    DATA gr_tareas  TYPE RANGE OF otjid.

    FIELD-SYMBOLS <fs_object> LIKE LINE OF lt_object.
    FIELD-SYMBOLS <fs_headwi> LIKE LINE OF lts_headwi.
    FIELD-SYMBOLS <fs_userwi> TYPE lty_userwi.

    ls_id = sy-uname.

    SELECT SINGLE pernr subty objps sprps endda begda seqnr
      INTO lwa_pa0105
      FROM pa0105
      WHERE pernr IN lr_pernr
        AND subty  = '0001'
        AND objps  = space
        AND sprps  = space
        AND endda >= sy-datum
        AND begda <= sy-datum
        AND seqnr IN lr_seqnr
        AND usrid  = ls_id.

    SELECT SINGLE orgeh plans
      INTO ( orgeh_text, plans_text )
      FROM pa0001
      WHERE pernr = lwa_pa0105-pernr
        AND subty = space
        AND objps = lwa_pa0105-objps
        AND sprps = lwa_pa0105-sprps
        AND endda = lwa_pa0105-endda
        AND seqnr = lwa_pa0105-seqnr.


    IF orgeh_text IS INITIAL.
      RETURN.
    ENDIF.
    IF plans_text IS INITIAL.
      RETURN.
    ENDIF.

    CALL FUNCTION 'Z_HR_RFC_GET_DATA_BY_UNIT_ORG'
      EXPORTING ip_flag  = 'T'
                ip_objid = orgeh_text
      TABLES    t_objec  = lt_object.


    IF pernr_filter[] IS NOT INITIAL.
      LOOP AT lt_object ASSIGNING <fs_object>.
        IF <fs_object>-objid NOT IN pernr_filter.
          CLEAR <fs_object>-objid.
        ENDIF.
      ENDLOOP.
      DELETE lt_object WHERE objid IS INITIAL.
    ENDIF.

    IF lt_object[] IS INITIAL.
      RETURN.
    ENDIF.

    CALL FUNCTION 'RH_GET_ACTIVE_WF_PLVAR'
      IMPORTING act_plvar = ls_plvar.

    SELECT SINGLE sobid INTO sobid_string
      FROM hrp1001
      WHERE plvar  = ls_plvar     " Plan actual
        AND otype  = 'S'          " Posición
        AND objid  = plans_text " Jefe
        AND rsign  = 'A'          " Sub Ordinados
        AND relat  = '012'        " Informa a
        AND sclas  = 'O'          " Unidad Organizativa
        AND endda >= sy-datum
        AND begda <= sy-datum.

    IF sobid_string IS INITIAL.
      CLEAR lt_object.
      REFRESH lt_object.
      MESSAGE s000(zhrmsg) WITH TEXT-t03.
    ELSE.

      DELETE lt_object WHERE objid = lwa_pa0105-pernr. " se vuelve a considerar

      IF lt_object[] IS INITIAL.
        RETURN.
      ENDIF.

      SELECT usrid INTO TABLE lt_userid
        FROM pa0105
        FOR ALL ENTRIES IN lt_object
        WHERE pernr  = lt_object-objid
          AND subty  = '0001'
          AND objps  = space
          AND sprps  = space
          AND endda >= sy-datum
          AND begda <= sy-datum.
      IF lt_userid[] IS INITIAL.
        RETURN.
      ENDIF.

      lt_emp[] = lt_userid[].
      " Filter by task in swwuserwi table with TASK_OBJ field,
      " which must be fetched from the constant table

      IF lt_emp[] IS INITIAL.
        RETURN.
      ENDIF.

      IF task_filter[] IS INITIAL.
        SELECT user_id wi_id INTO TABLE ltd_userwi
          FROM swwuserwi
          FOR ALL ENTRIES IN lt_emp
          WHERE user_id   = lt_emp-user_id
            AND task_obj IN gr_tareas.
      ELSE.
        SELECT user_id wi_id INTO TABLE ltd_userwi
          FROM swwuserwi
          FOR ALL ENTRIES IN lt_emp
          WHERE user_id   = lt_emp-user_id
            AND task_obj IN task_filter
            AND task_obj IN gr_tareas.
      ENDIF.

      IF ltd_userwi[] IS INITIAL.
        RETURN.
      ENDIF.

      SELECT * INTO TABLE lts_headwi
        FROM swwwihead
        FOR ALL ENTRIES IN ltd_userwi
        WHERE wi_id = ltd_userwi-wi_id.

      lts_headwi[] = lts_headwi[].

      LOOP AT lts_headwi ASSIGNING <fs_headwi>
           WHERE wi_stat = 'READY' OR wi_stat = 'STARTED'.

        CLEAR worklist_structure.

        MOVE-CORRESPONDING <fs_headwi> TO worklist_structure.
        worklist_structure-wi_cd_ftd = <fs_headwi>-wi_cd.
        worklist_structure-wi_ct_ftd = <fs_headwi>-wi_ct.

        " Search for agent---
        ASSIGN ltd_userwi[ wi_id = worklist_structure-wi_id ] TO <fs_userwi>.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.
        <fs_headwi>-wi_aagent = <fs_userwi>-user_id.
        " --
        SELECT SINGLE typetext INTO worklist_structure-typetext
          FROM swwtyptext
          WHERE wi_type  = <fs_headwi>-wi_type
            AND language = 'S'.

        SELECT SINGLE dhstatext INTO worklist_structure-dhstatext
          FROM swwdhstext
          WHERE wi_dh_stat = <fs_headwi>-wi_dh_stat
            AND language   = 'S'.

        SELECT SINGLE statustext INTO worklist_structure-statustext
          FROM swwstatext
          WHERE wi_status = <fs_headwi>-wi_stat
            AND language  = 'S'.

        IF <fs_headwi>-wi_aagent IS INITIAL.
          worklist_structure-wi_aa_name = TEXT-c01.

        ELSE.
          CALL FUNCTION 'SWL_AGENTS_NAME_DETERMIN'
            EXPORTING agent      = <fs_headwi>-wi_aagent
            IMPORTING agent_name = worklist_structure-wi_aa_name.
        ENDIF.

        IF worklist_structure-wi_type = 'F'.

          IF worklist_structure-wi_creator(2) = 'US'.
            ls_user = worklist_structure-wi_creator+2.
          ELSE.
            ls_user = worklist_structure-wi_creator.
          ENDIF.

          IF ls_user IS NOT INITIAL.

            ls_realo = ls_user.

            CALL FUNCTION 'RH_READ_OBJECT'
              EXPORTING  plvar     = ls_plvar
                         otype     = 'US'
                         realo     = ls_realo
              IMPORTING  stext     = ls_stext
              EXCEPTIONS not_found = 1
                         OTHERS    = 2.
            IF sy-subrc = 0.

              worklist_structure-wi_aagent  = ls_user.
              worklist_structure-wi_aa_name = ls_stext.

            ENDIF.

          ENDIF.

        ENDIF.

        APPEND worklist_structure TO worklist_table.

      ENDLOOP.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
