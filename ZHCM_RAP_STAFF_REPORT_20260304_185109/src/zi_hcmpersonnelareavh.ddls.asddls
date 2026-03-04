@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hcm Personnel Area Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel: { dataCategory: #VALUE_HELP,
                representativeKey: 'HCMPersonnelArea',
                usageType.sizeCategory: #S,
                usageType.dataClass:  #CUSTOMIZING,
                usageType.serviceQuality: #A }
@Search.searchable: true
define view entity ZI_HCMPersonnelAreaVH as
 select from I_HCMPersonnelArea
{

      @ObjectModel.text.element: [ 'HCMPersonnelAreaName']
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking:#HIGH
  key HCMPersonnelArea,
      @Semantics.text: true
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking:#LOW
      HCMPersonnelAreaName,
      CompanyCode,
      HCMCountryRegionGrouping
      
}
