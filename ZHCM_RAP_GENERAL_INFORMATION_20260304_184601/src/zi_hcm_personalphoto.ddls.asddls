@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Personal Photo'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_HCM_PersonalPhoto as select from I_HCMPersonalData
{
key HCMPersonnelNumber
// key HCMSubtype,
// key HCMObjectIdentification,
// key HCMRecordIsLocked,
// key EndDate,
// key StartDate
// key HCMSequentialNumber,   
}
where HCMRecordIsLocked = '' and 
      EndDate >= $session.system_date and
      StartDate <= $session.system_date
