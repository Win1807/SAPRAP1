@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Domain Value help for ZD_TYPE_PERIOD'
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
@Metadata.ignorePropagatedAnnotations: true
@UI.presentationVariant: [{ sortOrder: [{ by: 'PeriodType', direction: #ASC }] }]
define view entity ZI_HCM_DOMAIN_TYPE_PERIOD as select from ZI_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZD_TYPE_PERIOD' )
{
     @Semantics.language: true
  key Language,

      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: [ 'Text' ]
  key cast( ValueLow as ze_tabletype  ) as PeriodType,

      @Semantics.text: true
      Text
}
