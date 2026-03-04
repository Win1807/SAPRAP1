CLASS zcl_hcm_general_information DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.
    CLASS-METHODS get_unig_org FOR TABLE FUNCTION ztf_hcm_unitorggi.
    CLASS-METHODS get_employee FOR TABLE FUNCTION ztf_hcm_employeegi.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_hcm_general_information IMPLEMENTATION.
  METHOD get_unig_org BY DATABASE FUNCTION FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY USING hrp1001 pa0001 pa0105.

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

           lt_manager_unit_org = SELECT mandt, orgeh as objid, '' as sobid
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

*    lt_uo_padre_position_person = select a.mandt, uo_child, uo_father, b.sobid as Possition, c.pernr as PersonalNumber  from :lt_uo_padre as a left join hrp1001 as b
*                                                                                    on
*                                                                                    a.mandt = b.mandt and
*                                                                                    a.uo_child = b.objid and
*                                                                                       B.otype = 'O' AND
*                                                                                       b.rsign = 'B' and
*                                                                                       b.relat = '003' and
*                                                                                       b.sclas = 'S' AND
*                                                                                       B.endda >= current_date and
*                                                                                        B.begda <= current_date
*                                                                        LEFT JOIN PA0001 AS C
*                                                                        ON b.mandt = c.mandt and
*                                                                            B.sobid = C.plans AND
*                                                                            C.endda >= current_date and
*                                                                            C.begda <= current_date  and
*                                                                             c.sprps = '';



        return  select mandt, uo_child, uo_father from :lt_uo_padre;
  endmethod.
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

           lt_manager_unit_org = SELECT mandt, orgeh as objid, '' as sobid
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

ENDCLASS.
