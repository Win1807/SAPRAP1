@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Constants Calendar types'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root view entity ZI_HCM_CALENDAR_TYPES
  as select from zbcranv_n

{
  key rangeid,
  key bukrs,
  key numb,

      zlow,
      zhigh
}

where rangeid = '0000900037'
  and bukrs   = '100'
