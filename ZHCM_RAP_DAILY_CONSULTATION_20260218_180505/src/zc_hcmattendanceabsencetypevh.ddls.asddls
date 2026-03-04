@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Attendance Absence Type VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel: {
        dataCategory: #VALUE_HELP,
        representativeKey: 'HCMAttendanceAbsenceType',
        usageType.sizeCategory: #S,
        usageType.dataClass: #ORGANIZATIONAL,
        usageType.serviceQuality: #A,
        supportedCapabilities: [ #VALUE_HELP_PROVIDER, #SEARCHABLE_ENTITY ],
        modelingPattern: #VALUE_HELP_PROVIDER       
    }
@Search.searchable: true
define view entity ZC_HCMAttendanceAbsenceTypeVH as select from t554s
  association [0..1] to I_HCMPersonnelSubareaGrouping  as _PersSubareaGrpg on  $projection.HCMPersonnelSubareaGrouping = _PersSubareaGrpg.HCMPersonnelSubareaGrouping
  association [0..*] to I_HCMAttendanceAbsenceTypeText as _Text            on  $projection.HCMPersonnelSubareaGrouping = _Text.HCMPersonnelSubareaGrouping
                                                                           and $projection.HCMAttendanceAbsenceType    = _Text.HCMAttendanceAbsenceType
{
      @ObjectModel.foreignKey.association: '_PersSubareaGrpg'
  key moabw as HCMPersonnelSubareaGrouping,
      @ObjectModel.text.association: '_Text'
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking:#HIGH
  key subty as HCMAttendanceAbsenceType,
      @Semantics.businessDate.to: true
      @Consumption.hidden: true
  key endda as EndDate,
      @Semantics.businessDate.from: true
      @Consumption.hidden: true
      begda as StartDate,
      _PersSubareaGrpg,
      _Text
      }      where begda <= $session.system_date and endda >= $session.system_date
