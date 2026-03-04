@EndUserText.label: 'Request Fracction Vacation'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_FRAC_VAC'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION
define root custom entity ZC_HCM_VACATION_FRACTION

{
  key EmployeeNumber    : pernr_d;   -- Numero Empleado

      @UI.dataFieldDefault: [ { label: 'Clase de Absentismo' } ]
      @UI.lineItem: [ { position: 10 } ]

      AbsenteeismClass : subty; // awart

      @UI.dataFieldDefault: [ { label: 'Fecha Desde' } ]
      @UI.lineItem: [ { position: 20 } ]
      StartDate  : begda;

      @UI.dataFieldDefault: [ { label: 'Fecha Hasta' } ]
      @UI.lineItem: [ { position: 30 } ]
      EndDate  : endda;

      WorkingDays : abap.dec(3,2);

      @UI.dataFieldDefault: [ { label: 'Nombres y Apellidos' } ]
      @UI.lineItem: [ { position: 40 } ]
      AuthorizerName       : char40;    -- Nombres y Apellidos

      @UI.dataFieldDefault: [ { label: 'Nombres y Apellidos' } ]
      @UI.lineItem: [ { position: 50 } ]
      AuthorizerNote  : char256;
}
