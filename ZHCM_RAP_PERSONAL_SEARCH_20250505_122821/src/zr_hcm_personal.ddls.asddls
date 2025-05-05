@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Base Employee List'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZR_HCM_PERSONAL
  as select from I_HCMOrganizationalAssignment

  association [0..1] to I_HCMPersonalData  as _PersonalData    on  $projection.HCMPersonnelNumber  = _PersonalData.HCMPersonnelNumber
                                                               and _PersonalData.HCMRecordIsLocked = ''
                                                               and _PersonalData.EndDate           >= $session.system_date
                                                               and _PersonalData.StartDate         <= $session.system_date

  association [0..*] to I_HCMCommunication as _Communication   on  $projection.HCMPersonnelNumber   = _Communication.HCMPersonnelNumber
                                                               and _Communication.HCMRecordIsLocked = ''
                                                               and _Communication.EndDate           >= $session.system_date
                                                               and _Communication.StartDate         <= $session.system_date

  association [0..1] to pa0032             as _HCMInternalData on  $projection.HCMPersonnelNumber = _HCMInternalData.pernr
                                                               and _HCMInternalData.sprps         = ''
                                                               and _HCMInternalData.endda         >= $session.system_date
                                                               and _HCMInternalData.begda         <= $session.system_date
{
  key HCMPersonnelNumber,
  key EndDate,
  key StartDate,

      HCMEmployeeName,
     HCMPosition,
      _HCMPosition._Text[EndDate >= $session.system_date and StartDate <= $session.system_date and  Language = $session.system_language].HCMPositionName,
      
      HCMOrganizationalUnit,
//      _HCMOrganizationalUnit._Text.HCMOrganizationalUnitName,

      HCMPersonnelArea,
//      _HCMPersonnelArea.HCMPersonnelAreaName,

      HCMPersonnelSubarea,
//      _HCMPersonnelSubarea.PersonnelSubareaName,

      HCMEmployeeGroup,
//      _HCMEmployeeGroup._Text.HCMEmployeeGroupName,
      HCMEmployeeSubgroup,
//      _HCMEmployeeSubGroup._Text.HCMEmployeeSubgroupName,
      HCMJob,
      _HCMJob._Text[EndDate >= $session.system_date and StartDate <= $session.system_date and Language= $session.system_language].HCMJobTitle,
     
      CompanyCode,
      _CompanyCode[ Language = $session.system_language ].CompanyCodeName,
     
      cast(substring(_PersonalData.HCMEmployeeBirthDate,5,2) as abap.numc( 2 ) ) as BirthMonth,
      cast(substring(_PersonalData.HCMEmployeeBirthDate,7,2) as abap.numc( 2 ) ) as Birthday,

      _Communication[ HCMSubtype = '0001' ].HCMCommunicationID                   as HCMCommunicationID,
       @Semantics.eMail.address: true
      _Communication[ HCMSubtype = '0010' ].HCMCommunicationLongID               as HCMCommunicationLongID,
      
      _HCMInternalData.tel01                                                     as HCMTelephone01,
      _HCMInternalData.tel02                                                     as HCMTelephone02,


      _PersonalData,
      _HCMPosition,

      _HCMOrganizationalUnit,
      _HCMPersonnelArea,
      _Communication,
      _CompanyCode,
      _HCMPersonnelSubarea,
      _HCMEmployeeGroup,
      _HCMEmployeeSubGroup,
      _HCMJob,
_HCMInternalData

}

where
      EndDate           >= $session.system_date
  and StartDate         <= $session.system_date
  and HCMRecordIsLocked = ''
