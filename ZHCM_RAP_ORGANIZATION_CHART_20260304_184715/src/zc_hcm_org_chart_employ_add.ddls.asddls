@EndUserText.label: 'Employee data adicional'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_ORGANIZATION_CHART'

define custom entity ZC_HCM_ORG_CHART_EMPLOY_ADD

{

  key PersonalNumber : pernr_d;
      HCMyears       : abap.int1;
      HCMmounths     : abap.int1;
      HCMdays        : abap.int1;
      userId         : sysid;
      
}
