@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection Compensación variable'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_HCM_REMUNERA_VARIABLE
  as projection on ZI_HCM_REMUNERA_VARIABLE
{
      @ObjectModel.text.element: [ 'TableTypeText' ]
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_READ_DOMAIN_TABLETYPE', element: 'TableType'},
                                                     distinctValues: true }]
      @Consumption.filter:{ mandatory: true, multipleSelections: false, selectionType: #SINGLE, defaultValue:'DET'}
  key TableType,

      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCM_YEARS', element: 'FiscYear'},
                                                     distinctValues: true }]
      @Consumption.filter:{ mandatory: true, multipleSelections: false, selectionType: #SINGLE, defaultValue:'2024'}
  key FiscYear,

      @ObjectModel.text.element: [ 'MonthName' ]
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCM_MONTHNAME', element: 'CalendarMonth'},
                                                     distinctValues: true }]
      @Consumption.filter:{ mandatory: true, multipleSelections: false, selectionType: #SINGLE, defaultValue: '6'}
  key MonthNumber,

      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCM_VH_EMPLOYEE', element: 'EmployeeNumber'},
                                                     distinctValues: true }]
      @Consumption.filter:{ mandatory: true, multipleSelections: false, selectionType: #SINGLE}
  key EmployeeNumber,

  key DisplayOrder1,
  key DisplayOrder2,
  key DisplayOrder3,

      _TableType.Text      as TableTypeText,
      _MonthName.MonthName as MonthName,
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
      _Years
}
// where _MonthName.CalendarMonth = substring( $session.system_date, 5, 2 )
