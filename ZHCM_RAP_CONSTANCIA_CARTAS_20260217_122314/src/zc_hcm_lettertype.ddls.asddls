@EndUserText.label: 'Tipo de Carta por Empleado'

@Metadata.allowExtensions: true

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_PROOFLETTER'
define root custom entity ZC_HCM_LETTERTYPE

{
      @UI.lineItem: [ { label: 'Nombre Usuario' } ]
      @UI.selectionField: [ { position: 10 } ]
  key username : syuname;

      lettertype : ze_tipcar;
}
