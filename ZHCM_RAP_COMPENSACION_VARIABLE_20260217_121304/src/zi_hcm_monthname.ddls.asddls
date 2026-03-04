@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Get Month Name'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
@UI.presentationVariant: [{ sortOrder: [{ by: 'CalendarMonth', direction: #ASC }] }]
define view entity ZI_HCM_MONTHNAME
  as select from GRFN_IV_MonthName
{
      @Semantics.language: true
  key Language,
  
      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: [ 'MonthName' ]
  key CalendarMonth,
  
      @Semantics.text: true
      MonthName
}
where
  Language = $session.system_language
