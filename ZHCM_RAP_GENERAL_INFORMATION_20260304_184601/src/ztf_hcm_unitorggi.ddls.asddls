@EndUserText.label: 'Tree Unit Organization for Manager'
@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
define table function ZTF_HCM_UnitOrgGI
with parameters 
@Environment.systemField: #CLIENT
client: abap.clnt,
@Environment.systemField: #USER
ManagerUser : syuname

returns {
  mandt: abap.clnt;
  UO_CHILD : orgeh;
  UO_FATHER: orgeh;
//  Possition: plans;
//  PersonalNumber: pernr_d;
}
implemented by method ZCL_HCM_GENERAL_INFORMATION=>get_UNIG_ORG;
