@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'HCM Current Org. Assgmt'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
define view entity ZI_HCMCurOrglAssgmt_VH
  as select from I_HCMCurOrglAssgmt
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
  key HCMPersonnelNumber,
      @UI.hidden: true
  key HCMSubtype,
      @UI.hidden: true
  key HCMObjectIdentification,
      @UI.hidden: true
  key HCMRecordIsLocked,
  key EndDate,
  key StartDate,
      @UI.hidden: true
  key HCMSequentialNumber,

      @UI.selectionField: [{ position: 10  }]
      HCMPersonnelArea,
      @UI.selectionField: [{ position: 20  }]
      HCMPersonnelSubarea,
      @UI.selectionField: [{ position: 30  }]
      HCMEmployeeGroup,
      @UI.selectionField: [{ position: 40  }]
      HCMEmployeeSubgroup,

      @UI.selectionField: [{ position: 50  }]
      HCMPayrollArea,
      @UI.selectionField: [{ position: 60  }]
      BusinessArea,
      @UI.selectionField: [{ position: 70  }]
      CompanyCode,

      HCMLegalPerson,

      HCMWorkContract,
      @UI.selectionField: [{ position: 80  }]
      CostCenter,

      @UI.selectionField: [{ position: 100  }]
      HCMOrganizationalUnit,

      @UI.selectionField: [{ position: 110  }]
      HCMOrganizationalKey,

      @UI.selectionField: [{ position: 120  }]
      HCMPosition,
      @UI.selectionField: [{ position: 130  }]
      HCMJob,
      @UI.selectionField: [{ position: 120  }]
      HCMSupervisorArea,
      HCMPayrollAdministrator,
      HCMMasterDataAdministrator,
      HCMTimeRecordingAdministrator,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.7
      HCMEmployeeName,
      HCMObjectType,
      HCMAdministratorGroup,
      ControllingArea,
      FundsCenter,
      Fund,
      FunctionalArea,
      GrantID,
      Segment,
      BudgetPeriod,
      /* Associations */
      _BusinessArea,
      _CompanyCode,
      _ControllingArea,
      _CostCenter,
      _FundsCenter,
      _HCMEmployeeGroup,
      _HCMEmployeeSubGroup,
      _HCMJob,
      _HCMOrganizationalUnit,
      _HCMPersonnelArea,
      _HCMPersonnelSubarea,
      _HCMPosition

}
