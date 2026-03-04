@EndUserText.label: 'Org. Unit'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel: {
        dataCategory: #VALUE_HELP,
        representativeKey: 'OrganizationalUnit',
        usageType.sizeCategory: #S,
        usageType.dataClass: #ORGANIZATIONAL,
        usageType.serviceQuality: #A,
        supportedCapabilities: [ #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY ],
        modelingPattern: #VALUE_HELP_PROVIDER       
    }
@Search.searchable: true
define view entity ZC_HCMORGUNIT as select from I_OrgUnitText
{
@Search.defaultSearchElement: true
@Search.fuzzinessThreshold: 0.8
//      @UI.textArrangement: #TEXT_LAST
      @ObjectModel.text.element: [ 'OrganizationalUnitName' ]
@UI.selectionField: [{ position: 10 }]

key OrganizationalUnit,
 /* Associations */
 @Search.defaultSearchElement: true
 @Search.fuzzinessThreshold: 0.7
  @Semantics.text: true
  @Consumption.filter.hidden: true
 OrganizationalUnitName
} where Language = $session.system_language
