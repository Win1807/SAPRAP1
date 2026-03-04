@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Diagnostic classification'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity zi_hcm_diagnost_classification as select from ztclasifi
{
    key zetcodig as TDisCode,
    key zeccodig as ClassifCode,
        zecdescr as ClassifDesc
}
