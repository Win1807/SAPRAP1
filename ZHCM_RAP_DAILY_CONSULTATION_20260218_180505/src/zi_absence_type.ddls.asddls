@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Absence Type Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_Absence_Type
  as select from ZTF_Absencetype(
                   client     : $session.client,
                   UserPerson : $session.user)

{

//      @UI.lineItem: [ { position: 10 } ]
  key awart as AbsenceType,
//      @UI.lineItem: [ { position: 20 } ]
      atext as AbsenceTypeText
}
