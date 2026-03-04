@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HCM Personnel Subarea Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_HCMPersonnelSubareaVH
  as select from I_HCMPersonnelSubarea
{
      @UI.selectionField: [{ position: 10 }]
      @UI.lineItem: [{ position: 10 }]
  key HCMPersonnelArea,
      @ObjectModel.text.element: [ 'PersonnelSubareaName']
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking:#HIGH
      @UI.lineItem: [{ position: 20 }]
      @UI.selectionField: [{ position: 20 }]
  key HCMPersonnelSubarea,
      @Semantics.text: true
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking:#LOW
      @UI.lineItem: [{ position: 25 }]
      PersonnelSubareaName,
      @UI.lineItem: [{ position: 15 }]
      _HCMPersonnelArea.HCMPersonnelAreaName

}
