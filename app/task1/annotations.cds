using WindFarmService as service from '../../srv/windfarm-service';

// VALUE HELP ANNOTATIONS 
annotate service.WindFarmAnalytics with {
    // Country Value Help - references the grouped country entity
    country @(
        Common.ValueList : {
            CollectionPath : 'CountryValueHelp',
            Parameters : [{
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : country,
                ValueListProperty : 'country'
            }]
        },
        Common.Label : '{i18n>Country}',
    );

     // Wind Farm Value Help - references the grouped windFarm entity
    windFarm @(
        Common.ValueList : {
            CollectionPath : 'windFarmValueHelp',
            Parameters : [{
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : windFarm,
                ValueListProperty : 'windFarm'
            }]
        }
    );

     // Sea Value Help - references the grouped sea entity
    waterBody @(
        Common.ValueList : {
            CollectionPath : 'waterBodyValueHelp',
            Parameters : [{
                $Type : 'Common.ValueListParameterInOut',
                LocalDataProperty : waterBody,
                ValueListProperty : 'waterBody'
            }]
        },
        Common.Label : '{i18n>Sea}',
    );
}

// TOOLTIPS FOR TASK1 - Industry Benchmark Information
annotate service.WindFarmAnalytics with {
    // Country with Distribution Information
    country @(
        Common.QuickInfo : 'Country Distribution: DE: 29 farms | DK: 8 farms | NL: 6 farms | BE: 10 farms | UK: 52 farms'
    );
    
    // Capacity Factor with Industry Benchmark Tooltip
    capacityFactorReal @(
        Common.QuickInfo : 'Industry Comparison: Range 24%-51.5% | Average: 40.3% | Median: 40.9%',
        Common.Label : '{i18n>CapacityFactorReal}',
    );
    
    // Wind Farm Efficiency with Industry Benchmark Tooltip  
    windFarmEfficiency @(
        Common.QuickInfo : 'Industry Comparison: Range 53.2%-82.4% | Average: 68.3% | Median: 67.5%',
        Common.Label : '{i18n>WindFarmEfficiency}',
    );
    
    // Wind Farm Rated Power with Industry Benchmark Tooltip
    windFarmRatedPowerMW @(
        Common.QuickInfo : 'Industry Comparison: Range 48.3-100000 MW | Average: 634.3 MW | Median: 400 MW',
        Common.Label : '{i18n>WindFarmRatedPower}',
    );
    
    // Power Density with Industry Benchmark Tooltip
    windFarmDensityMWKm2 @(
        Common.QuickInfo : 'Industry Comparison: Range 2-20 MW/km² | Average: 9.3 MW/km² | Median: 8.6 MW/km²',
        Common.Label : '{i18n>WindFarmDensityMwkm}',
    );
    
    // Number of Turbines with Industry Benchmark Tooltip
    numberWT @(
        Common.QuickInfo : 'Industry Comparison: Range 12-6667 turbines | Average: 184.6 turbines | Median: 72 turbines',
        Common.Label : '{i18n>NumberOfWindTurbines}',
    );
    
    // Wind Farm Area with Industry Benchmark Tooltip
    windFarmAreaKm2 @(
        Common.QuickInfo : 'Industry Comparison: Range 2-5000 turbines | Average: 247.58 km² | Median: 39 km²',
        Common.Label : '{i18n>WindFarmAreaKm}',
    );
    
    // Rotor Diameter with Industry Benchmark Tooltip
    rotorDiameterM @(
        Common.QuickInfo : 'Larger rotors capture more wind energy. Modern offshore turbines typically 120-200m diameter.',
        Common.Label : '{i18n>RotorDiameterM}',
    );
    
    // Nacelle Height with Industry Benchmark Tooltip
    nacelleHeightM @(
        Common.QuickInfo : 'Higher nacelles access stronger, more consistent winds. Offshore turbines typically 80-150m height.',
        Common.Label : '{i18n>NacelleHeightM}',
    );
}

