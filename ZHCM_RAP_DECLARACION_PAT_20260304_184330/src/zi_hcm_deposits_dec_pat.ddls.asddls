@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Declaration Patrimonial - Deposits'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZI_HCM_DEPOSITS_DEC_PAT
  as select from pa9301 as p01

    inner join   pa0105 as p105

      on p105.pernr = p01.pernr

    inner join   pa9308 as p08
      on
          p08.pernr = p01.pernr
      and p08.subty = p01.subty
      and p08.objps = p01.objps
      and p08.sprps = p01.sprps
      and p08.endda = p01.endda
      and p08.begda = p01.begda

  association to parent ZI_HCM_DECLARATION_PAT as _Declaration on $projection.DepositEmployeeNumber = _Declaration.EmployeeNumber

{
  key p01.pernr       as DepositEmployeeNumber,
  key p01.seqnr       as DepositSequentialNumber,

      p01.zbank_desc  as DepositBankDescription,
      p01.zsaknr_type as DepositTypeBank,

      _Declaration
}

where p105.usrid  = $session.user
  and p08.subty   = ''
  and p08.objps   = ''
  and p08.sprps   = ''
  and p08.endda  >= $session.system_date
  and p08.begda  <= $session.system_date
  and p08.seqnr   = '000'
