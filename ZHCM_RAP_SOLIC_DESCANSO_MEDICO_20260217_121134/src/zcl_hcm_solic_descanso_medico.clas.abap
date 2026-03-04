class ZCL_HCM_SOLIC_DESCANSO_MEDICO definition
  public
  final
  create public .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    TYPES hcm_subordinate_employees   TYPE STANDARD TABLE OF zi_hcm_subordinate_employees.
    TYPES hcm_request_employees       TYPE STANDARD TABLE OF zc_hcm_request_med_employee.
    TYPES hcm_initialization_approves TYPE STANDARD TABLE OF zc_hcm_initialization_approve.
    TYPES hcm_approve_request_med     TYPE STANDARD TABLE OF zc_hcm_approve_request_med.

    METHODS save_request
      IMPORTING request_medical_leave TYPE hcm_request_employees OPTIONAL
      RETURNING VALUE(result)         TYPE bapiret2.

    METHODS inizialitation
      IMPORTING userid         TYPE uname DEFAULT sy-uname
      EXPORTING employeename   TYPE emnam
                employeenumber TYPE pernr_d
                usrid9000      TYPE sysid.

    METHODS validate_input
      CHANGING  request_employees TYPE hcm_request_employees OPTIONAL
      RETURNING VALUE(messages)   TYPE bapiret2_t.

    METHODS get_direct_subord_employees
      IMPORTING user_name             TYPE uname
      CHANGING  subordinate_employees TYPE hcm_subordinate_employees.

    METHODS get_all_subord_employees
      IMPORTING user_name             TYPE uname
      CHANGING  subordinate_employees TYPE hcm_subordinate_employees.

    METHODS approve_request
      IMPORTING approve_request TYPE hcm_approve_request_med
      RETURNING VALUE(messages) TYPE bapiret2_t.

    METHODS reject_request
      IMPORTING reject_request  TYPE hcm_approve_request_med
      RETURNING VALUE(messages) TYPE bapiret2_t.
    METHODS create_intotype82_test
      IMPORTING i_soldes         TYPE zesoldes
                i_flag           TYPE flag
      RETURNING value(e_mensaje) TYPE char100.
    METHODS create_intotype2001_test
      IMPORTING i_soldes         TYPE zesoldes
      RETURNING value(e_mensaje) TYPE char100.
    METHODS create_intotype2001
      IMPORTING i_soldes         TYPE zesoldes
      RETURNING value(e_mensaje) TYPE char100.
    METHODS create_intotype82
      IMPORTING i_soldes         TYPE zesoldes
                i_flag           TYPE flag
      RETURNING value(e_mensaje) TYPE char100.
    METHODS create_file_al11
      IMPORTING i_soldes         TYPE zesoldes
      RETURNING value(e_mensaje) TYPE char100.
    METHODS get_message
      IMPORTING iw_syst          TYPE syst
      RETURNING value(e_mensaje) TYPE char100.
    METHODS notificate
      IMPORTING i_soldes    TYPE zesoldes
                i_operacion TYPE char1.
  PROTECTED SECTION.
    METHODS generate_request_number
      IMPORTING year       TYPE gjahr
      EXPORTING request_id TYPE char08
                !message   TYPE char100.

    METHODS get_table_inf
      CHANGING soldesmedic TYPE zthr_soldesmedic.

    METHODS send_mail
      IMPORTING i_soldes         TYPE zesoldes
                i_emisor         TYPE ad_smtpadr
                i_subject        TYPE so_obj_des
                it_mensaje       TYPE soli_tab
                it_destinatarios TYPE ztt_destinatarios
                i_commit         TYPE flag OPTIONAL.

  PRIVATE SECTION.
    DATA ac_emisor TYPE ad_smtpadr VALUE 'P' ##NO_TEXT.
    DATA ac_copia  TYPE ad_smtpadr.

    CONSTANTS ac_p TYPE char1 VALUE 'P' ##NO_TEXT.
    CONSTANTS EmployeeBloqued TYPE char3 VALUE '184'.

    DATA ao_constantes TYPE REF TO zbc_constants_admin_n.
    DATA ac_op         TYPE char1.



    METHODS get_body_mail
      IMPORTING i_soldes          TYPE zesoldes
                i_operacion       TYPE char1
                i_jefe            TYPE flag
      RETURNING VALUE(rt_mensaje) TYPE soli_tab.

    METHODS get_recipients
      IMPORTING i_empleado             TYPE pernr_d
                i_jefe                 TYPE flag
      RETURNING VALUE(rt_destinatario) TYPE ztt_destinatarios.

    METHODS get_message_request
      IMPORTING iw_syst          TYPE syst
      RETURNING VALUE(e_mensaje) TYPE char100.












ENDCLASS.



CLASS ZCL_HCM_SOLIC_DESCANSO_MEDICO IMPLEMENTATION.


  METHOD generate_request_number.
    DATA ls_number     TYPE char8.
    DATA ac_objeto_num TYPE nrobj VALUE 'ZSOLDES'.

    CALL FUNCTION 'NUMBER_RANGE_ENQUEUE'
      EXPORTING  object           = ac_objeto_num
      EXCEPTIONS foreign_lock     = 1
                 object_not_found = 2
                 system_failure   = 3
                 OTHERS           = 4.

    CALL FUNCTION 'NUMBER_GET_NEXT'
      EXPORTING  nr_range_nr             = '01'
                 object                  = ac_objeto_num
                 toyear                  = year
      IMPORTING  number                  = ls_number
      EXCEPTIONS interval_not_found      = 1
                 number_range_not_intern = 2
                 object_not_found        = 3
                 quantity_is_0           = 4
                 quantity_is_not_1       = 5
                 interval_overflow       = 6
                 buffer_overflow         = 7
                 OTHERS                  = 8.
    IF sy-subrc IS INITIAL.
      request_id = |{ ls_number ALPHA = IN }|.
    ELSE.

      CALL FUNCTION 'MESSAGE_TEXT_BUILD'
        EXPORTING msgid               = sy-msgid
                  msgnr               = sy-msgno
                  msgv1               = sy-msgv1
                  msgv2               = sy-msgv2
                  msgv3               = sy-msgv3
                  msgv4               = sy-msgv4
        IMPORTING message_text_output = message.
    ENDIF.

    CALL FUNCTION 'NUMBER_RANGE_DEQUEUE'
      EXPORTING  object           = ac_objeto_num
      EXCEPTIONS object_not_found = 1
                 OTHERS           = 2.
  ENDMETHOD.


  METHOD get_all_subord_employees.
    TYPES: BEGIN OF lty_pa0105,
             pernr TYPE pa0105-pernr,
             subty TYPE subty,
             endda TYPE endda,
             begda TYPE begda,
             usrid TYPE sysid,
           END OF lty_pa0105.

    TYPES: BEGIN OF lty_pa0001,
             pernr TYPE pa0001-pernr,
             ename TYPE pa0001-ename,
           END OF lty_pa0001.

    TYPES: BEGIN OF lty_pernr,
             pernr TYPE pa0001-pernr,
             ename TYPE pa0001-ename,
             vorna TYPE pa0002-vorna,
             nachn TYPE pa0002-nachn,
             orgeh TYPE pa0001-orgeh,
             begda TYPE pa0002-begda,
           END OF lty_pernr.

    TYPES ltyd_pa0105 TYPE STANDARD TABLE OF lty_pa0105.
    TYPES ltyd_pa0001 TYPE STANDARD TABLE OF lty_pa0001.

    DATA ltd_result_objects   TYPE objec_t.
    DATA ltd_result_structure TYPE struc_t.

    DATA lt_pernr             TYPE STANDARD TABLE OF lty_pernr.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lwa_root_copy        TYPE gdstr.

    DATA lt_peraux            TYPE ztt_personal.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA ls_peraux            TYPE zwe_personal.

    REFRESH: ltd_result_objects, ltd_result_structure,
             lt_peraux.
    CLEAR : lwa_root_copy,
            ls_peraux.

*&----------------------------------------------------------------------------&
*&-----------------1.Obtener información del empleado (jefe)------------------&
*&----------------------------------------------------------------------------&

    " Para saber el N° de empleado a partir del usuario SAP
    SELECT p~pernr INTO TABLE @DATA(ltd_pa0105)
      FROM pa0105 AS p
      WHERE p~usrty  = '0001' " Ajuste
*      WHERE p~usrty EQ '9000'
        AND p~usrid  = @user_name
        AND p~begda <= @sy-datum
        AND p~endda >= @sy-datum.

    IF ltd_pa0105[] IS NOT INITIAL.
      " El nombre del empleado se obtiene de la tabla PA0001
      SELECT p~pernr,
             p~ename
        INTO TABLE @DATA(ltd_pa0001)
        FROM pa0001 AS p
        FOR ALL ENTRIES IN @ltd_pa0105
        WHERE p~pernr  = @ltd_pa0105-pernr
          AND p~begda <= @sy-datum
          AND p~endda >= @sy-datum.
    ENDIF.

