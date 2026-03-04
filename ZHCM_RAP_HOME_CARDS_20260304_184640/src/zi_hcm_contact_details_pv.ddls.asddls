@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Projection Contact Details Employee'

@Metadata.allowExtensions: true

@ObjectModel.representativeKey: 'EmployeeNumber'
@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, sizeCategory: #L, serviceQuality: #C }

@Search.searchable: true

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION

define root view entity ZI_HCM_CONTACT_DETAILS_PV
  provider contract transactional_query
  as projection on ZI_HCM_CONTACT_DETAILS

{
          @Search.defaultSearchElement: true

  key     EmployeeNumber,  -- Numero del empleado

          FullName,  -- Nombre Completo
          EmployeeLastName,  -- Apellido Empleado
          EmployeeName,  -- Nombre Empleado
          PositionEmp,  -- Posición Empleado
          PositionName,  -- Nombre Posición
          Annex01,  -- Anexo 01
          Annex02,  -- Anexo 02
          PhoneEmployee,  --  Telefono Empleado
          EmployeeEmail,  -- Email Empleado
          OrganizationalUnit, --  Unidad Organizativa del Empleado
          OrgnizationalUnitName, -- Descripccion de Unidad Organizativa del Empleado

          @ObjectModel.virtualElement: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_HOME_CARDS'
          @UI.lineItem: [ { position: 20, label: 'Virtual Element' } ]
  virtual PhotoEmployee : abap.rawstring(0),  -- Foto del Empleado

          @ObjectModel.virtualElement: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_HOME_CARDS'
          @UI.lineItem: [ { position: 30, label: 'Virtual Element' } ]
  virtual BossName : emnam, -- Nombre del Jefe

          @ObjectModel.virtualElement: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_HOME_CARDS'
          @UI.lineItem: [ { position: 40, label: 'Virtual Element' } ]
  virtual BossMail : comm_id_long -- Correo del Jefe
}
