@EndUserText.label: 'Calendar Employee'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_HOME_CARDS'

define custom entity ZC_HCM_CALENDAR

{
      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: false }
      @UI.selectionField: [ { position: 20 } ]
  key InputStartDate              : begda;

      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: false }
      @UI.selectionField: [ { position: 30 } ]
  key InputEndDate                : endda;

      @Semantics.businessDate.from: true
      @UI.lineItem: [ { position: 10 } ]
      OutputStartDate              : begda;

      @Semantics.businessDate.to: true
      @UI.lineItem: [ { position: 20 } ]
      OutpuEndDate                : endda;

      @UI.lineItem: [ { position: 30 } ]
      Type : abap.char(6);

      @UI.lineItem: [ { position: 40 } ]
      HolidayText : textl_d;

      @UI.lineItem: [ { position: 50 } ]
      HCMPersonnelNumber : pernr_d;
}
