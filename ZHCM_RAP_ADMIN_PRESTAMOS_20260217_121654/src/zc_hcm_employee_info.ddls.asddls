@EndUserText.label: 'Informacion del empleado'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_LOAN_ADMIN'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root custom entity ZC_HCM_EMPLOYEE_INFO
{
  key EmployeeNumber  : pernr_d;
  
  UserSystem  : smnam;
  
  IsBoss : boolean; 
  
  LastName        : char80; -- Apellido Empleado
  
  EmployeeName     : vorna;  -- Nombre Empleado
  
  EmployeeFullName      : char80;    -- Nombres y Apellidos
  
  Dni      : psg_idnum;    -- Dni
  
  Mail : comm_id_long; -- Email
  
}
