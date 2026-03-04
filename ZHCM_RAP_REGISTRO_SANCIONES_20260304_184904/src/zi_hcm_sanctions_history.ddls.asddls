@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Employee Sanction History'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root view entity ZI_HCM_SANCTIONS_HISTORY
  as select from zthrsanciones   as Sancion

    inner join   zthrtiposancion as PosSancion on Sancion.sancionid = PosSancion.sancionid

{
  key Sancion.pernr      as EmployeeNumber,

  key Sancion.sancionid,

      @Semantics.businessDate.from: true
      @UI.dataFieldDefault: [ { label: 'Fecha Inicio' } ]
      @UI.lineItem: [ { position: 20 } ]
  key Sancion.begda,

      @Semantics.businessDate.from: true
      @UI.dataFieldDefault: [ { label: 'Fecha Fin' } ]
      @UI.lineItem: [ { position: 30 } ]
  key Sancion.endda,

      @UI.dataFieldDefault: [ { label: 'Tipo de Sanción' } ]
  key PosSancion.awart   as SanctionType,

      @UI.dataFieldDefault: [ { label: 'Descripción Tipo de Sancion' } ]
      @UI.lineItem: [ { position: 10 } ]
      PosSancion.abwtxt,

      Sancion.bukrs,

      @UI.dataFieldDefault: [ { label: 'Nro. de Días' } ]
      @UI.lineItem: [ { position: 40 } ]
      Sancion.day_nr,

      @UI.dataFieldDefault: [ { label: 'Motivo' } ]
      @UI.lineItem: [ { position: 50 } ]
      Sancion.motsan,

      Sancion.aedat,
      Sancion.uname
}
