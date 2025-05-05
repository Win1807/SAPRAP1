@EndUserText.label: 'Table function for Employee Manager'
@ClientHandling.type: #CLIENT_DEPENDENT
define table function ZTF_HCM_EmployeeManager
with parameters EmployeeNumber : pernr_d,
@Environment.systemField: #CLIENT
client: abap.clnt
returns {
  mandt : abap.clnt;
  NumberManager : pernr_d;
  NameManager : smnam;
  MailManager : comm_id_long;
  UserIdManager: syuname;
  
}
implemented by method zcl_hcm_manager=>get_employee_Manager;
