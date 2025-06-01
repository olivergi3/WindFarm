using WindFarmService as service from '../../srv/windfarm-service';

// Aggregation Support für WindFarmAnalytics
annotate service.WindFarmAnalytics with @(
  Aggregation.CustomAggregate #windFarmRatedPowerMW : 'Edm.Decimal',
  Aggregation.CustomAggregate #capacityFactorReal : 'Edm.Decimal',
  Aggregation.CustomAggregate #windFarmEfficiency : 'Edm.Decimal',
  Common.SemanticKey : [windFarm],
) {
  windFarm                @ID : 'WindFarm';
  windFarmRatedPowerMW    @Aggregation.default: #SUM;
  capacityFactorReal      @Aggregation.default: #AVERAGE;
  windFarmEfficiency      @Aggregation.default: #AVERAGE;
  numberWT                @Aggregation.default: #SUM;
};

annotate service.WindFarmAnalytics with @Aggregation.ApplySupported : {
  Transformations : [
    'aggregate',
    'topcount',
    'bottomcount',
    'identity',
    'concat',
    'groupby',
    'filter',
    'search'
  ],
  GroupableProperties  : [
    windFarm,
    country,
    powerRatingCategory,
    capacityFactorCategory,
    efficiencyCategory,
    densityCategory,
    numberWT,
    windFarmRatedPowerMW,
    capacityFactorReal,
    windFarmEfficiency,
    windFarmDensityMWKm2
  ],
  AggregatableProperties : [
    {Property : windFarmRatedPowerMW},
    {Property : capacityFactorReal},
    {Property : windFarmEfficiency},
    {Property : numberWT},
    {Property : windFarmDensityMWKm2}
  ],
};

// Analytics Aggregated Properties - Dashboard Style KPIs
annotate service.WindFarmAnalytics with @(
  Analytics.AggregatedProperty #totalWindFarms :
  {
    Name                 : 'totalWindFarms',
    AggregationMethod    : 'countdistinct',
    AggregatableProperty : windFarm,
    @Common.Label        : 'Total Wind Farms'
  },
  Analytics.AggregatedProperty #avgCapacityFactor :
  {
    Name                 : 'avgCapacityFactor',
    AggregationMethod    : 'average',
    AggregatableProperty : capacityFactorReal,
    @Common.Label        : 'Avg Capacity Factor (%)'
  },
  Analytics.AggregatedProperty #totalPower :
  {
    Name                 : 'totalPower',
    AggregationMethod    : 'sum',
    AggregatableProperty : windFarmRatedPowerMW,
    @Common.Label        : 'Total Power (MW)'
  },
  Analytics.AggregatedProperty #avgEfficiency :
  {
    Name                 : 'avgEfficiency',
    AggregationMethod    : 'average',
    AggregatableProperty : windFarmEfficiency,
    @Common.Label        : 'Avg Efficiency (%)'
  },
  Analytics.AggregatedProperty #countWindFarms :
  {
    Name                 : 'countWindFarms',
    AggregationMethod    : 'countdistinct',
    AggregatableProperty : windFarm,
    @Common.Label        : 'Count of Wind Farms'
  }
);

// Main Dashboard KPI Section (große Zahlen-Cards wie Screenshot)
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
    Detail : {
      DefaultPresentationVariant : {
        Visualizations : [
          '@UI.Chart#chartCountryPerformance'
        ],
      },
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
    Detail : {
      DefaultPresentationVariant : {
        Visualizations : [
          '@UI.Chart#chartCapacityComparison'
        ],
      },
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
    Detail : {
      DefaultPresentationVariant : {
        Visualizations : [
          '@UI.Chart#chartPowerDistribution'
        ],
      },
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
    Detail : {
      DefaultPresentationVariant : {
        Visualizations : [
          '@UI.Chart#chartEfficiencyDensity'
        ],
      },
    },
    SelectionVariant : {
      SelectOptions : []
    }
  }
);

// Optimierte Chart-Definitionen für bessere Dashboard-Darstellung

// Chart 1: Power Distribution Donut (wie Screenshot rechts oben)
annotate service.WindFarmAnalytics with @(
  UI.PresentationVariant #pvPowerDistribution : {
    Visualizations : ['@UI.Chart#chartPowerDistribution']
  },
  UI.Chart #chartPowerDistribution : {
    Title               : 'Power Rating Distribution',
    ChartType           : #Donut,
    DynamicMeasures     : [
      '@Analytics.AggregatedProperty#countWindFarms'
    ],
    Dimensions          : [powerRatingCategory],
    MeasureAttributes   : [{
      DynamicMeasure : '@Analytics.AggregatedProperty#countWindFarms',
      Role      : #Axis1
    }],
    DimensionAttributes : [{
      Dimension : powerRatingCategory,
      Role      : #Category
    }]
  }
);

