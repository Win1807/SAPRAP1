@EndUserText.label: 'Interface Absenteeism Class'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_ABSENTEEISM'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION
define root custom entity ZI_HCM_VH_ABSENTEEISMCLASS

{
      @UI.dataFieldDefault: [ { label: 'Matricula' } ]
  key EmployeeNumber    : hr_pernr;   -- Numero Empleado

      @UI.dataFieldDefault: [ { label: 'Clase Absentismo' } ]
      @UI.lineItem: [ { position: 10 } ]
  key AbsenteeismClass : subty; -- Clase Absentismo

      @UI.dataFieldDefault: [ { label: 'Decripcción de Absentismo' } ]
      @UI.lineItem: [ { position: 20 } ]
      AbsenteeismClassTxt   : hrtypetext; -- Decripcción de Absentismo
}