// Basic Aggregation Support for Analytical List Page
annotate service.WindFarmAnalytics with @Aggregation.ApplySupported : {
  Transformations : [
    'aggregate',
    'groupby',
    'filter'
  ],
  GroupableProperties  : [
    windFarm,
    country,
    waterBody,
    numberWT,
    windFarmRatedPowerMW,
    capacityFactorReal,
    windFarmEfficiency,
    windFarmDensityMWKm2,
    rotorDiameterM,
    nacelleHeightM,
    windFarmAreaKm2,
    windKw,
    windLambda,
    wtRatedPowerMW,
    capacityFactorModel,
    capacityFactorInfiniteFarm,
    capacityFactorIsolatedTurbine,
    ratioCapacityFactorRealModel
  ],
  AggregatableProperties : [
    {Property : windFarmRatedPowerMW},
    {Property : capacityFactorReal},
    {Property : windFarmEfficiency},
    {Property : numberWT},
    {Property : windFarmDensityMWKm2},
    {Property : windFarm}
  ]
};

// Basic Analytics Properties for ALP
annotate service.WindFarmAnalytics with @(
  Analytics.AggregatedProperty #totalWindFarms : {
    Name                 : 'totalWindFarms',
    AggregationMethod    : 'countdistinct',
    AggregatableProperty : windFarm,
    @Common.Label        : '{i18n>TotalWindFarms}'
  },
  Analytics.AggregatedProperty #avgCapacityFactor : {
    Name                 : 'avgCapacityFactor',
    AggregationMethod    : 'average',
    AggregatableProperty : capacityFactorReal,
    @Common.Label        : '{i18n>AvgCapacityFactor}'
  },
  Analytics.AggregatedProperty #totalPower : {
    Name                 : 'totalPower',
    AggregationMethod    : 'sum',
    AggregatableProperty : windFarmRatedPowerMW,
    @Common.Label        : '{i18n>TotalPowerMw}'
  },
  Analytics.AggregatedProperty #avgEfficiency : {
    Name                 : 'avgEfficiency',
    AggregationMethod    : 'average',
    AggregatableProperty : windFarmEfficiency,
    @Common.Label        : '{i18n>Avgefficiency}'
  },
  Analytics.AggregatedProperty #countWindFarms : {
    Name                 : 'countWindFarms',
    AggregationMethod    : 'countdistinct',
    AggregatableProperty : windFarm,
    @Common.Label        : '{i18n>CountOfWindFarms}'
  }
);

// Basic KPI Cards for ALP
annotate service.WindFarmAnalytics with @(
  UI.KPI #totalWindFarmsKPI : {
    DataPoint : {
      Value       : windFarm,
      Title       : 'Total Wind Farms',
      Description : 'Count of Wind Farms',
      CriticalityCalculation : {
        ImprovementDirection: #Maximize,
        AcceptanceRangeLowValue: 50
      }
    },
    SelectionVariant : {
      SelectOptions : []
    }
  },
  
  UI.KPI #avgCapacityFactorKPI : {
    DataPoint : {
      Value       : capacityFactorReal,
      Title       : 'Avg Capacity Factor',
      Description : 'Average Capacity Factor (%)',
      CriticalityCalculation : {
        ImprovementDirection: #Maximize,
        AcceptanceRangeLowValue: 35,
        ToleranceRangeLowValue: 30
      }
    },
    SelectionVariant : {
      SelectOptions : []
    }
  },
  
  UI.KPI #totalPowerKPI : {
    DataPoint : {
      Value       : windFarmRatedPowerMW,
      Title       : 'Total Power',
      Description : 'Total Power (MW)',
      CriticalityCalculation : {
        ImprovementDirection: #Maximize,
        AcceptanceRangeLowValue: 20000,
        ToleranceRangeLowValue: 15000
      }
    },
    SelectionVariant : {
      SelectOptions : []
    }
  },
  
  UI.KPI #avgEfficiencyKPI : {
    DataPoint : {
      Value       : windFarmEfficiency,
      Title       : 'Avg Efficiency',
      Description : 'Average Efficiency (%)',
      CriticalityCalculation : {
        ImprovementDirection: #Maximize,
        AcceptanceRangeLowValue: 65,
        ToleranceRangeLowValue: 60
      }
    },
    SelectionVariant : {
      SelectOptions : []
    }
  }
);

// Simple Chart for ALP
annotate service.WindFarmAnalytics with @UI.Chart : {
  Title               : '{i18n>PerformanceOverview}',
  Description         : 'Total Power by Country',
  ChartType           : #Column,
  DynamicMeasures     : [
    '@Analytics.AggregatedProperty#totalPower'
  ],
  Dimensions          : [country],
  MeasureAttributes   : [{
    DynamicMeasure : '@Analytics.AggregatedProperty#totalPower',
    Role    : #Axis1
  }],
  DimensionAttributes : [{
    Dimension : country,
    Role      : #Category
  }]
};

