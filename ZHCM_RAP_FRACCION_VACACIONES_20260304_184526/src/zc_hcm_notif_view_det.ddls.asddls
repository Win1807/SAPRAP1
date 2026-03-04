@EndUserText.label: 'Aprobar,rechazar prestamos'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_FRAC_VAC'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root custom entity ZC_HCM_NOTIF_VIEW_DET
{ 

  key EmployeeNumberBoss  : p_pernr; -- Numero de empleado jefe
  
  key EmployeeNumber  : p_pernr; -- Numero de empleado del solicitante
  
  TimeType : ptarq_uia_timetype; -- Cta. 
  
  TymeTypeText : kotxt; -- Cuenta de tiempos
  
  DeductBegin : ptm_dedstart; -- Deducible de
  
  DeductEnd : ptm_dedend; -- Deducible a
  
  BeginDate : begda; -- Desde
  
  EndDate : endda; -- Hasta
  
  Entitle : ptarq_entitle ; -- Derecho
  
  DeductedReduced : ptarq_deducted_reduced; -- Utilizado hasta hoy
  
  DeductedReducedFut : ptarq_deducted_reduced_fut ; -- Baja futura
  
  Requested : ptarq_requested; -- Solicitado
  
  DeductedReducedFutRequested : ptarq_deducted_reduced_fut_req ; --Planificado
  
  RestUsed : ptarq_rest_used ; --Restantes
  
  RestPosted : ptarq_rest_posted ; -- Restantes
  
  RestPostedRequested : ptarq_rest_posted_requested; -- Restantes
  
}
