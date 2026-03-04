@EndUserText.label: 'Interface DATA_CERTIF_ITF'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_CERTIF_ITF'

@UI.headerInfo: { typeName: 'Certificado de ITF', typeNamePlural: 'Certificado de ITF' }
define root custom entity ZC_HCM_DATA_CERTIF_ITF

{
      @UI: {
      facet: [
      { label: 'Informacion ITF', id: 'ItfId', position: 10, type: #COLLECTION },
      { parentId: 'ItfId', type: #FIELDGROUP_REFERENCE, targetQualifier: 'ItfIdFG' }
      ],
      // fieldgroup used for grouping all fields with same qualifier to one group
      fieldGroup: [{ qualifier: 'ItfIdFG', position: 10, label: 'Ejercicio' }],
      // Identification used for detailed view
      identification: [{ position: 10, importance: #HIGH }]
      // lienitem used for position in the list view
      }
      @UI.lineItem        : [{position: 10, importance: #HIGH}]
      @UI.lineItem        : [{label: 'Ejercicio'}]
      @UI.selectionField  : [{ position: 10 }]
      @Consumption.filter.hidden: true
  key EMPLOYEEYEAR    : char4;

  key EMPLOYEENUMBER  : pernr_d;

      USERNAME      : syuname;
      STARTDATE       : char6;
      ENDDATE         : char6;

      @UI.dataFieldDefault: [ { label: 'Tipo de Documento' } ]
      @UI.fieldGroup: [ { qualifier: 'ItfIdFG', position: 20, label: 'Tipo de Documento' } ]
      @UI.lineItem: [ { position: 20, label: 'Tipo de Documento' } ]
      DOCUMENTTYPE    : char30;

      @UI.fieldGroup: [ { qualifier: 'ItfIdFG', position: 30, label: 'Número Documento' } ]
      @UI.lineItem: [ { position: 30 } ]
      DOCUMENTNUMBER  : psg_idnum;

      @UI.fieldGroup: [ { qualifier: 'ItfIdFG', position: 40, label: 'Nombre Empleado' } ]
      @UI.lineItem: [ { position: 40, label: 'Nombre' } ]
      EMPLOYEENAME    : char120;

      @Semantics.currencyCode: true
      @UI.fieldGroup: [ { qualifier: 'ItfIdFG', position: 50, label: 'Moneda' } ]
      @UI.lineItem: [ { position: 50, label: 'Moneda' } ]
      CURRENCY        : waers;

      @EndUserText.label: 'Total Impuesto'
      @UI.fieldGroup: [ { qualifier: 'ItfIdFG', position: 60, label: 'Total Impuesto' } ]
      @UI.lineItem: [ { position: 60 } ]
      TOTALIMPORT     : abap.dec(16,2);

      COMPANYNAME     : butxt;
      COMPANYERUC     : paval;
      DIRECTION       : char120;
      TAXRCREDIT      : abap.dec(16,2);
      TAXRCHARGES     : abap.dec(16,2);
      TAXRRESERVALS   : abap.dec(16,2);
      STARDATETEXT    : char50;
      ENDDATEXT       : char50;
}