*&----------------------------------------------------------------------------&
*&----------------------------2.Obtener subordinados&-------------------------&
*&----------------------------------------------------------------------------&

    DATA(subordinate_employees_aux) = subordinate_employees[].
    REFRESH subordinate_employees[].
    READ TABLE ltd_pa0001 INDEX 1 INTO DATA(lwa_pa0001).
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    " Obtener posición de empleado (aprobador)
    CALL FUNCTION 'HR_STRUCTURE_GET'
      EXPORTING  root_plvar       = '01'
                 root_otype       = 'P'
                 root_objid       = lwa_pa0001-pernr
                 begda            = sy-datum
                 endda            = sy-datum
                 pathid           = 'PERS'
      IMPORTING  result_objects   = ltd_result_objects
                 result_structure = ltd_result_structure
                 root_copy        = lwa_root_copy
      EXCEPTIONS plvar_not_found  = 1
                 root_not_found   = 2
                 path_not_found   = 3
                 internal_error   = 4
                 OTHERS           = 5.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    ASSIGN ltd_result_objects[ otype = 'S' ] TO FIELD-SYMBOL(<fs_result1>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    " Obtener Unidad Organizativa, en caso sea jefe
    CALL FUNCTION 'HR_STRUCTURE_GET'
      EXPORTING  root_plvar       = '01'
                 root_otype       = 'S'
                 root_objid       = <fs_result1>-objid
                 begda            = sy-datum
                 endda            = sy-datum
                 pathid           = 'A012'
      IMPORTING  result_objects   = ltd_result_objects
                 result_structure = ltd_result_structure
                 root_copy        = lwa_root_copy
      EXCEPTIONS plvar_not_found  = 1
                 root_not_found   = 2
                 path_not_found   = 3
                 internal_error   = 4
                 OTHERS           = 5.

    " Obtener Unidad Organizativa, en caso sea jefe
    CALL FUNCTION 'HR_STRUCTURE_GET'
      EXPORTING  root_plvar       = '01'
                 root_otype       = 'S'
                 root_objid       = <fs_result1>-objid
                 begda            = sy-datum
                 endda            = sy-datum
                 pathid           = 'A012'
      IMPORTING  result_objects   = ltd_result_objects
                 result_structure = ltd_result_structure
                 root_copy        = lwa_root_copy
      EXCEPTIONS plvar_not_found  = 1
                 root_not_found   = 2
                 path_not_found   = 3
                 internal_error   = 4
                 OTHERS           = 5.
    IF sy-subrc is INITIAL.
      DELETE ltd_result_objects INDEX 1.
      DELETE ltd_result_objects INDEX 2.
      DELETE ltd_result_structure INDEX 1.
      DELETE ltd_result_structure INDEX 2.
      " Si la posicion es jefe, devolvera unidad Organizativa
      ASSIGN ltd_result_objects[ otype = 'O' ] TO FIELD-SYMBOL(<fs_result2>).

      IF sy-subrc = 0.

        IF subordinate_employees_aux[] IS INITIAL.
          " Obtener todas las personas debajo de la Unidad Organizativa.
          CALL FUNCTION 'HR_STRUCTURE_GET'
            EXPORTING  root_plvar       = '01'
                       root_otype       = 'O'
                       root_objid       = <fs_result2>-objid
                       begda            = sy-datum
                       endda            = sy-datum
                       pathid           = 'PERS-O'
            IMPORTING  result_objects   = ltd_result_objects
                       result_structure = ltd_result_structure
                       root_copy        = lwa_root_copy
            EXCEPTIONS plvar_not_found  = 1
                       root_not_found   = 2
                       path_not_found   = 3
                       internal_error   = 4
                       OTHERS           = 5.
          IF sy-subrc <> 0.
            RETURN.
          ENDIF.

          DELETE ltd_result_objects INDEX 1.
          DELETE ltd_result_objects INDEX 2.
          DELETE ltd_result_structure INDEX 1.
          DELETE ltd_result_structure INDEX 2.

          DATA employees_asignados TYPE ztt_personal.

          LOOP AT ltd_result_objects ASSIGNING FIELD-SYMBOL(<fs_result3>) WHERE otype = 'P'.
            INSERT INITIAL LINE INTO TABLE employees_asignados ASSIGNING FIELD-SYMBOL(<employees_asignado>).
            <employees_asignado>-pernr = <fs_result3>-objid.
            <employees_asignado>-ename = <fs_result3>-stext.
            <employees_asignado>-begda = <fs_result3>-begda.
          ENDLOOP.
          DELETE employees_asignados WHERE pernr = lwa_pa0001-pernr.

        ELSE.
          " cuando tiene filtros
          ASSIGN subordinate_employees_aux[ 1 ] TO FIELD-SYMBOL(<subordinate_employee>).
          IF sy-subrc IS INITIAL.

            DATA r_usrid9000 TYPE RANGE OF sysid.
            DATA r_vorna     TYPE RANGE OF vorna.
            DATA r_nachn     TYPE RANGE OF nachn.
            IF <subordinate_employee>-usrid9000 IS NOT INITIAL.
              INSERT VALUE #( sign   = 'I'
                              option = 'CP'
                              low    = <subordinate_employee>-usrid9000 ) INTO TABLE r_usrid9000.
            ENDIF.

            IF <subordinate_employee>-fullnames IS NOT INITIAL.
              INSERT VALUE #( sign   = 'I'
                              option = 'CP'
                              low    = |*{ <subordinate_employee>-fullnames }*| ) INTO TABLE r_vorna.
            ENDIF.

            IF <subordinate_employee>-fullsurnames IS NOT INITIAL.
              INSERT VALUE #( sign   = 'I'
                              option = 'CP'
                              low    = |*{ <subordinate_employee>-fullsurnames }*| ) INTO TABLE r_nachn.
            ENDIF.

            DATA(ls_vorna) = <subordinate_employee>-fullnames.
            DATA(ls_nachn) = <subordinate_employee>-fullsurnames.

            DATA srch_str1  TYPE c LENGTH 20.
            DATA srch_str2  TYPE c LENGTH 40.
            DATA srch_str3  TYPE c LENGTH 40.
            DATA srch_str4  TYPE c LENGTH 40.
            DATA srch_str5  TYPE c LENGTH 40.
            DATA srch_str6  TYPE c LENGTH 40.
            DATA srch_str7  TYPE c LENGTH 40.
            DATA ls_nombre1 TYPE c LENGTH 40.
            DATA ls_nombre2 TYPE c LENGTH 40.
            CONCATENATE '%' ls_vorna '%' INTO srch_str1.
            CONCATENATE '%' ls_nachn '%' INTO srch_str2.

            " Nombres todo mayúscula
            srch_str1 = to_upper( srch_str1 ).
            " Apellido paterno todo mayúscula
            srch_str2 = to_upper( srch_str2 ).
            " Apellido paterno primera mayúscula
            srch_str4 = srch_str2.
            srch_str4 = |{ srch_str4(2) }| & |{ to_lower( srch_str4+2 ) }|.
            " Apellido paterno todo minúscula
            srch_str7 = srch_str2.
            srch_str7 = |{ srch_str7(2) }| & |{ to_lower( srch_str7+2 ) }|.
            " Nombres primera con mayúscula
            srch_str5 = srch_str1.
            srch_str5 = |{ srch_str5(2) }| & |{ to_lower( srch_str5+2 ) }|.
            " Nombres todo minúscula
            srch_str6 = srch_str1.
            srch_str6 = |{ srch_str6(2) }| & |{ to_lower( srch_str6+2 ) }|.
            " Nombres primeras letras minúsculas
            ls_vorna = to_upper( ls_vorna ).

            SPLIT ls_vorna AT space INTO ls_nombre1 ls_nombre2.
            ls_nombre1 = condense( val  = ls_nombre1
                                   from = ` `
                                   to   = `` ).
            ls_nombre2 = condense( val  = ls_nombre2
                                   from = ` `
                                   to   = `` ).
            " Primer Nombre
            ls_nombre1 = |{ ls_nombre1(1) }| & |{ to_lower( ls_nombre1+1 ) }|.
            " Segundo Nombre
            ls_nombre2 = |{ ls_nombre2(1) }| & |{ to_lower( ls_nombre2+1 ) }|.

            IF ls_nombre2 IS NOT INITIAL.
              CONCATENATE ls_nombre1 ls_nombre2 INTO srch_str3 SEPARATED BY space.
              CONCATENATE '%' srch_str3 '%' INTO srch_str3.
            ELSE.
              CONCATENATE '%' ls_nombre1 '%' INTO srch_str3.
            ENDIF.

            IF r_usrid9000[] IS NOT INITIAL.
              SELECT a~pernr
                     c~ename
                     d~vorna
                     d~nachn
                     c~orgeh
                     c~begda
                INTO TABLE lt_pernr
                FROM pa0105 AS a
                       INNER JOIN
                         pa0001 AS c ON a~pernr = c~pernr
                           INNER JOIN
                             pa0002 AS d ON a~pernr = d~pernr
                WHERE a~usrid IN r_usrid9000
                AND   a~usrty = '9000'
                AND a~begda <= sy-datum
                AND a~endda >= sy-datum
                AND c~begda <= sy-datum
                AND c~endda >= sy-datum
                AND c~plans <> '99999999'
                AND d~begda <= sy-datum
                AND d~endda >= sy-datum
                AND ( ( d~nachn LIKE srch_str2 OR d~nachn LIKE srch_str4 OR d~nachn LIKE srch_str7 OR d~nachn IN r_nachn )
                OR  ( d~nach2 LIKE srch_str2 OR d~nach2 LIKE srch_str4 OR d~nach2 LIKE srch_str7 OR d~nach2 IN r_nachn ) )
                AND ( d~vorna LIKE srch_str1 OR d~vorna LIKE srch_str3 OR d~vorna LIKE srch_str5 OR d~vorna LIKE srch_str6 OR d~vorna IN r_vorna ).

            ELSE.
              IF ls_nachn IS NOT INITIAL AND ls_vorna IS INITIAL.

                SELECT a~pernr
                       b~ename
                       a~vorna
                       a~nachn
                       b~orgeh
                       b~begda
                  INTO TABLE lt_pernr
                  FROM pa0002 AS a
                         INNER JOIN
                           pa0001 AS b ON a~pernr = b~pernr
                  WHERE a~begda <= sy-datum
                  AND a~endda >= sy-datum
                  AND ( ( a~nachn LIKE srch_str2 OR a~nachn LIKE srch_str4 OR a~nachn LIKE srch_str7  OR a~nachn IN r_nachn )
                  OR    ( a~nach2 LIKE srch_str2 OR a~nach2 LIKE srch_str4 OR a~nach2 LIKE srch_str7  OR a~nach2 IN r_nachn ) )
                  AND b~begda <= sy-datum
                  AND b~endda >= sy-datum
                  AND b~plans <> '99999999'.

              ELSEIF ls_vorna IS NOT INITIAL AND ls_nachn IS INITIAL.

                SELECT a~pernr
                       b~ename
                       a~vorna
                       a~nachn
                       b~orgeh
                       b~begda
                  INTO TABLE lt_pernr
                  FROM pa0002 AS a
                         INNER JOIN
                           pa0001 AS b ON a~pernr = b~pernr
                  WHERE a~begda <= sy-datum
                  AND a~endda >= sy-datum
                  AND ( a~vorna LIKE srch_str1 OR a~vorna LIKE srch_str3 OR a~vorna LIKE srch_str5 OR a~vorna LIKE srch_str6  OR a~vorna IN r_vorna )
                  AND b~begda <= sy-datum
                  AND b~endda >= sy-datum
                  AND b~plans <> '99999999'.

              ELSEIF ls_vorna IS NOT INITIAL AND ls_nachn IS NOT INITIAL.
                SELECT a~pernr
                       b~ename
                       a~vorna
                       a~nachn
                       b~orgeh
                       b~begda
                  INTO TABLE lt_pernr
                  FROM pa0002 AS a
                         INNER JOIN
                           pa0001 AS b ON a~pernr = b~pernr
                  WHERE a~begda <= sy-datum
                  AND a~endda >= sy-datum
                  AND ( ( a~nachn LIKE srch_str2 OR a~nachn LIKE srch_str4 OR a~nachn LIKE srch_str7  OR a~nachn IN r_nachn )
                  OR    ( a~nach2 LIKE srch_str2 OR a~nach2 LIKE srch_str4 OR a~nach2 LIKE srch_str7  OR a~nach2 IN r_nachn ) )
                  AND ( a~vorna LIKE srch_str1 OR a~vorna LIKE srch_str3 OR a~vorna LIKE srch_str5 OR a~vorna LIKE srch_str6  OR a~vorna IN r_vorna )
                  AND b~begda <= sy-datum
                  AND b~endda >= sy-datum
                  AND b~plans <> '99999999'.

              ENDIF.
            ENDIF.
            " Se borra de la data el que consulta
            DELETE lt_pernr WHERE pernr = lwa_pa0001-pernr.

            SORT lt_pernr BY pernr
                             orgeh.
            DELETE ADJACENT DUPLICATES FROM lt_pernr COMPARING pernr orgeh.

            " Obtener todas las personas debajo de la Unidad Organizativa.
            CALL FUNCTION 'HR_STRUCTURE_GET'
              EXPORTING  root_plvar       = '01'
                         root_otype       = 'O'
                         root_objid       = <fs_result2>-objid
                         begda            = sy-datum
                         endda            = sy-datum
                         pathid           = 'ORGEH'
              IMPORTING  result_objects   = ltd_result_objects
                         result_structure = ltd_result_structure
                         root_copy        = lwa_root_copy
              EXCEPTIONS plvar_not_found  = 1
                         root_not_found   = 2
                         path_not_found   = 3
                         internal_error   = 4
                         OTHERS           = 5.

            IF sy-subrc <> 0.
              RETURN.
            ENDIF.

            LOOP AT lt_pernr ASSIGNING FIELD-SYMBOL(<fs_pernr>).

              ASSIGN ltd_result_objects[ plvar = '01'
                                         otype = 'O'
                                         objid = <fs_pernr>-orgeh ] TO <fs_result3>.
              IF sy-subrc IS NOT INITIAL.
                CONTINUE.
              ENDIF.
              INSERT INITIAL LINE INTO TABLE employees_asignados ASSIGNING <employees_asignado>.
              <employees_asignado>-pernr = <fs_pernr>-pernr.
              <employees_asignado>-ename = <fs_pernr>-ename.
              <employees_asignado>-begda = <fs_pernr>-begda.
            ENDLOOP.
          ENDIF.
        ENDIF.

        IF employees_asignados[] IS NOT INITIAL.
          SELECT pernr, nachn, nach2, vorna
            FROM pa0002
            INTO TABLE @DATA(employee_infotype_2_t)
            FOR ALL ENTRIES IN @employees_asignados
            WHERE pernr  = @employees_asignados-pernr
              AND subty  = @space
              AND objps  = @space
              AND sprps  = @space
              AND endda >= @sy-datum  " reference_date
              AND begda <= @sy-datum  " reference_date
              AND seqnr  = @space.

          " Obtener le usuario de tabla PA0105 de la lista obtenida
          SELECT pernr, subty, endda, begda, usrid
            INTO TABLE @DATA(lt_pa0105)
            FROM pa0105 AS p
            FOR ALL ENTRIES IN @employees_asignados
            WHERE p~usrty  = '0001'
              AND p~pernr  = @employees_asignados-pernr
              AND p~begda <= @sy-datum
              AND p~endda >= @sy-datum.

          " Obtener el usuario de la tabla PA0105 clase 9000
          SELECT pernr, subty, endda, begda, usrid
            INTO TABLE @DATA(lt_pa0105_9000)
            FROM pa0105 AS p
            FOR ALL ENTRIES IN @employees_asignados
            WHERE p~usrty  = '9000'
              AND p~pernr  = @employees_asignados-pernr
              AND p~begda <= @sy-datum
              AND p~endda >= @sy-datum.

          SORT lt_pa0105 BY pernr
                            subty.
          SORT lt_pa0105_9000 BY pernr
                                 subty.
          LOOP AT employees_asignados ASSIGNING <employees_asignado>.
            READ TABLE lt_pa0105 ASSIGNING FIELD-SYMBOL(<fs_p0105>) WITH KEY pernr = <employees_asignado>-pernr
                                                                             subty = '0001'
                 BINARY SEARCH.
            IF sy-subrc = 0.
              <employees_asignado>-usrid = <fs_p0105>-usrid.
            ENDIF.

            " Clase 9000
            READ TABLE lt_pa0105_9000 ASSIGNING FIELD-SYMBOL(<fs_p0105_9000>) WITH KEY pernr = <employees_asignado>-pernr
                                                                                       subty = '9000'
                 BINARY SEARCH.
            IF sy-subrc = 0.
              <employees_asignado>-usrid_9000 = <fs_p0105_9000>-usrid.
            ENDIF.
          ENDLOOP.

          LOOP AT employees_asignados ASSIGNING <employees_asignado>.
            INSERT INITIAL LINE INTO TABLE subordinate_employees ASSIGNING FIELD-SYMBOL(<subordinate_employees>).
            <subordinate_employees>-employeenumber = <employees_asignado>-pernr.
            <subordinate_employees>-UserID         = <employees_asignado>-usrid.
            <subordinate_employees>-usrid9000      = <employees_asignado>-usrid_9000.
            <subordinate_employees>-employeename   = <employees_asignado>-ename.
            <subordinate_employees>-admissiondate  = <employees_asignado>-begda.

            ASSIGN employee_infotype_2_t[ pernr = <employees_asignado>-pernr ] TO FIELD-SYMBOL(<employee_infotype_2>).
            IF sy-subrc = 0.
              <subordinate_employees>-fullsurnames = |{ <employee_infotype_2>-nachn } { <employee_infotype_2>-nach2 }|.
              <subordinate_employees>-fullnames    = <employee_infotype_2>-vorna.
            ENDIF.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_direct_subord_employees.
    TYPES: BEGIN OF lty_pa0105,
             pernr TYPE pa0105-pernr,
             subty TYPE subty,
             endda TYPE endda,
             begda TYPE begda,
             usrid TYPE sysid,
           END OF lty_pa0105.

    TYPES: BEGIN OF lty_pa0001,
             pernr TYPE pa0001-pernr,
             ename TYPE pa0001-ename,
           END OF lty_pa0001.

    TYPES: BEGIN OF lty_pernr,
             pernr TYPE pa0001-pernr,
             ename TYPE pa0001-ename,
             vorna TYPE pa0002-vorna,
             nachn TYPE pa0002-nachn,
             orgeh TYPE pa0001-orgeh,
             begda TYPE pa0002-begda,
           END OF lty_pernr.

    TYPES ltyd_pa0105 TYPE STANDARD TABLE OF lty_pa0105.
    TYPES ltyd_pa0001 TYPE STANDARD TABLE OF lty_pa0001.

    DATA ltd_result_objects     TYPE objec_t.
    DATA ltd_result_structure   TYPE struc_t.
    DATA lt_pernr               TYPE STANDARD TABLE OF lty_pernr.

    DATA ltd_result_objects_2   TYPE objec_t.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA ltd_result_structure_2 TYPE struc_t.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lwa_root_copy          TYPE gdstr.

    DATA lt_peraux              TYPE ztt_personal.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA ls_peraux              TYPE zwe_personal.

    REFRESH: ltd_result_objects, ltd_result_structure,
             lt_peraux.
    CLEAR : lwa_root_copy,
            ls_peraux.

    " 1.    Para saber el N° de empleado a partir del usuario SAP
    SELECT p~pernr INTO TABLE @DATA(ltd_pa0105)
      FROM pa0105 AS p
      WHERE p~usrty  = '0001'
        AND p~usrid  = @user_name
        AND p~begda <= @sy-datum
        AND p~endda >= @sy-datum.

    IF ltd_pa0105[] IS NOT INITIAL.
      " 2.   El nombre del empleado se obtiene de la tabla PA0001 y se obtiene el campo ENAME
      SELECT p~pernr,
             p~ename
        INTO TABLE @DATA(ltd_pa0001)
        FROM pa0001 AS p
        FOR ALL ENTRIES IN @ltd_pa0105
        WHERE p~pernr  = @ltd_pa0105-pernr
          AND p~begda <= @sy-datum
          AND p~endda >= @sy-datum.
    ENDIF.
*&----------------------------------------------------------------------------&
*&----------------------------2.Obtener subordinados&-------------------------&
*&----------------------------------------------------------------------------&

    DATA(subordinate_employees_aux) = subordinate_employees[].
    REFRESH subordinate_employees[].

    READ TABLE ltd_pa0001 INDEX 1 INTO DATA(lwa_pa0001).
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    " Obtener Posiciones de las personas
    CALL FUNCTION 'HR_STRUCTURE_GET'
      EXPORTING  root_plvar         = '01'
                 root_otype         = 'P'
                 root_objid         = lwa_pa0001-pernr
*                 ROOT_OBJECTS       =
                 begda              = sy-datum
                 endda              = sy-datum
                 pathid             = 'PERS'
*                 PATHID_IS_INTERN   =
                 stru_tech_depth    = 0
                 stru_status_vector = '1'
*                 stru_status_overlap = ' '
                 provide_text       = 'X'
                 provide_relat      = 'X'
                 provide_dflag      = 'X'
                 recursion_check    = 'X'
