@EndUserText.label: 'Calcular prestamo'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_LOAN_ADMIN'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root custom entity ZC_HCM_CALCULATE_LOAN
{
  key LoanAmount : abap.dec( 13, 2 ); -- Monto
  
  QuotaNumbers: ze_numcuota; -- Numero de cuotas
  
  LoanType: dlart; -- Clase de prestamo
  
  ImportQuotaGrati : abap.dec( 13, 2 );
  
  ImportQuotaSimp : abap.dec( 13, 2 );
  
  PaymentStartDate : ze_finpago; -- Fecha de inicio amortizacion
  
  PaymentEndDate : ze_finpago; -- Fecha de culminación del pago estimado (ZFECFP)
  
}
