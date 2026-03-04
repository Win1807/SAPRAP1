@EndUserText.label: 'Interface Reason Request fotocheck'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_PHOTOCHECK_REQ'

@Search.searchable: true
define custom entity ZI_HCM_VH_REASON_REQ

{
      @Search.defaultSearchElement: true
      @UI.lineItem: [ { position: 10 } ]
  key IdReason    : ze_id_motivo;

      @UI.lineItem: [ { position: 20 } ]
      DesReason   : ze_desc_motivo;

      UserName : syuname;
      MessageText     : ze_mensaje;
}
