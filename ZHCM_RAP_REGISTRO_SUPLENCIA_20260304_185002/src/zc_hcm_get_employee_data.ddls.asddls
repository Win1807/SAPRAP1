@EndUserText.label: 'Datos de empleado'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_SUBSTITUTION_RECORD'
define custom entity ZC_HCM_GET_EMPLOYEE_DATA
  with parameters
    EmployeeNumber : persno

{
  key Name                : emnam;

      Sname                : smnam;
      CompanyCode          : bukrs;
      CompanyName          : butxt;
      PersonalArea         : persa;
      PersonalAreaText     : pbtxt;
      PersonalSubArea      : btrtl;
      PersonalSubAreaText  : btrtx;
      EmployeeGroup        : persg;
      EmployeeGrouNname    : pgtxt;
      EmployeeSubGroup     : persk;
      EmployeeSubGroupName : pktxt;
      AreaControlling      : kokrs;
      AreaControllingName  : bezei;
      BussinessArea        : gsber;
      BussinessAreaDesc    : gtext;
      PayrollArea          : abkrs;
      PayrollAreaText      : abktx;
      WorkContract         : ansvh;
      WorkContractText     : anstx;
      CostCenter           : kostl;
      Description          : kltxt;
      OrganizationalUnit   : orgeh;
      OrganizationalUnitShortText : orgtx;
      PositionPlans        : plans;
      PositionShortText    : plstx;
      Job                  : stell;
      JobTitle             : stltx;
      FunctionalArea       : fkber;
      FunctionalAreaName   : fkbtx;
      ObjectType           : otype;
      ObjectTypeText       : otext;
}
