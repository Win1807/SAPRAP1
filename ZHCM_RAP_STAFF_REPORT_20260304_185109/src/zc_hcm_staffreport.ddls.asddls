@EndUserText.label: 'Staff Report'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_STAFF_REPORT'
//@Search.searchable: true

@UI.headerInfo: { typeName: 'Empleado',
                  typeNamePlural: 'Empleados',
                  title: { type: #STANDARD, value: 'PersonnelNumber' },
                  description.value: 'PersonnelNumber' }

@UI:{
   presentationVariant: [{ sortOrder: [{ by: 'PersonnelNumber', direction: #ASC  }]  }]
}
define custom entity ZC_HCM_StaffReport
  // with parameters parameter_name : parameter_type
{

      @UI.lineItem            : [{position: 10}]
      @UI.selectionField      : [{position: 10}]
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_HCMEmployeeVH', element: 'HCMPersonnelNumber'}, distinctValues: true, label: 'Datos del personal', useForValidation: false},
                                        { entity:{ name: 'ZC_HCMPersonnelActionVH', element: 'HCMPersonnelNumber'}, distinctValues: true, label: 'Medidas', qualifier: 'SecondVH', useForValidation: false},
                                        { entity:{ name: 'ZI_HCM_PERSONALID_VH', element: 'HCMPersonnelNumber'}, distinctValues: true, label: 'Identificación Personal', qualifier: 'ThirdVH', useForValidation: false},
                                        { entity:{ name: 'ZI_HCMCurOrglAssgmt_VH', element: 'HCMPersonnelNumber'}, distinctValues: true, label: 'Asignación Organizativa', qualifier: 'FourthVH', useForValidation: false}
                                        ]
      @Consumption.filter     : { mandatory: false, multipleSelections: true, selectionType: #SINGLE }
  key PersonnelNumber         : pernr_d; // Número de empleado
      @UI.lineItem            : [{position: 20}]
      @EndUserText.label      : 'Matricula'
      UserName                : sysid; //Matricula
      @UI.hidden              : true
      FullName                : ze_nomco; // Nombre completo del empleado o candidato
      @UI.lineItem            : [{position: 30}]
      @EndUserText.label      : 'Nombres'

      FirstName               : vorna;     // Primer nombre
      @UI.lineItem            : [{position: 40}]
      @EndUserText.label      : 'Apellido Paterno'
      LastName1               : nachn;     // Primer apellido
      @UI.lineItem            : [{position: 50}]
      @EndUserText.label      : 'Apellido Materno'
      LastName2               : nach2;     // Segundo apellido

      @UI.lineItem            : [{position: 60}]
      @ObjectModel.text.element:[ 'EmployeeStatusText' ]
      @UI.textArrangement     : #TEXT_ONLY
      @EndUserText.label      : 'Situación de trabajador'
      @EndUserText.quickInfo  : 'Situación de trabajador'
      EmploymentStatus        : stat2;     // Estado de empleo - Activo/Terminado
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      EmployeeStatusText      : ze_sittra; // Estado del empleado

      @UI.selectionField      : [{position: 100}]
      //      @Consumption.filter     : { selectionType: #INTERVAL , multipleSelections: false }

      @UI.lineItem            : [{position: 70}]
      @EndUserText.label      : 'Fecha de alta'
      HireDate                : dat02;     // Fecha de contratación

      @UI.lineItem            : [{position: 80}]
      @ObjectModel.text.element:[ 'PositionText' ]
      @UI.textArrangement     : #TEXT_ONLY
      PositionCode            : plans;     // Código del puesto
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      PositionText            : sttext;    // Descripción del puesto

      @UI.lineItem            : [{position: 90}]
      @EndUserText.label      : 'Grado salarial'
      SalaryGrade             : trfgr;     // Grado salarial

      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_HCMORGUNIT', element: 'OrganizationalUnit'},
                                               distinctValues: true}]
      @UI.selectionField      : [{position: 80}]
      @UI.lineItem            : [{position: 100}]
      @ObjectModel.text.element:[ 'OrgUnitText' ]
      @UI.textArrangement     : #TEXT_ONLY
      OrganizationalUnit      : orgeh;     // Código de unidad organizativa
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      OrgUnitText             : sttext;    // Descripción de la unidad organizativa

      @UI.selectionField      : [{position: 150}]
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_HCMORGUNIT', element: 'OrganizationalUnit'},
                                                     distinctValues: true}]
      @UI.lineItem            : [{position: 110}]
      @ObjectModel.text.element:[ 'ServiceText' ]
      @UI.textArrangement     : #TEXT_ONLY
      Service                 : zeserv; // Servicio
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      ServiceText             : sttext; // Descripción del servicio

      @UI.selectionField      : [{position: 140}]
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_HCMORGUNIT', element: 'OrganizationalUnit'},
                                                     distinctValues: true}]
      @UI.lineItem            : [{position: 120}]
      @ObjectModel.text.element:[ 'AreaText' ]
      @UI.textArrangement     : #TEXT_ONLY
      Area                    : zearea; // Área
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      AreaText                : sttext; // Descripción del área

      @UI.selectionField      : [{position: 130}]
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZC_HCMORGUNIT', element: 'OrganizationalUnit'},
                                                     distinctValues: true}]
      @UI.lineItem            : [{position: 130}]
      @ObjectModel.text.element:[ 'DivisionText' ]
      @UI.textArrangement     : #TEXT_ONLY
      Division                : zediv; // División
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      DivisionText            : sttext;    // Descripción de la división

      @UI.lineItem            : [{position: 140}]
      @ObjectModel.text.element:[ 'WorkScheduleText' ]
      @UI.textArrangement     : #TEXT_ONLY
      @EndUserText.label      : 'Horario de trabajo'
      WorkScheduleCode        : schkn;     // Código de horario laboral
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      WorkScheduleText        : retext; // Descripción del horario laboral

      @UI.lineItem            : [{position: 150}]
      @ObjectModel.text.element:[ 'TimestampText' ]
      @UI.textArrangement     : #TEXT_ONLY
      @EndUserText.label      : 'Captura de Marca'
      Timestamp               : pt_zterf; // Marca de tiempo para asistencia
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      TimestampText           : dzetxt; // Texto de captura de marca de tiempo

      @UI.lineItem            : [{position: 160}]
      @EndUserText.label      : 'Nombre de jefe'
      ManagerName             : ze_nomco;  // Nombre del gerente



      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCMPersonnelSubareaVH', element: 'HCMPersonnelSubarea'},
                                           additionalBinding: [{ localElement: 'DivisionCode', element: 'HCMPersonnelArea'  }],
                                                     distinctValues: true}]
      @Consumption.filter     : { mandatory: false, multipleSelections: true, selectionType: #SINGLE}
      @UI.selectionField      : [{position: 40}]
      @UI.lineItem            : [{position: 170}]
      @ObjectModel.text.element:[ 'SubdivisionText' ]
      @UI.textArrangement     : #TEXT_ONLY
      SubdivisionCode         : btrtl;     // Código de subdivisión
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      SubdivisionText         : btext;     // Descripción de la subdivisión

      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCMPersonnelAreaVH', element: 'HCMPersonnelArea'},
                                     additionalBinding: [{ localElement: 'CompanyCode', element: 'CompanyCode' }],
                                               distinctValues: true}]
      @Consumption.filter     : { mandatory: false, multipleSelections: true, selectionType: #SINGLE}
      @UI.selectionField      : [{position: 30}]
      @UI.lineItem            : [{position: 175}]
      @ObjectModel.text.element:[ 'DivisionName' ]
      @UI.textArrangement     : #TEXT_ONLY
      DivisionCode            : persa;     // Código de división
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      DivisionName            : name1;     // Nombre de la división

      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCMEmployeeGroupVH', element: 'HCMEmployeeGroup'},
                                                      distinctValues: true}]
      @UI.selectionField      : [{position: 50}]
      @UI.lineItem            : [{position: 180}]
      @ObjectModel.text.element:[ 'PersonnelGroupText' ]
      @UI.textArrangement     : #TEXT_ONLY
      PersonnelGroup          : persg;     // Grupo de personal
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      PersonnelGroupText      : pgtxt;     // Descripción del grupo de personal

      @UI.selectionField      : [{position: 60}]
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCMEmployeeSubgroupVH', element: 'EmployeeSubGroup'},
                                          additionalBinding: [{ localElement: 'PersonnelGroup', element: 'EmployeeGroup'  }],
                                                       distinctValues: true}]
      @UI.lineItem            : [{position: 190}]
      @ObjectModel.text.element:[ 'PersonnelAreaText' ]
      @UI.textArrangement     : #TEXT_ONLY
      PersonnelArea           : persk;     // Área de personal
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      PersonnelAreaText       : pktxt;     // Descripción del área de personal

      @UI.lineItem            : [{position: 200}]
      PayrollArea             : abkrs;     // Área de nómina

      @UI.selectionField      : [{position: 70}]
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCMWorkContractVH', element: 'WorkContract'},
                                        distinctValues: true}]
      @UI.lineItem            : [{position: 210}]
      @ObjectModel.text.element:[ 'RelationText' ]
      @UI.textArrangement     : #TEXT_ONLY
      EmploymentRelation      : ansvh;     // Relación laboral
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      RelationText            : anstx; // Texto de relación laboral (no mostrado)

      @UI.lineItem            : [{position: 220}]
      @ObjectModel.text.element:[ 'ContractText' ]
      @UI.textArrangement     : #TEXT_ONLY
      ContractType            : cttyp;     // Tipo de contrato
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      ContractText            : cttxt;     // Texto del tipo de contrato (no mostrado)

      @UI.selectionField      : [{position: 110}]
      @UI.lineItem            : [{position: 230}]
      @EndUserText.label      : 'Fecha inicial de contrato'
      ContractStartDate       : begda;     // Fecha de inicio del contrato
      @UI.lineItem            : [{position: 240}]
      @UI.selectionField      : [{position: 120}]
      @EndUserText.label      : 'Fecha fin de contrato'
      ContractEndDate         : ctedt;     // Fecha de finalización del contrato

      @UI.lineItem            : [{position: 250}]
      ValidityPeriod          : ze_plavig; // Periodo de validez (meses y días)

      @UI.selectionField      : [{position: 90}]
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCMJobVH', element: 'HCMJob'},

                                        distinctValues: true}]
      @UI.lineItem            : [{position: 260}]
      @ObjectModel.text.element:[ 'FunctionText' ]
      @UI.textArrangement     : #TEXT_ONLY
      @EndUserText.label      : 'Función'
      FunctionCode            : stell;     // Código de función
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      FunctionText            : sttext;    // Texto de función

      @UI.hidden              : true
      PowerType               : subty;     // Tipo de poder
      @UI.hidden              : true
      PowerTypeText           : sttext;    // Texto del tipo de poder (no mostrado)

      @UI.lineItem            : [{position: 270}]
      CostCenter              : kostl;     // Centro de costo

      @UI.lineItem            : [{position: 280}]
      @ObjectModel.text.element:[ 'GenterText' ]
      @UI.textArrangement     : #TEXT_ONLY
      @EndUserText.label      : 'Sexo'
      Gender                  : gesch;     // Código de género
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      GenterText              : ze_sexo;

      @UI.lineItem            : [{position: 290}]
      @EndUserText.label      : 'Fecha de nacimiento'
      DateOfBirth             : begda; //gbdat;     // Fecha de nacimiento

      @UI.lineItem            : [{position: 300}]
      @ObjectModel.text.element:[ 'DocTypeName' ]
      @UI.textArrangement     : #TEXT_ONLY
      @EndUserText.label      : 'Tipo de documento'
      DocumentType            : subty; // Tipo de documento
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      DocTypeName             : ze_nomtipdoc; // Nombre del tipo de documento

      @UI.lineItem            : [{position: 305}]
      @EndUserText.label      : 'N° de Documento'
      DocumentNumber          : icnum;     // Número de documento

      @UI.lineItem            : [{position: 308}]
      @EndUserText.label      : 'Inscrito a EPS'
      EpsNo                   : pltyp;     // Número de salud




      @UI.hidden              : true
      Nationality             : natio;     // Código de nacionalidad
      @UI.hidden              : true
      NationalityText         : natio;     // Nombre de la nacionalidad
      @UI.hidden              : true
      Age                     : ze_edad;   // Edad
      
      @UI.hidden              : true
      MaritalStatus           : famst;     // Estado civil
      @UI.hidden              : true
      MaritalStatusText       : fatxt;     // Descripción del estado civil
      
      @UI.hidden              : true
      StreetType              : strds;     // Código de tipo de calle
      @UI.hidden              : true
      StreetName              : stras;     // Nombre de la calle
      
      @UI.hidden              : true
      BuildingNumber          : hsnmr;     // Número del edificio
      @UI.hidden              : true
      PostalCode              : posta;     // Código postal
      @UI.hidden              : true
      CompleteAddress         : ze_dirco;  // Dirección completa
      @UI.hidden              : true
      District                : zz_dist;   // Distrito
      @UI.hidden              : true
      Department              : zz_depa;   // Departamento
      @UI.hidden              : true
      Province                : zz_prov;   // Provincia
      @UI.hidden              : true
      DistrictName            : zednomb; // Nombre del distrito
      @UI.hidden              : true
      DepartmentName          : zednomb; // Nombre del departamento
      @UI.hidden              : true
      ProvinceName            : zednomb; // Nombre de la provincia



      @UI.lineItem            : [{position: 310}]
      @ObjectModel.text.element:[ 'TrainingText' ]
      @UI.textArrangement     : #TEXT_ONLY
      @EndUserText.label      : 'Formación'
      Training                : ausbi;     // Capacitación
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      TrainingText            : atext;     // Texto de capacitación

      @UI.lineItem            : [{position: 320}]
      @ObjectModel.text.element:[ 'DegreeText' ]
      @UI.textArrangement     : #TEXT_ONLY
      @EndUserText.label      : 'Grado'
      Degree                  : slabs;     // Título o grado
      @Semantics.text         : true
      @Consumption.filter.hidden: true
      DegreeText              : sttext;    // Nombre del grado

      @UI.lineItem            : [{position: 330}]
      @EndUserText.label      : 'Universidad'
      University              : insti; // Universidad

      @ObjectModel.text.element:['CompanyName']
      @UI.textArrangement     : #TEXT_ONLY
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCM_COMPANY_VH', element: 'Company'},
                                                     distinctValues: true}]
      @Consumption.filter     : { mandatory: true, multipleSelections: false, selectionType: #SINGLE}
      @UI.selectionField      : [{position: 20}]
      CompanyCode             : bukrs;     // Código de la empresa
      @Consumption.filter.hidden: true
      CompanyName             : butxt;     // Nombre de la empresa

      @UI.hidden              : true
      StartDate               : begda;     // Fecha de inicio
      @UI.hidden              : true
      EndDate                 : endda;     // Fecha de finalización
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @UI.hidden              : true
      EconomicSubsidy         : pad_amt7s; // subeco - Subsidio económico
      @Semantics.amount.currencyCode: 'CurrencyCode'
      @UI.hidden              : true
      BasicSalary             : pad_amt7s; // suebas -Salario base
      @UI.hidden              : true
      AmountInWords           : ze_imptex; // Monto en palabras
      @UI.hidden              : true
      CurrencyCode            : waers;     // Código de moneda
      @UI.hidden              : true
      CurrencySymbol          : char03;    // Símbolo de moneda
      @UI.hidden              : true
      LegalRepresentativeName : ze_nomco; // Nombre del representante legal
      @UI.hidden              : true
      LegalRepresentativeId   : abap.char( 11 ); // zz_ndoc - ID del representante legal
      @UI.hidden              : true
      InternalCategory        : funkt;     // Categoría interna
      @UI.hidden              : true
      InternalCategoryText    : sttext;    // Texto de categoría interna

      @UI.hidden              : true
      PayrollAccountType      : bkont;     // Tipo de cuenta de nómina
      @UI.hidden              : true
      PayrollAccount          : bankn;     // Número de cuenta de nómina
      @UI.hidden              : true
      CtsAccountType          : bkont;     // Tipo de cuenta CTS
      @UI.hidden              : true
      CtsAccount              : bankn;     // afpkl - Número de cuenta CTS
      @UI.hidden              : true
      PensionSystem           : zafpk;     // Sistema de pensiones
      @UI.hidden              : true
      PensionSystemName       : abap.char( 40 ); //afpds- Nombre del sistema de pensiones
      @UI.hidden              : true
      IpssNumber              : icnum; // Número IPSS autogenerado
      @UI.hidden              : true
      HolidayCalendar         : hident; // Calendario de vacaciones
      @UI.hidden              : true
      OrganizationAddress     : ze_dirco; // Dirección completa de la organización
      @UI.hidden              : true
      ManagerPersonnelId      : pernr_d; // Código del personal del gerente
      @UI.hidden              : true
      ManagerDocType          : ze_nomtipdoc; // Tipo de documento del gerente
      @UI.hidden              : true
      ManagerDocumentNumber   : icnum; // Número del documento del gerente
}
