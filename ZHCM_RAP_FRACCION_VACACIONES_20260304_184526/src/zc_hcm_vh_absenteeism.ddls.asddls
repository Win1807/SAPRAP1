@EndUserText.label: 'Value Help Absenteeism Class'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_FRAC_VAC'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@Search.searchable: true

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION
define custom entity ZC_HCM_VH_ABSENTEEISM

{
      @ObjectModel.text.element: [ 'AbsenteeismDescription' ]
      @Search.defaultSearchElement: true
  key AbsenteeismClass       : awart;

  key EmployeeNumber     : pernr_d;

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Semantics.text: true
      AbsenteeismDescription : atext;

      VacationStartDate : sydatum;
      VacationEndDate   : sydatum;
}
