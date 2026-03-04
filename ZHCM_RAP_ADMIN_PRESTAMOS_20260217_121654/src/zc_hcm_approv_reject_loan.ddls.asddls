@EndUserText.label: 'Aprobar,rechazar prestamos'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_LOAN_ADMIN'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root custom entity ZC_HCM_APPROV_REJECT_LOAN
{ 

  key LoanAppNumber  : ze_numsolpres; -- Numero de prestamo administrativo
  
  Action : abap.char( 1 ); -- Accion para aprobar, rechazar solicitud
  
  Nivel : abap.char( 1 );
  
  QuotaNumbers : ze_numcuota; --Numero de cuotas
  
  QuotaNumbersMax:  ze_numcuota; -- Numero maximo de cuotas
  
  LoanAmount : abap.dec( 13, 2 ); --Monto del prestamo
  
  LoanType : dlart; -- Motivo de Prestamo
  
  EmployeeNumber : pernr_d; --Numero de empleado 
  
  RelationLaboral : ansvh ; -- Relacion laboral
  
  RelationLaboralDesc: anstx; -- Relacion laboral Descripcion
  
  DateEndCont : ctedt ; --Fecha fin de contrato
  
  DateInit : datum ; -- Fecha inicio
  
  DateEnd : datum ; -- Fecha fin
  
  DateClose: char02 ; -- Fecha de Cierre
  
  PersonnelArea : persk; -- Area de personal
  
  FlagBoss : flag; -- Flag de jefe
  
  DNINumber :  psg_idnum; -- Número ID (DNI);
  
  EmployeeName: pad_cname; -- Nombre de empleado
  
  CurrencyKey: ktext; --Descripcion clave moneda
  
  CurrencyKeyCode: waers; --Codigo de moneda
  
  QuotaAmountSimple : abap.dec( 13, 2 ); --Importe cuota simple(ZIMPCS)
  
  QuotaAmountGrat : abap.dec( 13, 2 ); --Importe cuota gratificacion(ZIMPCG)
  
  Mail : comm_id_long; -- Mail -- Correo
  
  CommentLoan : ze_comenprest; -- Comentario de la solicitud de préstamo admnistrativo (ZCOMEN)
  
  AmountEnd :  abap.dec( 13, 2 ); --Monto fin
  
  AmountEnd2 : abap.dec( 13, 2 ); --Monto fin 2
  
  RejectMessaje : alshuffvl_wao ; --Motivo de rechazo
  
  TransgressionInd : ze_trangresion; -- Indicador de Trangresión (ZTRANG)
  
  TransgressionMes : ze_msjtransgre; -- Mensaje de Trangresión (ZMSJTRANGR)
  
}
