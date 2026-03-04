@EndUserText.label: 'Personal Search'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_PERSONAL_CHANGE'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION
define custom entity ZC_HCM_PERSONAL_SEARCH

{
      @UI.dataFieldDefault: [ { label: 'Matricula' } ]
      @UI.lineItem: [ { position: 10 } ]
      @UI.selectionField: [ { position: 30 } ]
  key EmployeeNumber    : pd_objid_r;   -- Numero Empleado

      @UI.dataFieldDefault: [ { label: 'Apellido Empleado' } ]
      @UI.selectionField: [ { position: 20 } ]
      LastName        : wfd_firstname; -- Apellido Empleado

      @UI.dataFieldDefault: [ { label: 'Nombre Empleado' } ]
      @UI.selectionField: [ { position: 30 } ]
      EmployeeName     : short_d;  -- Nombre Empleado

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_READ_DOMAIN_SEARCH_T', element: 'SearchType' } } ]
      @UI.dataFieldDefault: [ { label: 'Tipo Busqueda' } ]
      @UI.selectionField: [ { position: 40 } ]
      SearchType : ze_search_type; -- Tipo de Busqueda

      @UI.dataFieldDefault: [ { label: 'Nombres y Apellidos' } ]
      @UI.lineItem: [ { position: 20 } ]
      EmployeeFullName      : stext;    -- Nombres y Apellidos

      @UI.dataFieldDefault: [ { label: 'Fecha de Ingreso' } ]
      @UI.lineItem: [ { position: 30 } ]
      StartDate         : begdatum;   -- Fecha de Ingreso
}
