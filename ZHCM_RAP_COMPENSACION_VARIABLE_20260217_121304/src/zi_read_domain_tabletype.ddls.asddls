@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Texto del dominio ZD_TABLETYPE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_READ_DOMAIN_TABLETYPE
  as select distinct from ZI_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZD_TABLETYPE' )
{
      @Semantics.language: true
  key Language,

      @UI.textArrangement: #TEXT_ONLY
      @ObjectModel.text.element: [ 'Text' ]
  key cast( ValueLow as ze_tabletype  ) as TableType,

      @Semantics.text: true
      Text
}
