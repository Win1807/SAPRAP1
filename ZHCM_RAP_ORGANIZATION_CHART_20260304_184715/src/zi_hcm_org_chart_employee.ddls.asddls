
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'General Information Employee'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_HCM_ORG_CHART_EMPLOYEE

  as select from ZTF_HCM_ORG_CHART_EmployeeGI( client: $session.client, ManagerUser: $session.user )
    association [0..1] to I_HCMPersonalData     as _PersonalData        on  $projection.PersonalNumber      = _PersonalData.HCMPersonnelNumber
                                                                        and _PersonalData.HCMRecordIsLocked = ''
                                                                        and _PersonalData.EndDate           >= $session.system_date
                                                                        and _PersonalData.StartDate         <= $session.system_date
     association [0..1] to ZI_HCM_PersonalAddresses     as _PersonalAddresses        on  $projection.PersonalNumber      = _PersonalAddresses.HCMPersonnelNumber
                                                                        and _PersonalAddresses.HCMRecordIsLocked = ''
                                                                        and _PersonalAddresses.HCMSubtype = '0001'
                                                                        and _PersonalAddresses.EndDate           >= $session.system_date
                                                                        and _PersonalAddresses.StartDate         <= $session.system_date  
                                                                        
  association [0..1] to pa0032             as _HCMInternalData on  $projection.PersonalNumber = _HCMInternalData.pernr
                                                               and _HCMInternalData.sprps         = ''
                                                               and _HCMInternalData.endda         >= $session.system_date
                                                               and _HCMInternalData.begda         <= $session.system_date   
  association [0..1] to pa0041             as _HCMDateSpecifications on  $projection.PersonalNumber = _HCMDateSpecifications.pernr
                                                               and _HCMDateSpecifications.sprps         = ''
                                                               and _HCMDateSpecifications.endda         >= $session.system_date
                                                               and _HCMDateSpecifications.begda         <= $session.system_date   
                                                               
  association [0..1] to I_HCMCommunication as _Communication   on  $projection.PersonalNumber   = _Communication.HCMPersonnelNumber
                                                               and _Communication.HCMRecordIsLocked = ''
                                                               and _Communication.HCMSubtype = '0010'
                                                               and _Communication.EndDate           >= $session.system_date
                                                               and _Communication.StartDate         <= $session.system_date  
  association[0..*] to ZI_HCM_PersonalAbsenteeism as _PersonalAbsenteeism   on $projection.PersonalNumber  = _PersonalAbsenteeism.HCMPersonnelNumber    
  
  association[0..1] to ZI_HCM_PlannedCompensation as _PlannedCompensation   on $projection.HCMJob  = _PlannedCompensation.Objid
                                                                                    and _PlannedCompensation.Plvar = '01'
                                                                                    and _PlannedCompensation.Otype = 'C'
                                                                                    and _PlannedCompensation.Istat = '1'
                                                                                    and _PlannedCompensation.EndDate >= $session.system_date
                                                                                    and _PlannedCompensation.StartDate <= $session.system_date
 association [0..1] to ZI_HCMBasicPay as _HCMBasicPay on $projection.PersonalNumber = _HCMBasicPay.HCMPersonnelNumber and
                                                                _HCMBasicPay.HCMRecordIsLocked = '' and
                                                                _HCMBasicPay.EndDate >= $session.system_date and
                                                                _HCMBasicPay.StartDate <= $session.system_date
  
                                                                                                                     
  association [0..*] to I_HCMJobText                as _HCMJobText                on  $projection.HCMJob    =  _HCMJobText.HCMJob
                                                                                  and _HCMJobText.StartDate <= $session.system_date
                                                                                  and _HCMJobText.EndDate   >= $session.system_date
                                                                                  and _HCMJobText.Language  = $session.system_language
  association [0..1] to I_HCMPersonnelArea          as _HCMPersonnelArea          on  $projection.HCMPersonnelArea = _HCMPersonnelArea.HCMPersonnelArea
  association [0..1] to I_HCMPersonnelSubarea       as _HCMPersonnelSubarea       on  $projection.HCMPersonnelArea    = _HCMPersonnelSubarea.HCMPersonnelArea
                                                                                  and $projection.HCMPersonnelSubarea = _HCMPersonnelSubarea.HCMPersonnelSubarea

  association [0..*] to I_HCMPositionText           as _HCMPositionText           on  $projection.HCMPosition        =  _HCMPositionText.HCMPosition
                                                                                  and _HCMPositionText.HCMObjectType =  'S'
                                                                                  and _HCMPositionText.EndDate         >= $session.system_date
                                                                                  and _HCMPositionText.StartDate       <= $session.system_date
                                                                                  and _HCMPositionText.Language       = $session.system_language

  association [0..*] to I_HCMEmployeeGroupText      as _HCMEmployeeGroupText      on  $projection.HCMEmployeeGroup = _HCMEmployeeGroupText.HCMEmployeeGroup

  association [0..*] to I_HCMEmployeeSubgroupText   as _HCMEmployeeSubgroupText   on  $projection.HCMEmployeeSubgroup = _HCMEmployeeSubgroupText.HCMEmployeeSubgroup

  association [0..1] to I_CompanyCode               as _CompanyCode               on  $projection.CompanyCode = _CompanyCode.CompanyCode

  association [0..*] to ZI_HCM_COST_CENTER_TEXT     as _CostCenterText            on  $projection.ControllingArea = _CostCenterText.ControllingArea
                                                                                  and $projection.CostCenter      = _CostCenterText.CostCenter
                                                                                  and _CostCenterText.Language    = $session.system_language

  association [0..*] to I_HCMOrganizationalUnitText as _HCMOrganizationalUnitText on  $projection.UnitOrganizational = _HCMOrganizationalUnitText.HCMOrganizationalUnit
  association [0..*] to ZI_HCM_EmployeeMaritalStatText as _HCMEmployeeMaritalStatText on  $projection.hcmemployeemaritalstatus = _HCMEmployeeMaritalStatText.HCMEmployeeMaritalStatus

  association [0..*] to t542t as _HCMWorkContractText on $projection.HCMWorkContract = _HCMWorkContractText.ansvh and
                                                         _HCMWorkContractText.molga = '99'
                                                      and _HCMWorkContractText.spras    = $session.system_language
  association [0..*] to t549t as _HCMPayrollAreaText on $projection.HCMPayrollArea = _HCMPayrollAreaText.abkrs 
                                                     and _HCMPayrollAreaText.sprsl    = $session.system_language
  

