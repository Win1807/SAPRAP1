@EndUserText.label: 'Obtener lista de empleados substitutos'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_SUBSTITUTION_RECORD'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define custom entity ZC_HCM_GET_PERSONAL_SUBSTITUTE
  with parameters
    EmployeeNumb : pernr_d,
    Society      : bukrs

{
      @UI.lineItem: [ { position: 10, label: 'Numero de personal', importance: #HIGH } ]
  key EmployeeNumber : pernr_d;

      @UI.lineItem: [ { position: 20, label: 'Nombre', importance: #HIGH } ]
      Name : pad_vorna;

      @UI.lineItem: [ { position: 30, label: 'Apellido paterno', importance: #HIGH } ]
      PaternalSurname : pad_nachn;

      @UI.lineItem: [ { position: 40, label: 'Apellido materno', importance: #HIGH } ]
      MaternalSurname : pad_nach2;
}
