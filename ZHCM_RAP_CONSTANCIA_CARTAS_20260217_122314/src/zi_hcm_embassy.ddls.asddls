@AbapCatalog.viewEnhancementCategory: [#NONE]
@ObjectModel.dataCategory: #VALUE_HELP
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Get Country'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS -- drop down menu for value help
@UI.presentationVariant: [{ sortOrder: [{ by: 'land1', direction: #ASC }] }]

define view entity ZI_HCM_EMBASSY
  as select from t005t as t

{
      @EndUserText.label: 'Código País'
      @ObjectModel.text.element: [ 'Landx' ]
  key t.land1,

      @EndUserText.label: 'Descripción'
      @Search.defaultSearchElement: true
      t.landx
}

where spras = 'S'
