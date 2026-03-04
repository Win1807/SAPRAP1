@EndUserText.label: 'Obtencion de data de Personal'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_BANDEJA_JEFATURA'

@Search.searchable: true
define custom entity ZC_HCM_GET_PERSONAL

{
      @Search.defaultSearchElement: true
  key EmployeeNumber   : persno;

      @Search.defaultSearchElement: true
      Name       : pad_vorna;

      @Search.defaultSearchElement: true
      LastName      : pad_nachn;
}
