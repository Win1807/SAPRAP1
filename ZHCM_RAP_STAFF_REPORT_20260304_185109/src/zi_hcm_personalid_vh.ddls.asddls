@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HCM Personal ID'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_HCM_PERSONALID_VH as select from pa0185 as  _personalId
association [1] to I_HCMCurOrglAssgmt as _OrgAssg on _personalId.pernr = _OrgAssg.HCMPersonnelNumber
{
@Search.defaultSearchElement: true
@Search.fuzzinessThreshold: 0.7
key pernr as HCMPersonnelNumber,
@UI.hidden: true
 key subty as Subty,
 @UI.hidden: true
 key objps as Objps,
 @UI.hidden: true
 key sprps as Sprps,
 @UI.hidden: true
 key endda as Endda,
 @UI.hidden: true
 key begda as Begda,
 @UI.hidden: true
 key seqnr as Seqnr,
 ictyp as Ictyp,
 icnum as Icnum,
 @Search.defaultSearchElement: true
@Search.fuzzinessThreshold: 0.7
 _OrgAssg.HCMEmployeeName  
} 
where begda <= $session.system_date and
      endda >= $session.system_date