{
   key PersonalNumber,
     begda    as StartDate,
   endda    as EndDate,
      @ObjectModel.text.association: '_HCMOrganizationalUnitText'
  UO_CHILD as UnitOrganizational,
      //      UO_CHILD,
      // UO_FATHER,
      Possition,
      ename    as HCMEmployeeName,
      @ObjectModel.text.association: '_HCMJobText'
      stell    as HCMJob,
      _HCMJobText.HCMJobTitle,
      @ObjectModel.foreignKey.association: '_HCMPersonnelArea'
      werks    as HCMPersonnelArea,
      _HCMPersonnelArea.HCMPersonnelAreaName,

      btrtl    as HCMPersonnelSubarea,
      _HCMPersonnelSubarea.PersonnelSubareaName,
      @ObjectModel.text.association: '_HCMPositionText'
      plans    as HCMPosition,
       _HCMPositionText.HCMPositionName,
      ansvh    as HCMWorkContract,
      _HCMWorkContractText.atx as HCMWorkContractText,
      abkrs    as HCMPayrollArea,
      _HCMPayrollAreaText.atext as HCMPayrollAreaText,
      @ObjectModel.text.association: '_HCMEmployeeGroupText'
      persg    as HCMEmployeeGroup,
      @ObjectModel.text.association: '_HCMEmployeeSubgroupText'
      persk    as HCMEmployeeSubgroup,
      bukrs    as CompanyCode,
      _CompanyCode.CompanyCodeName,
      @ObjectModel.text.association: '_CostCenterText'
      kostl    as CostCenter,
      _CostCenterText.CostCenterName,
      kokrs    as ControllingArea,
      cast( '100' as abap.char( 10 ) ) as OccupationGrade,
      
      _PersonalData.HCMEmployeeBirthDate,
      @ObjectModel.text.association: '_HCMEmployeeMaritalStatText'
      _PersonalData.HCMEmployeeMaritalStatus,
      
      _PersonalAddresses.Street,
      _PersonalAddresses.HouseNumber,
      _PersonalAddresses.AppartmentId,
      _PersonalAddresses.District,
      
      _HCMInternalData.tel01                                                     as HCMTelephone01,
      _HCMInternalData.tel02                                                     as HCMTelephone02,
      _HCMInternalData.gebnr as BuildingNumber ,
      _HCMInternalData.zimnr as RoomNumber ,
 
       case '01' 
        when _HCMDateSpecifications.dar01 then _HCMDateSpecifications.dat01
        when _HCMDateSpecifications.dar02 then _HCMDateSpecifications.dat02
        when _HCMDateSpecifications.dar03 then _HCMDateSpecifications.dat03
        when _HCMDateSpecifications.dar04 then _HCMDateSpecifications.dat04
        when _HCMDateSpecifications.dar05 then _HCMDateSpecifications.dat05
        when _HCMDateSpecifications.dar06 then _HCMDateSpecifications.dat06
        when _HCMDateSpecifications.dar07 then _HCMDateSpecifications.dat07
        when _HCMDateSpecifications.dar08 then _HCMDateSpecifications.dat08
        when _HCMDateSpecifications.dar09 then _HCMDateSpecifications.dat09
        when _HCMDateSpecifications.dar10 then _HCMDateSpecifications.dat10
        else '00000000'
       end as InitDate,
      
     _Communication.HCMCommunicationLongID               as HCMCommunicationLongID,
     

_PlannedCompensation.Cpind,
_HCMBasicPay.PayScaleType,
_HCMBasicPay.PayScaleTypeText,
_HCMBasicPay.PayScaleArea,
_HCMBasicPay.PayScaleAreaText,
_HCMBasicPay.PayScaleGroup,
_HCMBasicPay.PayScaleLevel,
_HCMBasicPay.CapacityUtilizationLevel,
@Semantics.amount.currencyCode: 'Currency'
_HCMBasicPay.Salary,
_HCMBasicPay.Currency,
@Semantics.amount.currencyCode: 'Currency'
_HCMBasicPay._PayGradeLevels.MinSalary,
@Semantics.amount.currencyCode: 'Currency'
_HCMBasicPay._PayGradeLevels.MaxSalary,
@Semantics.amount.currencyCode: 'Currency'
_HCMBasicPay._PayGradeLevels.ReferenceSalary,

@Semantics.amount.currencyCode: 'Currency'


case
when _HCMBasicPay._PayGradeLevels.ReferenceSalary <> 0 then cast( cast ( _HCMBasicPay.Salary as abap.dec( 23, 2 ) ) / cast ( _HCMBasicPay._PayGradeLevels.ReferenceSalary as abap.dec( 23, 2 )  ) as abap.dec( 23, 2 ) )
else cast( '0' as abap.dec( 23, 2 ) ) end as RatioSalary,

case
when _HCMBasicPay._PayGradeLevels.DiffMaxMin <> 0 then 
cast( cast ( _HCMBasicPay.Salary  - _HCMBasicPay._PayGradeLevels.MinSalary as abap.dec( 23, 2 )  ) / cast ( _HCMBasicPay._PayGradeLevels.DiffMaxMin as abap.dec( 23, 2 )  ) * 100 as abap.dec( 23, 2 )  )
else cast( '0' as abap.dec( 23, 2 ) ) end as PosSalary,

@EndUserText.label: 'Ocupaciones múltiples'
'' as MultipleOccupations,



      _HCMJobText,
      _HCMPositionText,
      _HCMEmployeeGroupText,
      _HCMEmployeeSubgroupText,
      _CostCenterText,
      _HCMPersonnelArea,
      _HCMEmployeeMaritalStatText,
      //      _HCMPersonnelSubarea,
      //      _HCMPosition,
      //      _HCMEmployeeGroup,
      //      _HCMEmployeeSubGroup,
      //      _CompanyCode,
      //      _CostCenter,
      _HCMOrganizationalUnitText,

      _PersonalData,
      _PersonalAbsenteeism,
      _HCMBasicPay
      
      

}
