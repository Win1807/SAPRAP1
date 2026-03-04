@EndUserText.label: 'Terminos y condiciones'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_LOAN_ADMIN'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root custom entity ZC_HCM_TERMS_COND
{
  key TermsConditions  : abap.char( 1 );
  
  FileTerms : abap.char( 1000 ); 
  
}
