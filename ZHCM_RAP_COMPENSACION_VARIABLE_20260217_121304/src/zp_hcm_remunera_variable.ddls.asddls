@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Resumen y Detalle-Comp.Var.'
@Metadata.ignorePropagatedAnnotations: true
@VDM.private: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZP_HCM_REMUNERA_VARIABLE
  as select from ZI_HCM_REMUNERA_VAR_RESUMEN
{
  key TableType,
  key FiscYear,
  key MonthNumber,
  key EmployeeNumber,
  key DisplayOrder1,
  key DisplayOrder2,
  key DisplayOrder3,
      ReportCode,
      DisplayFormat,
      DisplayedColumn1,
      DisplayedColumn2,
      DisplayedColumn3,
      DisplayedColumn4,
      DisplayedColumn5,
      DisplayedColumn6,
      DisplayedColumn7,
      DisplayedColumn8,
      DisplayedColumn9,
      DisplayedColumn10,
      DisplayedColumn11,
      DisplayedColumn12,
      DisplayedColumn13,
      DisplayedColumn14,
      DisplayedColumn15,
      DisplayedColumn16,
      DisplayedColumn17,
      DisplayedColumn18,
      DisplayedColumn19,
      DisplayedColumn20,
      cast( '' as ze_colum ) as DisplayedColumn21,
      cast( '' as ze_colum ) as DisplayedColumn22,
      cast( '' as ze_colum ) as DisplayedColumn23,
      cast( '' as ze_colum ) as DisplayedColumn24,
      cast( '' as ze_colum ) as DisplayedColumn25,
      cast( '' as ze_colum ) as DisplayedColumn26,
      cast( '' as ze_colum ) as DisplayedColumn27,
      cast( '' as ze_colum ) as DisplayedColumn28,
      cast( '' as ze_colum ) as DisplayedColumn29,
      cast( '' as ze_colum ) as DisplayedColumn30


}
union select from ZI_HCM_REMUNERA_VAR_DETALLE
{
  key TableType,
  key FiscYear,
  key MonthNumber,
  key EmployeeNumber,
  key DisplayOrder1,
  key DisplayOrder2,
  key DisplayOrder3,
      ReportCode,
      DisplayFormat,
      DisplayedColumn1,
      DisplayedColumn2,
      DisplayedColumn3,
      DisplayedColumn4,
      DisplayedColumn5,
      DisplayedColumn6,
      DisplayedColumn7,
      DisplayedColumn8,
      DisplayedColumn9,
      DisplayedColumn10,
      DisplayedColumn11,
      DisplayedColumn12,
      DisplayedColumn13,
      DisplayedColumn14,
      DisplayedColumn15,
      DisplayedColumn16,
      DisplayedColumn17,
      DisplayedColumn18,
      DisplayedColumn19,
      DisplayedColumn20,
      DisplayedColumn21,
      DisplayedColumn22,
      DisplayedColumn23,
      DisplayedColumn24,
      DisplayedColumn25,
      DisplayedColumn26,
      DisplayedColumn27,
      DisplayedColumn28,
      DisplayedColumn29,
      DisplayedColumn30


}
