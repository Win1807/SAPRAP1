@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Int Texto del dominio ZD_LETTER_REASON'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZI_READ_DOMAIN_REQUESTTYPE
  as select distinct from ZI_CUSTOMER_DOMAIN_VALUE_TEXT(
                            p_domain_name : 'ZD_REQUESTTYPE')

{
      @Semantics.language: true
  key Language,

      @ObjectModel.text.element: [ 'Text' ]
      @UI.textArrangement: #TEXT_ONLY
  key cast(ValueLow as ze_requesttype) as RequestType,

      @Semantics.text: true
      Text
}
