@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Personal Search'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.representativeKey: 'EmployeeNumber'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

@Search.searchable: true

define root view entity ZI_HCM_PERSONAL_SEARCH
  as select from pa0001 as P1

    inner join   pa0105 as P5
      on  P5.pernr = P1.pernr
      and P1.endda = P5.endda
      and P5.subty = '0010'
      and P1.endda between P5.begda and P5.endda

  association [1..1] to I_HCMPositionText as _HCMPositionText
    on  $projection.PositionEmp        = _HCMPositionText.HCMPosition
    and _HCMPositionText.HCMObjectType = 'S'
    and _HCMPositionText.Language      = $session.system_language
    and _HCMPositionText.EndDate       = '99991231'

{
      @EndUserText.label: ' Numero del empleado'
      @Search.defaultSearchElement: true
      @UI.lineItem: [ { position: 10, label: 'Numero del empleado' } ]
  key P5.pernr                         as EmployeeNumber, -- Numero del empleado                                                       

      @EndUserText.label: ' Nombre Completo del empleado'
      @Search.defaultSearchElement: true
      P1.sname                         as FullName, -- Nombre Completo

      P1.plans                         as PositionEmp, -- Posicion

      @EndUserText.label: ' Posición'
      @Search.defaultSearchElement: true
      @UI.selectionField: [ { position: 20 } ]
      _HCMPositionText.HCMPositionName as PositionName, -- Nombre Posicion

      @Search.defaultSearchElement: true
      @UI.lineItem: [ { position: 30, label: 'Correo del Jefe' } ]
      P5.usrid_long                    as MailEmployee    -- Correo del Jefe
}
