@EndUserText.label: 'Division Change'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_PERSONAL_CHANGE'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@VDM.usage.type: [ #TRANSACTIONAL_PROCESSING_SERVICE ]
@VDM.viewType: #CONSUMPTION
define root custom entity ZC_HCM_DIVISION_CHANGE

{
      @UI.dataFieldDefault: [ { label: 'Matricula' } ]
      @UI.lineItem: [ { position: 10 } ]
      @UI.selectionField: [ { position: 10 } ]
  key EmployeeNumber    : pd_objid_r;   -- Numero Empleado

      @UI.dataFieldDefault: [ { label: 'Nombres y Apellidos' } ]
      @UI.lineItem: [ { position: 20 } ]
      EmployeeFullName      : stext;    -- Nombres y Apellidos

      @UI.dataFieldDefault: [ { label: 'Division Actual' } ]
      @UI.selectionField: [ { position: 20 } ]
      CurrentDivision     : persa;  -- Actual Division

      @UI.dataFieldDefault: [ { label: 'Division Actual Descripccion' } ]
      CurrentDivisionText  : pbtxt; -- División Actual Descripccion

      @UI.dataFieldDefault: [ { label: 'Subdivision Actual' } ]
      @UI.selectionField: [ { position: 30 } ]
      CurrentSubDivision     : btrtl;  -- Actual Subdivision

      @UI.dataFieldDefault: [ { label: 'SubDivision Actual Descripccion' } ]
      CurrentSubDivisionText : btrtx; -- SubDivision Actual Descripccion

      @Consumption.filter: { mandatory: false, multipleSelections: true, selectionType: #SINGLE }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_HCMPersonnelArea', element: 'HCMPersonnelArea' },
                                            distinctValues: false } ]
      @UI.dataFieldDefault: [ { label: 'Division Actual' } ]
      @UI.lineItem: [ { position: 30 } ]
      @UI.selectionField: [ { position: 40 } ]
      NewDivision     : persa;  -- Nueva Division 

      @Consumption.filter: { mandatory: false, multipleSelections: true, selectionType: #SINGLE }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_HCMPersonnelSubarea', element: 'HCMPersonnelSubarea' },
                                            distinctValues: false } ]
      @UI.dataFieldDefault: [ { label: 'Subdivision Actual' } ]
      @UI.lineItem: [ { position: 40 } ]
      @UI.selectionField: [ { position: 50 } ]
      NewSubDivision     : btrtl;  -- Nueva Subdivision

      @UI.dataFieldDefault: [ { label: 'Fecha Solicitud' } ]
      @UI.lineItem: [ { position: 50 } ]
      RequestDate      : datum;    -- Fecha Solicitud

      CompanyCode     : bukrs;  -- Sociedad 
}
