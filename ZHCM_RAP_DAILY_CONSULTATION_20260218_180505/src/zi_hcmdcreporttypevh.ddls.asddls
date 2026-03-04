@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'DC Report type VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_HCMDCReportTypeVH as select from ZI_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZD_DC_TREPORT' )
{
     @Semantics.language: true
  key Language,

      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: [ 'Text' ]
  key cast( ValueLow as ze_dc_treport  ) as DCReportType,

      @Semantics.text: true
      Text
}