*                 AUTHORITY_CHECK    = 'X'
                 text_buffer_fill   = 'X'
                 read_mode          = 'F'
*                 KEEP_ORDER         =
      IMPORTING  result_objects     = ltd_result_objects
                 result_structure   = ltd_result_structure
                 root_copy          = lwa_root_copy
      EXCEPTIONS plvar_not_found    = 1
                 root_not_found     = 2
                 path_not_found     = 3
                 internal_error     = 4
                 OTHERS             = 5.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    ASSIGN ltd_result_objects[ otype = 'S' ] TO FIELD-SYMBOL(<fs_result1>).
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    " Obtener Unidad Organizativa, en caso sea jefe
    CALL FUNCTION 'HR_STRUCTURE_GET'
      EXPORTING  root_plvar         = '01'
                 root_otype         = 'S'
                 root_objid         = <fs_result1>-objid
*                 ROOT_OBJECTS       =
                 begda              = sy-datum
                 endda              = sy-datum
                 pathid             = 'A012'
*                 PATHID_IS_INTERN   =
                 stru_tech_depth    = 0
                 stru_status_vector = '1'
*                 stru_status_overlap = ' '
                 provide_text       = 'X'
                 provide_relat      = 'X'
                 provide_dflag      = 'X'
                 recursion_check    = 'X'
*                 AUTHORITY_CHECK    = 'X'
                 text_buffer_fill   = 'X'
                 read_mode          = 'F'
*                 KEEP_ORDER         =
      IMPORTING  result_objects     = ltd_result_objects
                 result_structure   = ltd_result_structure
                 root_copy          = lwa_root_copy
      EXCEPTIONS plvar_not_found    = 1
                 root_not_found     = 2
                 path_not_found     = 3
                 internal_error     = 4
                 OTHERS             = 5.

    IF sy-subrc is INITIAL.
      DELETE ltd_result_objects INDEX 1.
      DELETE ltd_result_objects INDEX 2.
      DELETE ltd_result_structure INDEX 1.
      DELETE ltd_result_structure INDEX 2.
      " Si la posicion es jefe, devolvera unidad Organizativa
      ASSIGN ltd_result_objects[ otype = 'O' ] TO FIELD-SYMBOL(<fs_result2>).
      IF sy-subrc = 0.

        IF subordinate_employees_aux[] IS INITIAL.
          " Obtener todas las personas debajo de la Unidad Organizativa.
          CALL FUNCTION 'HR_STRUCTURE_GET'
            EXPORTING  root_plvar         = '01'
                       root_otype         = 'O'
                       root_objid         = <fs_result2>-objid
*                       ROOT_OBJECTS       =
                       begda              = sy-datum
                       endda              = sy-datum
                       pathid             = 'O-P'
*                       PATHID_IS_INTERN   =
                       stru_tech_depth    = 0
                       stru_status_vector = '1'
*                       stru_status_overlap = ' '
                       provide_text       = 'X'
                       provide_relat      = 'X'
                       provide_dflag      = 'X'
                       recursion_check    = 'X'
*                       AUTHORITY_CHECK    = 'X'
                       text_buffer_fill   = 'X'
                       read_mode          = 'F'
