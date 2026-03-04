@EndUserText.label: 'Emisión de Fotocheck'

@Metadata.allowExtensions: true

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_PHOTOCHECK_REQ'
define root custom entity ZC_HCM_PHOTOCHECK_REQ

{
  key MessageText : natxt;
  key MessageID   : char1;

      @Consumption.filter: { multipleSelections: false, selectionType: #INTERVAL }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_HCM_VH_REASON_REQ', element: 'DesReason' },
                                            distinctValues: true } ]
      @UI.selectionField: [ { position: 10 } ]
      IdReason    : ze_id_motivo;

      @UI.selectionField: [ { position: 20 } ]
      CommentSol  : ze_comentario;
}
