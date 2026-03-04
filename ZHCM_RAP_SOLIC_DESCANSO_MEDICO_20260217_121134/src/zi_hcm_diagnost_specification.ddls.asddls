@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Diagnostic specification'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_hcm_diagnost_specification as select from ztespecifi
{
    key zetcodig as TDisCode,
    key zeccodig as ClassifCode,
    key zeecodig as EspecCode,
        flagother as FlagOther,
        zeedescr as EspecDesc
}
