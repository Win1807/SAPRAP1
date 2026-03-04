@EndUserText.label: 'Personal Information'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_DECLARATION_PAT'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION

define root custom entity ZC_HCM_PERSONAL_INFORMATION

{
  key UserName  : uname;
  
  key EmployeeNumber  : persno;

      @UI.dataFieldDefault: [ { label: 'DNI/Libreta Electoral:' } ]
      @UI.lineItem: [ { position: 20 } ]
      EmployeeDNI  : psg_idnum;

      @UI.dataFieldDefault: [ { label: 'Apellido Paterno:' } ]
      @UI.lineItem: [ { position: 30 } ]
      EmployeePatName  : pad_nachn;

      @UI.dataFieldDefault: [ { label: 'Apellido Materno:' } ]
      @UI.lineItem: [ { position: 40 } ]
      EmployeeMatName  : pad_nach2;

      @UI.dataFieldDefault: [ { label: 'Nombres:' } ]
      @UI.lineItem: [ { position: 50 } ]
      EmployeeName  : pad_vorna;

      @UI.dataFieldDefault: [ { label: 'Domicilio Actual:' } ]
      @UI.lineItem: [ { position: 60 } ]
      TaxAdress  : pad_stras;

      @UI.dataFieldDefault: [ { label: 'Domicilio Actual:' } ]
      @UI.lineItem: [ { position: 70 } ]
      District  : zednomb;

      @UI.dataFieldDefault: [ { label: 'Provincia:' } ]
      @UI.lineItem: [ { position: 80 } ]
      Province  : zednomb;

      @UI.dataFieldDefault: [ { label: 'Departamento:' } ]
      @UI.lineItem: [ { position: 90 } ]
      Department  : zednomb;

      @UI.dataFieldDefault: [ { label: 'Estado Civil:' } ]
      @UI.lineItem: [ { position: 100 } ]
      MartialStatus  : fatxt;

      @UI.dataFieldDefault: [ { label: 'Fecha de Nacimiento:' } ]
      @UI.lineItem: [ { position: 110 } ]
      Birthdate  : begda;

      @UI.dataFieldDefault: [ { label: 'Teléfono' } ]
      @UI.lineItem: [ { position: 120 } ]
      Phone  : telnr;
}