*                       KEEP_ORDER         =
            IMPORTING  result_objects     = ltd_result_objects_2
                       result_structure   = ltd_result_structure_2
                       root_copy          = lwa_root_copy
            EXCEPTIONS plvar_not_found    = 1
                       root_not_found     = 2
                       path_not_found     = 3
                       internal_error     = 4
                       OTHERS             = 5.

          IF sy-subrc <> 0.
            RETURN.
          ENDIF.
          " Implement suitable error handling here
          DELETE ltd_result_objects_2 INDEX 1.
          DELETE ltd_result_structure_2 INDEX 1.

          DATA employees_asignados TYPE ztt_personal.

          LOOP AT ltd_result_objects_2 ASSIGNING FIELD-SYMBOL(<fs_result3>)
               WHERE otype = 'P'.
            IF sy-subrc = 0.
              INSERT INITIAL LINE INTO TABLE employees_asignados ASSIGNING FIELD-SYMBOL(<employees_asignado>).
              <employees_asignado>-pernr = <fs_result3>-objid.
              <employees_asignado>-ename = <fs_result3>-stext.
              <employees_asignado>-begda = <fs_result3>-begda.
            ENDIF.
          ENDLOOP.
          DELETE employees_asignados WHERE pernr = lwa_pa0001-pernr.

        ELSE.
          " cuando tiene filtros
          ASSIGN subordinate_employees_aux[ 1 ] TO FIELD-SYMBOL(<subordinate_employee>).
          IF sy-subrc IS INITIAL.

            DATA r_usrid9000 TYPE RANGE OF sysid.
            DATA r_vorna     TYPE RANGE OF vorna.
            DATA r_nachn     TYPE RANGE OF nachn.
            IF <subordinate_employee>-usrid9000 IS NOT INITIAL.
              INSERT VALUE #( sign   = 'I'
                              option = 'CP'
                              low    = <subordinate_employee>-usrid9000 ) INTO TABLE r_usrid9000.
            ENDIF.

            IF <subordinate_employee>-fullnames IS NOT INITIAL.
              INSERT VALUE #( sign   = 'I'
                              option = 'CP'
                              low    = |*{ <subordinate_employee>-fullnames }*| ) INTO TABLE r_vorna.
            ENDIF.

            IF <subordinate_employee>-fullsurnames IS NOT INITIAL.
              INSERT VALUE #( sign   = 'I'
                              option = 'CP'
                              low    = |*{ <subordinate_employee>-fullsurnames }*| ) INTO TABLE r_nachn.
            ENDIF.

            DATA(ls_vorna) = <subordinate_employee>-fullnames.
            DATA(ls_nachn) = <subordinate_employee>-fullsurnames.

            DATA srch_str1  TYPE c LENGTH 20.
            DATA srch_str2  TYPE c LENGTH 40.
            DATA srch_str3  TYPE c LENGTH 40.
            DATA srch_str4  TYPE c LENGTH 40.
            DATA srch_str5  TYPE c LENGTH 40.
            DATA srch_str6  TYPE c LENGTH 40.
            DATA srch_str7  TYPE c LENGTH 40.
            DATA ls_nombre1 TYPE c LENGTH 40.
            DATA ls_nombre2 TYPE c LENGTH 40.
            CONCATENATE '%' ls_vorna '%' INTO srch_str1.
            CONCATENATE '%' ls_nachn '%' INTO srch_str2.

            " Nombres todo mayúscula
            srch_str1 = to_upper( srch_str1 ).
            " Apellido paterno todo mayúscula
            srch_str2 = to_upper( srch_str2 ).
            " Apellido paterno primera mayúscula
            srch_str4 = srch_str2.

            srch_str4 = srch_str2.
            " Apellido paterno todo minúscula
            srch_str7 = srch_str2.
            " Nombres primera con mayúscula
            srch_str5 = srch_str1.
            " Nombres todo minúscula
            srch_str6 = srch_str1.
            " Nombres primeras letras minúsculas

            SPLIT ls_vorna AT space INTO ls_nombre1 ls_nombre2.
            ls_nombre1 = condense( val  = ls_nombre1
                                   from = ` `
                                   to   = `` ).
            ls_nombre2 = condense( val  = ls_nombre2
                                   from = ` `
                                   to   = `` ).

            srch_str4 = |{ srch_str4(2) }| & |{ to_lower( srch_str4+2 ) }|.
            " Apellido paterno todo minúscula
            srch_str7 = srch_str2.
            srch_str7 = |{ srch_str7(2) }| & |{ to_lower( srch_str7+2 ) }|.
            " Nombres primera con mayúscula
            srch_str5 = srch_str1.
            srch_str5 = |{ srch_str5(2) }| & |{ to_lower( srch_str5+2 ) }|.
            " Nombres todo minúscula
            srch_str6 = srch_str1.
            srch_str6 = |{ srch_str6(2) }| & |{ to_lower( srch_str6+2 ) }|.
            " Nombres primeras letras minúsculas
            ls_vorna = to_upper( ls_vorna ).
            SPLIT ls_vorna AT space INTO ls_nombre1 ls_nombre2.
            ls_nombre1 = condense( val  = ls_nombre1
                                   from = ` `
                                   to   = `` ).
            ls_nombre2 = condense( val  = ls_nombre2
                                   from = ` `
                                   to   = `` ).

            " Primer Nombre
            ls_nombre1 = |{ ls_nombre1(1) }| & |{ to_lower( ls_nombre1+1 ) }|.
            " Segundo Nombre
            ls_nombre2 = |{ ls_nombre2(1) }| & |{ to_lower( ls_nombre2+1 ) }|.
            IF ls_nombre2 IS NOT INITIAL.
              CONCATENATE ls_nombre1 ls_nombre2 INTO srch_str3 SEPARATED BY space.
              CONCATENATE '%' srch_str3 '%' INTO srch_str3.
            ELSE.
              CONCATENATE '%' ls_nombre1 '%' INTO srch_str3.
            ENDIF.

            IF r_usrid9000[] IS NOT INITIAL.
              SELECT a~pernr
                     c~ename
                     d~vorna
                     d~nachn
                     c~orgeh
                     c~begda
                INTO TABLE lt_pernr
                FROM pa0105 AS a
                       INNER JOIN
                         pa0001 AS c ON a~pernr = c~pernr
                           INNER JOIN
                             pa0002 AS d ON a~pernr = d~pernr
                WHERE a~usrid IN r_usrid9000
                AND   a~usrty = '9000'
                AND a~begda <= sy-datum
                AND a~endda >= sy-datum
                AND c~begda <= sy-datum
                AND c~endda >= sy-datum
                AND d~begda <= sy-datum
                AND d~endda >= sy-datum
                AND ( ( d~nachn LIKE srch_str2 OR d~nachn LIKE srch_str4 OR d~nachn LIKE srch_str7 OR d~nachn IN r_nachn )
                OR  ( d~nach2 LIKE srch_str2 OR d~nach2 LIKE srch_str4 OR d~nach2 LIKE srch_str7 OR d~nach2 IN r_nachn ) )
                AND ( d~vorna LIKE srch_str1 OR d~vorna LIKE srch_str3 OR d~vorna LIKE srch_str5 OR d~vorna LIKE srch_str6 OR d~vorna IN r_vorna ).

            ELSE.
              IF ls_nachn IS NOT INITIAL AND ls_vorna IS INITIAL.

                SELECT a~pernr
                       b~ename
                       a~vorna
                       a~nachn
                       b~orgeh
                       b~begda
                  INTO TABLE lt_pernr
                  FROM pa0002 AS a
                         INNER JOIN
                           pa0001 AS b ON a~pernr = b~pernr
                  WHERE a~begda <= sy-datum
                  AND a~endda >= sy-datum
                  AND ( ( a~nachn LIKE srch_str2 OR a~nachn LIKE srch_str4 OR a~nachn LIKE srch_str7 OR a~nachn IN r_nachn )
                  OR  ( a~nach2 LIKE srch_str2 OR a~nach2 LIKE srch_str4 OR a~nach2 LIKE srch_str7 OR a~nach2 IN r_nachn ) )
                  AND b~begda <= sy-datum
                  AND b~endda >= sy-datum.

              ELSEIF ls_vorna IS NOT INITIAL AND ls_nachn IS INITIAL.

                SELECT a~pernr
                       b~ename
                       a~vorna
                       a~nachn
                       b~orgeh
                       b~begda
                  INTO TABLE lt_pernr
                  FROM pa0002 AS a
                         INNER JOIN
                           pa0001 AS b ON a~pernr = b~pernr
                  WHERE a~begda <= sy-datum
                  AND a~endda >= sy-datum
                  AND ( a~vorna LIKE srch_str1 OR a~vorna LIKE srch_str3 OR a~vorna LIKE srch_str5 OR a~vorna LIKE srch_str6 OR a~vorna IN r_vorna )
                  AND b~begda <= sy-datum
                  AND b~endda >= sy-datum.

              ELSEIF ls_vorna IS NOT INITIAL AND ls_nachn IS NOT INITIAL.
                SELECT a~pernr
                       b~ename
                       a~vorna
                       a~nachn
                       b~orgeh
                       b~begda
                  INTO TABLE lt_pernr
                  FROM pa0002 AS a
                         INNER JOIN
                           pa0001 AS b ON a~pernr = b~pernr
                  WHERE a~begda <= sy-datum
                  AND a~endda >= sy-datum
                  AND ( a~nachn LIKE srch_str2 OR a~nachn LIKE srch_str4 OR a~nachn LIKE srch_str7 OR a~nachn IN r_nachn )
                  AND ( a~nach2 LIKE srch_str2 OR a~nach2 LIKE srch_str4 OR a~nach2 LIKE srch_str7 OR a~nach2 IN r_nachn )
                  OR ( a~vorna LIKE srch_str1 OR a~vorna LIKE srch_str3 OR a~vorna LIKE srch_str5 OR a~vorna LIKE srch_str6 OR a~vorna IN r_vorna )
                  AND b~begda <= sy-datum
                  AND b~endda >= sy-datum.

              ENDIF.
            ENDIF.
            " Se borra de la data el que consulta
            DELETE lt_pernr WHERE pernr = lwa_pa0001-pernr.
            SORT lt_pernr BY pernr
                             orgeh.
            DELETE ADJACENT DUPLICATES FROM lt_pernr COMPARING pernr orgeh.

            LOOP AT lt_pernr ASSIGNING FIELD-SYMBOL(<fs_pernr>).
              IF <fs_pernr>-orgeh = <fs_result2>-objid.
                INSERT INITIAL LINE INTO TABLE employees_asignados ASSIGNING <employees_asignado>.
                <employees_asignado>-pernr = <fs_pernr>-pernr.
                <employees_asignado>-ename = <fs_pernr>-ename.
                <employees_asignado>-begda = <fs_pernr>-begda.
              ENDIF.
            ENDLOOP.

          ENDIF.
        ENDIF.

        IF employees_asignados IS NOT INITIAL.
          SELECT pernr, nachn, nach2, vorna
            FROM pa0002
            INTO TABLE @DATA(employee_infotype_2_t)
            FOR ALL ENTRIES IN @employees_asignados
            WHERE pernr  = @employees_asignados-pernr
              AND subty  = @space
              AND objps  = @space
              AND sprps  = @space
              AND endda >= @sy-datum  " reference_date
              AND begda <= @sy-datum  " reference_date
              AND seqnr  = @space.

          " Obtener el usuario de tabla PA0105 de la lista obtenida
          SELECT pernr, subty, endda, begda, usrid
            INTO TABLE @DATA(lt_pa0105)
            FROM pa0105 AS p
            FOR ALL ENTRIES IN @employees_asignados
            WHERE p~usrty  = '0001'
              AND p~pernr  = @employees_asignados-pernr
              AND p~begda <= @sy-datum
              AND p~endda >= @sy-datum.

          " Obtener el usuario de la tabla PA0105 clase 9000
          SELECT pernr, subty, endda, begda, usrid
            INTO TABLE @DATA(lt_pa0105_9000)
            FROM pa0105 AS p
            FOR ALL ENTRIES IN @employees_asignados
            WHERE p~usrty  = '9000'
              AND p~pernr  = @employees_asignados-pernr
              AND p~begda <= @sy-datum
              AND p~endda >= @sy-datum.

          SORT lt_pa0105 BY pernr
                            subty.
          SORT lt_pa0105_9000 BY pernr
                                 subty.
          LOOP AT employees_asignados ASSIGNING <employees_asignado>.
            READ TABLE lt_pa0105 ASSIGNING FIELD-SYMBOL(<fs_p0105>) WITH KEY pernr = <employees_asignado>-pernr
                                                                             subty = '0001'
                 BINARY SEARCH.
            IF sy-subrc = 0.
              <employees_asignado>-usrid = <fs_p0105>-usrid.
            ENDIF.

            " Clase 9000
            READ TABLE lt_pa0105_9000 ASSIGNING FIELD-SYMBOL(<fs_p0105_9000>) WITH KEY pernr = <employees_asignado>-pernr
                                                                                       subty = '9000'
                 BINARY SEARCH.
            IF sy-subrc = 0.
              <employees_asignado>-usrid_9000 = <fs_p0105_9000>-usrid.
            ENDIF.

          ENDLOOP.
        ENDIF.

        LOOP AT employees_asignados ASSIGNING <employees_asignado>.
          INSERT INITIAL LINE INTO TABLE subordinate_employees ASSIGNING FIELD-SYMBOL(<subordinate_employees>).
          <subordinate_employees>-employeenumber = <employees_asignado>-pernr.
          <subordinate_employees>-userid         = <employees_asignado>-usrid.
          <subordinate_employees>-usrid9000      = <employees_asignado>-usrid_9000.
          <subordinate_employees>-employeename   = <employees_asignado>-ename.
          <subordinate_employees>-admissiondate  = <employees_asignado>-begda.

          ASSIGN employee_infotype_2_t[ pernr = <employees_asignado>-pernr ] TO FIELD-SYMBOL(<employee_infotype_2>).
          IF sy-subrc = 0.
            <subordinate_employees>-fullsurnames = |{ <employee_infotype_2>-nachn } { <employee_infotype_2>-nach2 }|.
            <subordinate_employees>-fullnames    = <employee_infotype_2>-vorna.
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_table_inf.

    SELECT SINGLE * FROM zi_hcm_type_disease
      INTO @DATA(lwa_type_disease)
      WHERE tdiscode EQ @soldesmedic-tenf_code.

    soldesmedic-tenf_desc = lwa_type_disease-tdisdesc.

    SELECT SINGLE * FROM zi_hcm_medical_center
      INTO @DATA(lwa_medical_center)
      WHERE  cmcode EQ @soldesmedic-cm_codigo.

    soldesmedic-cm_descr = lwa_medical_center-cmdesc.

    SELECT * FROM zi_hcm_diagnost_classification
 INTO TABLE @DATA(diagnost_classifications)
 WHERE tdiscode EQ @soldesmedic-tenf_code AND
  ( classifcode EQ @soldesmedic-clasfi_code1 OR
    classifcode EQ @soldesmedic-clasfi_code2 OR
    classifcode EQ @soldesmedic-clasfi_code3 ).

    READ TABLE diagnost_classifications INTO DATA(fs_class) WITH KEY classifcode = soldesmedic-clasfi_code1.
    IF sy-subrc IS INITIAL.
      soldesmedic-calsfi_desc1 = fs_class-classifdesc.
    ENDIF.

    READ TABLE diagnost_classifications INTO fs_class WITH KEY classifcode = soldesmedic-clasfi_code2.
    IF sy-subrc IS INITIAL.
      soldesmedic-calsfi_desc2 = fs_class-classifdesc.
    ENDIF.

    READ TABLE diagnost_classifications INTO fs_class WITH KEY classifcode = soldesmedic-clasfi_code3.
    IF sy-subrc IS INITIAL.
      soldesmedic-calsfi_desc3 = fs_class-classifdesc.
    ENDIF.

    SELECT * FROM zi_hcm_diagnost_specification
      INTO TABLE @DATA(diagnost_specifications)
      FOR ALL ENTRIES IN @diagnost_classifications
      WHERE tdiscode EQ @soldesmedic-tenf_code AND
            ( classifcode EQ @diagnost_classifications-classifcode )
      AND ( especcode EQ @soldesmedic-especi_code1 OR
              especcode EQ @soldesmedic-especi_code2 OR
              especcode EQ @soldesmedic-especi_code3 ).


    READ TABLE diagnost_specifications INTO DATA(diagnost_specification)
    WITH KEY classifcode = soldesmedic-clasfi_code1
             especcode = soldesmedic-especi_code1.
    IF sy-subrc IS INITIAL.
      soldesmedic-especi_desc1 = diagnost_specification-especdesc.
    ENDIF.

    READ TABLE diagnost_specifications INTO diagnost_specification
    WITH KEY classifcode = soldesmedic-clasfi_code2
             especcode = soldesmedic-especi_code2.
    IF sy-subrc IS INITIAL.
      soldesmedic-especi_desc2 = diagnost_specification-especdesc.
    ENDIF.

    READ TABLE diagnost_specifications INTO diagnost_specification
    WITH KEY classifcode = soldesmedic-clasfi_code3
       especcode = soldesmedic-especi_code3.
    IF sy-subrc IS INITIAL.
      soldesmedic-especi_desc3 = diagnost_specification-especdesc.
    ENDIF.


  ENDMETHOD.


  METHOD if_rap_query_provider~select.
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

              WHEN 'ZI_HCM_SUBORDINATE_EMPLOYEES'.

                DATA i_subordinate_employees TYPE STANDARD TABLE OF zi_hcm_subordinate_employees.

                DATA val_search_type         TYPE c LENGTH 1.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).

                      " Initialize values
                      " TODO: variable is assigned but never used (ABAP cleaner)
                      DATA(ls_error) = VALUE com_err( ).

                      DATA subordinate_employees TYPE hcm_subordinate_employees.

                      REFRESH: subordinate_employees,
                               i_subordinate_employees.
                      DATA filter TYPE c LENGTH 1.
                      INSERT INITIAL LINE INTO TABLE subordinate_employees ASSIGNING FIELD-SYMBOL(<subordinate_employees>).
                      LOOP AT filter_object ASSIGNING FIELD-SYMBOL(<fs_filter>).
                        CASE <fs_filter>-name.
                          WHEN 'USRID9000'.
                            <subordinate_employees>-usrid9000 = <fs_filter>-range[ 1 ]-low.
                            filter = 'X'.
                          WHEN 'FULLNAMES'.
                            <subordinate_employees>-fullnames = <fs_filter>-range[ 1 ]-low.
                            REPLACE ALL OCCURRENCES OF '*' IN <subordinate_employees>-fullnames WITH ''.
                            filter = 'X'.
                          WHEN 'FULLSURNAMES'.
                            <subordinate_employees>-fullsurnames = <fs_filter>-range[ 1 ]-low.
                            REPLACE ALL OCCURRENCES OF '*' IN <subordinate_employees>-fullsurnames WITH ''.
                            filter = 'X'.
                          WHEN 'SEARCHTYPE'.
                            val_search_type = <fs_filter>-range[ 1 ]-low.
                        ENDCASE.
                      ENDLOOP.

                      IF filter IS INITIAL.
                        REFRESH subordinate_employees[].
                      ENDIF.
                      CASE val_search_type.
                        WHEN 'D'.
                          " Subordinados Directos
                          get_direct_subord_employees( EXPORTING user_name             = sy-uname   " user_name
                                                       CHANGING  subordinate_employees = subordinate_employees ).
                        WHEN 'T'.
                          " Subordinados Todos
                          get_all_subord_employees( EXPORTING user_name             = sy-uname   " user_name
                                                    CHANGING  subordinate_employees = subordinate_employees ).
                      ENDCASE.

                      " Fill response
                      DATA struct_subordinate_employee LIKE LINE OF i_subordinate_employees.

                      IF page_size > 0.
                        LOOP AT subordinate_employees ASSIGNING FIELD-SYMBOL(<subordinate_employee>) FROM offset + 1 TO ( offset + page_size ).
                          MOVE-CORRESPONDING <subordinate_employee> TO struct_subordinate_employee.
                          INSERT struct_subordinate_employee INTO TABLE i_subordinate_employees.
                        ENDLOOP.
                      ELSE.
                        LOOP AT subordinate_employees ASSIGNING <subordinate_employee>.
                          MOVE-CORRESPONDING <subordinate_employee> TO struct_subordinate_employee.
                          INSERT struct_subordinate_employee INTO TABLE i_subordinate_employees.
                        ENDLOOP.
                      ENDIF.

                      io_response->set_data( i_subordinate_employees ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( subordinate_employees ) ).
                      ENDIF.

                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO DATA(lx_dest).
                    MESSAGE lx_dest->get_text( ) TYPE 'E'.
                ENDTRY.
              WHEN 'ZC_HCM_INITIALIZATION'.

                DATA initialization TYPE STANDARD TABLE OF zc_hcm_initialization.

                DATA employeename   TYPE emnam.
                DATA employeenumber TYPE pernr_d.
                DATA usrid9000      TYPE sysid.

                TRY.
                    IF io_request->is_data_requested( ).
                      io_request->get_paging( ).

                      inizialitation( EXPORTING userid         = sy-uname            " Nombre de usuario
                                      IMPORTING employeename   = employeename        " Nombre Empleado
                                                employeenumber = employeenumber      " Número de personal
                                                usrid9000      = usrid9000 ).        " Nombre de Usuario 9000

                      " Fill response
                      INSERT INITIAL LINE INTO TABLE initialization ASSIGNING FIELD-SYMBOL(<fs_ini>).
                      <fs_ini>-userid         = sy-uname.
                      <fs_ini>-employeename   = employeename.
                      <fs_ini>-employeenumber = employeenumber.
                      <fs_ini>-usrid9000      = usrid9000.

                      io_response->set_data( initialization ).

                      IF io_request->is_total_numb_of_rec_requested( ).
                        io_response->set_total_number_of_records( lines( initialization ) ).
                      ENDIF.
                    ENDIF.
                  CATCH cx_rfc_dest_provider_error INTO lx_dest.
                    MESSAGE lx_dest->get_text( ) TYPE 'E'.
                ENDTRY.
              WHEN 'ZC_HCM_INITIALIZATION_APPROVE'.

                DATA hcm_initialization_approves TYPE STANDARD TABLE OF zc_hcm_initialization_approve.
                " TODO: variable is assigned but never used (ABAP cleaner)
                DATA initialization_approves     TYPE hcm_initialization_approves.

                IF io_request->is_data_requested( ).
                  io_request->get_paging( ).

                  INSERT INITIAL LINE INTO TABLE initialization_approves ASSIGNING FIELD-SYMBOL(<initialization_approve>).
                  LOOP AT filter_object ASSIGNING <fs_filter>.
                    CASE <fs_filter>-name.
                      WHEN 'COMPANYCODE'.
                        <initialization_approve>-CompanyCode = <fs_filter>-range[ 1 ]-low.
                      WHEN 'REQUESTID'.
                        <initialization_approve>-RequestID = <fs_filter>-range[ 1 ]-low.
                    ENDCASE.
                  ENDLOOP.

                  DATA companycode TYPE bukrs.
                  DATA requestid   TYPE zesoldes.

                  companycode = <initialization_approve>-CompanyCode.
                  requestid = <initialization_approve>-RequestID.
                  SELECT * FROM zi_hcm_employee_information
                    INTO TABLE @DATA(hcm_employees_information)
                    WHERE CompanyCode = @companycode
                      AND RequestID   = @requestid.

                  ASSIGN hcm_employees_information[ 1 ] TO FIELD-SYMBOL(<fs_employee_information>).
                  IF sy-subrc IS INITIAL.
                    INSERT INITIAL LINE INTO TABLE hcm_initialization_approves ASSIGNING FIELD-SYMBOL(<fs_initialization_approve>).
                    MOVE-CORRESPONDING <fs_employee_information> TO <fs_initialization_approve>.
                  ENDIF.
                ENDIF.

                io_response->set_data( hcm_initialization_approves ).

                IF io_request->is_total_numb_of_rec_requested( ).
                  io_response->set_total_number_of_records( lines( hcm_initialization_approves ) ).
                ENDIF.

              WHEN 'ZC_HCM_REQUEST_MED_EMPLOYEE'.
                "
                DATA request_employees TYPE hcm_request_employees.

                io_response->set_data( request_employees ).

                IF io_request->is_total_numb_of_rec_requested( ).
                  io_response->set_total_number_of_records( lines( request_employees ) ).
                ENDIF.

            ENDCASE.
          CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_range).
            MESSAGE lx_no_range->get_text( ) TYPE 'E'.
        ENDTRY.

      CATCH cx_rap_query_provider INTO DATA(lx_query_provider).
        MESSAGE lx_query_provider->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD inizialitation.
    " TODO: parameter USERID is never used (ABAP cleaner)

    TYPES: BEGIN OF gty_p0001,
             pernr TYPE persno,
             endda TYPE endda,
             begda TYPE begda,
             ename TYPE emnam,
           END OF gty_p0001.

    TYPES: BEGIN OF gty_p0105,
             pernr TYPE persno,
             usrid TYPE sysid,
           END OF gty_p0105.

    DATA lwa_pa0105      TYPE gty_p0105.
    DATA lt_pa0001       TYPE STANDARD TABLE OF gty_p0001.
    DATA lwa_pa0105_9000 TYPE gty_p0105.

    " LLENADO DE DATOS SOLICITUD
    SELECT SINGLE pernr usrid FROM pa0105
      INTO lwa_pa0105
      WHERE usrid  = sy-uname
        AND begda <= sy-datum
        AND endda >= sy-datum.
    IF lwa_pa0105 IS NOT INITIAL.
      " Empleado
      employeenumber = lwa_pa0105-pernr.
      SELECT pernr endda begda ename FROM pa0001
        INTO TABLE lt_pa0001
        WHERE pernr  = lwa_pa0105-pernr
          AND endda >= sy-datum.

      SELECT SINGLE pernr usrid FROM pa0105
        INTO lwa_pa0105_9000
        WHERE pernr  = lwa_pa0105-pernr
          AND begda <= sy-datum
          AND endda >= sy-datum
          AND subty  = '9000'.

      IF lwa_pa0105_9000 IS NOT INITIAL.
        usrid9000 = lwa_pa0105_9000-usrid.
      ENDIF.

    ENDIF.
    IF lt_pa0001 IS NOT INITIAL.
      SORT lt_pa0001 BY pernr
                        endda DESCENDING.
      ASSIGN lt_pa0001[ 1 ] TO FIELD-SYMBOL(<fs_pa0001>).
      IF sy-subrc = 0.
        " Nombre de empleado
        employeename = <fs_pa0001>-ename.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD save_request .
    DATA request_employees TYPE hcm_request_employees.

    DATA lw_soldes  TYPE zthr_soldesmedic.
    DATA ls_soldes  TYPE char12.
    DATA ls_part2   TYPE char8.
    DATA ls_mensaje TYPE char100.
    DATA message_validate TYPE  char1.

    READ TABLE request_medical_leave  ASSIGNING FIELD-SYMBOL(<fs_employee>) INDEX 1.
    IF sy-subrc IS INITIAL.

      lw_soldes-empleado_solicitud =  <fs_employee>-employeenumber.
      lw_soldes-autogenerado = <fs_employee>-autogeneratedcode.
      lw_soldes-cm_codigo =  <fs_employee>-mccode.
      lw_soldes-idate = <fs_employee>-issuedate.
      lw_soldes-begda = <fs_employee>-datestartmc.
      lw_soldes-endda = <fs_employee>-dateendmc.
      lw_soldes-tenf_code = <fs_employee>-tdiscode.
      lw_soldes-clasfi_code1 = <fs_employee>-classifcode1.
      lw_soldes-especi_code1 = <fs_employee>-especcode1.
      lw_soldes-otros1 = <fs_employee>-others1.
      lw_soldes-clasfi_code2 = <fs_employee>-classifcode2.
      lw_soldes-especi_code2 = <fs_employee>-especcode2.
      lw_soldes-otros2 = <fs_employee>-others2.
      lw_soldes-clasfi_code3 = <fs_employee>-classifcode3.
      lw_soldes-especi_code3 = <fs_employee>-especcode3.
      lw_soldes-otros3 = <fs_employee>-others3.

      me->get_table_inf(
        CHANGING
          soldesmedic =  lw_soldes
      ).

      SELECT SINGLE bukrs INTO @DATA(company)
        FROM pa0001
        WHERE pernr  = @lw_soldes-empleado_solicitud
          AND begda <= @sy-datum
          AND endda >= @sy-datum.

      IF sy-subrc <> 0.
        result = VALUE #( type    = 'E'
                          message = TEXT-e01 ).
        RETURN.
      ENDIF.

      lw_soldes-bukrs            = company.
      lw_soldes-estado_solicitud   = ac_p.
      lw_soldes-usuario_solicitud  = <fs_employee>-userid.
      lw_soldes-fecha_solicitud    = sy-datum.
      lw_soldes-hora_solicitud     = sy-uzeit.

      lw_soldes-archivo = <fs_employee>-filepath.

      split <fs_employee>-filetype at '/' into data(filetype1) data(filetype2).

      lw_soldes-tipo_archivo = |.| & |{ filetype2 }|.
      lw_soldes-archivo_bin        = <fs_employee>-filebin.
      "
      lw_soldes-empleado_nombre    = <fs_employee>-employeename.
      lw_soldes-usrid_9000 = <fs_employee>-usrid9000.

      generate_request_number(
                                EXPORTING year       = sy-datum(4)
                                IMPORTING request_id = ls_part2
                                          message    = ls_mensaje ).


      " Concatenamos ejercicio + N° de solicitud
      CONCATENATE sy-datum(4) ls_part2 INTO ls_soldes.
      lw_soldes-soldes = ls_soldes.

      IF ls_mensaje IS INITIAL.

        MODIFY zthr_soldesmedic FROM lw_soldes.
        IF sy-subrc IS INITIAL.
          MESSAGE e007(zhcm_rap_pe) WITH lw_soldes-soldes INTO result-message.
          result-type    = 'S'.
        ELSE.
          data message_error TYPE bapiret2_t.
          INSERT VALUE #( type = 'E' message = TEXT-026 ) into table message_error.
          READ TABLE message_error into result index 1.
        ENDIF.
      ELSE.
        result-message = ls_mensaje.
        result-type    = 'E'.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD validate_input.
    DATA lo_constantes   TYPE REF TO zbc_constants_admin_n.
    DATA lr_tipos        TYPE RANGE OF varbez1.
    DATA lv_size         TYPE fpm_file_size.

    DATA lr_classifcode  TYPE RANGE OF zeccodig.
    DATA lr_especcode    TYPE RANGE OF zeecodig.

    DATA lwa_classifcode LIKE LINE OF lr_classifcode.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lwa_especcode   LIKE LINE OF lr_especcode.

    TRY.
        lo_constantes = NEW #( pi_repid = 'ZCL_SOLDESM' ).
      CATCH zcx_programa_desconocido INTO DATA(lx_programa_desconocido).
        MESSAGE lx_programa_desconocido->get_text( ) TYPE 'E'.
    ENDTRY.
    " ID de Rango
    lo_constantes->get_first_value_range( EXPORTING pi_rangeid     = '0000091062'
                                          IMPORTING pe_first_value = lv_size ).
    IF lv_size IS NOT INITIAL.
      lv_size *= 1024.
    ENDIF.
    " ID de Rango
    lo_constantes->get_range( EXPORTING pi_rangeid = '0000091063'
                              CHANGING  pt_range   = lr_tipos ).

    ASSIGN request_employees[ 1 ] TO FIELD-SYMBOL(<fs_request>).
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    lwa_classifcode-sign   = 'I'.
    lwa_classifcode-option = 'EQ'.
    lwa_classifcode-low    = <fs_request>-classifcode1.
    INSERT lwa_classifcode INTO TABLE lr_classifcode.
    lwa_classifcode-low = <fs_request>-classifcode2.
    INSERT lwa_classifcode INTO TABLE lr_classifcode.
    lwa_classifcode-low = <fs_request>-classifcode3.
    INSERT lwa_classifcode INTO TABLE lr_classifcode.

    lwa_especcode-sign   = 'I'.
    lwa_especcode-option = 'EQ'.
    lwa_especcode-low    = <fs_request>-especcode1.
    INSERT lwa_classifcode INTO TABLE lr_especcode.
    lwa_especcode-low = <fs_request>-especcode2.
    INSERT lwa_classifcode INTO TABLE lr_especcode.
    lwa_especcode-low = <fs_request>-especcode3.
    INSERT lwa_classifcode INTO TABLE lr_especcode.

    DELETE lr_classifcode WHERE low IS INITIAL.
    DELETE lr_especcode WHERE low IS INITIAL.

    SELECT * FROM zi_hcm_diagnost_specification
      INTO TABLE @DATA(diagnost_specifications)
      WHERE tdiscode     = @<fs_request>-tdiscode
        AND classifcode IN @lr_classifcode
        AND especcode   IN @lr_especcode.

    " Validar que matrícula no sea vacío
    IF <fs_request>-userid IS INITIAL.
      INSERT VALUE #( type    = 'E'
                      message = TEXT-020 ) INTO TABLE messages.
    ENDIF.

    " Validar que matrícula infotipo 105 clase 9000 no sea vacío
    IF <fs_request>-usrid9000 IS INITIAL.
      INSERT VALUE #( type    = 'E'
                      message = TEXT-024 ) INTO TABLE messages.
    ENDIF.

    " Validar que nombre y apellido no sea vacío.
    IF <fs_request>-employeename IS INITIAL.
      INSERT VALUE #( type    = 'E'
                      message = TEXT-021 ) INTO TABLE messages.
    ENDIF.

    CONSTANTS codigo_autogenerado_validacion type char2 VALUE '17'.
    " Validación código autogenerado
    IF <fs_request>-autogeneratedcode IS NOT INITIAL.
      DATA(lv_length) = strlen( <fs_request>-autogeneratedcode ).
      IF lv_length <> codigo_autogenerado_validacion.
        INSERT VALUE #( type    = 'E'
                        message = TEXT-016 ) INTO TABLE messages.
      ELSE.
        " Validar duplicidad de código autogenerado.
        SELECT SINGLE autogenerado INTO @DATA(ls_autogenerado)
          FROM zthr_soldesmedic
          WHERE autogenerado = @<fs_request>-autogeneratedcode.

        IF ls_autogenerado IS NOT INITIAL.
          INSERT VALUE #( type    = 'E'
                          message = TEXT-018 ) INTO TABLE messages.
        ENDIF.
      ENDIF.
    ENDIF.

    " Validar fecha de emisión
    IF <fs_request>-issuedate IS INITIAL.
      INSERT VALUE #( type    = 'E'
                      message = TEXT-003 ) INTO TABLE messages.
    ENDIF.

    " Validar fecha de inicio DM
    IF <fs_request>-datestartmc IS INITIAL.
      INSERT VALUE #( type    = 'E'
                      message = TEXT-004 ) INTO TABLE messages.
    ENDIF.

    " Validar fecha de fin DM
    IF <fs_request>-dateendmc IS INITIAL.
      INSERT VALUE #( type    = 'E'
                      message = TEXT-005 ) INTO TABLE messages.
    ENDIF.

    " Validar fecha inicio y fecha fin
    IF <fs_request>-datestartmc IS NOT INITIAL AND <fs_request>-dateendmc IS NOT INITIAL.
      IF <fs_request>-datestartmc > <fs_request>-dateendmc.
        INSERT VALUE #( type    = 'E'
                        message = TEXT-014 ) INTO TABLE messages.
      ENDIF.
      IF <fs_request>-dateendmc < <fs_request>-datestartmc.

        INSERT VALUE #( type    = 'E'
                        message = TEXT-014 ) INTO TABLE messages.
      ENDIF.
    ENDIF.

    " Validar centro médico
    IF <fs_request>-mccode IS INITIAL.
      INSERT VALUE #( type    = 'E'
                      message = TEXT-023 ) INTO TABLE messages.
    ENDIF.

    " Validar Tipo de enfermedad
    IF <fs_request>-tdiscode IS INITIAL.
      INSERT VALUE #( type    = 'E'
                      message = TEXT-006 ) INTO TABLE messages.
    ELSE.
      " Validar clasificación diagnóstico 1
      IF <fs_request>-classifcode1 IS INITIAL.
        INSERT VALUE #( type    = 'E'
                        message = TEXT-007 ) INTO TABLE messages.
      ENDIF.
    ENDIF.

    " Validar que se haya seleccionado un archivo
    IF <fs_request>-filepath IS INITIAL.
      INSERT VALUE #( type    = 'E'
                      message = TEXT-008 ) INTO TABLE messages.
    ELSE.

      IF <fs_request>-filetype IN lr_tipos.
        DATA(size) = xstrlen( <fs_request>-filebin ).
        IF size IS NOT INITIAL.
          IF size >= lv_size.
            DATA ls_str TYPE string.
            ls_str = lv_size / 1024.
            INSERT VALUE #( type    = 'E'
                            message = |{ TEXT-022 } { ls_str } KB|  ) INTO TABLE messages.
          ENDIF.
        ENDIF.
      ELSE.
        INSERT VALUE #( type    = 'E'
                        message = TEXT-009 ) INTO TABLE messages.
      ENDIF.
    ENDIF.

    " VALIDAR QUE LOS DIAGNÓSTICOS NO SEAN IGUALES. SE VALIDA SI LA ENFERMEDAD, CLASIFICACION 1
    IF <fs_request>-tdiscode IS NOT INITIAL AND <fs_request>-classifcode1 IS NOT INITIAL.
      " SE VALIDA LA CLASIFICACION 2 SI SE HA LLENADO
      IF <fs_request>-classifcode2 IS NOT INITIAL.
        " SE VALIDA CLASIFICACION 1 SEA IGUAL A  CLASIFICACION 2
        IF <fs_request>-classifcode1 = <fs_request>-classifcode2.
          " SE VALIDA ESPECIFICACION 1 SEA IGUAL A  ESPECIFICACION 2
          IF <fs_request>-especcode1 = <fs_request>-especcode2.
            INSERT VALUE #( type    = 'E'
                            message = TEXT-011 ) INTO TABLE messages.
          ENDIF.
        ENDIF.
      ENDIF.

      " SE VALIDA LA CLASIFICACION 3 SI SE HA LLENADO
      IF <fs_request>-classifcode3 IS NOT INITIAL.
        " SE VALIDA CLASIFICACION 1 SEA IGUAL A  CLASIFICACION 3
        IF <fs_request>-classifcode1 = <fs_request>-classifcode3.
          " SE VALIDA ESPECIFICACION 1 SEA IGUAL A  ESPECIFICACION 3
          IF <fs_request>-especcode1 = <fs_request>-especcode3.
            INSERT VALUE #( type    = 'E'
                            message = TEXT-012 ) INTO TABLE messages.
          ENDIF.
        ENDIF.
      ENDIF.

      " SE VALIDA CLASIFICACION 2 TENGA DATOS Y CLASIFICACION 3 TAMBIEN
      IF <fs_request>-classifcode2 IS NOT INITIAL AND <fs_request>-classifcode3 IS NOT INITIAL.
        " SE VALIDA CLASIFICACION 2 SEA IGUAL A  CLASIFICACION 3
        IF <fs_request>-classifcode2 = <fs_request>-classifcode3.
          " SE VALIDA ESPECIFICACION 2 SEA IGUAL A  ESPECIFICACION 3
          IF <fs_request>-especcode2 = <fs_request>-especcode3.
            INSERT VALUE #( type    = 'E'
                            message = TEXT-013 ) INTO TABLE messages.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    " VALIDAR CAMPO OTROS
    IF <fs_request>-tdiscode IS NOT INITIAL.
      IF <fs_request>-classifcode1 IS NOT INITIAL.
        ASSIGN diagnost_specifications[ tdiscode    = <fs_request>-tdiscode
                                        classifcode = <fs_request>-classifcode1
                                        especcode   = <fs_request>-especcode1 ] TO FIELD-SYMBOL(<fs_espec>).
        IF sy-subrc IS INITIAL.
          IF <fs_espec>-flagother = 'X' AND <fs_request>-others1 IS INITIAL.
            INSERT VALUE #( type    = 'E'
                            message = TEXT-019 ) INTO TABLE messages.
          ENDIF.
        ENDIF.
      ENDIF.
      " VALIDA CLASIFICACION 2
      IF <fs_request>-classifcode2 IS NOT INITIAL.
        IF <fs_request>-especcode2 IS NOT INITIAL.
          ASSIGN diagnost_specifications[ tdiscode    = <fs_request>-tdiscode
                                          classifcode = <fs_request>-classifcode2
                                          especcode   = <fs_request>-especcode2 ] TO <fs_espec>.
          IF sy-subrc IS INITIAL.
            IF <fs_espec>-flagother = 'X' AND <fs_request>-others2 IS INITIAL.
              INSERT VALUE #( type    = 'E'
                              message = TEXT-019 ) INTO TABLE messages.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
      " VALIDA CLASIFICACION 3
      IF <fs_request>-classifcode3 IS NOT INITIAL.
        ASSIGN diagnost_specifications[ tdiscode    = <fs_request>-tdiscode
                                        classifcode = <fs_request>-classifcode3
                                        especcode   = <fs_request>-especcode3 ] TO <fs_espec>.
        IF sy-subrc IS INITIAL.
          IF <fs_espec>-flagother = 'X' AND <fs_request>-others3 IS INITIAL.
            INSERT VALUE #( type    = 'E'
                            message = TEXT-019 ) INTO TABLE messages.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD approve_request.
    CONSTANTS error TYPE c LENGTH 1 VALUE 'E'.
    CONSTANTS ac_a  TYPE c LENGTH 1 VALUE 'A'.
    DATA valido    TYPE c LENGTH 1.
    DATA e_mensaje TYPE char100.

    READ TABLE approve_request INTO DATA(approve_req) INDEX 1.

    IF approve_req-usrid9000 <> sy-uname.
      valido = 'X'.
    ELSE.
      CLEAR valido.
      INSERT VALUE #( type    = error
                      message = TEXT-010 ) INTO TABLE messages.
    ENDIF.

    IF valido <> 'X'.
      RETURN.
    ENDIF.


    call FUNCTION 'ZHCM_RFC_APPROVE_MEDICAL_REQ' DESTINATION 'NONE'
      EXPORTING
        requestid = approve_req-requestid
        flag      = approve_req-flag
      IMPORTING
        messages  = messages
      .
    ""DENTRO D ELA CLASE
