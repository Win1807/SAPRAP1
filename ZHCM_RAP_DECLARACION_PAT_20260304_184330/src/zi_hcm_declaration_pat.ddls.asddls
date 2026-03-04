@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Declaration Patrimonial'

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define root view entity ZI_HCM_DECLARATION_PAT
  as select from pa0105 as p105

  composition [0..*] of ZI_HCM_DEPOSITS_DEC_PAT as _Deposits
  composition [0..*] of ZI_HCM_IMMOVABLES_DEC_PAT as _Immovables
  composition [0..*] of ZI_HCM_VEHICLES_DEC_PAT as _Vehicles
  composition [0..*] of ZI_HCM_VALUES_DEC_PAT as _Values
  composition [0..*] of ZI_HCM_OTHERS_DEC_PAT as _Others
  composition [0..*] of ZI_HCM_DEBITS_DEC_PAT as _Debits

{
  key p105.pernr   as EmployeeNumber,

      _Deposits, // Deposito
      _Immovables, //immuebles
      _Vehicles, //Vehiculos
      _Values, //Valores
      _Others, //Otros
      _Debits //Deudas
}

where p105.usrid = $session.user
  and p105.subty = '0001'
