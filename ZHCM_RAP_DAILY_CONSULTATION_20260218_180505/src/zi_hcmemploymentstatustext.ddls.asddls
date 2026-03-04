@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employment Status Text'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_HCMEmploymentStatusText as select from I_HCMEmploymentStatusText
{ @Semantics.language: true
 key Language,
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: [ 'HCMEmploymentStatusText' ]
 key HCMEmploymentStatus,
 @Semantics.text: true
 HCMEmploymentStatusText
 /* Associations */

    
} 
where 
    HCMEmploymentStatusType = '2'
     and
Language = $session.system_language
