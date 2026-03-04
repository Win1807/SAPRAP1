@EndUserText.label: 'Get Value for Asistencia Diaria'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_ABSENTEEISM'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION

define root custom entity ZC_HCM_ASISTENCIA_DIARIA

{
      @UI.dataFieldDefault: [ { label: 'Matricula' } ]
      @UI.lineItem: [ { position: 10 } ]
      @UI.selectionField: [ { position: 10 } ]
  key EmployeeNumber    : pd_objid_r;   -- Numero Empleado

      @UI.dataFieldDefault: [ { label: 'Código Compañia' } ]
      @UI.lineItem: [ { position: 20 } ]
      @UI.selectionField: [ { position: 10 } ]
      CompanyCode : bukrs; -- Código Compañia
}