// Simple LineItem for ALP
annotate service.WindFarmAnalytics with @UI.LineItem : [
  {
    $Type: 'UI.DataFieldForAction',
    Action: 'WindFarmService.EntityContainer/checkAI',
    Label: '{i18n>Askai}'
  },
  {
    Value          : windFarm,
    Label          : '{i18n>WindFarm}',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'14em'}
  }, {
    Value          : country,
    Label          : '{i18n>Country}',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'10em'}
  }, {
    Value          : waterBody,
    Label          : '{i18n>Sea}',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'10em'}
  }, {
    Value          : windFarmRatedPowerMW,
    Label          : '{i18n>RatedPowerMw}',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'12em'}
  }, {
    Value          : windFarmDensityMWKm2,
    Label          : '{i18n>DensityMwkm}',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'12em'}
  }, {
    Value          : capacityFactorReal,
    Label          : '{i18n>CapacityFactor}',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'14em'}
  }, {
    Value          : windFarmEfficiency,
    Label          : '{i18n>Efficiency}',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'12em'}
  }, {
    Value          : numberWT,
    Label          : '{i18n>NumberOfTurbines}',
    @UI.Importance : #Medium,
    @HTML5.CssDefaults: {width:'12em'}
  }, {
    Value          : windFarmAreaKm2,
    Label          : '{i18n>WindFarmAreaKm}',
    @UI.Importance : #Medium,
    @HTML5.CssDefaults: {width:'12em'}
  },
];

// Simple Presentation Variant for ALP
annotate service.WindFarmAnalytics with @UI.PresentationVariant : {
  Text: 'Wind Farm Dashboard',
  GroupBy : [
    country
  ],
  Total : [
    windFarmRatedPowerMW,
    numberWT
  ],
  Visualizations : [
    '@UI.Chart',                         
    '@UI.LineItem'                      
  ],
  SortOrder : [{
    Property : windFarmRatedPowerMW,
    Descending : true
  }]
};

// Enhanced Selection Fields for ALP - including category fields with value help
annotate service.WindFarmAnalytics with @UI.SelectionFields : [
  country,
  windFarm,
  waterBody
];

