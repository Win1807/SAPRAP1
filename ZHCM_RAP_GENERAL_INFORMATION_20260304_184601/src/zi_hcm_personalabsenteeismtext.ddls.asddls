@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Personal Absenteeism'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_HCM_PersonalAbsenteeismText
  as select from t001p as tp
    inner join   t554t as tt on tp.moabw = tt.moabw
{
  key tp.werks as HCMPersonnelArea,
  key tp.btrtl as HCMPersonnelSubarea,
  key tt.awart as AbsenteeismClass,
      @Semantics.language: true
  key tt.sprsl as Language,  
      @Semantics.text: true
      tt.atext as AbsenteeismClassText



}
