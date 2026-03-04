@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Pay Grade Levels'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_HCM_PayGradeLevels
  as select from t710
  association [0..1] to t710a as _T710A on  $projection.Molga = _T710A.molga
                                        and $projection.Sltyp = _T710A.sltyp
                                        and $projection.Slreg = _T710A.slreg
                                        and $projection.Slgrp = _T710A.slgrp
                                        and _T710A.endda >= $session.system_date and
                                            _T710A.begda <= $session.system_date
{
  key molga        as Molga,//99
  key sltyp        as Sltyp,//trfar
  key slreg        as Slreg,//trfgb
  key slgrp        as Slgrp,//trfgr
  key sllvl        as Sllvl,//trfst
  key endda        as EndDate,//
      begda        as BegDate,
      @Semantics.amount.currencyCode : 'Currency'
      slmin        as MinSalary,
      @Semantics.amount.currencyCode : 'Currency'
      slmax        as MaxSalary,
      @Semantics.amount.currencyCode : 'Currency'
      slref        as ReferenceSalary,
      @Semantics.amount.currencyCode : 'Currency'
      ( slmax - slmin ) as DiffMaxMin,
      _T710A.waers as Currency
    
} where molga = '99' and
    begda <= $session.system_date and
    endda >= $session.system_date
 