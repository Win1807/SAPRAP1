@EndUserText.label: 'Inizialitation Data Request Medical'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_SOLIC_DESCANSO_MEDICO'
define custom entity ZC_HCM_INITIALIZATION
{
  key UserID            : sysid;
      EmployeeName      : emnam;
      EmployeeNumber    : pernr_d;
      UsrID9000         : sysid;
}
