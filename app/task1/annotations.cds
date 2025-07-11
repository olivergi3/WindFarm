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
        Common.QuickInfo : 'Industry Comparison: Range 24%-51.5% | Average: 40.3% | Median: 40.9%'
    );
    
    // Wind Farm Efficiency with Industry Benchmark Tooltip  
    windFarmEfficiency @(
        Common.QuickInfo : 'Industry Comparison: Range 53.2%-82.4% | Average: 68.3% | Median: 67.5%'
    );
    
    // Wind Farm Rated Power with Industry Benchmark Tooltip
    windFarmRatedPowerMW @(
        Common.QuickInfo : 'Industry Comparison: Range 48.3-100000 MW | Average: 634.3 MW | Median: 400 MW'
    );
    
    // Power Density with Industry Benchmark Tooltip
    windFarmDensityMWKm2 @(
        Common.QuickInfo : 'Industry Comparison: Range 2-20 MW/km² | Average: 9.3 MW/km² | Median: 8.6 MW/km²'
    );
    
    // Number of Turbines with Industry Benchmark Tooltip
    numberWT @(
        Common.QuickInfo : 'Industry Comparison: Range 12-6667 turbines | Average: 184.6 turbines | Median: 72 turbines'
    );
    
    // Wind Farm Area with Industry Benchmark Tooltip
    windFarmAreaKm2 @(
        Common.QuickInfo : 'Calculated from total rated power and power density. Industry varies widely based on turbine spacing and terrain.'
    );
    
    // Rotor Diameter with Industry Benchmark Tooltip
    rotorDiameterM @(
        Common.QuickInfo : 'Larger rotors capture more wind energy. Modern offshore turbines typically 120-200m diameter.'
    );
    
    // Nacelle Height with Industry Benchmark Tooltip
    nacelleHeightM @(
        Common.QuickInfo : 'Higher nacelles access stronger, more consistent winds. Offshore turbines typically 80-150m height.'
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
    @Common.Label        : 'Avg Capacity Factor (%)'
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
    @Common.Label        : 'Avg Efficiency (%)'
  },
  Analytics.AggregatedProperty #countWindFarms : {
    Name                 : 'countWindFarms',
    AggregationMethod    : 'countdistinct',
    AggregatableProperty : windFarm,
    @Common.Label        : 'Count of Wind Farms'
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
    Label: '{i18n>Ask AI}'
  },
  {
    Value          : windFarm,
    Label          : 'Wind Farm',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'14em'}
  }, {
    Value          : country,
    Label          : '{i18n>Country1}',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'10em'}
  }, {
    Value          : waterBody,
    Label          : 'Sea',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'10em'}
  }, {
    Value          : windFarmRatedPowerMW,
    Label          : 'Rated Power (MW)',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'12em'}
  }, {
    Value          : windFarmDensityMWKm2,
    Label          : 'Density (MW/km²)',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'12em'}
  }, {
    Value          : capacityFactorReal,
    Label          : 'Capacity Factor (%)',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'14em'}
  }, {
    Value          : windFarmEfficiency,
    Label          : 'Efficiency (%)',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'12em'}
  }, {
    Value          : numberWT,
    Label          : 'Number of Turbines',
    @UI.Importance : #Medium,
    @HTML5.CssDefaults: {width:'12em'}
  }, {
    Value          : windFarmAreaKm2,
    Label          : 'Wind Farm Area (km²)',
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
    TypeName       : 'Wind Farm',
    TypeNamePlural : 'Wind Farm Analytics',
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
      Label  : 'General Information'
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
      Label  : 'Performance Metrics',
      ID     : 'PerformanceMetrics',
      Facets : [
        {
          $Type  : 'UI.ReferenceFacet',
          ID     : 'PowerPerformance',
          Target : '@UI.FieldGroup#PowerPerformance',
          Label  : 'Power & Efficiency'
        },
        {
          $Type  : 'UI.ReferenceFacet',
          ID     : 'CapacityFactors',
          Target : '@UI.FieldGroup#CapacityFactors',
          Label  : 'Capacity Factors'
        }
      ]
    },
    {
      $Type  : 'UI.CollectionFacet',
      Label  : 'Characteristics',
      ID     : 'Characteristics',
      Facets : [
        {
          $Type  : 'UI.ReferenceFacet',
          ID     : 'TurbineCharacteristics',
          Target : '@UI.FieldGroup#TurbineCharacteristics',
          Label  : 'Turbine Specifications'
        },
        {
          $Type  : 'UI.ReferenceFacet',
          ID     : 'WindCharacteristics',
          Target : '@UI.FieldGroup#WindCharacteristics',
          Label  : 'Wind Characteristics'
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
        Label : 'Sea'
      },
      { 
        $Type : 'UI.DataField',
        Value : windFarmAreaKm2, 
        Label : 'Total Area (km²)'
      },
      { 
        $Type : 'UI.DataField',
        Value : numberWT, 
        Label : 'Number of Turbines'
      },
      { 
        $Type : 'UI.DataField',
        Value : windFarmRatedPowerMW, 
        Label : 'Total Rated Power (MW)'
      }
    ]
  },
  
  // Performance Metrics Field Groups (WITH TOOLTIPS)
  FieldGroup #PowerPerformance : { 
    Data : [
      { 
        $Type : 'UI.DataField',
        Value : windFarmRatedPowerMW, 
        Label : 'Rated Power (MW)'
      },
      { 
        $Type : 'UI.DataField',
        Value : windFarmEfficiency, 
        Label : 'Farm Efficiency (%)'
      },
      { 
        $Type : 'UI.DataField',
        Value : windFarmDensityMWKm2, 
        Label : 'Power Density (MW/km²)'
      },
      { 
        $Type : 'UI.DataField',
        Value : ratioCapacityFactorRealModel, 
        Label : 'Real/Model Ratio'
      }
    ]
  },
  
  FieldGroup #CapacityFactors : { 
    Data : [
      { 
        $Type : 'UI.DataField',
        Value : capacityFactorReal, 
        Label : 'Real Capacity Factor (%)'
      },
      { 
        $Type : 'UI.DataField',
        Value : capacityFactorModel, 
        Label : 'Model Capacity Factor (%)'
      },
      { 
        $Type : 'UI.DataField',
        Value : capacityFactorInfiniteFarm, 
        Label : 'Infinite Farm Factor (%)'
      },
      { 
        $Type : 'UI.DataField',
        Value : capacityFactorIsolatedTurbine, 
        Label : 'Isolated Turbine Factor (%)'
      }
    ]
  },
  
  // Characteristics Field Groups (WITH TOOLTIPS)
  FieldGroup #TurbineCharacteristics : { 
    Data : [
      { 
        $Type : 'UI.DataField',
        Value : wtRatedPowerMW, 
        Label : 'Turbine Rated Power (MW)'
      },
      { 
        $Type : 'UI.DataField',
        Value : rotorDiameterM, 
        Label : 'Rotor Diameter (m)'
      },
      { 
        $Type : 'UI.DataField',
        Value : nacelleHeightM, 
        Label : 'Nacelle Height (m)'
      }
    ]
  },
  
  FieldGroup #WindCharacteristics : { 
    Data : [
      { 
        $Type : 'UI.DataField',
        Value : windKw, 
        Label : 'Wind Speed (kW)'
      },
      { 
        $Type : 'UI.DataField',
        Value : windLambda, 
        Label : 'Wind Lambda'
      }
    ]
  }
};

annotate service.WindFarmAnalytics with {
    windFarm @Common.Label : '{i18n>Wind Farm Name}';
};