*    DATA ls_ruta TYPE eps2filnam VALUE '/xcom_rep/GAHR/salida/dctm/DM/100'.
*
*    ls_ruta = |{ ls_ruta }/{ approve_req-requestid }.txt|.
*    OPEN DATASET ls_ruta FOR OUTPUT IN BINARY MODE.
*
*    IF sy-subrc = 8.
*      INSERT INITIAL LINE INTO TABLE messages ASSIGNING FIELD-SYMBOL(<message>).
*      MESSAGE e008(zhcm_rap_pe) WITH sy-uname INTO <message>-message.
*      <message>-type = error.
*    ENDIF.
*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.
*
*    DELETE DATASET ls_ruta.
*    " Test infotipos grabado infotipo82  y 2001.
*    e_mensaje = create_intotype82_test( i_soldes = approve_req-requestid
*                                        " MODIFICAR CLASE NUEVA
*                                        i_flag   = approve_req-flag ).
*    " MODIFICAR CLASE NUEVA
*    e_mensaje = create_intotype2001_test( approve_req-requestid ).
*
*    IF e_mensaje IS INITIAL.
*      e_mensaje = create_intotype82( i_soldes = approve_req-requestid
*                                     i_flag   = approve_req-flag ).
*      IF e_mensaje IS INITIAL.
*        e_mensaje = create_intotype2001( approve_req-requestid ).
*        IF e_mensaje IS INITIAL.
*          UPDATE zthr_soldesmedic SET estado_solicitud  = ac_a
*                          usuario_aprobador = sy-uname
*                          fecha_aprobacion  = sy-datum
*                      WHERE soldes = approve_req-requestid.
*          IF sy-subrc IS INITIAL.
*
*            CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' DESTINATION 'NONE'
*              EXPORTING wait = 'X'.
*
*            INSERT INITIAL LINE INTO TABLE messages ASSIGNING <message>.
*            MESSAGE e009(zhcm_rap_pe) WITH approve_req-requestid INTO <message>-message.
*            <message>-type = error.
*            create_file_al11( i_soldes = approve_req-requestid ).
*            notificate( i_soldes    = approve_req-requestid
*                        i_operacion = ac_a ).
*          ELSE.
*            e_mensaje = get_message( sy ).
*          ENDIF.
*        ENDIF.
*      ENDIF.
*    ENDIF.
  ENDMETHOD.


  METHOD get_body_mail.
    DATA ls_name         TYPE tdobname.

    DATA ltd_lines       TYPE STANDARD TABLE OF tline.
    DATA lws_contents    TYPE soli.
    " tdline,
    DATA ls_content_aux  TYPE char200.
    " tdline,
    DATA ls_content_new  TYPE char200.
    DATA ls_format_aux   TYPE tdformat.
    DATA ls_diagnostico1 TYPE char50.
    DATA ls_diagnostico2 TYPE char50.
    DATA ls_diagnostico3 TYPE char50.
    DATA ld_fecha_ini    TYPE char10.
    DATA ld_fecha_fin    TYPE char10.
    DATA ld_fecha_emi    TYPE char10.

    DATA ls_tabix        TYPE sy-tabix.

    DATA lw_soldes       TYPE zthr_soldesmedic.

    DATA ls_usrid_9000   TYPE sysid.

    SELECT SINGLE * INTO lw_soldes FROM zthr_soldesmedic WHERE soldes = i_soldes.
    SELECT SINGLE usrid INTO ls_usrid_9000
      FROM pa0105
      WHERE pernr  = lw_soldes-empleado_solicitud
        AND begda <= sy-datum
        AND endda >= sy-datum
        AND subty  = '9000'.

    IF i_jefe = abap_true.

      IF i_operacion = 'A'.
        ls_name = 'ZHRSOLDES_001_JEFE'.
      ELSEIF i_operacion = 'R'.
        ls_name = 'ZHRSOLDES_002_JEFE'.
      ELSEIF i_operacion = 'S'.
        ls_name = 'ZHRSOLDES_003_JEFE'.
      ELSE.
        EXIT.
      ENDIF.

    ELSE.

      IF i_operacion = 'A'.
        ls_name = 'ZHRSOLDES_001'.
      ELSEIF i_operacion = 'R'.
        ls_name = 'ZHRSOLDES_002'.
      ELSEIF i_operacion = 'S'.
        ls_name = 'ZHRSOLDES_003'.
      ELSE.
        EXIT.
      ENDIF.

    ENDIF.

    " Obtener cuerpo del mensaje para el colaborador/jefe
    CALL FUNCTION 'READ_TEXT'
      EXPORTING  id                      = 'ST'
                 language                = 'S' " sy-langu
                 name                    = ls_name
                 object                  = 'TEXT'
      TABLES     lines                   = ltd_lines
      EXCEPTIONS id                      = 1
                 language                = 2
                 name                    = 3
                 not_found               = 4
                 object                  = 5
                 reference_check         = 6
                 wrong_access_to_archive = 7.
    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.

    CONCATENATE lw_soldes-calsfi_desc1 lw_soldes-especi_desc1 lw_soldes-otros1 INTO ls_diagnostico1 SEPARATED BY '/'.
    CONCATENATE lw_soldes-calsfi_desc2 lw_soldes-especi_desc2 lw_soldes-otros2 INTO ls_diagnostico2 SEPARATED BY '/'.
    CONCATENATE lw_soldes-calsfi_desc3 lw_soldes-especi_desc3 lw_soldes-otros3 INTO ls_diagnostico3 SEPARATED BY '/'.
    CONCATENATE lw_soldes-begda+6(2) lw_soldes-begda+4(2) lw_soldes-begda(4)   INTO ld_fecha_ini SEPARATED BY '/'.
    CONCATENATE lw_soldes-endda+6(2) lw_soldes-endda+4(2) lw_soldes-endda(4)   INTO ld_fecha_fin SEPARATED BY '/'.
    CONCATENATE lw_soldes-idate+6(2) lw_soldes-idate+4(2) lw_soldes-idate(4)   INTO ld_fecha_emi SEPARATED BY '/'.

    REFRESH rt_mensaje.
    IF i_operacion = 'S'.
      LOOP AT ltd_lines ASSIGNING FIELD-SYMBOL(<fs_lines>).

        lws_contents-line = <fs_lines>-tdline.
        REPLACE '&1' INTO lws_contents-line WITH i_soldes.
        REPLACE '&2' INTO lws_contents-line WITH lw_soldes-motivo_rechazo.
        REPLACE '&3' INTO lws_contents-line WITH ls_usrid_9000.
        REPLACE '&4' INTO lws_contents-line WITH lw_soldes-empleado_nombre.
        REPLACE '&5' INTO lws_contents-line WITH lw_soldes-tenf_desc.
        REPLACE '&6' INTO lws_contents-line WITH ls_diagnostico1.
        REPLACE '&7' INTO lws_contents-line WITH ls_diagnostico2.
        REPLACE '&8' INTO lws_contents-line WITH ls_diagnostico3.
        REPLACE '&9' INTO lws_contents-line WITH ld_fecha_ini.

        REPLACE '<(>&<)>' INTO lws_contents-line WITH '&'.
        REPLACE '<(>,<)>' INTO lws_contents-line WITH ','.
        REPLACE '&A1' INTO lws_contents-line WITH ld_fecha_fin.
        REPLACE '&A2' INTO lws_contents-line WITH ld_fecha_emi.
        REPLACE '&A3' INTO lws_contents-line WITH lw_soldes-cm_descr.
        REPLACE '&A4' INTO lws_contents-line WITH lw_soldes-autogenerado.
        IF <fs_lines>-tdformat = ''.
          IF ls_format_aux = '*'.
            CONCATENATE ls_content_aux <fs_lines>-tdline INTO ls_content_new SEPARATED BY space.
            ASSIGN rt_mensaje[ ls_tabix ] TO FIELD-SYMBOL(<fs_mensaje>).
            IF sy-subrc IS INITIAL.
              <fs_mensaje>-line = ls_content_new.
              " Más de una linea
              ls_content_aux = ls_content_new.
            ENDIF.
          ENDIF.
        ELSE.
          INSERT lws_contents INTO TABLE rt_mensaje.
        ENDIF.
        IF <fs_lines>-tdformat <> ''.
          ls_tabix = sy-tabix.
          ls_content_aux = <fs_lines>-tdline.
          ls_format_aux = <fs_lines>-tdformat.
        ENDIF.
      ENDLOOP.

    ELSE.
      LOOP AT ltd_lines ASSIGNING FIELD-SYMBOL(<fs_lines1>).

        lws_contents-line = <fs_lines1>-tdline.
        REPLACE '&1' INTO lws_contents-line WITH i_soldes.
        REPLACE '&2' INTO lws_contents-line WITH lw_soldes-motivo_rechazo.
        REPLACE '&3' INTO lws_contents-line WITH ls_usrid_9000.
        REPLACE '&4' INTO lws_contents-line WITH lw_soldes-empleado_nombre.
        REPLACE '&5' INTO lws_contents-line WITH lw_soldes-tenf_desc.
        REPLACE '&6' INTO lws_contents-line WITH ls_diagnostico1.
        REPLACE '&7' INTO lws_contents-line WITH ls_diagnostico2.
        REPLACE '&8' INTO lws_contents-line WITH ls_diagnostico3.
        REPLACE '&9' INTO lws_contents-line WITH ld_fecha_ini.

        REPLACE '<(>&<)>' INTO lws_contents-line WITH '&'.
        REPLACE '<(>,<)>' INTO lws_contents-line WITH ','.
        REPLACE '&A1' INTO lws_contents-line WITH ld_fecha_fin.
        REPLACE '&A2' INTO lws_contents-line WITH ld_fecha_emi.
        REPLACE '&A3' INTO lws_contents-line WITH lw_soldes-cm_descr.
        REPLACE '&A4' INTO lws_contents-line WITH lw_soldes-autogenerado.
        IF <fs_lines1>-tdformat = ''.
          IF ls_format_aux = '*'.
            CONCATENATE ls_content_aux <fs_lines1>-tdline INTO ls_content_new SEPARATED BY space.
            ASSIGN rt_mensaje[ ls_tabix ] TO FIELD-SYMBOL(<fs_mensaje1>).
            IF sy-subrc IS INITIAL.
              <fs_mensaje1>-line = ls_content_new.
              " Más de una linea
              ls_content_aux = ls_content_new.
            ENDIF.
          ENDIF.
        ELSE.
          INSERT lws_contents INTO TABLE rt_mensaje.
        ENDIF.
        IF <fs_lines1>-tdformat <> ''.
          ls_tabix = sy-tabix.
          ls_content_aux = lws_contents.
          ls_format_aux = <fs_lines1>-tdformat.
        ENDIF.
      ENDLOOP.

    ENDIF.
  ENDMETHOD.


  METHOD get_message_request.

    CALL FUNCTION 'MESSAGE_TEXT_BUILD'
      EXPORTING
        msgid               = iw_syst-msgid
        msgnr               = iw_syst-msgno
        msgv1               = iw_syst-msgv1
        msgv2               = iw_syst-msgv2
        msgv3               = iw_syst-msgv3
        msgv4               = iw_syst-msgv4
      IMPORTING
        message_text_output = e_mensaje.

  ENDMETHOD.


  METHOD get_recipients.
    DATA lt_objetos TYPE objec_t.
    DATA lt_estruct TYPE struc_t.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA ls_copy    TYPE gdstr.
    DATA ls_email   TYPE comm_id_long.

