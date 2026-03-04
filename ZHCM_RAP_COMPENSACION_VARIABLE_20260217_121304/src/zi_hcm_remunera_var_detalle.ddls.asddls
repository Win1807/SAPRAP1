@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Detalle - Compensación Variable'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_HCM_REMUNERA_VAR_DETALLE
  as select from ztpbcdetalle
{
  key cast( 'DET' as ze_tabletype ) as TableType,
  key zanorv                        as FiscYear,
  key zmesrv                        as MonthNumber,
  key pernr                         as EmployeeNumber,
  key zord01                        as DisplayOrder1,
  key zord02                        as DisplayOrder2,
  key zord03                        as DisplayOrder3,
      zcodre                        as ReportCode,
      zformt                        as DisplayFormat,
      zcol01                        as DisplayedColumn1,
      zcol02                        as DisplayedColumn2,
      zcol03                        as DisplayedColumn3,
      zcol04                        as DisplayedColumn4,
      zcol05                        as DisplayedColumn5,
      zcol06                        as DisplayedColumn6,
      zcol07                        as DisplayedColumn7,
      zcol08                        as DisplayedColumn8,
      zcol09                        as DisplayedColumn9,
      zcol10                        as DisplayedColumn10,
      zcol11                        as DisplayedColumn11,
      zcol12                        as DisplayedColumn12,
      zcol13                        as DisplayedColumn13,
      zcol14                        as DisplayedColumn14,
      zcol15                        as DisplayedColumn15,
      zcol16                        as DisplayedColumn16,
      zcol17                        as DisplayedColumn17,
      zcol18                        as DisplayedColumn18,
      zcol19                        as DisplayedColumn19,
      zcol20                        as DisplayedColumn20,
      zcol21                        as DisplayedColumn21,
      zcol22                        as DisplayedColumn22,
      zcol23                        as DisplayedColumn23,
      zcol24                        as DisplayedColumn24,
      zcol25                        as DisplayedColumn25,
      zcol26                        as DisplayedColumn26,
      zcol27                        as DisplayedColumn27,
      zcol28                        as DisplayedColumn28,
      zcol29                        as DisplayedColumn29,
      zcol30                        as DisplayedColumn30
}
