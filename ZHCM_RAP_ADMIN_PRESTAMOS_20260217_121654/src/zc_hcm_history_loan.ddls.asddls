@EndUserText.label: 'Historial de prestamos'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_LOAN_ADMIN'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root custom entity ZC_HCM_HISTORY_LOAN
{
  key EmployeeNumber  : pernr_d;
  
  LoanType : dlart; --Clase de prestamo  (DLART)

  ActualNumber: objps; --Identificacion Objeto (OBJPS)

  LoanTypeDesc : sbttx; --Denominación Subtipo (SBTTX) 
  
  LoanAmount : abap.dec( 13, 2 ); --Importe prestamo (DARBT)

  CurrencyKey : waers; --Clave moneda (WAERS)  

  QuotaNumbers : ze_numcuota; -- Numero de cuotas (ZNCUOT)  

  QuotaAmountSimple : abap.dec( 15 , 2 ); --Nomina personal importe (ZSALDO)  

  OutBalance : abap.dec( 15 , 2 ); -- Out Balance (TILBT)
    
  EstEndPayment : pclo_dlend;  -- Fin prestamo (DLEND) 

  LoanStatus : char15; -- Status (STATUS)

  MessageType : bapi_mtype; -- Tipo mensaje (TYPE)

  Message : bapi_msg; -- Mensaje (MESSAGE)  

  
}
