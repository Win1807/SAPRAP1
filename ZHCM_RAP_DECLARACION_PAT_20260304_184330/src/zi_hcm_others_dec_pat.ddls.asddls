@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Declaration Patrimonial - Others'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZI_HCM_OTHERS_DEC_PAT
  as select from pa9306 as p06

    inner join   pa0105 as p105

      on p105.pernr = p06.pernr

    inner join   pa9308 as p08
      on
          p08.pernr = p06.pernr
      and p08.subty = p06.subty
      and p08.objps = p06.objps
      and p08.sprps = p06.sprps
      and p08.endda = p06.endda
      and p08.begda = p06.begda

  association to parent ZI_HCM_DECLARATION_PAT as _Declaration on $projection.OtherEmployeeNumber = _Declaration.EmployeeNumber

{
  key p06.pernr     as OtherEmployeeNumber,
  key p06.seqnr     as OtherSequentialNumber,

      p06.zconcept  as OtherConcept,
      cast(p06.zcomm_val as abap.dec(13,2)) as OtherMonthlyIncome,
      _Declaration
}

where p105.usrid  = $session.user
  and p08.subty   = ''
  and p08.objps   = ''
  and p08.sprps   = ''
  and p08.endda  >= $session.system_date
  and p08.begda  <= $session.system_date
  and p08.seqnr   = '000'
