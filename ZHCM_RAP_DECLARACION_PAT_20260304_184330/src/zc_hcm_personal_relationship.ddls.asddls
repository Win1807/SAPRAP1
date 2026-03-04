@EndUserText.label: 'Personal Relalionship'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_DECLARATION_PAT'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION
define root custom entity ZC_HCM_PERSONAL_RELATIONSHIP

{
  key UserName  : uname;
  key EmployeeNumber  : persno;

      @UI.dataFieldDefault: [ { label: 'Parentesco' } ]
      @UI.lineItem: [ { position: 10 } ]
      Relationship  : stext;

      @UI.dataFieldDefault: [ { label: 'Apellido Paterno' } ]
      @UI.lineItem: [ { position: 20 } ]
      FamilyPaternalName : pad_nachn;

      @UI.dataFieldDefault: [ { label: 'Apellido Materno' } ]
      @UI.lineItem: [ { position: 30 } ]
      FamilyMaternalName  : pad_nachn;

      @UI.dataFieldDefault: [ { label: 'Nombres' } ]
      @UI.lineItem: [ { position: 40 } ]
      FamilyNames  : pad_vorna;

      @UI.dataFieldDefault: [ { label: 'Tipo Documento de Identidad' } ]
      @UI.lineItem: [ { position: 50 } ]
      FamilyTypeDNI  : ictxt;

      @UI.dataFieldDefault: [ { label: 'Número Documento de Identidad' } ]
      @UI.lineItem: [ { position: 60 } ]

      FamilyNumberDNI  : icnum;
}
