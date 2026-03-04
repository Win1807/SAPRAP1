@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interace Get Relationships'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help

-- drop down  menu for value help
define view entity ZI_HCM_RELATIONSHIPS
  as select from pa0105 as p05

    inner join   pa0021 as p21
      on  p05.pernr = p21.pernr
      and p05.usrty = '0001'
      and p05.endda = '99991231'

    inner join   t591s  as t1S
      on t1S.subty = p21.subty

{
  key p21.subty                                  as IdFamiliar,
  key p21.objps                                  as IdObjeto,

      concat_with_space(p21.favor, p21.fanam, 1) as fullname,
      t1S.stext                                  as Parentezco
}

where p05.usrid = $session.user
  and (p21.subty = '1' or p21.subty = '2')
  and p21.endda = '99991231'
  and t1S.infty = '0021'
  and t1S.sprsl = $session.system_language
