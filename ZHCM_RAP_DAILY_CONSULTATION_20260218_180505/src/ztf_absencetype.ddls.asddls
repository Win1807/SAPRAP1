@EndUserText.label: 'Absence Type'
@ClientHandling.type: #CLIENT_DEPENDENT
@AccessControl.authorizationCheck: #NOT_REQUIRED
define table function ZTF_Absencetype
with parameters 
@Environment.systemField: #CLIENT
client: abap.clnt,
@Environment.systemField: #USER
UserPerson : syuname
returns {
  mandt : abap.clnt;
  /*  pernr : persno;
  usrid : syuname;
werks : werks_d;
  btrtl : btrtl;
  moabw : moabw;*/
  awart : awart;
  atext : abwtxt;
  
}
implemented by method ZCL_HCM_DAILY_CONSULTATION=>get_absence_type;
