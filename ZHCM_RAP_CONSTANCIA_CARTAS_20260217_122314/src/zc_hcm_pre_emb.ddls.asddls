@EndUserText.label: 'Interf. Carta de Presentación a Embajada'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_PROOFLETTER'
define custom entity ZC_HCM_PRE_EMB
{
  key PDF : /moc/xstring;

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_HCM_EMBASSY', element: 'landx' },
                                            distinctValues: true } ]
      @EndUserText.label: 'País de Destino'
      EMBASSY : landx;

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_READ_DOMAIN_REASON', element: 'LetterReason' } } ]
      REASON : ze_motivo;

      COURSE : ze_curso;

      ORGANIZER : ze_instit;

      REASONOTHERS : ze_detall;

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_READ_DOMAIN_REQUESTTYPE', element: 'RequestType' } } ]
      REQUESTTYPE : ze_requesttype;

      SUBTY : subty;
      objps : objps;
}
