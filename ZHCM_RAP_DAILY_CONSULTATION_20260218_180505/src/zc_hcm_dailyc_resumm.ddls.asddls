@EndUserText.label: 'Daily consultation detail'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_DAILY_CONSULTATION'
@Search.searchable: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
//@UI.selectionVariant: [
//  {
//    text: 'Detalle',
//    qualifier: 'DET'
//  }
//]

//@UI.presentationVariant: [
//  {
//    qualifier: 'pvariantDET',
//    text: '(#PresentationVariant)',
//    maxItems: 5,
//    // Search Term #DefaultSort
//    sortOrder: [
//      {
//        by: 'MarkDate',
//        direction: #ASC
//      }
//    ],
//    visualizations: [{type: #AS_LINEITEM}]
//  }
//]
//
//// Search Term #SelectionVariant
//@UI.selectionVariant: [
//  {
//    qualifier: 'svariantDET',
//    text: 'Detalle'
////    ,
////    filter: 'CriticalityCode GE 0 and CriticalityCode LE 2'
//  }
//]
//
//// Search Term #SelectionPresentationVariant
//@UI.selectionPresentationVariant: [
//  {
//    text: '(#SelectionPresentationVariant)',
//    presentationVariantQualifier: 'pvariantDET',
//    selectionVariantQualifier: 'svariantDET'
//  }
//]


@UI.selectionVariant: [{ 
    text: '...',
    qualifier: 'svHCMEmployeeGroup',
    filter: 'HCMEmployeeGroup NE A'
    
 }]
define custom entity ZC_HCM_DAILYC_RESUMM
  //  with parameters



{
//      @ObjectModel.text.element:['FullName']
      @Search.defaultSearchElement: true
//      @Search.fuzzinessThreshold: 0.8

      @UI.lineItem            : [{position: 10}]
      @UI.selectionField      : [{position: 30}]
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_HCMEmployeeVH', element: 'HCMPersonnelNumber'},
                                                   distinctValues: true, useForValidation: false}]
      @Consumption.filter     : { mandatory: false, multipleSelections: true, selectionType: #SINGLE}
  key PersonnelNumber         : pernr_d; // Employee Number (Código)

      @UI.selectionField      : [{position: 20}]
      @Consumption.filter     : { selectionType: #INTERVAL , multipleSelections: false }
      @EndUserText.label      : 'Periodo de selección'
  key SelectionPeriod         : ze_hcm_period_select;

//      @EndUserText.label      : 'Fecha'
//  key MarkDate                : ldate; // Mark Date (Fecha de marca)
      @EndUserText.label      : 'Semana'
      @UI.lineItem            : [{position: 20}]
  key WeekMonth               : ze_hcm_week; // Weeks of month ( Semanas del mes )


      @EndUserText.label      : 'Periodo'
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCM_DOMAIN_TYPE_PERIOD', element: 'PeriodType'},
                                                     distinctValues: true}]
      @Consumption.filter     : { mandatory: true, multipleSelections: false, selectionType: #SINGLE, defaultValue: '6'}
      @UI.selectionField      : [{position: 10 }]
      Periodo                 : ze_type_period;

      @Semantics.text         : true
      @Search.fuzzinessThreshold: 0.7
      @Search.defaultSearchElement: true
      @UI.hidden              : true
      LastName                : pad_nachn; // Last Name (Apellido)
      @Semantics.text         : true
      @Search.fuzzinessThreshold: 0.6
      @Search.defaultSearchElement: true
      @UI.hidden              : true
      SecondLastName          : pad_nach2; // Second Last Name (Segundo apellido)
      @Semantics.text         : true
      @Search.fuzzinessThreshold: 0.5
      @Search.defaultSearchElement: true
      @UI.hidden              : true
      FirstName               : pad_vorna; // First Name (Nombre de pila)

      @ObjectModel.text.element:['CompanyName']
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCM_COMPANY_VH', element: 'Company'},
                                                     distinctValues: true}]
      @Consumption.filter     : { mandatory: true, multipleSelections: false, selectionType: #SINGLE}
      @UI.selectionField      : [{position: 50}]
//      @UI.lineItem            : [{position: 20}]
      Company                 : bukrs;


//      @EndUserText.label      : 'RUC'
//      RUC                     : paval; // RUC
//      @EndUserText.label      : 'DNI'
//      DNI                     : psg_idnum; // DNI


//      @EndUserText.label      : 'Hr.Ing.Teo'
//      TheoreticalStartTime    : sobeg;     // Theoretical Start Time (Hora de ingreso teórico)
//
//      @EndUserText.label      : 'Hr.Sal.Teo'
//      TheoreticalEndTime      : soend;     // Theoretical End Time (Hora de salida teórico)
//
//      @EndUserText.label      : 'Hr.Ing.Real'
//      ActualStartTime         : ltime; // Actual Start Time (Hora de ingreso real)
//
//      @EndUserText.label      : 'Hr.Sal.Real'
//      ActualEndTime           : ltime; // Actual End Time (Hora de salida real)
//
//      @EndUserText.label      : 'Dif.Min/Hor'
//      TimeDifference          : sobeg; // Time Difference (Diferencia en minutos u horas)
//
//      @Semantics.amount.currencyCode: 'Currency'
//      @EndUserText.label      : 'Cost.Hr.Hombre'
//      LaborCost               : pad_amt7s; // Labor Cost (Costo horas hombre)
//      @UI.hidden              : true
//      Currency                : waers; //campo andicional para el importe

      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCMEmploymentStatusText', element: 'HCMEmploymentStatus'},
                                                     distinctValues: true}]
      @Consumption.filter     : { mandatory: true, multipleSelections: true, selectionType: #SINGLE, defaultValue: '3'}
      @UI.selectionField      : [{position: 40}]
      OccupationStatus        : stat2;

      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCMEmployeeGroupVH', element: 'HCMEmployeeGroup'},
                                                     distinctValues: true}]
      @UI.selectionField      : [{position: 60}]
      HCMEmployeeGroup        : persg;
      @UI.hidden: true
      ReportType              : ze_dc_treport;


