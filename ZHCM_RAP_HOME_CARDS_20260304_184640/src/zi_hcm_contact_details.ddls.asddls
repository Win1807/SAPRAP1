@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Contact Details Employee'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.representativeKey: 'EmployeeNumber'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view entity ZI_HCM_CONTACT_DETAILS
  as select from    pa0001 as P1

    inner join      pa0105 as P5
      on  P5.pernr = P1.pernr
      and P1.endda = P5.endda
      and P5.subty = '0001'
      and P1.endda between P5.begda and P5.endda

    inner join      pa0002 as p2
      on  p2.pernr  = P1.pernr
      and p2.endda  = P5.endda
      and p2.sprps is initial

    left outer join pa0032 as p32
      on  p32.pernr  = P5.pernr
      and p32.begda <= $session.system_date
      and p32.endda >= $session.system_date

  association [1..1] to I_HCMPositionText            as _HCMPositionText
    on $projection.PositionEmp = _HCMPositionText.HCMPosition
        and _HCMPositionText.StartDate  <= $session.system_date
    and _HCMPositionText.EndDate    >= $session.system_date

  association [1..1] to I_HCMCommunication           as _HCMCommunication
    on  $projection.EmployeeNumber    = _HCMCommunication.HCMPersonnelNumber
    and _HCMCommunication.StartDate  <= $session.system_date
    and _HCMCommunication.EndDate    >= $session.system_date
    and _HCMCommunication.HCMSubtype  = '0010'

  association [1..1] to I_HCMOrganizationalUnitBasic as _HCMOrganizationalUnitBasic
    on  P1.orgeh = _HCMOrganizationalUnitBasic.HCMOrganizationalUnit
    and _HCMOrganizationalUnitBasic.Language   = $session.system_language
    and _HCMOrganizationalUnitBasic.StartDate <= $session.system_date
    and _HCMOrganizationalUnitBasic.EndDate   >= $session.system_date

{
  key P5.pernr                                                          as EmployeeNumber, -- Numero del empleado                                                       

      P1.sname                                                          as FullName, -- Nombre Completo
      concat_with_space(p2.nachn, p2.nach2, 1)                          as EmployeeLastName, -- Apellido Empleado NACHN NACHN2
      p2.vorna                                                          as EmployeeName, -- Nombre Empleado VORNA
      P1.plans                                                          as PositionEmp, -- Posicion
      _HCMPositionText.HCMPositionName                                  as PositionName, -- Nombre Posicion
      p32.tel01                                                         as Annex01, -- Anexo 01
      p32.tel02                                                         as Annex02,  -- Anexo 02
      cast(concat_with_space(p32.tel01, p32.tel02, 1) as abap.char(20)) as PhoneEmployee, -- Telefono Empleado      
      _HCMCommunication.HCMCommunicationLongID                          as EmployeeEmail,  -- Email Empleado
      _HCMOrganizationalUnitBasic.HCMOrganizationalUnit                 as OrganizationalUnit,
      _HCMOrganizationalUnitBasic.HCMOrganizationalUnitName             as OrgnizationalUnitName,  -- Descripccion de Unidad Organizativa del Empleado
      P1.endda
}

where P5.usrid = $session.user
  and P5.endda = '99991231';
