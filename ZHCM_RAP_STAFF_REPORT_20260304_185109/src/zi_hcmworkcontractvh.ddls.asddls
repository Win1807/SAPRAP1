@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HCM Work Contract Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel: { dataCategory: #VALUE_HELP,
                representativeKey: 'WorkContract',
                usageType.sizeCategory: #S,
                usageType.dataClass:  #CUSTOMIZING,
                usageType.serviceQuality: #A }
@Search.searchable: true
define view entity ZI_HCMWorkContractVH
  as select from t542t
{
    @UI.hidden: true
key molga as HMCLo,
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking:#HIGH
  key ansvh as WorkContract,
      @Semantics.text: true
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking:#LOW
      atx   as WorkContractName

}
where
  spras = $session.system_language
