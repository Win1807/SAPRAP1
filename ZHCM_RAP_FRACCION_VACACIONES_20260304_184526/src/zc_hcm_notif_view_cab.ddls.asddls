@EndUserText.label: 'Aprobar,rechazar prestamos'

@ObjectModel.query.implementedBy: 'ABAP:ZCL_HCM_FRAC_VAC'
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }

define root custom entity ZC_HCM_NOTIF_VIEW_CAB
{

  key EmployeeNumberBoss : p_pernr; -- Numero de empleado jefe
      EmployeeNumber     : p_pernr; -- Numbero de empleado
      ReqId              : tim_req_id; -- Request ID
      FirstSubmDate      : datum; -- Fecha de solicitud

      Sname              : smnam; -- Solicitante

      SubtypeDescription : ptarq_uia_awart_text; -- Clase de absentismo

      Begdate            : begda; -- De

      Enddate            : endda; -- A

      Deduction          : ptarq_uia_deduction_text; -- Utilizado tabla

      DeductionTooltip   : char256;        -- Utilizado 2

      PastNotice         : tim_req_notice; -- Notas anteriores 1

      CurrNotice         : tim_req_notice; -- Notas anteriores 2

}
