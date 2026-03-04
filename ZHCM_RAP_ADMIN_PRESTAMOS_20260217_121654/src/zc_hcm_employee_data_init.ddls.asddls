@EndUserText.label: 'Data inicial para creación de prestamo'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_LOAN_ADMIN'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root custom entity ZC_HCM_EMPLOYEE_DATA_INIT
{
  key EmployeeNumber  : pernr_d;
  
  EmployeeDni : psg_idnum;
   
  Currency  : ktext;
  
  CurrencyKey : waers;
  
}