// ENHANCED OBJECT PAGE with General Info in Header and Reorganized Metrics
annotate service.WindFarmAnalytics with @UI : {
  HeaderInfo : {
    TypeName       : '{i18n>WindFarm}',
    TypeNamePlural : '{i18n>WindFarmAnalytics}',
    Title          : { Value : windFarm },
    Description    : { Value : country }, 
    ImageUrl       : windFarmImageUrl
  },
  
  // Enhanced Header Facets
  HeaderFacets : [
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'HeaderGeneralInfo',
      Target : '@UI.FieldGroup#HeaderGeneralInfo',
      Label  : '{i18n>GeneralInformation}'
    }
  ],
  
  Identification : [
    { Value : windFarm },
    { Value : country },
    { Value : waterBody}
  ],
  
  //  Facet Structure
  Facets : [
    {
      $Type  : 'UI.CollectionFacet',
      Label  : '{i18n>PerformanceMetrics}',
      ID     : 'PerformanceMetrics',
      Facets : [
        {
          $Type  : 'UI.ReferenceFacet',
          ID     : 'PowerPerformance',
          Target : '@UI.FieldGroup#PowerPerformance',
          Label  : '{i18n>PowerEfficiency}'
        },
        {
          $Type  : 'UI.ReferenceFacet',
          ID     : 'CapacityFactors',
          Target : '@UI.FieldGroup#CapacityFactors',
          Label  : '{i18n>CapacityFactors}'
        }
      ]
    },
    {
      $Type  : 'UI.CollectionFacet',
      Label  : '{i18n>Characteristics}',
      ID     : 'Characteristics',
      Facets : [
        {
          $Type  : 'UI.ReferenceFacet',
          ID     : 'TurbineCharacteristics',
          Target : '@UI.FieldGroup#TurbineCharacteristics',
          Label  : '{i18n>TurbineSpecifications}'
        },
        {
          $Type  : 'UI.ReferenceFacet',
          ID     : 'WindCharacteristics',
          Target : '@UI.FieldGroup#WindCharacteristics',
          Label  : '{i18n>WindCharacteristics}'
        }
      ]
    }
  ],
  
  // Header Field Groups - General Information (WITH TOOLTIPS)
  FieldGroup #HeaderGeneralInfo : { 
    Data : [
      { 
        $Type : 'UI.DataField',
        Value : waterBody, 
        Label : '{i18n>Sea}'
      },
      { 
        $Type : 'UI.DataField',
        Value : windFarmAreaKm2, 
        Label : '{i18n>TotalAreaKm}'
      },
      { 
        $Type : 'UI.DataField',
        Value : numberWT, 
        Label : '{i18n>NumberOfTurbines}'
      },
      { 
        $Type : 'UI.DataField',
        Value : windFarmRatedPowerMW, 
        Label : '{i18n>TotalRatedPowerMw}',
        @UI.Hidden,
      }
    ]
  },
  
  // Performance Metrics Field Groups (WITH TOOLTIPS)
  FieldGroup #PowerPerformance : { 
    Data : [
      { 
        $Type : 'UI.DataField',
        Value : windFarmRatedPowerMW, 
        Label : '{i18n>RatedPowerMw}'
      },
      { 
        $Type : 'UI.DataField',
        Value : windFarmEfficiency, 
        Label : '{i18n>FarmEfficiency}'
      },
      { 
        $Type : 'UI.DataField',
        Value : windFarmDensityMWKm2, 
        Label : '{i18n>PowerDensityMwkm}'
      },
      { 
        $Type : 'UI.DataField',
        Value : ratioCapacityFactorRealModel, 
        Label : '{i18n>RealmodelRatio}'
      }
    ]
  },
  
  FieldGroup #CapacityFactors : { 
    Data : [
      { 
        $Type : 'UI.DataField',
        Value : capacityFactorReal, 
        Label : '{i18n>RealCapacityFactor}'
      },
      { 
        $Type : 'UI.DataField',
        Value : capacityFactorModel, 
        Label : '{i18n>ModelCapacityFactor}'
      },
      { 
        $Type : 'UI.DataField',
        Value : capacityFactorInfiniteFarm, 
        Label : '{i18n>InfiniteFarmFactor}'
      },
      { 
        $Type : 'UI.DataField',
        Value : capacityFactorIsolatedTurbine, 
        Label : '{i18n>IsolatedTurbineFactor}'
      }
    ]
  },
  
  // Characteristics Field Groups (WITH TOOLTIPS)
  FieldGroup #TurbineCharacteristics : { 
    Data : [
      { 
        $Type : 'UI.DataField',
        Value : wtRatedPowerMW, 
        Label : '{i18n>TurbineRatedPowerMw}'
      },
      { 
        $Type : 'UI.DataField',
        Value : rotorDiameterM, 
        Label : '{i18n>RotorDiameterM}'
      },
      { 
        $Type : 'UI.DataField',
        Value : nacelleHeightM, 
        Label : '{i18n>NacelleHeightM}'
      }
    ]
  },
  
  FieldGroup #WindCharacteristics : { 
    Data : [
      { 
        $Type : 'UI.DataField',
        Value : windKw, 
        Label : '{i18n>WindSpeedKw}'
      },
      { 
        $Type : 'UI.DataField',
        Value : windLambda, 
        Label : '{i18n>WindLambda}'
      }
    ]
  }
};

annotate service.WindFarmAnalytics with {
    windFarm @Common.Label : '{i18n>WindFarmName}';
};
annotate service.WindFarmAnalytics with {
    windKw @Common.Label : '{i18n>WindKw}'
};

annotate service.WindFarmAnalytics with {
    windLambda @Common.Label : '{i18n>WindLambda}'
};

annotate service.WindFarmAnalytics with {
    wtRatedPowerMW @Common.Label : '{i18n>WtRatedPowerMw}'
};

annotate service.WindFarmAnalytics with {
    capacityFactorModel @Common.Label : '{i18n>CapacityFactorModel}'
};

annotate service.WindFarmAnalytics with {
    capacityFactorInfiniteFarm @Common.Label : '{i18n>CapacityFactorInfiniteFarm}'
};

annotate service.WindFarmAnalytics with {
    capacityFactorIsolatedTurbine @Common.Label : '{i18n>CapacityFactorIsolatedTurbine}'
};

annotate service.WindFarmAnalytics with {
    ratioCapacityFactorRealModel @Common.Label : '{i18n>RatioCfRealmodel}'
};

