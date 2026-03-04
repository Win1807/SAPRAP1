@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Entity Base for Company value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_HCM_COMPANY_VH as select from t001
{

  key bukrs as Company,
      butxt as CompanyDenomination,
      ort01 as Population,
      waers as CurrencyKey
}
where spras = $session.system_language 
and
       xtemplt = ''
