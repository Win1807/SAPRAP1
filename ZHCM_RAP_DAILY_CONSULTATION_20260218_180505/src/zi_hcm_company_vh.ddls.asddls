@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Company value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_HCM_COMPANY_VH
  as select from ZR_HCM_COMPANY_VH

{
      @ObjectModel.text.element: ['CompanyDenomination']
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
  key Company,
      @Search.defaultSearchElement: true
      @Semantics.text: true
      @Search.fuzzinessThreshold: 0.7
      CompanyDenomination,
      Population,
      CurrencyKey
}
