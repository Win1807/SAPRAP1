@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HCM Personnel Action Value Help'
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
define view entity ZC_HCMPersonnelActionVH as select from I_HCMPersonnelAction
{

@Search.defaultSearchElement: true
@Search.fuzzinessThreshold: 0.8
@Search.ranking: #HIGH
@UI.lineItem: [{ position: 50 }] 
key HCMPersonnelNumber,
@UI.hidden: true
key HCMSubtype,
@UI.hidden: true
key HCMObjectIdentification,
key HCMRecordIsLocked,
@UI.lineItem: [{ position: 70 }]
@UI.selectionField: [{ position: 10 }] 
@Consumption.filter:{ selectionType: #SINGLE, multipleSelections: false}
key EndDate,
@UI.lineItem: [{ position: 60 }] 
key StartDate,
 @UI.hidden: true
key HCMSequentialNumber,
@UI.lineItem: [{ position: 80 }]
HCMGrpgValForPersAssignments,
@UI.lineItem: [{ position: 90 }]
HCMPersonnelActionType,
@UI.lineItem: [{ position: 100 }]
HCMPersonnelActionReason,
@UI.lineItem: [{ position: 110 }]
HCMCustomerSpecificPersStatus,
@UI.lineItem: [{ position: 120 }]
HCMEmploymentStatus,
@UI.lineItem: [{ position: 130 }]
HCMSpecialPaymentStatus
} 
where StartDate <= $session.system_date and EndDate >= $session.system_date
