@EndUserText.label: 'Sanction List'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_SANCTIONS_REGISTRY'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION
define custom entity ZC_HCM_SANCTIONS_LIST

{
      @UI.dataFieldDefault: [ { label: 'Id Sanciones' } ]
      @UI.lineItem: [ { position: 10 } ]
      @UI.selectionField: [ { position: 10 } ]
  key Sanctionid : ze_num3;

      @UI.dataFieldDefault: [ { label: 'Descripcción Sanciones' } ]
      @UI.lineItem: [ { position: 20 } ]
      SanctionText : ze_desc_motivo;

      @UI.dataFieldDefault: [ { label: 'Tipo de Sanciones' } ]
      @UI.lineItem: [ { position: 20 } ]
      SanctionType : awart;

      @UI.dataFieldDefault: [ { label: 'Fecha Inicio' } ]
      @UI.lineItem: [ { position: 20 } ]
      Begday : day_nr;

      @UI.dataFieldDefault: [ { label: 'Número de Días' } ]
      @UI.lineItem: [ { position: 20 } ]
      NumberDays : day_nr;
}
