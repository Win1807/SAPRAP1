@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Declaration Patrimonial - Debitos'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define view entity ZI_HCM_DEBITS_DEC_PAT
  as select from pa9307 as p07

    inner join   pa0105 as p105

      on p105.pernr = p07.pernr

    inner join   pa9308 as p08
      on
          p08.pernr = p07.pernr
      and p08.subty = p07.subty
      and p08.objps = p07.objps
      and p08.sprps = p07.sprps
      and p08.endda = p07.endda
      and p08.begda = p07.begda

  association to parent ZI_HCM_DECLARATION_PAT as _Declaration on $projection.DebitEmployeeNumber = _Declaration.EmployeeNumber

{
  key p07.pernr                             as DebitEmployeeNumber,
  key p07.seqnr                             as DebitSequentialNumber,

      p07.zbank_desc                        as DebitBankDescription,
      cast(p07.zcomm_val as abap.dec(13,2)) as DebitAmount,
      p07.zterm                             as DebitTerm,

      _Declaration
}

where p105.usrid  = $session.user
  and p08.subty   = ''
  and p08.objps   = ''
  and p08.sprps   = ''
  and p08.endda  >= $session.system_date
  and p08.begda  <= $session.system_date
  and p08.seqnr   = '000'
