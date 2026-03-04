@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Personal Photo Projection'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZC_HCM_PersonalPhoto
  as projection on ZI_HCM_PersonalPhoto
{
  key     HCMPersonnelNumber,
          @Semantics.largeObject: {
                mimeType: 'MimeType', //case-sensitive
                fileName: 'FileName', //case-sensitive

                //          acceptableMimeTypes: ['image/png', 'image/jpeg'],
                contentDispositionPreference: #INLINE }

          @Semantics.imageUrl: true
          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
  virtual Attachment : hrfio_rawstring,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
          @Semantics.mimeType: true
  virtual MimeType   : w3conttype,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
  virtual FileName   : char30,

          @ObjectModel.virtualElementCalculatedBy: 'ABAP:ZCL_HCM_GENERAL_INF'
          @Semantics.imageUrl: true
  virtual Foto       : abap.char( 1024 )
}
