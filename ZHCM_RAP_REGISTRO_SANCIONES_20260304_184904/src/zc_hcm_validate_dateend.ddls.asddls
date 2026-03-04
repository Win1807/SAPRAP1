@EndUserText.label: 'Validate Employee Date End'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_SANCTIONS_REGISTRY'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION
define custom entity ZC_HCM_VALIDATE_DATEEND

{
      @UI.dataFieldDefault: [ { label: 'Número de Empleado' } ]
      @UI.lineItem: [ { position: 10 } ]
      @UI.selectionField: [ { position: 10 } ]
  key EmployeeNumber  : pernr_d;

      @UI.dataFieldDefault: [ { label: 'Fecha Inicio' } ]
      @UI.lineItem: [ { position: 20 } ]
      @UI.selectionField: [ { position: 20 } ]
      begda : begda;

      @UI.dataFieldDefault: [ { label: 'Número Días' } ]
      @UI.lineItem: [ { position: 30 } ]
      @UI.selectionField: [ { position: 30 } ]
      NumberDays  : day_nr;

      @UI.dataFieldDefault: [ { label: 'Fecha Fin' } ]
      @UI.lineItem: [ { position: 40 } ]
      endda : endda;

      @UI.dataFieldDefault: [ { label: 'Mensaje' } ]
      @UI.lineItem: [ { position: 50 } ]
      message : char100;
}
