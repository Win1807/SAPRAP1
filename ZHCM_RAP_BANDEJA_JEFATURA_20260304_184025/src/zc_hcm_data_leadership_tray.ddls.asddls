@EndUserText.label: 'Interface DATA_BANDEJA_JEFATURA'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_BANDEJA_JEFATURA'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define custom entity ZC_HCM_DATA_LEADERSHIP_TRAY

{
      @UI: {
      facet: [
      { label: 'Informacion bandeja', id: 'BandejaId', position: 10, type: #COLLECTION },
      { parentId: 'BandejaId', type: #FIELDGROUP_REFERENCE, targetQualifier: 'BandejaIdFG' }
      ],
      // fieldgroup used for grouping all fields with same qualifier to one group
      fieldGroup: [{ qualifier: 'BandejaIdFG', position: 10, label: 'Key' }],
      // Identification used for detailed view
      identification: [{ position: 10, importance: #HIGH }]
      // lienitem used for position in the list view
      }
  key IdWorkItem       : sww_wiid; // Id WorkItem

      @Consumption.filter: { mandatory: false, multipleSelections: true, selectionType: #SINGLE }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZC_HCM_GET_PERSONAL', element: 'EmployeeNumber' },
                                            distinctValues: false } ]
      @Search.defaultSearchElement: true
      @UI.selectionField: [ { position: 20 } ]
      EmployeeNumber : pernr_d;

      Type           : sww_witype; // Tipo
      Languaje       : sww_lang; // Idioma

      @UI.fieldGroup: [ { qualifier: 'BandejaIdFG', position: 20, label: 'Texto' } ]
      @UI.lineItem: [ { position: 20, importance: #HIGH, label: 'Texto' } ]
      Text            : witext; // Texto

      TaskText        : sww_rhtext; // Texto Tarea

      @UI.fieldGroup: [ { qualifier: 'BandejaIdFG', position: 30, label: 'Fecha creación' } ]
      @UI.lineItem: [ { position: 30, importance: #HIGH, label: 'Fecha creación' } ]
      DateCreate      : sww_cd; // Fecha de creación

      CreatedAt       : sww_ct; // Creado a las'
      LastResponsable : sww_aagent; // Ultimo responsable

      @Consumption.filter: { mandatory: false, multipleSelections: true, selectionType: #SINGLE }
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZC_HCM_GET_TASK', element: 'Task' },
                                            distinctValues: false } ]
      @Search.defaultSearchElement: true
      @UI.selectionField: [ { position: 10 } ]
      Task                    : sww_task; // Tarea

      EndUserConfirmation     : sww_wiconf; // Fin confirmacion usuario
      Rejectable              : sww_reject; // Rechazable
      StatusText              : sww_statxt; // Status

      @UI.fieldGroup: [ { qualifier: 'BandejaIdFG', position: 10, label: 'Responsable' } ]
      @UI.lineItem: [ { position: 10, importance: #HIGH, label: 'Responsable' } ]
      Responsable             : swr_agtnam; // Reponsable
}
