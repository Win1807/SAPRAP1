@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Personal Absenteeism'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@UI:{
   presentationVariant: [{ sortOrder: [{ by: 'StartDate', direction: #DESC  }]  }]
}
define view entity ZI_HCM_PersonalAbsenteeism as select from pa2001
association [0..1] to I_HCMOrganizationalAssignment as _HCMOrganizationalAssignment
        on  $projection.HCMPersonnelNumber  = _HCMOrganizationalAssignment.HCMPersonnelNumber
                                                               and _HCMOrganizationalAssignment.HCMRecordIsLocked = ''
                                                               and _HCMOrganizationalAssignment.EndDate           >= $session.system_date
                                                               and _HCMOrganizationalAssignment.StartDate         <= $session.system_date
association [0..*] to ZI_HCM_PersonalAbsenteeismText as _PersonalAbsenteeismText 
                                on $projection.hcmpersonnelarea = _PersonalAbsenteeismText.HCMPersonnelArea and
                                   $projection.hcmpersonnelsubarea = _PersonalAbsenteeismText.HCMPersonnelSubarea and
                                   $projection.AbsenteeismClass = _PersonalAbsenteeismText.AbsenteeismClass

{
 key pernr as HCMPersonnelNumber,
 key subty as HCMSubtype,
 key objps as HCMObjectIdentification,
 @Semantics.booleanIndicator: true
 key sprps as HCMRecordIsLocked,
 key endda as EndDate,
 key begda as StartDate,
 key seqnr as HCMSequentialNumber,
 _HCMOrganizationalAssignment.HCMPersonnelArea,
 _HCMOrganizationalAssignment.HCMPersonnelSubarea,
  @ObjectModel.text.association: '_PersonalAbsenteeismText'
 awart as AbsenteeismClass,
 kaltg as DaysAbsenteeism,

_PersonalAbsenteeismText
    
} 
