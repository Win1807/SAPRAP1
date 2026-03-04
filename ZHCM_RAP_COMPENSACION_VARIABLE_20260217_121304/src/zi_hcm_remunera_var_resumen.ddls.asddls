@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Resumen - Compensación Variable'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_HCM_REMUNERA_VAR_RESUMEN
  as select from ztpbcresumen
{
  key cast( 'RES' as ze_tabletype  ) as TableType,
  key zanorv                         as FiscYear,
  key zmesrv                         as MonthNumber,
  key pernr                          as EmployeeNumber,
  key zord01                         as DisplayOrder1,
  key zord02                         as DisplayOrder2,
  key zord03                         as DisplayOrder3,
      zcodre                         as ReportCode,
      zformt                         as DisplayFormat,
      zcol01                         as DisplayedColumn1,
      zcol02                         as DisplayedColumn2,
      zcol03                         as DisplayedColumn3,
      zcol04                         as DisplayedColumn4,
      zcol05                         as DisplayedColumn5,
      zcol06                         as DisplayedColumn6,
      zcol07                         as DisplayedColumn7,
      zcol08                         as DisplayedColumn8,
      zcol09                         as DisplayedColumn9,
      zcol10                         as DisplayedColumn10,
      zcol11                         as DisplayedColumn11,
      zcol12                         as DisplayedColumn12,
      zcol13                         as DisplayedColumn13,
      zcol14                         as DisplayedColumn14,
      zcol15                         as DisplayedColumn15,
      zcol16                         as DisplayedColumn16,
      zcol17                         as DisplayedColumn17,
      zcol18                         as DisplayedColumn18,
      zcol19                         as DisplayedColumn19,
      zcol20                         as DisplayedColumn20
}
