@EndUserText.label: 'Employee Search List'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_SANCTIONS_REGISTRY'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION
define root custom entity ZC_HCM_EMPLOYEE_SEARCH_SANC

{
      @UI.dataFieldDefault: [ { label: 'Número de Empleado' } ]
      @UI.lineItem: [ { position: 10 } ]
      @UI.selectionField: [ { position: 30 } ]
  key EmployeeNumber  : pernr_d;

      @UI.dataFieldDefault: [ { label: 'Apellido Empleado' } ]
      @UI.lineItem: [ { position: 20 } ]
      @UI.selectionField: [ { position: 10 } ]
      EmployeeLastName : char80;

      @UI.dataFieldDefault: [ { label: 'Nombre Empleado' } ]
      @UI.lineItem: [ { position: 30 } ]
      @UI.selectionField: [ { position: 20 } ]
      EmployeeName : vorna;

      @UI.dataFieldDefault: [ { label: 'Faltas' } ]
      @UI.lineItem: [ { position: 40 } ]
      Absences : abwtg;

      @UI.dataFieldDefault: [ { label: 'Tardanzas' } ]
      @UI.lineItem: [ { position: 50 } ]
      Tardiness : abstd;
}
