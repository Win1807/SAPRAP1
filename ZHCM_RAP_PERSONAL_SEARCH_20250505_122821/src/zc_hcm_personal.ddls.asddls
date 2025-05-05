@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Projection for ZI_HCM_PERSONAL'

@Metadata.allowExtensions: true

@ObjectModel.semanticKey: [ 'HCMPersonnelNumber' ]

@Search.searchable: true



define root view entity ZC_HCM_PERSONAL
  as projection on ZR_HCM_PERSONAL 
{
          @ObjectModel.text.element: ['HCMEmployeeName']
          @Search.defaultSearchElement: true
          @Search.fuzzinessThreshold: 0.8

  key     HCMPersonnelNumber,

  key     EndDate,
  key     StartDate,

          @Semantics.text: true
          @Search.defaultSearchElement: true
          @Search.fuzzinessThreshold: 0.7

          HCMEmployeeName,

          @ObjectModel.text.element: [ 'HCMPositionName' ]
          HCMPosition,

          @Semantics.text: true

          HCMPositionName,

          @ObjectModel.text.element: [ 'HCMOrganizationalUnitName' ]
          HCMOrganizationalUnit,

          @Semantics.text: true
          _HCMOrganizationalUnit._Text.HCMOrganizationalUnitName : localized,

          @ObjectModel.text.element: [ 'HCMPersonnelAreaName' ]
          HCMPersonnelArea,

          @Semantics.text: true
          _HCMPersonnelArea.HCMPersonnelAreaName,

          @ObjectModel.text.element: [ 'PersonnelSubareaName' ]
          HCMPersonnelSubarea,

          _HCMPersonnelSubarea.PersonnelSubareaName,

          @ObjectModel.text.element: [ 'HCMEmployeeGroupName' ]
          HCMEmployeeGroup,

          _HCMEmployeeGroup._Text.HCMEmployeeGroupName           : localized,

          @ObjectModel.text.element: [ 'HCMEmployeeSubgroupName' ]
          HCMEmployeeSubgroup,

          _HCMEmployeeSubGroup._Text.HCMEmployeeSubgroupName     : localized,

          @ObjectModel.text.element: [ 'HCMJobTitle' ]
          HCMJob,

          HCMJobTitle,

          @ObjectModel.text.element: [ 'CompanyCodeName' ]
          CompanyCode,

          CompanyCodeName,

          BirthMonth,
          Birthday,
          HCMCommunicationID,
          @EndUserText.label: 'Nombre de usuario de sistema'
          HCMCommunicationLongID,
          HCMTelephone01,
          HCMTelephone02,

          @EndUserText.label: 'Nombre del Jefe'
          @ObjectModel.text.element: [ 'HCMEmployeeManagerName' ]
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_MANAGER'
  virtual HCMEmployeeManagerNumber : pernr_d,

          @EndUserText.label: 'Nombre del Jefe'
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_MANAGER'
  virtual HCMEmployeeManagerName   : smnam,

          @EndUserText.label: 'Duración en la posición(aa/mm)'
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_MANAGER'
  virtual HCMDurationPosition      : abap.char(10),

          @Semantics.largeObject: {
          mimeType: 'MimeType', //case-sensitive
          fileName: 'FileName', //case-sensitive

          //          acceptableMimeTypes: ['image/png', 'image/jpeg'],
          contentDispositionPreference: #INLINE }

          @Semantics.imageUrl: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_MANAGER'
  virtual Attachment               : hrfio_rawstring,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_MANAGER'
          @Semantics.mimeType: true
  virtual MimeType                 : w3conttype,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_MANAGER'
  virtual FileName                 : char30,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_MANAGER'
          @Semantics.imageUrl: true
  virtual Foto                     : abap.char( 1024 )

          /* Associations */
          //          _Communication,
          //          _CompanyCode,
          //          _HCMEmployeeGroup,
          //          _HCMEmployeeSubGroup,
          //          _HCMJob,
          //          _HCMOrganizationalUnit,
          //          _HCMPersonnelArea,
          //          _HCMPersonnelSubarea,
          //          _HCMPosition,
          //          _PersonalData
}