*&----------------------------------------------------------------------------&
*&---------------1.Obtener email de empleado que generó la sol.&--------------&
*&----------------------------------------------------------------------------&
    IF i_jefe = abap_false.
      CLEAR ls_email.
      SELECT usrid_long INTO ls_email
        FROM pa0105
        UP TO 1 ROWS
        WHERE pernr  = i_empleado
          AND subty  = '0010'
          AND begda <= sy-datum
          AND endda >= sy-datum.
      ENDSELECT.
      IF ls_email IS NOT INITIAL.
        INSERT INITIAL LINE INTO TABLE rt_destinatario ASSIGNING FIELD-SYMBOL(<fs_dest>).
        <fs_dest>-email = ls_email.
        <fs_dest>-sndex = abap_true.
      ENDIF.
    ELSE.
*&----------------------------------------------------------------------------&
*&--2.Obtener email de resp. de Unidad org. del empleado que generó la sol.&--&
*&----------------------------------------------------------------------------&

      " Obtener unidad org. inmediada del empleado
      CALL FUNCTION 'HR_STRUCTURE_GET'
        EXPORTING  root_plvar       = '01'
                   root_otype       = 'P'
                   root_objid       = i_empleado
                   pathid           = 'PEGET_O'
        IMPORTING  result_objects   = lt_objetos
                   result_structure = lt_estruct
                   root_copy        = ls_copy
        EXCEPTIONS plvar_not_found  = 1
                   root_not_found   = 2
                   path_not_found   = 3
                   internal_error   = 4
                   OTHERS           = 5.
      IF sy-subrc = 0.
        READ TABLE lt_objetos WITH KEY otype = 'O' INTO DATA(lw_obj).
        IF sy-subrc IS INITIAL.
          " Obtener posición que dirige a unid. org.
          CALL FUNCTION 'HR_STRUCTURE_GET'
            EXPORTING  root_plvar       = '01'
                       root_otype       = 'O'
                       root_objid       = lw_obj-objid
                       pathid           = 'B012'
            IMPORTING  result_objects   = lt_objetos
                       result_structure = lt_estruct
                       root_copy        = ls_copy
            EXCEPTIONS plvar_not_found  = 1
                       root_not_found   = 2
                       path_not_found   = 3
                       internal_error   = 4
                       OTHERS           = 5.
          IF sy-subrc = 0.
            READ TABLE lt_objetos WITH KEY otype = 'S' INTO lw_obj.
            IF sy-subrc IS INITIAL.
              " Obtener titular de la posición
              REFRESH: lt_objetos, lt_estruct.
              CLEAR ls_copy.
              CALL FUNCTION 'HR_STRUCTURE_GET'
                EXPORTING  root_plvar         = '01'
                           root_otype         = 'S'
                           root_objid         = lw_obj-objid
                           pathid             = 'RSX7'
                           begda              = sy-datum
                           endda              = sy-datum
                           stru_status_vector = '1'
                IMPORTING  result_objects     = lt_objetos
                           result_structure   = lt_estruct
                           root_copy          = ls_copy
                EXCEPTIONS plvar_not_found    = 1
                           root_not_found     = 2
                           path_not_found     = 3
                           internal_error     = 4
                           OTHERS             = 5.

              IF sy-subrc = 0.
                READ TABLE lt_objetos WITH KEY otype = 'P' INTO lw_obj.
                IF sy-subrc IS INITIAL.
                  CLEAR ls_email.
                  " Se validad si el empleado es el jefe de la posición
                  IF lw_obj-objid <> i_empleado.
                    SELECT usrid_long INTO ls_email
                      FROM pa0105
                      UP TO 1 ROWS
                      WHERE pernr  = lw_obj-objid
                        AND subty  = '0010'
                        AND begda <= sy-datum
                        AND endda >= sy-datum.
                    ENDSELECT.
                    IF ls_email IS NOT INITIAL.
                      INSERT INITIAL LINE INTO TABLE rt_destinatario ASSIGNING <fs_dest>.
                      <fs_dest>-email = ls_email.
                      <fs_dest>-sndex = abap_true.
                    ENDIF.
                  ELSE.
                    " Obtener unidad org. inmediada del empleado
                    REFRESH: lt_objetos, lt_estruct.
                    CLEAR ls_copy.
                    CALL FUNCTION 'HR_STRUCTURE_GET'
                      EXPORTING  root_plvar       = '01'
                                 root_otype       = 'P'
                                 root_objid       = i_empleado
                                 pathid           = 'PEGET_O'
                      IMPORTING  result_objects   = lt_objetos
                                 result_structure = lt_estruct
                                 root_copy        = ls_copy
                      EXCEPTIONS plvar_not_found  = 1
                                 root_not_found   = 2
                                 path_not_found   = 3
                                 internal_error   = 4
                                 OTHERS           = 5.
                    IF sy-subrc = 0.
                      READ TABLE lt_objetos WITH KEY otype = 'O' INTO DATA(lw_obj2).
                      IF sy-subrc IS INITIAL.
                        " obtener posición que dirige a unid. org.
                        CALL FUNCTION 'HR_STRUCTURE_GET'
                          EXPORTING  root_plvar       = '01'
                                     root_otype       = 'O'
                                     root_objid       = lw_obj2-objid
                                     pathid           = 'A002'
                          IMPORTING  result_objects   = lt_objetos
                                     result_structure = lt_estruct
                                     root_copy        = ls_copy
                          EXCEPTIONS plvar_not_found  = 1
                                     root_not_found   = 2
                                     path_not_found   = 3
                                     internal_error   = 4
                                     OTHERS           = 5.
                        IF sy-subrc = 0.
                          " Eliminamos unidad organizativa subordinada
                          DELETE lt_objetos WHERE objid = lw_obj2-objid.

                          READ TABLE lt_objetos WITH KEY otype = 'O' INTO lw_obj2.
                          IF sy-subrc IS INITIAL.
                            " obtener posición que dirige a unid. org.
                            CALL FUNCTION 'HR_STRUCTURE_GET'
                              EXPORTING  root_plvar       = '01'
                                         root_otype       = 'O'
                                         root_objid       = lw_obj2-objid
                                         pathid           = 'B012'
                              IMPORTING  result_objects   = lt_objetos
                                         result_structure = lt_estruct
                                         root_copy        = ls_copy
                              EXCEPTIONS plvar_not_found  = 1
                                         root_not_found   = 2
                                         path_not_found   = 3
                                         internal_error   = 4
                                         OTHERS           = 5.
                            IF sy-subrc = 0.
                              READ TABLE lt_objetos WITH KEY otype = 'S' INTO lw_obj2.
                              IF sy-subrc IS INITIAL.
                                " obtener titular de la posición
                                REFRESH: lt_objetos, lt_estruct.
                                CLEAR ls_copy.
                                CALL FUNCTION 'HR_STRUCTURE_GET'
                                  EXPORTING  root_plvar         = '01'
                                             root_otype         = 'S'
                                             root_objid         = lw_obj2-objid
                                             pathid             = 'RSX7'
                                             begda              = sy-datum
                                             endda              = sy-datum
                                             stru_status_vector = '1'
                                  IMPORTING  result_objects     = lt_objetos
                                             result_structure   = lt_estruct
                                             root_copy          = ls_copy
                                  EXCEPTIONS plvar_not_found    = 1
                                             root_not_found     = 2
                                             path_not_found     = 3
                                             internal_error     = 4
                                             OTHERS             = 5.

                                IF sy-subrc = 0.
                                  READ TABLE lt_objetos WITH KEY otype = 'P' INTO lw_obj2.
                                  IF sy-subrc IS INITIAL.
                                    SELECT usrid_long INTO ls_email
                                      FROM pa0105
                                      UP TO 1 ROWS
                                      WHERE pernr  = lw_obj2-objid
                                        AND subty  = '0010'
                                        AND begda <= sy-datum
                                        AND endda >= sy-datum.
                                    ENDSELECT.
                                    IF ls_email IS NOT INITIAL.
                                      INSERT INITIAL LINE INTO TABLE rt_destinatario ASSIGNING <fs_dest>.
                                      <fs_dest>-email = ls_email.
                                      <fs_dest>-sndex = abap_true.
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
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD notificate.
    DATA lw_soldes  TYPE zthr_soldesmedic.
    DATA ls_subject TYPE so_obj_des.

    TRY.
        ao_constantes = NEW #( pi_repid = 'ZCL_SOLDESM' ).
      CATCH zcx_programa_desconocido into data(lx_programa_desconocido).
            MESSAGE lx_programa_desconocido->get_text( ) TYPE 'E'.
    ENDTRY.

    ao_constantes->get_first_value_range( EXPORTING pi_rangeid     = '0000091057'  " ID de Rango
                                          IMPORTING pe_first_value = ac_emisor ).

    ao_constantes->get_first_value_range( EXPORTING pi_rangeid     = '0000091058'  " ID de Rango
                                          IMPORTING pe_first_value = ac_copia ).

    SELECT SINGLE * INTO lw_soldes
      FROM zthr_soldesmedic
      WHERE soldes = i_soldes.

    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.
    ac_op = i_operacion.
    IF i_operacion = 'S'.
      CONCATENATE 'Solicitud de DM' i_soldes 'enviada' INTO ls_subject SEPARATED BY space.
    ELSEIF i_operacion = 'A'.
      CONCATENATE 'Solicitud de DM' i_soldes 'aprobada' INTO ls_subject SEPARATED BY space.
    ELSEIF i_operacion = 'R'.
      CONCATENATE 'Solicitud de DM' i_soldes 'rechazada' INTO ls_subject SEPARATED BY space.

    ELSE.
      EXIT.
    ENDIF.

    send_mail( i_soldes         = i_soldes
               i_subject        = ls_subject
               i_emisor         = ac_emisor " ac_emisor "ls_emisor
               it_mensaje       = get_body_mail( i_soldes    = i_soldes
                                                 i_operacion = i_operacion
                                                 i_jefe      = abap_false )
               it_destinatarios = get_recipients( i_empleado = lw_soldes-empleado_solicitud
                                                  i_jefe     = abap_false )
               i_commit         = abap_true ).

    send_mail( i_soldes         = i_soldes
               i_subject        = ls_subject
               i_emisor         = ac_emisor " ac_emisor "ls_emisor
               it_mensaje       = get_body_mail( i_soldes    = i_soldes
                                                 i_operacion = i_operacion
                                                 i_jefe      = abap_true )
               it_destinatarios = get_recipients( i_empleado = lw_soldes-empleado_solicitud
                                                  i_jefe     = abap_true )
               i_commit         = abap_true ).
  ENDMETHOD.


  METHOD reject_request.
    CONSTANTS error    TYPE c LENGTH 1 VALUE 'E'.
    CONSTANTS sucefull TYPE c LENGTH 1 VALUE 'S'.
    CONSTANTS reject   TYPE c LENGTH 1 VALUE 'R'.

    DATA e_mensaje TYPE char100.

    READ TABLE reject_request INTO DATA(reject_req) INDEX 1.

    UPDATE zthr_soldesmedic SET estado_solicitud = reject
                               fecha_rechazo    = sy-datum
                               usuario_anulador = sy-uname
                               motivo_rechazo   = reject_req-reasonrejection
                       WHERE soldes = reject_req-requestid.
    IF sy-subrc IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT' DESTINATION 'NONE'
        EXPORTING wait = 'X'.
 " CREAR METODO
      notificate( i_soldes    = reject_req-requestid
                  i_operacion = reject ).

      INSERT INITIAL LINE INTO TABLE messages ASSIGNING FIELD-SYMBOL(<message>).
      MESSAGE e010(zhcm_rap_pe) WITH reject_req-requestid INTO <message>-message.
      <message>-type = sucefull.

    ELSE.
      e_mensaje = get_message_request( sy ).
      INSERT VALUE #( type    = error
                      message = e_mensaje ) inTO table messages.
    ENDIF.
  ENDMETHOD.


  METHOD send_mail.
    DATA lo_send_email TYPE REF TO cl_bcs.
    DATA lo_document   TYPE REF TO cl_document_bcs.
    DATA lo_recipient  TYPE REF TO if_recipient_bcs.
    DATA lo_sender     TYPE REF TO cl_cam_address_bcs.
    DATA lo_sender_cc  TYPE REF TO cl_cam_address_bcs.

    DATA ls_cuerpo     TYPE soli_tab.
    DATA lwa_linea     TYPE solisti1.

    " Creado cuerpo en HTML
    APPEND '<body>' TO ls_cuerpo.
    LOOP AT it_mensaje ASSIGNING FIELD-SYMBOL(<fs_linea>).
      CONCATENATE <fs_linea> '</br>' INTO lwa_linea.
      INSERT lwa_linea INTO TABLE ls_cuerpo.
      CLEAR lwa_linea.
    ENDLOOP.
    APPEND '</body>' TO ls_cuerpo.
    " Título del correo
    TRY.
        " Formato HTML
        lo_document = cl_document_bcs=>create_document( i_type    = 'HTM'
                                                        i_subject = i_subject
                                                        i_text    = ls_cuerpo ).
      CATCH cx_document_bcs INTO DATA(lx_document_bcs).
        MESSAGE lx_document_bcs->get_text( ) TYPE 'E'.
    ENDTRY.

    TRY.
        lo_send_email = cl_bcs=>create_persistent( ).
      CATCH cx_send_req_bcs INTO DATA(lx_req_bcs).
        MESSAGE lx_req_bcs->get_text( ) TYPE 'E'.
    ENDTRY.

    TRY.
        lo_send_email->set_document( lo_document ).
      CATCH cx_send_req_bcs INTO lx_req_bcs.
        MESSAGE lx_req_bcs->get_text( ) TYPE 'E'.
    ENDTRY.

    TYPES:
      BEGIN OF gty_s_soldesmedic,
        soldes       TYPE zthr_soldesmedic-soldes,
        archivo      TYPE zthr_soldesmedic-archivo,
        tipo_archivo TYPE zthr_soldesmedic-tipo_archivo,
        archivo_bin  TYPE zthr_soldesmedic-archivo_bin,
      END OF gty_s_soldesmedic.
    DATA gty_t_soldesmedic TYPE gty_s_soldesmedic.
    DATA lv_file           TYPE xstring. " string,
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_tip_a1         TYPE soodk-objtp.
    DATA lv_tip_a2         TYPE soodk-objtp.
    DATA lt_list           TYPE solix_tab.
    " ENVIAR ARCHIVO ADJUNTO
    IF ac_op = 'R'.

      SELECT SINGLE soldes archivo tipo_archivo archivo_bin
        INTO gty_t_soldesmedic
        FROM zthr_soldesmedic
        WHERE soldes = i_soldes.

      SPLIT gty_t_soldesmedic-tipo_archivo AT '.' INTO lv_tip_a1 lv_tip_a2.
      lv_file = gty_t_soldesmedic-archivo_bin.

      TRY.
          lt_list = cl_bcs_convert=>xstring_to_solix( iv_xstring = lv_file ).
        CATCH cx_bcs INTO DATA(lx_bcs).
          MESSAGE lx_bcs->get_text( ) TYPE 'E'.

      ENDTRY.

      TRY.
          lo_document->add_attachment( i_attachment_type    = lv_tip_a2
                                       i_attachment_subject = i_subject
                                       i_att_content_hex    = lt_list ).
        CATCH cx_bcs INTO lx_bcs.
          MESSAGE lx_bcs->get_text( ) TYPE 'E'.
      ENDTRY.
    ENDIF.
    " Emisor del correo
    TRY.
        lo_sender = cl_cam_address_bcs=>create_internet_address( i_emisor ).
      CATCH cx_address_bcs INTO DATA(lx_address_bcs).
    ENDTRY.
    TRY.
        lo_send_email->set_sender( i_sender = lo_sender ).
      CATCH cx_send_req_bcs INTO lx_req_bcs.
        MESSAGE lx_req_bcs->get_text( ) TYPE 'E'.
    ENDTRY.

    " Destinatarios
    LOOP AT it_destinatarios ASSIGNING FIELD-SYMBOL(<fs_dest>).
      TRY.
          lo_recipient = cl_cam_address_bcs=>create_internet_address( <fs_dest>-email ).
        CATCH cx_address_bcs INTO lx_address_bcs.
          MESSAGE lx_address_bcs->get_text( ) TYPE 'E'.
      ENDTRY.
      TRY.
          lo_send_email->add_recipient( i_recipient = lo_recipient
                                        i_express   = <fs_dest>-sndex
                                        i_copy      = <fs_dest>-sndcp ).
        CATCH cx_send_req_bcs INTO lx_req_bcs.
          MESSAGE lx_req_bcs->get_text( ) TYPE 'E'.
      ENDTRY.
    ENDLOOP.

    " Enviar Copia
    " SE AGREGA CORREO DE BUZÓN DE DESCANSOS MÉDICOS
    IF ac_op = 'R' OR ac_op = 'A'.
