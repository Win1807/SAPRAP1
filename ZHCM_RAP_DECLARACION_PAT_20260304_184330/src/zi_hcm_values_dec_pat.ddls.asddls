@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Declaration Patrimonial - Valores'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZI_HCM_VALUES_DEC_PAT
  as select from pa9305 as p05

    inner join   pa0105 as p105

      on p105.pernr = p05.pernr

    inner join   pa9308 as p08
      on
          p08.pernr = p05.pernr
      and p08.subty = p05.subty
      and p08.objps = p05.objps
      and p08.sprps = p05.sprps
      and p08.endda = p05.endda
      and p08.begda = p05.begda

  association to parent ZI_HCM_DECLARATION_PAT as _Declaration on $projection.ValueEmployeeNumber = _Declaration.EmployeeNumber

{
  key p05.pernr        as ValueEmployeeNumber,
  key p05.seqnr        as ValueSequentialNumber,

      p05.zdescription as ValueBankDescription,
      p05.zcomm_val2   as ValueTypeBank,

      _Declaration
}

where p105.usrid  = $session.user
  and p08.subty   = ''
  and p08.objps   = ''
  and p08.sprps   = ''
  and p08.endda  >= $session.system_date
  and p08.begda  <= $session.system_date
  and p08.seqnr   = '000'
