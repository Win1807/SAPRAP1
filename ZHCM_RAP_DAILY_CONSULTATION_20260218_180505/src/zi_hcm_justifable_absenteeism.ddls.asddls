@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Domain Value help for ZD_TYPE_PERIOD'
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
@Metadata.ignorePropagatedAnnotations: true
@UI.presentationVariant: [{ sortOrder: [{ by: 'JustifableAbs', direction: #ASC }] }]
define view entity ZI_HCM_justifable_absenteeism as select from ZI_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZD_DC_JUSTIFIABLE_ABSENTEEISM' )
{
     @Semantics.language: true
  key Language,

      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: [ 'Text' ]
  key cast( ValueLow as char03  ) as JustifableAbs,

      @Semantics.text: true
      Text
}