*      TRY.
*          " ls_email2 "ac_copia
*          lo_sender_cc = cl_cam_address_bcs=>create_internet_address( ac_copia ).
*        CATCH cx_address_bcs INTO lx_address_bcs.
*          MESSAGE lx_address_bcs->get_text( ) TYPE 'E'.
*      ENDTRY.
*      TRY.
*          lo_send_email->add_recipient( i_recipient = lo_sender_cc
*                                        i_express   = 'X'
*                                        i_copy      = 'X' ).
*        CATCH cx_send_req_bcs INTO lx_req_bcs.
*          MESSAGE lx_req_bcs->get_text( ) TYPE 'E'.
*      ENDTRY.
    ENDIF.

    TRY.
        lo_send_email->send( i_with_error_screen = 'X' ).
        IF i_commit = abap_true.
          CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          DESTINATION 'NONE'
            EXPORTING wait = 'X'.
        ENDIF.
      CATCH cx_send_req_bcs INTO lx_req_bcs.
        MESSAGE lx_req_bcs->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDMETHOD.


  METHOD create_file_al11.
    DATA lt_binario TYPE TABLE OF solix-line.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA li_length  TYPE i.
    DATA ls_ruta    TYPE eps2filnam VALUE '/xcom_rep/GAHR/salida/dctm/DM/100'.
    DATA ls_tipo    TYPE zesoldes_tipof.
    DATA ls_archivo TYPE xstring.
    DATA ls_estado  TYPE zesoldes_estado.

    DATA ls_mensaje TYPE char100.

    SELECT SINGLE tipo_archivo archivo_bin estado_solicitud
      INTO ( ls_tipo, ls_archivo, ls_estado )
      FROM zthr_soldesmedic
      WHERE soldes = i_soldes.

    IF sy-subrc IS NOT INITIAL.
      RETURN.
    ENDIF.
    IF ls_estado <> 'A'.
      WRITE |{ | No tiene el estado APROBADO el N°. solicitud desc. médico | && i_soldes }|.
    ENDIF.
    IF ls_estado <> 'A'.
      RETURN.
    ENDIF.

    CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
      EXPORTING buffer        = ls_archivo
      IMPORTING output_length = li_length
      TABLES    binary_tab    = lt_binario.

    IF lt_binario IS NOT INITIAL.

      ls_ruta = |{ ls_ruta }/{ i_soldes }{ ls_tipo }|.

      OPEN DATASET ls_ruta FOR OUTPUT IN BINARY MODE.

      IF sy-subrc IS INITIAL.

        LOOP AT lt_binario ASSIGNING FIELD-SYMBOL(<fs_bin>).
          TRANSFER <fs_bin> TO ls_ruta.
        ENDLOOP.

        CLOSE DATASET ls_ruta.

      ELSE.
        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
          EXPORTING msgid               = sy-msgid
                    msgnr               = sy-msgno
                    msgv1               = sy-msgv1
                    msgv2               = sy-msgv2
                    msgv3               = sy-msgv3
                    msgv4               = sy-msgv4
          IMPORTING message_text_output = ls_mensaje.
      ENDIF.
    ELSE.
      CALL FUNCTION 'MESSAGE_TEXT_BUILD'
        EXPORTING msgid               = sy-msgid
                  msgnr               = sy-msgno
                  msgv1               = sy-msgv1
                  msgv2               = sy-msgv2
                  msgv3               = sy-msgv3
                  msgv4               = sy-msgv4
        IMPORTING message_text_output = ls_mensaje.
    ENDIF.

    WRITE ls_mensaje.
    IF ls_mensaje IS NOT INITIAL.
      e_mensaje = ls_mensaje.
    ENDIF.
  ENDMETHOD.


  METHOD create_intotype2001.
    DATA lw_soldes  TYPE zthr_soldesmedic.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lws_struc1 TYPE bapireturn1.
    DATA lws_struc2 TYPE bapireturn1.
    DATA lws_p2001  TYPE p2001.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lws_key    TYPE bapipakey.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA e_error    TYPE flag.

    SELECT * FROM zthr_soldesmedic
      INTO lw_soldes
      WHERE soldes = i_soldes.
    ENDSELECT.

    " Bloqueando Empleado
    CALL FUNCTION 'BAPI_EMPLOYEE_ENQUEUE'
      EXPORTING number = lw_soldes-empleado_solicitud
      IMPORTING return = lws_struc1.

    lws_p2001-infty = '2001'.
    lws_p2001-subty = '1130'.
    lws_p2001-pernr = lw_soldes-empleado_solicitud.
    lws_p2001-endda = lw_soldes-endda.
    lws_p2001-begda = lw_soldes-begda.
    lws_p2001-uname = sy-uname.
    lws_p2001-aedtm = sy-datum.

    " Creando infotipo 2001
    CALL FUNCTION 'HR_PSBUFFER_INITIALIZE'.

    CALL FUNCTION 'HR_INFOTYPE_OPERATION'
