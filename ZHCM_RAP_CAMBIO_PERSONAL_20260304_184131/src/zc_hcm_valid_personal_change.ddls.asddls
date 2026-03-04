@EndUserText.label: 'Valid Personal Change'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_PERSONAL_CHANGE'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION
define custom entity ZC_HCM_VALID_PERSONAL_CHANGE

{
      @UI.dataFieldDefault: [ { label: 'Número Empleado' } ]
      @UI.lineItem: [ { position: 10 } ]
      @UI.selectionField: [ { position: 10 } ]
  key EmployeeNumber : hrobjid; -- Número Empleado

      @UI.dataFieldDefault: [ { label: 'Estado del Mensaje' } ]
      @UI.lineItem: [ { position: 20 } ]
      Status  : char1;  -- Estado del Mensaje

      @UI.dataFieldDefault: [ { label: 'Mensaje' } ]
      @UI.lineItem: [ { position: 30 } ]
      Message : char120; -- Mensaje
}
