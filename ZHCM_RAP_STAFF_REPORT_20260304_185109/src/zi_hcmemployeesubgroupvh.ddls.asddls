@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HCM Employee Subgroup Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel: { dataCategory: #VALUE_HELP,
                representativeKey: 'EmployeeSubGroup',
                usageType.sizeCategory: #S,
                usageType.dataClass:  #CUSTOMIZING,
                usageType.serviceQuality: #A }
@Search.searchable: true
define view entity ZI_HCMEmployeeSubgroupVH
  as select from    t503z as a
    left outer join t501t as b on  b.persg = a.persg
                               and b.sprsl = $session.system_language
    left outer join t503t as c on  c.persk = a.persk
                               and c.sprsl = $session.system_language
{
       @UI.lineItem            : [{position: 10}]
  key  a.molga as HCMlo,
       @UI.lineItem            : [{position: 20}]
  key  a.persg as EmployeeGroup,

       //     b.ptext as EmployeeGroupName,
       @UI.lineItem            : [{position: 30}]
       @Search.defaultSearchElement:true
       @Search.fuzzinessThreshold:0.8
       @Search.ranking:#HIGH
  key  a.persk as EmployeeSubGroup,

       @UI.lineItem            : [{position: 40}]
       @Semantics.text: true
       @Search.defaultSearchElement:true
       @Search.fuzzinessThreshold:0.8
       @Search.ranking:#LOW
       b.ptext as EmployeeSubGroupName
}
