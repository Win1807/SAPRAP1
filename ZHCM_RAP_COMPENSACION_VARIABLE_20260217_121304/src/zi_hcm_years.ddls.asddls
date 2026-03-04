@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Years'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
-- drop down  menu for value help
@UI.presentationVariant: [{ sortOrder: [{ by: 'FiscYear', direction: #DESC }] }]
define view entity ZI_HCM_YEARS
  as select from ZTF_HCM_GET_YEARS_RV( Fecha: $session.system_date )
{
  key  FiscYear
}
