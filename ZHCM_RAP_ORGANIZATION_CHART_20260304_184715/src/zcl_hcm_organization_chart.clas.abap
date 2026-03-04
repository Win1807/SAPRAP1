CLASS zcl_hcm_organization_chart DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_amdp_marker_hdb .

    CLASS-METHODS get_unig_org
        FOR TABLE FUNCTION ztf_hcm_org_chart_unitorggi .
    CLASS-METHODS get_employee
        FOR TABLE FUNCTION ztf_hcm_org_chart_employeegi .

    INTERFACES if_rap_query_provider .

    TYPES:
      hcm_org_chart_employ_add TYPE STANDARD TABLE OF zc_hcm_org_chart_employ_add.

    METHODS get_employee_add
      IMPORTING
        !employee_number     TYPE pernr_d
      EXPORTING
        !employee_add_result TYPE hcm_org_chart_employ_add.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_hcm_organization_chart IMPLEMENTATION.

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

        DATA(parameters) = io_request->get_parameters( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(sort_order)    = io_request->get_sort_elements( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(search_string) = io_request->get_search_expression( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(param) = io_request->get_parameters( ).
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(filter) = io_request->get_filter( ).

        " paging
        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(skip_rows_number) = io_request->get_paging( )->get_offset( ).

        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(filter_object) = io_request->get_filter( )->get_as_ranges( ).

        CASE io_request->get_entity_id( ).

          WHEN 'ZC_HCM_ORG_CHART_EMPLOY_ADD'.

            DATA employee_adds           TYPE hcm_org_chart_employ_add.
            DATA interface_employee_adds TYPE hcm_org_chart_employ_add.

            DATA(filter_personal_advanced) = io_request->get_filter( )->get_as_ranges( ).

            DATA filter_employeenumber    TYPE pernr_d.



            IF filter_personal_advanced IS NOT INITIAL.

              LOOP AT filter_personal_advanced INTO DATA(filter_personal_u).

                CASE filter_personal_u-name.
                  WHEN 'PERSONALNUMBER'.
                    DATA(filter_employeenumber_range) = filter_personal_u-range.
                ENDCASE.

              ENDLOOP.

              IF filter_employeenumber_range IS NOT INITIAL.
                filter_employeenumber = filter_employeenumber_range[ 1 ]-low.
              ENDIF.

            ENDIF.

            " --- Request data
            IF io_request->is_data_requested( ).

              get_employee_add(   EXPORTING employee_number = filter_employeenumber
                                   IMPORTING employee_add_result = employee_adds ).

              " Fill response
              DATA interface_employee_add LIKE LINE OF interface_employee_adds.

              IF page_size > 0.
                LOOP AT employee_adds INTO DATA(employee_add) FROM offset + 1 TO ( offset + page_size ).

                  MOVE-CORRESPONDING employee_add  TO interface_employee_add.

                  APPEND interface_employee_add TO interface_employee_adds.
                ENDLOOP.
              ELSE.
                LOOP AT employee_adds INTO employee_add.

                  MOVE-CORRESPONDING employee_add  TO interface_employee_add.

                  APPEND interface_employee_add TO interface_employee_adds.

                ENDLOOP.
              ENDIF.

              io_response->set_data( interface_employee_adds ).

              IF io_request->is_total_numb_of_rec_requested( ).
                io_response->set_total_number_of_records( lines( employee_adds ) ).
              ENDIF.

            ENDIF.

        ENDCASE.

      CATCH cx_rap_query_provider.

    ENDTRY.
  ENDMETHOD.

  METHOD get_employee BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING hrp1001 pa0001 pa0105.

    declare lv_user  "$ABAP.type( syuname )";
    declare lv_exits char( 1 ) default '0';
    declare lv_row_count int;
    declare lv_row_count_manager int;
       if manageruser = '' then lv_user = current_user;
       else
       lv_user = manageruser;
       end if;

        lt_p0105 = select a.mandt,  a.pernr, a.usrid, b.orgeh
                    from pa0105 as a inner join pa0001 as b on
                                    a.mandt = b.mandt and
                                    a.pernr = b.pernr and
                                    b.sprps = '' and
                                    b.endda >= current_date and
                                    b.begda <= current_date
                    where
                     a.sprps = '' and
                     a.endda >= current_date and
                    a.begda <= current_date and
                    a.subty = '0001' and
*                    a.subty = '9000' and
                    a.usrid = :lv_user and
                    a.mandt = :client ;

        lt_manager_unit_org = SELECT mandt, objid, sobid
                                    from hrp1001
                                     where  otype = 'O' and
                                            rsign = 'B' and
                                            relat = '002' and
                                            sclas = 'O' and
                                            endda >= current_date and
                                            begda <= current_date;

*        lt_manager_unit_org = SELECT a.mandt, objid, sobid
*                                    from hrp1001 as a inner join :lt_p0105 as b
*                                                    on
*                                                    a.mandt = b.mandt and
*                                                    a.objid = b.orgeh
*                                     where  a.otype = 'O' and
*                                            a.rsign = 'B' and
*                                            a.relat = '002' and
*                                            a.sclas = 'O' and
*                                            a.endda >= current_date and
*                                            a.begda <= current_date;

        select count( * ) into lv_row_count_manager from :lt_manager_unit_org;

        if lv_row_count_manager = 0 then

           lt_manager_unit_org = select mandt, orgeh as objid, '' as sobid
                                    from :lt_p0105 ;

        end if;



lt_tmp = select * from :lt_manager_unit_org;
     while :lv_exits = '0' do
                lt_tmp = select a.mandt, a.objid, a.sobid
                                    from hrp1001 as a inner join :lt_tmp as b
                                                    on
                                                      a.mandt = b.mandt and
                                                      a.objid = b.sobid
                                     where a.otype = 'O' and
                                            rsign = 'B' and
                                            relat = '002' and
                                            sclas = 'O' and
                                            a.endda >= current_date and
                                            a.begda <= current_date;

*                    select count( * ) into lv_row_count from :lt_tmp;
                 if ::rowcount = 0 then break;

                 else
                      lt_manager_unit_org = select * from :lt_manager_unit_org
                                            union
                                            select * from :lt_tmp;
*                        lt_tmp = select '' as mandt, '' as objid, '' as sobid from dummy;
*
*                        lt_tmp = select * from :lt_tmp1;
*
*                        lt_tmp1 = select '' as mandt, '' as objid, '' as sobid from dummy;


                end if;

     end while ;

     lt_unidad_org = select mandt, objid from :lt_manager_unit_org
                    union
                    select mandt, sobid as objid from :lt_manager_unit_org;
     lt_uo_padre = select a.mandt, a.objid as uo_child, b.objid as uo_father
                    from :lt_unidad_org as a left join :lt_manager_unit_org as b
                              on a.objid = b.sobid;

    lt_uo_padre_position_person = select a.mandt, uo_child, uo_father, b.sobid as possition,
                    c.pernr as personalnumber,c.begda, c.endda, c.ename, c.stell, c.werks, c.btrtl, c.plans, c.ansvh,
                    c.abkrs, c.persg, c.persk, c.bukrs, c.kostl, c.kokrs

      from :lt_uo_padre as a inner join hrp1001 as b
                                on
                                a.mandt = b.mandt and
                                a.uo_child = b.objid and
                                   b.otype = 'O' AND
                                   b.rsign = 'B' and
                                   b.relat = '003' and
                                   b.sclas = 'S' AND
                                   b.endda >= current_date and
                                    b.begda <= current_date
                                    inner join pa0001 as c
                                    on b.mandt = c.mandt and
                                        b.sobid = c.plans and
                                        c.endda >= current_date and
                                        C.begda <= current_date  and
                                         c.sprps = '' ;



        RETURN  select mandt, uo_child, uo_father, possition, personalnumber,
        begda,endda,ename, stell, werks, btrtl, plans, ansvh,
                   abkrs, persg, persk, bukrs, kostl, kokrs
        from :lt_uo_padre_position_person;
  ENDMETHOD.


  METHOD get_unig_org BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING hrp1001 pa0001 pa0105.

    declare lv_user  "$ABAP.type( syuname )";
    declare lv_exits char( 1 ) default '0';
    declare lv_row_count int;
    declare lv_row_count_manager int;
    declare lv_count_padre_nivel int;
    declare lv_count_iteracion int;
    declare lv_hrp1001 char( 10 );

       if manageruser = '' then lv_user = current_user;
       else
       lv_user = manageruser;
       end if;

       if orgeh = '00000000' then

         lt_p0105 = select a.mandt,  a.pernr, a.usrid, b.orgeh
                    from pa0105 as a inner join pa0001 as b on
                                    a.mandt = b.mandt and
                                    a.pernr = b.pernr and
                                    b.sprps = '' and
                                    b.endda >= current_date and
                                    b.begda <= current_date
                    where
                     a.sprps = '' and
                     a.endda >= current_date and
                    a.begda <= current_date and
                    a.subty = '0001' and
*                    a.subty = '9000' and
                    a.usrid = :lv_user and
                    a.mandt = :client ;

       else -- subir nivel

           select count(*) into lv_row_count from hrp1001
                    where
                     otype = 'O' and
                     endda >= current_date and
                     begda <= current_date and
                     rsign = 'A' and
                     relat = '002' and
                     mandt = :client and
                     objid = orgeh;

           if :lv_row_count > 0 then

                select sobid into lv_hrp1001
                    from hrp1001
                    where
                     otype = 'O' and
                     endda >= current_date and
                     begda <= current_date and
                     rsign = 'A' and
                     relat = '002' and
                     mandt = :client and
                     objid = orgeh
                     limit 1;
            else

                select sobid into lv_hrp1001
                    from hrp1001
                    where
                     otype = 'O' and
                     endda >= current_date and
                     begda <= current_date and
                     rsign = 'A' and
                     relat = '002' and
                     mandt = :client and
                     sobid = orgeh
                     limit 1;


            end if;


           lt_p0105 = select a.mandt,  a.pernr, a.usrid, b.orgeh
                    from pa0105 as a inner join pa0001 as b on
                                    a.mandt = b.mandt and
                                    a.pernr = b.pernr and
                                    b.sprps = '' and
                                    b.endda >= current_date and
                                    b.begda <= current_date
                    where
                     a.sprps = '' and
                     a.endda >= current_date and
                    a.begda <= current_date and
                    a.subty = '0001' and
*                    a.subty = '9000' and
                    b.orgeh = :lv_hrp1001 and
                    a.mandt = :client ;


       end if;

                 lt_manager_unit_org = SELECT a.mandt, objid, sobid
                                    from hrp1001 as a inner join :lt_p0105 as b
                                                    on
                                                    a.mandt = b.mandt and
                                                    a.objid = b.orgeh
                                     where  a.otype = 'O' and
                                            a.rsign = 'B' and
                                            a.relat = '002' and
                                            a.sclas = 'O' and
                                            a.endda >= current_date and
                                            a.begda <= current_date;

        select count( * ) into lv_row_count_manager from :lt_manager_unit_org;

        if lv_row_count_manager = 0 then

           lt_manager_unit_org = select mandt, orgeh as objid, '' as sobid
                                    from :lt_p0105 ;

        end if;

        lt_tmp = select * from :lt_manager_unit_org;
     while :lv_exits = '0' do
                lt_tmp = select a.mandt, a.objid, a.sobid
                                    from hrp1001 as a inner join :lt_tmp as b
                                                    on
                                                      a.mandt = b.mandt and
                                                      a.objid = b.sobid
                                     where a.otype = 'O' and
                                            rsign = 'B' and
                                            relat = '002' and
                                            sclas = 'O' and
                                            a.endda >= current_date and
                                            a.begda <= current_date;

*                    select count( * ) into lv_row_count from :lt_tmp;
                 if ::rowcount = 0 then break;

                 else
                      lt_manager_unit_org = select * from :lt_manager_unit_org
                                            union
                                            select * from :lt_tmp;
*                        lt_tmp = select '' as mandt, '' as objid, '' as sobid from dummy;
*
*                        lt_tmp = select * from :lt_tmp1;
*
*                        lt_tmp1 = select '' as mandt, '' as objid, '' as sobid from dummy;


                end if;

     end while ;

     if lv_row_count_manager = 0 then
        lt_unidad_org = select mandt, objid from :lt_manager_unit_org;

     else
        lt_unidad_org = select mandt, objid from :lt_manager_unit_org
                    union
                    select mandt, sobid as objid from :lt_manager_unit_org;
     end if ;

     lt_uo_padre = select a.mandt, a.objid as uo_child, b.objid as uo_father
                        from :lt_unidad_org as a left join :lt_manager_unit_org as b
                                                    on a.objid = b.sobid;


     lt_uo_padre_position_person_acumulado = select a.mandt, a.uo_child, a.uo_father, b.sobid as possition, c.pernr as personalnumber  from :lt_uo_padre as a left join hrp1001 as b
                                                                                    on
                                                                                    a.mandt = b.mandt and
                                                                                    a.uo_child = b.objid and
                                                                                       b.otype = 'O' AND
                                                                                       b.rsign = 'B' and
                                                                                       b.relat = '003' and
                                                                                       b.sclas = 'S' AND
                                                                                       b.endda >= current_date and
                                                                                        b.begda <= current_date
                                                                        left join pa0001 as c
                                                                        on b.mandt = c.mandt and
                                                                            b.sobid = c.plans and
                                                                            c.endda >= current_date and
                                                                            c.begda <= current_date  and
                                                                             c.sprps = ''
                                                                        WHERE c.pernr <> '';


        lt_uo_position_person = select
                    ''  as mandt,
                    ''  as uo_child,
                    ''  as uo_father,
                    ''  as possition,
                    ''  as personalnumber
                        from dummy
                where 1 = 0;

        lt_joined = select
                                n.mandt,
                                n.uo_child,
                                n.uo_father,
                                p.possition,
                                p.personalnumber
                            from :lt_uo_padre as n
                            left join :lt_uo_position_person as p
                                    on p.mandt   = n.mandt
                                    and p.uo_child = n.uo_child;

        -- acumulaciones
        lt_uo_padre_position_person_acumulado = select * from :lt_uo_padre_position_person_acumulado
                                        union
                                        select * from :lt_joined;


        return select mandt, uo_child, uo_father, possition , personalnumber from :lt_uo_padre_position_person_acumulado;
  endmethod.

  METHOD get_employee_add.

    DATA: hcm_employee_add LIKE LINE OF employee_add_result.

    hcm_employee_add-personalnumber = employee_number.

    SELECT pernr, endda, begda FROM pa0001 INTO TABLE @DATA(dates_employee)
                                           WHERE pernr = @employee_number.

    "Ordenar fechas
    SORT dates_employee BY endda ASCENDING.

    IF dates_employee IS NOT INITIAL.

      READ TABLE dates_employee INTO DATA(date_employee) INDEX 1.

      DATA: beg_da_in TYPE d.
      DATA: end_da_in TYPE d.

      DATA: no_day_out    TYPE i,
            no_mounth_out TYPE i,
            no_year_out   TYPE i.

      beg_da_in = date_employee-begda.
      end_da_in = sy-datum.

      CALL FUNCTION 'HR_SGPBS_YRS_MTHS_DAYS'
        EXPORTING
          beg_da   = beg_da_in
          end_da   = end_da_in
        IMPORTING
          no_day   = no_day_out
          no_month = no_mounth_out
          no_year  = no_year_out.

      hcm_employee_add-hcmdays      = no_day_out.
      hcm_employee_add-hcmmounths   = no_mounth_out.
      hcm_employee_add-hcmyears     = no_year_out.

    ENDIF.

    "userID
    SELECT SINGLE usrid FROM pa0105 INTO @hcm_employee_add-userid
                                    WHERE pernr = @employee_number AND
                                          subty = '0001' AND
                                          endda = '99991231'.


    APPEND hcm_employee_add TO employee_add_result.


  ENDMETHOD.

ENDCLASS.
