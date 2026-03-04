@EndUserText.label: 'Lista motivo de prestamo'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_LOAN_ADMIN'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root custom entity ZC_HCM_REASON_LOAN
{
  key EmployeeNumber : pernr_d;
  key LoanType : subty;
  LoanDesc     : sbttx;
}