// Chart 2: Efficiency vs Density Scatter (wie Screenshot links unten)  
annotate service.WindFarmAnalytics with @(
  UI.PresentationVariant #pvEfficiencyDensity : {
    Visualizations : ['@UI.Chart#chartEfficiencyDensity']
  },
  UI.Chart #chartEfficiencyDensity : {
    Title               : 'Wind Farm Efficiency vs Density',
    ChartType           : #Scatter,
    Measures            : [windFarmDensityMWKm2, windFarmEfficiency],
    Dimensions          : [country],
    MeasureAttributes   : [{
      Measure : windFarmDensityMWKm2,
      Role    : #Axis1
    }, {
      Measure : windFarmEfficiency,
      Role    : #Axis2
    }],
    DimensionAttributes : [{
      Dimension : country,
      Role      : #Series
    }]
  }
);

// Chart 3: Country Performance (wie Screenshot rechts unten)
annotate service.WindFarmAnalytics with @(
  UI.PresentationVariant #pvCountryPerformance : {
    Visualizations : ['@UI.Chart#chartCountryPerformance']
  },
  UI.Chart #chartCountryPerformance : {
    Title               : 'Country-wise Performance',
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
  }
);

// Main Chart für Analytical List Page (Dashboard-optimiert)
annotate service.WindFarmAnalytics with @UI.Chart : {
  Title               : 'Performance Overview',
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

// Line Item für die Tabelle
annotate service.WindFarmAnalytics with @UI.LineItem : [
  {
    Value          : windFarm,
    Label          : 'Wind Farm',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'15em'},
  }, {
    Value          : country,
    Label          : 'Country',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'10em'},
  }, {
    Value          : windFarmRatedPowerMW,
    Label          : 'Rated Power (MW)',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'12em'},
  }, {
    Value          : windFarmDensityMWKm2,
    Label          : 'Density (MW/km²)',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'12em'},
  }, {
    Value          : capacityFactorReal,
    Label          : 'Capacity Factor (%)',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'14em'},
  }, {
    Value          : windFarmEfficiency,
    Label          : 'Efficiency (%)',
    @UI.Importance : #High,
    @HTML5.CssDefaults: {width:'12em'},
  }, {
    Value          : numberWT,
    Label          : 'Number of Turbines',
    @UI.Importance : #Medium,
    @HTML5.CssDefaults: {width:'12em'},
  }, {
    Value          : powerRatingCategory,
    Label          : 'Power Category',
    @UI.Importance : #Medium,
    @HTML5.CssDefaults: {width:'14em'},
  }
];

// Dashboard-Style Presentation Variant (alle Charts gleichzeitig)
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
    '@UI.Chart',                        // Main Performance Chart
    '@UI.Chart#chartPowerDistribution', // Donut Chart
    '@UI.Chart#chartEfficiencyDensity', // Scatter Plot
    '@UI.Chart#chartCountryPerformance',// Country Bar Chart  
    '@UI.LineItem'                      // Table
  ],
  SortOrder : [{
    Property : windFarmRatedPowerMW,
    Descending : true
  }]
};