//      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_HCMAttendanceAbsenceTypeVH', element: 'HCMAttendanceAbsenceType'},
//                                                     distinctValues: true}]
//
//      @UI.selectionField      : [{position: 80}]
//      @ObjectModel.text.element:['AbsenceTypeText']
//      @EndUserText.label      : 'Ti.Ausent.'
//      AbsenceType             : awart; // Absence Type (Tipo de ausentismos)
      
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_Absence_Type', element: 'AbsenceType'},
                                                     distinctValues: true}]     
      @UI.selectionField      : [{position: 200}]     
      @EndUserText.label      : 'Ti.Ausent.'
      AbsenceNew: awart; 
      
      
//      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCM_justifable_absenteeism', element: 'JustifableAbs'},
//                                               distinctValues: true}]
//      @Consumption.filter     : { mandatory: false, multipleSelections: true, selectionType: #SINGLE}
//      @UI.selectionField      : [{position: 90}]
//      @EndUserText.label: 'Absentismos justificables'
//      JustifableAbsenteeism   : char03;
      

      @Semantics.text         : true
      @UI.hidden              : true
      AbsenceTypeText         : abwtxt; // Absence Type Description (Txt. clas.ausentismo)
      @EndUserText.label: 'Apellidos y Nombres'
      @Semantics.text         : true
      @UI.lineItem            : [{position: 15}]
      FullName                : ze_hcm_fullname; // Full Name: Last Name + Second Last Name + First Name (Nombres completos)

      // Organizational Structure
      @ObjectModel.text.element:['DivisionText']
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_HCMORGUNIT', element: 'OrganizationalUnit'},
                                                     distinctValues: true}]
      @UI.selectionField      : [{position: 100}]
      @EndUserText.label      : 'División'
      Division                : zediv; // Division (División)

      @ObjectModel.text.element:['AreaText']
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_HCMORGUNIT', element: 'OrganizationalUnit'},
                                                     distinctValues: true}]
      @UI.selectionField      : [{position: 110}]
      @EndUserText.label      : 'Area'
      Area                    : zearea; // Area (Área)


      @ObjectModel.text.element:['ServiceText']
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_HCMORGUNIT', element: 'OrganizationalUnit'},
                                               distinctValues: true}]
      @UI.selectionField      : [{position: 120}]
      @EndUserText.label      : 'Servicio'
      Service                 : zeserv; // Service (Servicio)

      @ObjectModel.text.element:['OrganizationalUnitText']
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_HCMORGUNIT', element: 'OrganizationalUnit'},
                                               distinctValues: true}]
      @UI.selectionField      : [{position: 130}]
      @EndUserText.label      : 'Uni.Organiz.'
      OrganizationalUnit      : orgeh; // Organizational Unit (Unidad organizativa)


      @UI.hidden              : true
      DivisionText            : orgtx; // Division Text (Texto División)
      @UI.hidden              : true
      AreaText                : orgtx; // Area Text (Texto Área)
      @UI.hidden              : true
      ServiceText             : orgtx; // Service Text (Texto Servicio)
      @UI.hidden              : true
      OrganizationalUnitText  : orgtx; // Organizational Unit Text (Texto Unidad organizativa)
//      @UI.hidden              : true
//      DataOrigin              : char6; // Data Origin: Marks / IT2001 / ZL-CCNO (Origen del dato)

      // Break Mark Times
//      @EndUserText.label      : 'Hr.Ing.Refr'
//      BreakStartTime          : ltime; // Break Start Time (Hora de ingreso marca)
//
//      @EndUserText.label      : 'Hr.Sal.Refr'
//      BreakEndTime            : ltime; // Break End Time (Hora de salida marca)

 
      @UI.hidden              : true
      CompanyName             : butxt; // Company Name (Razón social)


      @EndUserText.label      : 'Total de Marca Real'
      @UI.lineItem            : [{position: 30}]
      TotalOfRealMarks        : ze_hcm_retyp; //Total of real Marks ( Total de marcas reales )
      
      @UI.lineItem            : [{position: 40}]
      @EndUserText.label      : 'Total de Marcas de absentismos'
      TotalOfAbsenteeismMarks : ze_hcm_subty; //Total of absenteeism marks( Total de marcas de absentismos )
      
      @EndUserText.label      : 'Total de Marcas teóricas'
      @UI.lineItem            : [{position: 50}]
      TotalOfTheoreticalMarks : ze_hcm_warst; //Total of theoretical marks ( Total de marcas teóricas )
      @EndUserText.label      : 'Porcentaje'
      @UI.lineItem            : [{position: 60}]
      Percentage              : ze_hcm_percentage; //Porcentage ( Porcentage )


}
