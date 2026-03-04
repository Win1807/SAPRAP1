@EndUserText.label: 'Registro de suplencia'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_SUBSTITUTION_RECORD'

define root custom entity ZC_HCM_REGISTER_SUBS

{
  key SolEmployeeNumber           : p_pernr; // Numero de Personal Solicitud

      EmployeeNumber              : p_pernr; // Pernr - Numero de empleado
      StartDate                   : begda;   // Begda - Fecha de Inicio Validez
      EndDate                     : endda;   // Endda - Fecha Fin Validez
      SubstituteClass             : vtart;   // Vtart - Clase de suplencia
      WorkPlanRule                : schkn;   // Schkn - Regla para plan horario de trabajo
      HolidaysCalendar            : hident;  // Mofid - Calendario de dias festivos
      GroupPersonSchedulePlan     : dzeity;  // Zeity - Agrupacion area personal p.planes horario trabajo
      GroupSubdivisionPers        : mosid;   // Mosid - Agrupacion de subdivisiones personal p.planes horario trabajo
      EmployeeNumberSupplant      : vpern;   // Vpern - Numero de empleado a suplantar
      PositionPlans               : plans;   // Plans - Posicion
      StartTime                   : beguz;   // Altpb - Hora de inicio
      EndTime                     : enduz;   // Altpe - Hora fin
      IndicateDayAnt              : vtken;   // Altpv - Indicador de dia anterior
      Division                    : gsber;   // Gsber - Division
      CostCenter                  : kostl;   // Kostl - Centro de Costo
      Society                     : bukrs;   // Bukrs - Sociedad

      SolUserNumber               : uname;   // Numero de Usuario Solicitud
      UnitOrg                     : orgeh;   // Unidad Organizativa
}
