@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'General Information Employee'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_HCM_GENERALINF_UnitOrg 

as select from ZTF_HCM_UnitOrgGI( client: $session.client, ManagerUser: $session.user )
//association [1..*] to ZI_HCM_GeneralInf_employee as _Employee on 
//                                            $projection.UnitOrganizational = _Employee.UnitOrganizational 
association [0..*] to I_HCMOrganizationalUnitText as _HCMOrganizationalUnitText on $projection.UnitOrganizational = _HCMOrganizationalUnitText.HCMOrganizationalUnit
association  [1..*] to ZI_HCM_GENERALINF_UnitOrg as _OrgUnitSon
                    on $projection.UnitOrganizational = _OrgUnitSon.UnitOrganizationalFather
{
@ObjectModel.text.association: '_HCMOrganizationalUnitText'
key UO_CHILD as UnitOrganizational,
 UO_FATHER as UnitOrganizationalFather,
 
 _OrgUnitSon,
 _HCMOrganizationalUnitText
// _Employee   
} 
