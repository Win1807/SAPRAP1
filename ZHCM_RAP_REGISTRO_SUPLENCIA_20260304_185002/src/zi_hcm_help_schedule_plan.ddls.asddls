@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Ayuda para regla de plan horario trabajo'

@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_HCM_HELP_SCHEDULE_PLAN
  as select from t508a as t5a

    inner join   t508s as t5s
      on  t5a.zeity = t5s.zeity
      and t5a.mofid = t5s.mofid
      and t5a.mosid = t5s.mosid
      and t5a.schkz = t5s.schkz

{
  key t5a.zeity as AgrupAreaPersonal,
  key t5a.mofid as HolidayCalendar,
  key t5a.mosid as AgrupSubdivitionsPer,
  key t5a.schkz as RuleSchedulePlan,
  key t5a.endda as EndDateValidate,

      t5a.zmodn as SchedulePlanPeriod,
      t5a.begda as StartDateValidate,
      t5s.rtext as SchedulePlanText
}where t5a.begda < $session.system_date and
       t5a.endda > $session.system_date
