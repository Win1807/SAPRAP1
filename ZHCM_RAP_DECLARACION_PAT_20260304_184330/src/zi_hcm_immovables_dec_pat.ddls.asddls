@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Declaration Patrimonial - Immovables'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZI_HCM_IMMOVABLES_DEC_PAT
  as select from pa9303 as p03

    inner join   pa0105 as p105

      on p105.pernr = p03.pernr

    inner join   pa9308 as p08
      on
          p08.pernr = p03.pernr
      and p08.subty = p03.subty
      and p08.objps = p03.objps
      and p08.sprps = p03.sprps
      and p08.endda = p03.endda
      and p08.begda = p03.begda

  association to parent ZI_HCM_DECLARATION_PAT as _Declaration on $projection.ImmovableEmployeeNumber = _Declaration.EmployeeNumber

{
  key p03.pernr                            as ImmovableEmployeeNumber,
  key p03.seqnr                            as ImmovableSequentialNumber,

      p03.zaddress                         as ImmovableAddress,
      p03.percent                          as ImmovablePercent,
      cast(p03.comm_val as abap.dec(13,2)) as ImmovableCommercialValue,
      cast(p03.mort_val as abap.dec(13,2)) as ImmovableTaxBalance,

      _Declaration
}

where p105.usrid  = $session.user
  and p08.subty   = ''
  and p08.objps   = ''
  and p08.sprps   = ''
  and p08.endda  >= $session.system_date
  and p08.begda  <= $session.system_date
  and p08.seqnr   = '000'
