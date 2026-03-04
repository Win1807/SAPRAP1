@EndUserText.label: 'Days Useful for Employee'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_ABSENTEEISM'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION
define root custom entity ZC_HCM_USEFUL_DAYS

{
      @UI.dataFieldDefault: [ { label: 'Matricula' } ]
  key EmployeeNumber    : hr_pernr;   -- Numero Empleado

      @UI.dataFieldDefault: [ { label: 'Clase de Absentismo' } ]
      @UI.lineItem: [ { position: 20 } ]
  key AbsenteeismClass : subty; -- Clas ede Absentismo

      @UI.dataFieldDefault: [ { label: 'Fecha Inicio' } ]
      @UI.lineItem: [ { position: 40 } ]
  key FromStart  : begda; -- Fecha Inicio

      @UI.dataFieldDefault: [ { label: 'Fecha Fin' } ]
      @UI.lineItem: [ { position: 50 } ]
      FromEnd  : endda; -- Fecha Fin

      @UI.dataFieldDefault: [ { label: 'Dias de Absentismo' } ]
      AbsenteeismDays : abwtg; -- Días Absentismo
}
