@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Planned Compensation'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_HCM_PlannedCompensation as select from hrp1005
{
 key plvar as Plvar,
 key otype as Otype,
 key objid as Objid,
 key subty as Subty,
 key istat as Istat,
 key begda as StartDate,
 key endda as EndDate,
 key varyf as Varyf,
 key seqnr as Seqnr,
// infty as Infty,
// otjid as Otjid,
// aedtm as Aedtm,
// uname as Uname,
// reasn as Reasn,
// histo as Histo,
// itxnr as Itxnr,
// molga as Molga,
// trfar as Trfar,
// trfgb as Trfgb,
// trfkz as Trfkz,
// trfg1 as Trfg1,
// trfg2 as Trfg2,
// trfs1 as Trfs1,
// trfs2 as Trfs2,
// budg1 as Budg1,
// budg2 as Budg2,
 curcy as Curcy,
// midpt as Midpt,
 frequ as Frequ,
 cpind as Cpind
// cpmin as Cpmin,
// cpmax as Cpmax
    
}
