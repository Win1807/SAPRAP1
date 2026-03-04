@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Read text from Domain'

define view entity ZI_CUSTOMER_DOMAIN_VALUE_T
  with parameters
    p_domain_name : sxco_ad_object_name
  as select from dd07t
{
  key dd07t.domname    as DomainName,
  key dd07t.valpos     as ValuePosition,
  key dd07t.ddlanguage as Language,
      dd07t.domvalue_l as ValueLow,
      dd07t.ddtext     as Text
}
where
      dd07t.as4local = 'A'
  and dd07t.domname  = $parameters.p_domain_name and ddlanguage = $session.system_language
  
