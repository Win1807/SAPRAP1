@EndUserText.label: 'Table Function - Cálculo de años'
@ClientHandling.type: #CLIENT_INDEPENDENT
define table function ZTF_HCM_GET_YEARS_RV
  with parameters
    Fecha : abap.dats

returns
{
  FiscYear : gjahr;
}
implemented by method
  ZCL_HCM_UTILITIES=>get_years;
