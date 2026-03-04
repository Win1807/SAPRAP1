@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HCM Job Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel: { dataCategory: #VALUE_HELP,
                representativeKey: 'HCMJob',
                usageType.sizeCategory: #S,
                usageType.dataClass:  #CUSTOMIZING,
                usageType.serviceQuality: #A }
@Search.searchable: true
define view entity ZI_HCMJobVH
  as select from    t513  as a
    inner join t513s as b on  a.stell = b.stell
                               and b.sprsl = $session.system_language 
                                 and  b.maint = 'P' and
                                 b.begda <= a.endda and
                                 b.endda >= a.begda                                
                                       
{
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking:#HIGH
  key a.stell as HCMJob,
  key a.endda as EndDate,
      a.begda as StartDate,
      @Semantics.text: true
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking:#LOW
      b.stltx as HCMJobName,
      b.maint as MaintOM
}
where a.begda <= $session.system_date and
      a.endda >= $session.system_date

