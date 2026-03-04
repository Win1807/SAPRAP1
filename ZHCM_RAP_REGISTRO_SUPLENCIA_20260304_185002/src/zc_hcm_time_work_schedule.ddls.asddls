@EndUserText.label: 'Obtener datos Plan de Trabajo'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_SUBSTITUTION_RECORD'

define custom entity ZC_HCM_TIME_WORK_SCHEDULE
  with parameters
    EmployeeNumber : pernr_d,
    ValueDate      : datum

{
  key AgrupAreaPersonal : dzeity;

      HolidayCalendar       : hident;
      AgrupSubDivisions     : mosid;
      WorkSchedulePlanRule  : schkn;
      WorkScheduleText      : retext;
}
