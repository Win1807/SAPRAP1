@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Obtener Clase de Suplencia'

@Metadata.ignorePropagatedAnnotations: true

define root view entity ZI_HCM_GET_SUBSTITUTE_CLASS
  with parameters
    Mover : mover

  as select from t556t

{
  key sprsl as Languaje,
  key mover as MoveKey,
  key vtart as SubstituteClass,

      vtext as Text
}

where mover = $parameters.Mover
  and sprsl = $session.system_language
