@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'General Information Employee'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_HCM_COST_CENTER_TEXT as select from I_CostCenterText
{
    
    key ControllingArea,
    key CostCenter,
    key ValidityEndDate,
    key ValidityStartDate,
    Language,
    CostCenterName,
    CostCenterDescription
}
where ValidityEndDate >= $session.system_date
      and ValidityStartDate <= $session.system_date
      and Language = $session.system_language
