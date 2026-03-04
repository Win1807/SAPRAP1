@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'General Information Employee'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_HCM_ORG_CHART_UnitOrg with parameters Orgeh: orgeh 

as select from ZTF_HCM_ORG_CHART_UNITORGGI( client: $session.client, ManagerUser: $session.user, Orgeh: $parameters.Orgeh )
//association [1..*] to ZI_HCM_GeneralInf_employee as _Employee on 
//                                            $projection.UnitOrganizational = _Employee.UnitOrganizational 
association [0..*] to I_HCMOrganizationalUnitText as _HCMOrganizationalUnitText on $projection.UnitOrganizational = _HCMOrganizationalUnitText.HCMOrganizationalUnit
association  [1..*] to ZI_HCM_ORG_CHART_UnitOrg as _OrgUnitSon
                    on $projection.UnitOrganizational = _OrgUnitSon.UnitOrganizationalFather
association [1..1] to pa0001 as pa on $projection.PersonalNumber = pa.pernr and pa.endda >= $session.system_date
association [1..1] to hrp1000 as hr on $projection.Possition = hr.objid and hr.endda >= $session.system_date
                                       and hr.otype = 'S'
{
@ObjectModel.text.association: '_HCMOrganizationalUnitText'
key UO_CHILD as UnitOrganizational,
key PersonalNumber as PersonalNumber,
 UO_FATHER as UnitOrganizationalFather,
 pa.sname as PersonalName,
 Possition as Possition,
 hr.mc_stext as PossitionDescripcion,
 
 _OrgUnitSon,
 _HCMOrganizationalUnitText
// _Employee   
} 
