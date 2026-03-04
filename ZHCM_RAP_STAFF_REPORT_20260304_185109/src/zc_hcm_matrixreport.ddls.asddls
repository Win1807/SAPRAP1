@EndUserText.label: 'Matrix Report List'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_STAFF_REPORT'


define custom entity ZC_HCM_MatrixReport

{

      @UI.lineItem                : [{position: 10}]
  key roleSignSuperiorSubordinate : zrsign;       // A o B superior/subordinado

      @UI.lineItem                : [{position: 20}]
  key supervisorPersonnelNumber   : zpernr_d;     // Cod persona superior
      @UI.lineItem                : [{position: 130}]
  key subordinatePersonnelNumber  : zpernr_d_s;   // Cod persona subordinada
      @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_HCM_COMPANY_VH', element: 'Company'},
                                                     distinctValues: true}]
      @Consumption.filter     : { mandatory: true, multipleSelections: false, selectionType: #SINGLE}
      @UI.selectionField      : [{position: 20}]
      CompanyCode                : bukrs;
      @UI.lineItem                : [{position: 30}]
      supervisorFunction          : zstell;       // Función persona nivel superior
      @UI.lineItem                : [{position: 40}]
      supervisorPositionNumber    : zplans;       // Posición persona nivel superior
      @UI.lineItem                : [{position: 50}]
      supervisorLastNamePaternal  : zpad_nachn;   // Apepat persona nivel superior
      @UI.lineItem                : [{position: 60}]
      supervisorLastNameMaternal  : zpad_nach2;   // Apemat persona nivel superior
      @UI.lineItem                : [{position: 70}]
      supervisorFirstName         : zpad_vorna;   // Names persona nivel superior
      @UI.lineItem                : [{position: 80}]
      supervisorFunctionText      : zstltx;       // Textp de la función de persona superior
      @UI.lineItem                : [{position: 90}]
      supervisorPositionText      : zplstx;       // Textp de la posición de persona superior
      @UI.lineItem                : [{position: 100}]
      supervisorTribeCode         : zsobid_t; // Cod. tribu persona superior
      @UI.lineItem                : [{position: 110}]
      supervisorTribeText         : zstext_t;     // Tribu text tribu persona superior

      @UI.lineItem                : [{position: 115}]
      supervisorSquadCode         : zsobid_s;     // Cod. squad persona superior
      @UI.lineItem                : [{position: 120}]
      supervisorSquadText         : zstext_s;     // Squad text persona superior

      @UI.lineItem                : [{position: 140}]
      subordinateFunction         : zstell_s;     // Función persona nivel subordinada
      @UI.lineItem                : [{position: 150}]
      subordinatePositionNumber   : zplans_s;     // Posición persona nivel subordinada
      @UI.lineItem                : [{position: 160}]
      subordinateLastNamePaternal : zpad_nachn_s; // Apepat persona nivel subordinada
      @UI.lineItem                : [{position: 170}]
      subordinateLastNameMaternal : zpad_nach2_s; // Apemat persona nivel subordinada
      @UI.lineItem                : [{position: 180}]
      subordinateFirstName        : zpad_vorna_s; // Names persona nivel subordinada
      @UI.lineItem                : [{position: 190}]
      subordinateFunctionText     : zstltx_s;     // Textp de la función de persona subordinada
      @UI.lineItem                : [{position: 200}]
      subordinatePositionText     : zplstx_s;     // Textp de la posición de persona subordinada
      @UI.lineItem                : [{position: 210}]
      subordinateTribeCode        : zsobid_t_s;   // Cod. tribu persona subordinada
      @UI.lineItem                : [{position: 220}]
      subordinateTribeText        : zstext_t_s;   // Tribu text tribu persona subordinada
      @UI.lineItem                : [{position: 230}]
      subordinateSquadCode        : zsobid_s_s;   // Cod. squad persona subordinada
      @UI.lineItem                : [{position: 240}]
      subordinateSquadText        : zstext_s_s;   // Squad text persona subordinada

      @UI.lineItem                : [{position: 250}]
      subordinateSquadCode2       : zsobid_s_s; // Cod. squad persona subordinada
      @UI.lineItem                : [{position: 260}]
      subordinateSquad2Text       : zstext_s_s; // Squad text persona subordinada

      @UI.lineItem                : [{position: 270}]
      positionEndDate             : endda; // Fecha fin de posición
      @UI.lineItem                : [{position: 280}]
      recordNumber                : sytabix; // Número de registro
}
