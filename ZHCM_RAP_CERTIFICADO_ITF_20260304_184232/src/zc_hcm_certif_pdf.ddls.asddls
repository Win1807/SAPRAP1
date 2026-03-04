@EndUserText.label: 'Obtencón de PDF de Certificado ITF'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_CERTIF_ITF'
define root custom entity ZC_HCM_CERTIF_PDF

{
  key pdf_data        : ze_pdftype;
  key EMPLOYEEYEAR    : char4;
  key EMPLOYEENUMBER  : pernr_d;

      USERNAME      : syuname;
      STARTDATE       : char6;
      ENDDATE         : char6;
      DOCUMENTTYPE    : char30;
      DOCUMENTNUMBER  : psg_idnum;
      EMPLOYEENAME    : char120;

      @Semantics.currencyCode: true
      CURRENCY        : waers;

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
