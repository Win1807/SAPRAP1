@EndUserText.label: 'Solicitud de Descanso Médico'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_SOLIC_DESCANSO_MEDICO'
define custom entity zi_hcm_subordinate_employees

{
  key EmployeeNumber    : pernr_d;   -- Numero Empleado

      @Search.defaultSearchElement: true
      @UI.dataFieldDefault: [ { label: 'Matricula' } ]
      @UI.lineItem: [ { position: 10 } ]
      @UI.selectionField: [ { position: 10 } ]
      UsrID9000         : sysid;   -- Usuario ID 9000

      @Search.defaultSearchElement: true
      @UI.dataFieldDefault: [ { label: 'Nombre Empleado' } ]
      @UI.selectionField: [ { position: 20 } ]
      FullNames        : wfd_firstname; -- Nombres

      @Search.defaultSearchElement: true
      @UI.dataFieldDefault: [ { label: 'Tipo de Documento' } ]
//      @UI.lineItem: [ { position: 10 } ]
      @UI.selectionField: [ { position: 30 } ]
      FullSurnames     : wfd_lastname;  -- Apellidos

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_READ_DOMAIN_SEARCH_T', element: 'SearchType' } } ]
      @UI.dataFieldDefault: [ { label: 'Tipo Busqueda' } ]
      @UI.selectionField: [ { position: 40 } ]
      SearchType : ze_search_type ;

      @UI.dataFieldDefault: [ { label: 'Nombres y Apellidos' } ]
      @UI.lineItem: [ { position: 20 } ]
      EmployeeName      : emnam;    -- Nombres y Apellidos

      @UI.dataFieldDefault: [ { label: 'Fecha de Ingreso' } ]
      @UI.lineItem: [ { position: 30 } ]
      AdmissionDate    : roverezdat;    -- Fecha de Ingreso

      UserID         : sysid;   -- Usuario ID
}