*    CALL FUNCTION 'Z_HR_INFOTYPE_OPERATION'  DESTINATION 'NONE'
      EXPORTING  infty         = lws_p2001-infty
                 number        = lws_p2001-pernr
                 subtype       = lws_p2001-subty
                 validityend   = lws_p2001-endda
                 validitybegin = lws_p2001-begda
                 record        = lws_p2001
                 operation     = 'INS'
      IMPORTING  return        = lws_struc2
                 key           = lws_key
      EXCEPTIONS OTHERS        = 0.

    IF lws_struc2-type = 'E'.
      e_error = abap_true.
      IF lws_struc2-number = EmployeeBloqued.
        e_mensaje = 'El empleado/candidato aún está bloqueado'.
      ELSE.
        e_mensaje = lws_struc2-message.
      ENDIF.
    ELSE.
      CLEAR e_mensaje.
    ENDIF.

    " Desbloqueando Empleado
    CLEAR lws_struc1.
    CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
      EXPORTING number = lw_soldes-empleado_solicitud
      IMPORTING return = lws_struc1.
  ENDMETHOD.


  METHOD create_intotype2001_test.
    DATA lw_soldes  TYPE zthr_soldesmedic.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lws_struc1 TYPE bapireturn1.
    DATA lws_struc2 TYPE bapireturn1.
    DATA lws_p2001  TYPE p2001.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lws_key    TYPE bapipakey.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA e_error    TYPE flag.

    SELECT * FROM zthr_soldesmedic
      INTO lw_soldes
      WHERE soldes = i_soldes.
    ENDSELECT.

    " Bloqueando Empleado
    CALL FUNCTION 'BAPI_EMPLOYEE_ENQUEUE'
      EXPORTING number = lw_soldes-empleado_solicitud
      IMPORTING return = lws_struc1.

    lws_p2001-infty = '2001'.
    lws_p2001-subty = '1130'.
    lws_p2001-pernr = lw_soldes-empleado_solicitud.
    lws_p2001-endda = lw_soldes-endda.
    lws_p2001-begda = lw_soldes-begda.
    lws_p2001-uname = sy-uname.
    lws_p2001-aedtm = sy-datum.

    " Creando infotipo 2001
    CALL FUNCTION 'HR_PSBUFFER_INITIALIZE'.

*    CALL FUNCTION 'Z_HR_INFOTYPE_OPERATION'  DESTINATION 'NONE'
    CALL FUNCTION 'HR_INFOTYPE_OPERATION'
      EXPORTING  infty         = lws_p2001-infty
                 number        = lws_p2001-pernr
                 subtype       = lws_p2001-subty
                 validityend   = lws_p2001-endda
                 validitybegin = lws_p2001-begda
                 record        = lws_p2001
                 operation     = 'INS'
                 nocommit      = 'X'
      IMPORTING  return        = lws_struc2
                 key           = lws_key
      EXCEPTIONS OTHERS        = 0.

    IF lws_struc2-type = 'E'.
      e_error = abap_true.
      IF lws_struc2-number = EmployeeBloqued.
        e_mensaje = 'El empleado/candidato aún está bloqueado'.
      ELSE.
        e_mensaje = lws_struc2-message.
      ENDIF.
    ELSE.
      CLEAR e_mensaje.
    ENDIF.

    " Desbloqueando Empleado
    CLEAR lws_struc1.
    CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
      EXPORTING number = lw_soldes-empleado_solicitud
      IMPORTING return = lws_struc1.
  ENDMETHOD.


  METHOD create_intotype82.
    DATA lw_soldes  TYPE zthr_soldesmedic.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lws_struc1 TYPE bapireturn1.
    DATA lws_struc2 TYPE bapireturn1.
    DATA lws_p0082  TYPE p0082.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lws_key    TYPE bapipakey.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA e_error    TYPE flag.

    SELECT * FROM zthr_soldesmedic
      INTO lw_soldes
      WHERE soldes = i_soldes.
    ENDSELECT.

    " Bloqueando Empleado
    CALL FUNCTION 'BAPI_EMPLOYEE_ENQUEUE'
      EXPORTING number = lw_soldes-empleado_solicitud
      IMPORTING return = lws_struc1.

    lws_p0082-infty           = '0082'.
    lws_p0082-subty           = 'B001'.
    lws_p0082-pernr           = lw_soldes-empleado_solicitud.
    lws_p0082-endda           = lw_soldes-endda.
    lws_p0082-begda           = lw_soldes-begda.
    lws_p0082-uname           = sy-uname.
    lws_p0082-aedtm           = sy-datum.
    lws_p0082-zz_nsolicitud   = lw_soldes-soldes.
    lws_p0082-zz_cauto        = lw_soldes-autogenerado.
    lws_p0082-zz_cdmedico     = lw_soldes-cm_codigo.
    lws_p0082-idate           = lw_soldes-idate.
    lws_p0082-zz_ctenfermedad = lw_soldes-tenf_code.
    lws_p0082-zz_cclasif1     = lw_soldes-clasfi_code1.
    lws_p0082-zz_cespecif1    = lw_soldes-especi_code1.
    lws_p0082-zz_otros1       = lw_soldes-otros1.
    lws_p0082-zz_cclasif2     = lw_soldes-clasfi_code2.
    lws_p0082-zz_cespecif2    = lw_soldes-especi_code2.
    lws_p0082-zz_otros2       = lw_soldes-otros2.
    lws_p0082-zz_cclasif3     = lw_soldes-clasfi_code3.
    lws_p0082-zz_cespeci3     = lw_soldes-especi_code3.
    lws_p0082-zz_otros3       = lw_soldes-otros3.
    IF i_flag = ''.
      lws_p0082-zz_flag = 'S'.
    ELSE.
      lws_p0082-zz_flag = 'N'.
    ENDIF.

    " Creando infotipo 82
    CALL FUNCTION 'HR_PSBUFFER_INITIALIZE'.

    CALL FUNCTION 'HR_INFOTYPE_OPERATION'
*    CALL FUNCTION 'Z_HR_INFOTYPE_OPERATION'  DESTINATION 'NONE'
      EXPORTING  infty         = lws_p0082-infty
                 number        = lws_p0082-pernr
                 subtype       = lws_p0082-subty
                 validityend   = lws_p0082-endda
                 validitybegin = lws_p0082-begda
                 record        = lws_p0082
                 operation     = 'INS'
      IMPORTING  return        = lws_struc2
                 key           = lws_key
      EXCEPTIONS OTHERS        = 0.

    IF lws_struc2-type = 'E'.
      e_error = abap_true.
      IF lws_struc2-number = EmployeeBloqued.
        e_mensaje = 'El empleado/candidato aún está bloqueado'.
      ELSE.
        e_mensaje = lws_struc2-message.
      ENDIF.
    ELSE.
      CLEAR e_mensaje.
    ENDIF.

    " Desbloqueando Empleado
    CLEAR lws_struc1.
    CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
      EXPORTING number = lw_soldes-empleado_solicitud
      IMPORTING return = lws_struc1.
  ENDMETHOD.


  METHOD create_intotype82_test.
    DATA lw_soldes  TYPE zthr_soldesmedic.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lws_struc1 TYPE bapireturn1.
    DATA lws_struc2 TYPE bapireturn1.
    DATA lws_p0082  TYPE p0082.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lws_key    TYPE bapipakey.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA e_error    TYPE flag.

    SELECT * FROM zthr_soldesmedic
      INTO lw_soldes
      WHERE soldes = i_soldes.
    ENDSELECT.

    " Bloqueando Empleado
    CALL FUNCTION 'BAPI_EMPLOYEE_ENQUEUE'
      EXPORTING
        number = lw_soldes-empleado_solicitud
      IMPORTING
        return = lws_struc1.

    lws_p0082-infty           = '0082'.
    lws_p0082-subty           = 'B001'.
    lws_p0082-pernr           = lw_soldes-empleado_solicitud.
    lws_p0082-endda           = lw_soldes-endda.
    lws_p0082-begda           = lw_soldes-begda.
    lws_p0082-uname           = sy-uname.
    lws_p0082-aedtm           = sy-datum.
    lws_p0082-zz_nsolicitud   = lw_soldes-soldes.
    lws_p0082-zz_cauto        = lw_soldes-autogenerado.
    lws_p0082-zz_cdmedico     = lw_soldes-cm_codigo.
    lws_p0082-idate           = lw_soldes-idate.
    lws_p0082-zz_ctenfermedad = lw_soldes-tenf_code.
    lws_p0082-zz_cclasif1     = lw_soldes-clasfi_code1.
    lws_p0082-zz_cespecif1    = lw_soldes-especi_code1.
    lws_p0082-zz_otros1       = lw_soldes-otros1.
    lws_p0082-zz_cclasif2     = lw_soldes-clasfi_code2.
    lws_p0082-zz_cespecif2    = lw_soldes-especi_code2.
    lws_p0082-zz_otros2       = lw_soldes-otros2.
    lws_p0082-zz_cclasif3     = lw_soldes-clasfi_code3.
    lws_p0082-zz_cespeci3     = lw_soldes-especi_code3.
    lws_p0082-zz_otros3       = lw_soldes-otros3.
    lws_p0082-IDATE = lw_soldes-idate.
    IF i_flag = ''.
      lws_p0082-zz_flag = 'S'.
    ELSE.
      lws_p0082-zz_flag = 'N'.
    ENDIF.

    " Creando infotipo 82
*SUBMIT Z_HR_INFOTYPE_OPERATION_JOB WITH p_infty    EQ lws_p0082-infty
*    with p_pernr EQ lws_p0082-pernr
* with  p_subty EQ  lws_p0082-subty
*  with   p_endda EQ lws_p0082-endda
*  with   p_begda EQ lws_p0082-begda
*  with   p_opera EQ 'INS'
*  with   p_nocom EQ 'X'
*    EXPORTING LIST TO MEMORY AND RETURN.


*    CALL FUNCTION 'HR_PSBUFFER_INITIALIZE'.
*
*    CLEAR lws_struc1.
*    CALL FUNCTION 'BAPI_EMPLOYEE_ENQUEUE'
*      EXPORTING
*        number = lw_soldes-empleado_solicitud
*      IMPORTING
*        return = lws_struc1.
*
*    CALL FUNCTION 'Z_HR_INFOTYPE_OPERATION'                 DESTINATION 'NONE'
    CALL FUNCTION 'HR_INFOTYPE_OPERATION'
      EXPORTING
        infty         = lws_p0082-infty
        number        = lws_p0082-pernr
        subtype       = lws_p0082-subty
        validityend   = lws_p0082-endda
        validitybegin = lws_p0082-begda
        record        = lws_p0082
        operation     = 'INS'
        nocommit      = 'X'
      importing
        return        = lws_struc2
        key           = lws_key
      EXCEPTIONS
        OTHERS        = 0.

    IF lws_struc2-type = 'E'.
      e_error = abap_true.
      IF lws_struc2-number = employeebloqued.
        e_mensaje = 'El empleado/candidato aún está bloqueado'.
      ELSE.
        e_mensaje = lws_struc2-message.
      ENDIF.
    ELSE.
      CLEAR e_mensaje.
    ENDIF.

    " Desbloqueando Empleado
    CLEAR lws_struc1.
    CALL FUNCTION 'BAPI_EMPLOYEE_DEQUEUE'
      EXPORTING
        number = lw_soldes-empleado_solicitud
      IMPORTING
        return = lws_struc1.
  ENDMETHOD.


  METHOD get_message.
    CALL FUNCTION 'MESSAGE_TEXT_BUILD'
      EXPORTING msgid               = iw_syst-msgid
                msgnr               = iw_syst-msgno
                msgv1               = iw_syst-msgv1
                msgv2               = iw_syst-msgv2
                msgv3               = iw_syst-msgv3
                msgv4               = iw_syst-msgv4
      IMPORTING message_text_output = e_mensaje.
  ENDMETHOD.
ENDCLASS.
