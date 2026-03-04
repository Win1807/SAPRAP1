@EndUserText.label: 'Interface DATA_GET_TASK'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_BANDEJA_JEFATURA'

@Search.searchable: true

define custom entity ZC_HCM_GET_TASK

{
      @Search.defaultSearchElement: true
      @UI.lineItem: [ { position: 10, label: 'Tarea' } ]
      @UI.selectionField: [ { position: 10 } ]
      @EndUserText.label: 'Tarea'
  key Task      : otjid;

      @Search.defaultSearchElement: true
      @UI.lineItem: [ { position: 20, label: 'Texto' } ]
      @EndUserText.label: 'Texto'
      Text      : stext;
}
