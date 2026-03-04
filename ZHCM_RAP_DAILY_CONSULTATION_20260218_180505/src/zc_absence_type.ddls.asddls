@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Absence Type Value Help'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@Search.searchable: true

define view entity ZC_Absence_Type
  as select from ZI_Absence_Type

{
    @Search.defaultSearchElement: true
      @ObjectModel.text.element: [ 'AbsenceTypeText' ]
      @Search.fuzzinessThreshold: 0.8
  key AbsenceType,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      @Semantics.text: true
      AbsenceTypeText
}