// Visual Filter für Country
annotate service.WindFarmAnalytics with @(
  UI.PresentationVariant #pvCountry : {
    Visualizations : ['@UI.Chart#chartCountry']
  },
  UI.Chart #chartCountry : {
    ChartType           : #Bar,
    DynamicMeasures     : [
      '@Analytics.AggregatedProperty#countWindFarms',
    ],
    Dimensions          : [country],
    MeasureAttributes   : [{
      DynamicMeasure : '@Analytics.AggregatedProperty#countWindFarms',
      Role      : #Axis1,
    }],
    DimensionAttributes : [{
      Dimension : country,
      Role      : #Category
    }],
  }
) {
  country @(
    Common.ValueList #vlCountry : {
      CollectionPath               : 'WindFarmAnalytics',
      PresentationVariantQualifier : 'pvCountry',
      Parameters                   : [{
        $Type             : 'Common.ValueListParameterInOut',
        LocalDataProperty : country,
        ValueListProperty : 'country'
      }]
    }
  )
};

// Chart 4: Capacity Factor Bar Chart (wie Screenshot Comparison)
annotate service.WindFarmAnalytics with @(
  UI.PresentationVariant #pvCapacityComparison : {
    Visualizations : ['@UI.Chart#chartCapacityComparison']
  },
  UI.Chart #chartCapacityComparison : {
    Title               : 'Capacity Factor by Wind Farm',
    Description         : 'Performance Comparison',
    ChartType           : #Column,
    Measures            : [capacityFactorReal],
    Dimensions          : [windFarm],
    MeasureAttributes   : [{
      Measure : capacityFactorReal,
      Role    : #Axis1
    }],
    DimensionAttributes : [{
      Dimension : windFarm,
      Role      : #Category
    }]
  }
);

// Performance Category Visual Filter
annotate service.WindFarmAnalytics with @(
  UI.PresentationVariant #pvPerformance : {
    Visualizations : ['@UI.Chart#chartPerformance']
  },
  UI.Chart #chartPerformance : {
    Title               : 'Performance Categories',
    ChartType           : #Donut,
    DynamicMeasures     : [
      '@Analytics.AggregatedProperty#countWindFarms',
    ],
    Dimensions          : [capacityFactorCategory],
    MeasureAttributes   : [{
      DynamicMeasure : '@Analytics.AggregatedProperty#countWindFarms',
      Role      : #Axis1,
    }],
    DimensionAttributes : [{
      Dimension : capacityFactorCategory,
      Role      : #Category
    }]
  }
);

// UI.HeaderInfo für Dashboard-Darstellung
annotate service.WindFarmAnalytics with @UI : {
  HeaderInfo : {
    TypeName       : 'Wind Farm Analytics',
    TypeNamePlural : 'Wind Farm Analytics Dashboard',
    Title          : { Value : 'Wind Farm Performance Dashboard' },
    Description    : { Value : 'Comprehensive Wind Farm Analysis' }
  },
  Identification : [
    { Value : windFarm },
  ],
  Facets : [{
    $Type  : 'UI.CollectionFacet',
    Label  : 'Wind Farm Details',
    ID     : 'WindFarmDetails',
    Facets : [{
      $Type  : 'UI.ReferenceFacet',
      ID     : 'GeneralData',
      Target : '@UI.FieldGroup#GeneralInformation',
      Label  : 'General Information'
    }, {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'PerformanceData',
      Target : '@UI.FieldGroup#PerformanceMetrics',
      Label  : 'Performance Metrics'
    }]
  }],
  FieldGroup #GeneralInformation : { Data : [
    { Value : windFarm, Label : 'Wind Farm Name' },
    { Value : country, Label : 'Country' },
    { Value : numberWT, Label : 'Number of Turbines' },
    { Value : powerRatingCategory, Label : 'Power Category' }
  ]},
  FieldGroup #PerformanceMetrics : { Data : [
    { Value : capacityFactorReal, Label : 'Capacity Factor (%)' },
    { Value : windFarmEfficiency, Label : 'Efficiency (%)' },
    { Value : windFarmRatedPowerMW, Label : 'Rated Power (MW)' },
    { Value : windFarmDensityMWKm2, Label : 'Power Density (MW/km²)' }
  ]},
};

// Selection Fields für Filter Bar
annotate service.WindFarmAnalytics with @UI.SelectionFields : [
  country,
  powerRatingCategory,
  capacityFactorCategory
];