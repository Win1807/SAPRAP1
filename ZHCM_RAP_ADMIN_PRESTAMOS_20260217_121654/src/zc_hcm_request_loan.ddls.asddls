@EndUserText.label: 'Solicitud Prestamo administrativo'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_LOAN_ADMIN'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root custom entity ZC_HCM_REQUEST_LOAN
{
  key LoanAppNumber  : ze_numsolpres; -- Numero de Solicitud prestamo administrativo
  
  PaymentStartDate : ze_finpago; -- Fecha de inicio amortizacion
  
  PaymentEndDate : ze_finpago; -- Fecha de culminación del pago estimado (ZFECFP)
  
  EmployeeNumber : pernr_d; -- Numero de Empleado
  
  Action : abap.char( 1 ); -- 'S' Grabación, 'M' Modify, 'R' Lectura de Datos
  
  -- Datos para estructura solicitud prestamos
  
  LoanType : dlart; --Clase de Prestamo (DLART)
  
  LoanAmount : abap.dec( 13, 2 ); --Monto del prestamo (ZMONPR)
  
  CurrencyKey : waers; --Clave moneda (WAERS)
  
  QuotaAmountSimple : abap.dec( 13, 2 ); --Importe cuota simple(ZIMPCS)
  
  QuotaAmountGrat : abap.dec( 13, 2 ); --Importe cuota gratificacion(ZIMPCG)
  
  QuotaNumbers : ze_numcuota; -- Numero de cuotas (ZNCUOT) 
  
  CommentLoan : ze_comenprest; -- Comentario de la solicitud de préstamo admnistrativo (ZCOMEN)
  
  ReqUser : ze_usu_sol; -- Usuario Solicitante (ZUSUSL)
  
  ReqDate : ze_fec_sol; -- Fecha de Solicitud (ZFECSL)
  
  UserAppBossU : ze_usuaproju; -- Usuario aprobador - Jefe de Unidad (ZUSUAPROJU)
  
  DateAppBossU : ze_fecaproju; -- Fecha de aprobación - Jefe de Unidad (ZFECAPROJU)
  
  UserAppBossD : ze_usuaprojd; -- Usuario aprobador - Jefe Descentraliado (ZUSUAPROJD)
  
  DateAppBossD : ze_fecaprojd; -- Fecha de aprobación - Jefe de Descentralizado (ZFECAPROJD)
  
  UserAppAdminP : ze_admpreap; -- Administrador de préstamos AP (ZUSUAPROAP)
  
  DateAppAdminP : ze_fecaproap; -- Fecha de aprobación -Administrador de Préstamos (ZFECAPROAP)
  
  TransgressionInd : ze_trangresion; -- Indicador de Trangresión (ZTRANG)
  
  TransgressionMes : ze_msjtransgre; -- Mensaje de Trangresión (ZMSJTRANGR)
  
  StatusAppAdminP :  ze_est_ap ; -- Estado de la Solicitud Adm. Aprobaciones (ZESTAP)
  
  StatusAppBossD : ze_est_jd; -- Estado de la Solicitud Adm. Aprobaciones (ZESTJD)
  
  StatusAppBossU : ze_est_ju; -- Estado de la Solicitud Jefe de unidad (ZESTJU)
  
  DNINumber :  psg_idnum; -- Número ID (DNI)
  
  Mail : comm_id_long; -- Mail
  
  Obs: alshuffvl_wao; -- Observaciones
  
  TermsConditions : ze_acep_tyc; -- Terminos y condiciones (TERYCOND)
  
  CreatedName : cnam; -- Creado por (CNAME)
  
  CreatedDate : rdir_cdate; -- Fecha de creacion (CDATE)
  
  CreatedTime : c_time ; -- Hora de creacion (CTIME)
  
  ModName : unam; -- Modificado por (UNAME)
  
  ModDate : rdir_udate; -- Fecha de modificacion (UDATE)
  
  ModTime: u_time; -- Hora de modificacion (UTIME)
  
  Currency  : abap.char( 20 ); -- Moneda descripción 
}
