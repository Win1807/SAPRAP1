@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HCM Communication'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
} 
define view entity ZR_HCM_COMMUNICATION_DC as select from I_HCMCommunication
association [0..1] to I_HCMOrganizationalAssignment as _HCMOrganizationalAssignment
        on $projection.HCMPersonnelNumber = _HCMOrganizationalAssignment.HCMPersonnelNumber 
            and _HCMOrganizationalAssignment.EndDate >= $session.system_date and _HCMOrganizationalAssignment.StartDate <= $session.system_date
{key HCMPersonnelNumber,
 key HCMSubtype,
 key HCMObjectIdentification,
 key HCMRecordIsLocked,
 key EndDate,
 key StartDate,
 key HCMSequentialNumber,

 HCMCommunicationID,
 HCMCommunicationLongID,
 _HCMOrganizationalAssignment.CompanyCode 

}
where HCMCommunicationID = $session.user and HCMSubtype = '0001'
