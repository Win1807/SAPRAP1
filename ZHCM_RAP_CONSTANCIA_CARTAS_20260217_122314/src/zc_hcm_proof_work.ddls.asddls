@EndUserText.label: 'Interface Constancia de Trabajo'

@Metadata.allowExtensions: true

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_PROOFLETTER'

define root custom entity ZC_HCM_PROOF_WORK

{
      @UI.lineItem: [ { label: 'Organización' } ]
      @UI.selectionField: [ { position: 10 } ]
  key emp      : char255;

  key username : syuname;
  key pdf      : /moc/xstring;

      @Consumption.hidden: true
      MessageText : natxt;

      @Consumption.hidden: true
      MessageID   : char1;
}
