@EndUserText.label: 'Tree Unit Organization for Manager'
@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
define table function ZTF_HCM_ORG_CHART_EmployeeGI
with parameters 
@Environment.systemField: #CLIENT
client: abap.clnt,
@Environment.systemField: #USER
ManagerUser : syuname

returns {
  mandt: abap.clnt;
  UO_CHILD : orgeh;
  UO_FATHER: orgeh;
  Possition: plans;
  PersonalNumber: pernr_d;
  begda:begda;
  endda: endda;
  ename: emnam ;
  stell:stell;
  werks:persa;
  btrtl:btrtl;
  plans:plans;
  ansvh:ansvh;
  abkrs:abkrs;
  persg:persg;
  persk:persk;
  bukrs:bukrs;
  kostl:kostl;
  kokrs:kokrs;
  
  
}
implemented by method ZCL_HCM_ORGANIZATION_CHART=>get_employee;
