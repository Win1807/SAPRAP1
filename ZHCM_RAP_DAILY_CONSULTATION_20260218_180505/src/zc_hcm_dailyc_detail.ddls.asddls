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

@UI:{
   presentationVariant: [{ sortOrder: [{ by: 'PersonnelNumber', direction: #ASC  }, 
                                        { by: 'MarkDate', direction: #ASC  }]  }]
}
define custom entity ZC_HCM_DAILYC_DETAIL
  //  with parameters



{
//      @Search.defaultSearchElement: true
//      @Search.fuzzinessThreshold: 0.8

      @UI.lineItem            : [{position: 30}]
      @UI.selectionField      : [{position: 30}]
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_HCM_GET_EMPLOY', element: 'HCMPersonnelNumber'}, distinctValues: true, label: 'Datos del personal', useForValidation: false},
                                        { entity:{ name: 'ZC_HCM_PERSONNEL_ACTION_VH', element: 'HCMPersonnelNumber'}, distinctValues: true, label: 'Medidas', qualifier: 'Second VH', useForValidation: false}
                                        ]
      @Consumption.filter     : { mandatory: false, multipleSelections: true, selectionType: #SINGLE}
  key PersonnelNumber         : pernr_d; // Employee Number (Código)

      //      @Semantics.businessDate.to: true
      @UI.selectionField      : [{position: 20}]
      @Consumption.filter     : { selectionType: #INTERVAL , multipleSelections: false }
      @EndUserText.label      : 'Periodo de selección'
  key SelectionPeriod         : ze_hcm_period_select;
      //      @Semantics.businessDate.from: true
      //  key StartDate              : begda;
      @UI.lineItem            : [{position: 50}]
      @EndUserText.label      : 'Fecha'
  key MarkDate                : ldate; // Mark Date (Fecha de marca)
     
      @EndUserText.label      : 'Periodo'
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCM_DOMAIN_TYPE_PERIOD', element: 'PeriodType'},
                                                     distinctValues: true}]
      @Consumption.filter     : { mandatory: true, multipleSelections: false, selectionType: #SINGLE, defaultValue: '6'}

      @UI.selectionField      : [{position: 10 }]
      //      @Consumption.defaultValue: '6'
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
      @Semantics.text         : true     
      @UI.lineItem            : [{position: 35}]
      @EndUserText.label: 'Apellidos y Nombres'
      FullName                : ze_hcm_fullname; // Full Name: Last Name + Second Last Name + First Name (Nombres completos)
      
      @ObjectModel.text.element:['CompanyName']
      @UI.textArrangement: #TEXT_ONLY
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCM_COMPANY_VH', element: 'Company'},
                                                     distinctValues: true}]
      @Consumption.filter     : { mandatory: true, multipleSelections: false, selectionType: #SINGLE}
      @UI.selectionField      : [{position: 50}]
      @UI.lineItem            : [{position: 20}]
      Company                 : bukrs;
      
      @UI.hidden              : true
      CompanyName             : butxt; // Company Name (Razón social)
      
      @UI.lineItem            : [{position: 10}]
      @EndUserText.label      : 'RUC'
      RUC                     : zd_hcm_paval; // RUC

      @UI.lineItem            : [{position: 40}]
      @EndUserText.label      : 'DNI'
      DNI                     : psg_idnum; // DNI

      @UI.lineItem            : [{position: 60}]
      @EndUserText.label      : 'Hr.Ing.Teo'
      @Semantics.time: true
      TheoreticalStartTime    : sobeg;    //Theoretical Start Time (Hora de ingreso teórico)

      @UI.lineItem            : [{position: 70}]
      @EndUserText.label      : 'Hr.Sal.Teo'
      TheoreticalEndTime      : soend;     //time; //timn; // Theoretical End Time (Hora de salida teórico)

      @UI.lineItem            : [{position: 80}]
      @EndUserText.label      : 'Hr.Ing.Real'
      ActualStartTime         : ltime; // Actual Start Time (Hora de ingreso real)

      @UI.lineItem            : [{position: 90}]
      @EndUserText.label      : 'Hr.Sal.Real'
      ActualEndTime           : ltime; // Actual End Time (Hora de salida real)

      @UI.lineItem            : [{position: 100}]
      @EndUserText.label      : 'Dif.Min/Hor'
      TimeDifference          : sobeg; // Time Difference (Diferencia en minutos u horas)

      @UI.lineItem            : [{position: 110}]
      @Semantics.amount.currencyCode: 'Currency'
      @EndUserText.label      : 'Cost.Hr.Hombre'
      LaborCost               : pad_amt7s; // Labor Cost (Costo horas hombre)
      @UI.hidden              : true
      Currency                : waers; //campo andicional para el importe

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

//      @Consumption.valueHelpDefinition: [{ entity:{ name: 'I_HCMATTENDANCEABSENCETYPE', element: 'HCMAttendanceAbsenceType'},
//                                                     distinctValues: true}]
      @UI.lineItem            : [{position: 120}]
//      @UI.selectionField      : [{position: 80}]
      @ObjectModel.text.element:['AbsenceTypeText']
      @EndUserText.label      : 'Ti.Ausent.'
       @UI.textArrangement: #TEXT_ONLY
      AbsenceType             : awart; // Absence Type (Tipo de ausentismos)
      
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
//      JustifableAbsenteeism   : ze_hcm_justy_abs;
      
      @UI.lineItem            : [{position: 130}]
      @ObjectModel.text.element:['TerminalText']
      @EndUserText.label      : 'Id.Term.'
      TerminalID              : terid; // Terminal ID (ID terminal)

      @Semantics.text         : true
      @UI.hidden              : true
      TerminalText            : ze_office_name; // Terminal ID Text (Texto ID terminal)
      @Semantics.text         : true
      @UI.hidden              : true
      AbsenceTypeText         : abwtxt; // Absence Type Description (Txt. clas.ausentismo)


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
      @UI.hidden              : true
      DataOrigin              : char6; // Data Origin: Marks / IT2001 / ZL-CCNO (Origen del dato)

      // Break Mark Times
      @UI.lineItem            : [{position: 180}]
      @EndUserText.label      : 'Hr.Ing.Refr'
      BreakStartTime          : ltime; // Break Start Time (Hora de ingreso marca)
      @UI.lineItem            : [{position: 190}]
      @EndUserText.label      : 'Hr.Sal.Refr'
      BreakEndTime            : ltime; // Break End Time (Hora de salida marca)


}
