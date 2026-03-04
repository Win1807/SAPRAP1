@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Employee Value Help'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel: {
        dataCategory: #VALUE_HELP,
        representativeKey: 'HCMPersonnelNumber',
        usageType.sizeCategory: #S,
        usageType.dataClass: #ORGANIZATIONAL,
        usageType.serviceQuality: #A,
        supportedCapabilities: [ #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY ],
        modelingPattern: #VALUE_HELP_PROVIDER       
    }

@Search.searchable: true
@Consumption.ranked: true  
define view entity ZC_HCMEmployeeVH as select from I_HCMPersonalData
{
@ObjectModel.text.element: ['HCMEmployeeLastName', 'HCMEmployeeFirstName']
@Search.defaultSearchElement: true
@Search.fuzzinessThreshold: 0.8
@Search.ranking: #HIGH
@UI.lineItem: [{ position: 50 }] 
key HCMPersonnelNumber,
 @UI.hidden: true
 key HCMSubtype,
 @UI.hidden: true
 key HCMObjectIdentification,
 @UI.hidden: true
 key HCMRecordIsLocked,
@UI.lineItem: [{ position: 70 }]
@UI.selectionField: [{ position: 10 }] 
@Consumption.filter:{ selectionType: #SINGLE, multipleSelections: false}
 key EndDate,//
@UI.lineItem: [{ position: 60 }] 
 key StartDate,//
 @UI.hidden: true
 key HCMSequentialNumber,

      @Semantics.text: true
      @Search.fuzzinessThreshold: 0.7
      @Search: { defaultSearchElement: true, ranking: #MEDIUM }
 @UI.lineItem: [{ position: 10 }]
 HCMEmployeeLastName,// 
      @Semantics.text: true
      @Search.fuzzinessThreshold: 0.6
      @Search: { defaultSearchElement: true, ranking: #LOW }
 @UI.lineItem: [{ position: 20 }]  
 HCMEmployeeFirstName, //
@UI.lineItem: [{ position: 30 }]  
 HCMEmployeeTitleCode,//
@UI.lineItem: [{ position: 40 }]  
 HCMEmployeeBirthDate
    
} where StartDate <= $session.system_date and EndDate >= $session.system_date and
    HCMRecordIsLocked = ''
