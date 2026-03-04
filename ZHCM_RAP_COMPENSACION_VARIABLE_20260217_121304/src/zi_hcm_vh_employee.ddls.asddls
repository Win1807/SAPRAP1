@EndUserText.label: 'Interface Ayuda de búsqueda Empleados'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_VH_EMPLOYEE'
@Search.searchable: true

define custom entity ZI_HCM_VH_EMPLOYEE
{
      @Search.defaultSearchElement: true
      @UI.lineItem   : [{position: 10}]
  key EmployeeNumber : persno;

      @Search.defaultSearchElement: true
      @UI.lineItem   : [{position: 20}]
      FirstSurname   : pad_nachn;

      @Search.defaultSearchElement: true
      @UI.lineItem   : [{position: 30}]
      SecondSurname  : pad_nach2;

      @Search.defaultSearchElement: true
      @UI.lineItem   : [{position: 40}]
      FullName       : pad_vorna;
}
