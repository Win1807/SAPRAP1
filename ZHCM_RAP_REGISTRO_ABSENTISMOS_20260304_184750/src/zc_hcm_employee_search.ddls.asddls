@EndUserText.label: 'Employee Search List'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_ABSENTEEISM'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION

define root custom entity ZC_HCM_EMPLOYEE_SEARCH

{
      @UI.dataFieldDefault: [ { label: 'Matricula' } ]
      @UI.lineItem: [ { position: 10 } ]
      @UI.selectionField: [ { position: 10 } ]
  key EmployeeNumber    : pd_objid_r;   -- Numero Empleado

      @UI.dataFieldDefault: [ { label: 'Apellido Empleado' } ]
      @UI.lineItem: [ { position: 20 } ]
      @UI.selectionField: [ { position: 20 } ]
      LastName        : char80; -- Apellido Empleado

      @UI.dataFieldDefault: [ { label: 'Nombre Empleado' } ]
      @UI.lineItem: [ { position: 30 } ]
      @UI.selectionField: [ { position: 30 } ]
      EmployeeName     : vorna;  -- Nombre Empleado

      @UI.dataFieldDefault: [ { label: 'Nombres y Apellidos' } ]
      @UI.lineItem: [ { position: 40 } ]
      EmployeeFullName      : char80;    -- Nombres y Apellidos
}
