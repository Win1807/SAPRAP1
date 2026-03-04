@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Group VH'
@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
@Consumption.ranked: true  

define view entity ZI_HCMEmployeeGroupVH as select from I_HCMEmployeeGroupText
{
//      @UI.textArrangement: #TEXT_LAST
@ObjectModel.text.element: [ 'HCMEmployeeGroupName' ]
@Search.defaultSearchElement: true
@Search.fuzzinessThreshold: 0.8
 key HCMEmployeeGroup,
  @Search.defaultSearchElement: true
  @Search.fuzzinessThreshold: 0.7
  @Semantics.text: true
 HCMEmployeeGroupName

} where Language = $session.system_language
