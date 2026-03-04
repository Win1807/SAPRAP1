@EndUserText.label: 'Employee Sanctions Record'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_SANCTIONS_REGISTRY'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION
define root custom entity ZC_HCM_SANCTIONS_RECORD

{
      @UI.dataFieldDefault: [ { label: 'Empleado' } ]
      @UI.lineItem: [ { position: 10 } ]
  key EmployeeNumber  : pernr_d;

      SanctionID : ze_num3;

      DateBegin  : begda;

      DateEnd  : endda;

      Company : bukrs;

      @UI.lineItem: [ { position: 20 } ]
      EmployeeLastName : nachn;

      @UI.lineItem: [ { position: 30 } ]
      EmployeeName : vorna;

      SanctionType  : awart;

      NumberDays  : day_nr;

      Reason  : ze_motsan;

      Username  : uname;
}
