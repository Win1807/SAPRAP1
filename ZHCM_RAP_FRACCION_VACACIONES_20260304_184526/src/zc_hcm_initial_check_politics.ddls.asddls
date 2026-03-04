@EndUserText.label: 'Initial Check Politics'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_FRAC_VAC'
define root custom entity ZC_HCM_INITIAL_CHECK_POLITICS

{
      @UI.lineItem: [ { type: #FOR_ACTION, dataAction: 'approve', label: 'approve', position: 10 } ]
  key EmployeeNumber : pernr_d;

      VacationDate : abap.dats;


      PoliticsDetails : dms_string;
      MessageText : dms_string;
      MessageType : char1;
}
