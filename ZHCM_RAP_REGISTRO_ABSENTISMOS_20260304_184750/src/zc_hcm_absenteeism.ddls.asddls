@EndUserText.label: 'Employee absenteeism'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_ABSENTEEISM'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION

define root custom entity ZC_HCM_ABSENTEEISM

{
      @UI.dataFieldDefault: [ { label: 'Matricula' } ]
  key EmployeeNumber    : hr_pernr;   -- Numero Empleado

      @UI.dataFieldDefault: [ { label: 'Mandante del Sistema' } ]
  key LogicalSystem : hrdocsys; -- Mandante

      @UI.dataFieldDefault: [ { label: 'Número de Documento' } ]
  key DocumentNumber : hrdocnr; -- Nro Documento

      @UI.dataFieldDefault: [ { label: 'Clase de Absentismo' } ]
      @UI.lineItem: [ { position: 20 } ]
      AbsenteeismClass : subty; -- Clase Absentismo

      @UI.dataFieldDefault: [ { label: 'Nombres y Apellidos' } ]
      @UI.lineItem: [ { position: 10 } ]
      EmployeeFullName      : stext;    -- Nombres y Apellidos

      @UI.dataFieldDefault: [ { label: 'Descripcción Clase de Absentismo' } ]
      @UI.lineItem: [ { position: 30 } ]
      AbsenteeismClassTxt   : hrtypetext; -- Descripcción Absentismo

      @UI.dataFieldDefault: [ { label: 'Fecha de Inicio' } ]
      @UI.lineItem: [ { position: 40 } ]
      FromStart  : begda; -- Fecha de Inicio

      @UI.dataFieldDefault: [ { label: 'Fecha de Fin' } ]
      @UI.lineItem: [ { position: 50 } ]
      FromEnd  : endda; -- Fecha de Fin

      @UI.dataFieldDefault: [ { label: 'Hora de Inicio' } ]
      @UI.lineItem: [ { position: 60 } ]
      TimeStart  : hrstime; -- Hora Inicio

      @UI.dataFieldDefault: [ { label: 'Hora de Fin' } ]
      @UI.lineItem: [ { position: 70 } ]
      TimeEnd  : hretime; -- Hora de Fin

      @UI.dataFieldDefault: [ { label: 'Dias de Absentismo' } ]
      AbsenteeismDays : abwtg; -- Días Absentismo

      @UI.dataFieldDefault: [ { label: 'Hora de Absentismo' } ]
      AbsenteeismTime : abstd; -- Hora Absentismo
}
