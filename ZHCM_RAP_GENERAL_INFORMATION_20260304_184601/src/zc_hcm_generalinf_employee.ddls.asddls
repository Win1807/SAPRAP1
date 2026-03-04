@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection forZI_HCM_GeneralInf_employee'
@Metadata.ignorePropagatedAnnotations: false
define root view entity ZC_HCM_GeneralInf_employee
  as projection on ZI_HCM_GeneralInf_employee
{
  key     PersonalNumber,
         StartDate,
          //  key     EndDate,
// @ObjectModel.text.association: '_HCMOrganizationalUnitText'
          UnitOrganizational,
          _HCMOrganizationalUnitText.HCMOrganizationalUnitName: localized,
          Possition,
          HCMEmployeeName,
//          @ObjectModel.text.association: '_HCMJobText'         
          HCMJob,
          HCMJobTitle,
//          @ObjectModel.foreignKey.association: '_HCMPersonnelArea'
          HCMPersonnelArea,
          HCMPersonnelAreaName,
          HCMPersonnelSubarea,
          PersonnelSubareaName,
//          @ObjectModel.text.association: '_HCMPositionText'
          HCMPosition,
          HCMPositionName,
          HCMWorkContract,
          HCMWorkContractText,
          
          HCMPayrollArea,
          HCMPayrollAreaText,
//          @ObjectModel.text.association: '_HCMEmployeeGroupText'
          HCMEmployeeGroup,
          _HCMEmployeeGroupText.HCMEmployeeGroupName:localized,
//          @ObjectModel.text.association: '_HCMEmployeeSubgroupText'
          HCMEmployeeSubgroup,
          _HCMEmployeeSubgroupText.HCMEmployeeSubgroupName:localized,
          CompanyCode,
          CompanyCodeName,
//           @ObjectModel.text.association: '_CostCenterText'
          CostCenter,
          CostCenterName,
           
          ControllingArea,
          OccupationGrade,
          HCMEmployeeBirthDate,
//           @ObjectModel.text.association: '_HCMEmployeeMaritalStatText'
          HCMEmployeeMaritalStatus,
          _HCMEmployeeMaritalStatText.HCMEmployeeMaritalStatText: localized,
          Street,
          HouseNumber,
          AppartmentId,
          District,
          HCMTelephone01,
          HCMTelephone02,
          BuildingNumber,
          RoomNumber,
          InitDate,
          HCMCommunicationLongID,
          Cpind,
          PayScaleType,
          PayScaleTypeText,
          PayScaleArea,
          PayScaleAreaText,
          PayScaleGroup,
          PayScaleLevel,
          CapacityUtilizationLevel,
          @Semantics.amount.currencyCode: 'Currency'
          Salary,
          Currency,
          @Semantics.amount.currencyCode: 'Currency'
          MinSalary,
          @Semantics.amount.currencyCode: 'Currency'
          MaxSalary,
          @Semantics.amount.currencyCode: 'Currency'
          ReferenceSalary,
          RatioSalary,
          PosSalary,
          MultipleOccupations,

          @EndUserText.label: 'Nombre del Jefe'
          @ObjectModel.text.element: [ 'ManagerEmployeeName' ]
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
  virtual ManagerEmployeeNumber      : pernr_d,

          @EndUserText.label: 'Nombre del Jefe'
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
  virtual ManagerEmployeeName        : smnam,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
  virtual ManagerTelephone01         : telin,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
  virtual ManagerTelephone02         : telin,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
  virtual ManagerBuildingNumber      : gebnr,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
  virtual ManagerRoomNumber          : dzimnr,
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
  virtual ManagerCommunicationLongID : comm_id_long,

          @Semantics.largeObject: {
                mimeType: 'MimeType', //case-sensitive
                fileName: 'FileName', //case-sensitive

                //          acceptableMimeTypes: ['image/png', 'image/jpeg'],
                contentDispositionPreference: #INLINE }

          @Semantics.imageUrl: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
  virtual Attachment                 : hrfio_rawstring,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
          @Semantics.mimeType: true
  virtual MimeType                   : w3conttype,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
  virtual FileName                   : char30,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
          @Semantics.imageUrl: true
  virtual Foto                       : abap.char( 1024 ),
          /* Associations */
//          _CostCenterText,
//          _HCMBasicPay,
//          _HCMEmployeeGroupText,
//          _HCMEmployeeMaritalStatText,
//          _HCMEmployeeSubgroupText,
//          _HCMJobText,
//          _HCMOrganizationalUnitText,
//          _HCMPersonnelArea,
//          _HCMPositionText,
          _PersonalAbsenteeism
//          _PersonalData
}
