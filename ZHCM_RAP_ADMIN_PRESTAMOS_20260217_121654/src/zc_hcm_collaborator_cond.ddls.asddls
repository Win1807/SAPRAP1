@EndUserText.label: 'Informacion del colaborador'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_LOAN_ADMIN'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root custom entity ZC_HCM_COLLABORATOR_COND
{
  key EmployeeNumber  : pernr_d;
  
  RelationLaboral      : ansvh;  -- Relacion laboral
  RelationLaboralDesc  : anstx;  -- Descripcion
  DateEndCont          : ctedt;  -- Fecha fin de contrato
  QuotaNumbersMax:  ze_numcuota; -- Numero maximo de cuotas
  
}
