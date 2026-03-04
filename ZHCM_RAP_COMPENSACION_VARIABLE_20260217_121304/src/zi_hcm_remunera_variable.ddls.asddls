@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Resumen y Detalle - Comp.Var.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_HCM_REMUNERA_VARIABLE
  as select from ZP_HCM_REMUNERA_VARIABLE
  association [0..1] to ZI_READ_DOMAIN_TABLETYPE as _TableType on $projection.TableType = _TableType.TableType
  association [0..1] to ZI_HCM_MONTHNAME         as _MonthName on $projection.MonthNumber = _MonthName.CalendarMonth
  association [0..1] to ZI_HCM_YEARS             as _Years     on $projection.FiscYear = _Years.FiscYear
  association [0..1] to ZI_HCM_VH_EMPLOYEE       as _Employee  on $projection.EmployeeNumber = _Employee.EmployeeNumber

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
      DisplayedColumn30,
      _TableType,
      _MonthName,
      _Years,
      _Employee

}
