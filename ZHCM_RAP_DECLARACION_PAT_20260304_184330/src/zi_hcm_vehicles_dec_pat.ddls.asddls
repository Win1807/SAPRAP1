@EndUserText.label: 'Declaration Patrimonial - Vehicles'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_HCM_VEHICLES_DEC_PAT
  as select from pa9304 as p04

    inner join   pa0105 as p105

      on p105.pernr = p04.pernr

    inner join   pa9308 as p08
      on
          p08.pernr = p04.pernr
      and p08.subty = p04.subty
      and p08.objps = p04.objps
      and p08.sprps = p04.sprps
      and p08.endda = p04.endda
      and p08.begda = p04.begda

  association to parent ZI_HCM_DECLARATION_PAT as _Declaration on $projection.VehicleEmployeeNumber = _Declaration.EmployeeNumber

{
  key p04.pernr                             as VehicleEmployeeNumber,
  key p04.seqnr                             as VehicleSequentialNumber,

      p04.zvehic                            as VehicleEmbarcation,
      p04.zvehic_numb                       as VehicleNumber,
      cast(p04.zcomm_val as abap.dec(13,2)) as VehicleApproximateValue,
      cast(p04.zmort_val as abap.dec(13,2)) as VehicleBalance,
      _Declaration
}

where p105.usrid  = $session.user
  and p08.subty   = ''
  and p08.objps   = ''
  and p08.sprps   = ''
  and p08.endda  >= $session.system_date
  and p08.begda  <= $session.system_date
  and p08.seqnr   = '000'
