using WindFarmService as service from '../../srv/windfarm-service';

annotate service.WindFarmCorrelationAnalysis with {
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
        Common.Label : '{i18n>Country1}',
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
        },
        Common.Label : '{i18n>WindFarmName}',
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

// task 3 annotations

// aggregation support
annotate service.WindFarmCorrelationAnalysis with @Aggregation.ApplySupported: {
    Transformations: [
        'aggregate',
        'groupby',
        'filter'
    ],
    GroupableProperties: [
        // basic identifications
        country,
        windFarm,
        waterBody,
        
        // physical characteristics
        rotorDiameterM,
        nacelleHeightM,
        wtRatedPowerMW,
        numberWT,
        windFarmAreaKm2,
        windFarmDensityMWKm2,
        windFarmRatedPowerMW,
        
        // operational characteristics
        capacityFactorReal,
        windFarmEfficiency,

        // efficiency correlation patterns
        heightEfficiencyProfile,
        areaEfficiencyProfile,
        rotorEfficiencyProfile,
        turbineCountEfficiencyProfile,
        wtPowerEfficiencyProfile,
        farmPowerEfficiencyProfile,
        densityEfficiencyProfile,
        
        // capacity factor correlation patterns
        turbineCountCapacityProfile,
        rotorCapacityProfile,
        heightCapacityProfile,
        farmPowerCapacityProfile,
        wtPowerCapacityProfile,
        areaCapacityProfile,
        capacityDensityProfile,
        
        // rated power correlation patterns
        densityRatedPowerProfile,
        turbineCountRatedPowerProfile,
        rotorRatedPowerProfile,
        heightRatedPowerProfile,
        wtRatedPowerProfile,
        areaRatedPowerProfile,
        
        // wt power correlation patterns
        densityWtPowerProfile,
        turbineCountWtPowerProfile,
        rotorWtPowerProfile,
        heightWtPowerProfile,
        areaWtPowerProfile
    ],
    AggregatableProperties: [
        // physical measurements
        { Property: rotorDiameterM },
        { Property: nacelleHeightM },
        { Property: wtRatedPowerMW },
        { Property: numberWT },
        { Property: windFarmAreaKm2 },
        { Property: windFarmDensityMWKm2 },
        
        // performance measurements 
        { Property: capacityFactorReal },
        { Property: windFarmRatedPowerMW },
        { Property: windFarmEfficiency },

        // count
        { Property: windFarm }
    ]
};

// ANALYTICS AGGREGATED PROPERTIES - ERWEITERT
annotate service.WindFarmCorrelationAnalysis with @(
    // basic counts
    Analytics.AggregatedProperty #totalWindFarmsCorr :
    {
        Name                 : 'totalWindFarmsCorr',
        AggregationMethod    : 'countdistinct',
        AggregatableProperty : 'windFarm',
        @Common.Label        : '{i18n>TotalWindFarms}'
    },
    Analytics.AggregatedProperty #countWindFarmsCorr :
    {
        Name                 : 'countWindFarmsCorr',
        AggregationMethod    : 'countdistinct',
        AggregatableProperty : 'windFarm',
        @Common.Label        : '{i18n>CountOfWindFarms}'
    },

    // physical characteristics aggregations (PPC = Physical Performance Characteristic)
    Analytics.AggregatedProperty #avgRotorDiameter :
    {
        Name                 : 'avgRotorDiameter',
        AggregationMethod    : 'average',
        AggregatableProperty : 'rotorDiameterM',
        @Common.Label        : '{i18n>AvgRotorDiameterM}'
    },
    Analytics.AggregatedProperty #avgNacelleHeight :
    {
        Name                 : 'avgNacelleHeight',
        AggregationMethod    : 'average',
        AggregatableProperty : 'nacelleHeightM',
        @Common.Label        : '{i18n>AvgNacelleHeightM}'
    },
    Analytics.AggregatedProperty #avgTurbinePower :
    {
        Name                 : 'avgTurbinePower',
        AggregationMethod    : 'average',
        AggregatableProperty : 'wtRatedPowerMW',
        @Common.Label        : '{i18n>AvgTurbinePowerMw}'
    },
    Analytics.AggregatedProperty #totalTurbines :
    {
        Name                 : 'totalTurbines',
        AggregationMethod    : 'sum',
        AggregatableProperty : 'numberWT',
        @Common.Label        : '{i18n>TotalTurbinesPpc}'
    },
    Analytics.AggregatedProperty #totalArea :
    {
        Name                 : 'totalArea',
        AggregationMethod    : 'sum',
        AggregatableProperty : 'windFarmAreaKm2',
        @Common.Label        : '{i18n>TotalAreaKmPpc}'
    },
    Analytics.AggregatedProperty #avgDensity :
    {
        Name                 : 'avgDensity',
        AggregationMethod    : 'average',
        AggregatableProperty : 'windFarmDensityMWKm2',
        @Common.Label        : '{i18n>AvgDensityMwkmPpc}'
    },

    // operational performance aggregations (OPC = Operational Performance Characteristic)
    Analytics.AggregatedProperty #avgCapacityFactorCorr :
    {
        Name                 : 'avgCapacityFactorCorr',
        AggregationMethod    : 'average',
        AggregatableProperty : 'capacityFactorReal',
        @Common.Label        : '{i18n>AvgCapacityFactor1}'
    },
    Analytics.AggregatedProperty #totalPowerCorr :
    {
        Name                 : 'totalPowerCorr',
        AggregationMethod    : 'sum',
        AggregatableProperty : 'windFarmRatedPowerMW',
        @Common.Label        : '{i18n>TotalPowerMwOpc}'
    },
    Analytics.AggregatedProperty #avgEfficiencyCorr :
    {
        Name                 : 'avgEfficiencyCorr',
        AggregationMethod    : 'average',
        AggregatableProperty : 'windFarmEfficiency',
        @Common.Label        : '{i18n>AvgEfficiencyOpc}'
    }
);

// ui annotations
annotate service.WindFarmCorrelationAnalysis with @(
    // selection fields filter
    UI.SelectionFields : [
        country,
        windFarm,
        waterBody
    ],
    
    // lineitem with all correlations
    UI.LineItem : [
        {
            $Type: 'UI.DataFieldForAction',
            Action: 'WindFarmService.EntityContainer/checkAI',
            Label: '{i18n>Askai}'
        },
        {
            Value          : windFarm,
            Label          : '{i18n>WindFarm}',
            @UI.Importance : #High
        }, {
            Value          : country,
            Label          : '{i18n>Country1}',
            @UI.Importance : #High
        }, {
            Value          : waterBody,
            Label          : '{i18n>Sea}',
            @UI.Importance : #High
        }, 
        // efficiency correlation patterns
        {
            Value          : heightEfficiencyProfile,
            Label          : '{i18n>HeightefficiencyPattern}',
            @UI.Importance : #Medium,
            Criticality    : heightEfficiencyCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : areaEfficiencyProfile,
            Label          : '{i18n>AreaefficiencyPattern}',
            @UI.Importance : #Medium,
            Criticality    : areaEfficiencyCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : rotorEfficiencyProfile,
            Label          : '{i18n>RotorefficiencyPattern}',
            @UI.Importance : #Medium,
            Criticality    : rotorEfficiencyCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : turbineCountEfficiencyProfile,
            Label          : '{i18n>TurbineCountefficiencyPattern}',
            @UI.Importance : #Medium,
            Criticality    : turbineCountEfficiencyCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : wtPowerEfficiencyProfile,
            Label          : '{i18n>WtPowerefficiencyPattern}',
            @UI.Importance : #Medium,
            Criticality    : wtPowerEfficiencyCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : farmPowerEfficiencyProfile,
            Label          : '{i18n>FarmPowerefficiencyPattern}',
            @UI.Importance : #Medium,
            Criticality    : farmPowerEfficiencyCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : densityEfficiencyProfile,
            Label          : '{i18n>DensityefficiencyPattern}',
            @UI.Importance : #High,
            Criticality    : densityEfficiencyCriticality,
            CriticalityRepresentation: #WithoutIcon
        },
        // capacity factor correlation patterns
        {
            Value          : turbineCountCapacityProfile,
            Label          : '{i18n>TurbineCountcapacityPattern}',
            @UI.Importance : #Medium,
            Criticality    : turbineCountCapacityCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : rotorCapacityProfile,
            Label          : '{i18n>RotorcapacityPattern}',
            @UI.Importance : #Medium,
            Criticality    : rotorCapacityCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : heightCapacityProfile,
            Label          : '{i18n>HeightcapacityPattern}',
            @UI.Importance : #Medium,
            Criticality    : heightCapacityCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : farmPowerCapacityProfile,
            Label          : '{i18n>FarmPowercapacityPattern}',
            @UI.Importance : #Medium,
            Criticality    : farmPowerCapacityCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : wtPowerCapacityProfile,
            Label          : '{i18n>WtPowercapacityPattern}',
            @UI.Importance : #Medium,
            Criticality    : wtPowerCapacityCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : areaCapacityProfile,
            Label          : '{i18n>AreacapacityPattern}',
            @UI.Importance : #Medium,
            Criticality    : areaCapacityCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : capacityDensityProfile,
            Label          : '{i18n>CapacitydensityPattern}',
            @UI.Importance : #Medium,
            Criticality    : capacityDensityCriticality,
            CriticalityRepresentation: #WithoutIcon
        },
        // rated power correlation patterns
        {
            Value          : densityRatedPowerProfile,
            Label          : '{i18n>DensityratedPowerPattern}',
            @UI.Importance : #Medium,
            Criticality    : densityRatedPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : turbineCountRatedPowerProfile,
            Label          : '{i18n>TurbineCountratedPowerPattern}',
            @UI.Importance : #Medium,
            Criticality    : turbineCountRatedPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : rotorRatedPowerProfile,
            Label          : '{i18n>RotorratedPowerPattern}',
            @UI.Importance : #Medium,
            Criticality    : rotorRatedPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : heightRatedPowerProfile,
            Label          : '{i18n>HeightratedPowerPattern}',
            @UI.Importance : #Medium,
            Criticality    : heightRatedPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : wtRatedPowerProfile,
            Label          : '{i18n>WtratedPowerPattern}',
            @UI.Importance : #Medium,
            Criticality    : wtRatedPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : areaRatedPowerProfile,
            Label          : '{i18n>ArearatedPowerPattern}',
            @UI.Importance : #Medium,
            Criticality    : areaRatedPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        },
        // wt power correlation patterns
        {
            Value          : densityWtPowerProfile,
            Label          : '{i18n>DensitywtPowerPattern}',
            @UI.Importance : #Medium,
            Criticality    : densityWtPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : turbineCountWtPowerProfile,
            Label          : '{i18n>TurbineCountwtPowerPattern}',
            @UI.Importance : #Medium,
            Criticality    : turbineCountWtPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : rotorWtPowerProfile,
            Label          : '{i18n>RotorwtPowerPattern}',
            @UI.Importance : #Medium,
            Criticality    : rotorWtPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : heightWtPowerProfile,
            Label          : '{i18n>HeightwtPowerPattern}',
            @UI.Importance : #Medium,
            Criticality    : heightWtPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : areaWtPowerProfile,
            Label          : '{i18n>AreawtPowerPattern}',
            @UI.Importance : #Medium,
            Criticality    : areaWtPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }
    ],

    // Presentation Variant 
    UI.PresentationVariant : {
        Text: 'Extended Wind Farm Correlation Analysis Dashboard',
        Visualizations : [
            '@UI.Chart#corrMain',
            '@UI.LineItem'
        ]
    },

    // Facets for Detail-View
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneralInfoFacet',
            Label : '{i18n>GeneralInformation}',
            Target : '@UI.FieldGroup#GeneralInfo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'EfficiencyCorrelationFacet',
            Label : '{i18n>EfficiencyCorrelationPatterns}',
            Target : '@UI.FieldGroup#EfficiencyCorrelations',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'CapacityFactorCorrelationFacet',
            Label : '{i18n>CapacityFactorCorrelationPatterns}',
            Target : '@UI.FieldGroup#CapacityFactorCorrelations',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'RatedPowerCorrelationFacet',
            Label : '{i18n>RatedPowerCorrelationPatterns}',
            Target : '@UI.FieldGroup#RatedPowerCorrelations',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'WtPowerCorrelationFacet',
            Label : '{i18n>WtPowerCorrelationPatterns}',
            Target : '@UI.FieldGroup#WtPowerCorrelations',
        },
    ],

    // FieldGroups
    UI.FieldGroup #GeneralInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : windFarmRatedPowerMW,
                Label : '{i18n>WindFarmRatedPower}',
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmDensityMWKm2,
                Criticality : windFarmDensityCriticality,
                CriticalityRepresentation: #WithoutIcon,
                Label : '{i18n>WindFarmDensityMwkm}',
            },
            {
                $Type : 'UI.DataField',
                Value : capacityFactorReal,
                Criticality : capacityFactorCriticality,
                CriticalityRepresentation: #WithoutIcon,
                Label : '{i18n>CapacityFactorReal}',
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmEfficiency,
                Criticality : windFarmEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon,
                Label : '{i18n>WindFarmEfficiency}',
            },
            {
                $Type : 'UI.DataField',
                Value : numberWT,
                Label : '{i18n>NumberOfWindTurbines}',
            },
            {
                $Type : 'UI.DataField',
                Value : rotorDiameterM,
                Label : '{i18n>RotorDiameterM}',
            },
            {
                $Type : 'UI.DataField',
                Value : nacelleHeightM,
                Label : '{i18n>NacelleHeightM}',
            },
            {
                $Type : 'UI.DataField',
                Value : wtRatedPowerMW,
                Label : '{i18n>WtRatedPowerMw}',
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmAreaKm2,
                Label : '{i18n>WindFarmAreaKm}',
            }
        ],
    },

    UI.FieldGroup #HeadInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : windFarm,
                Label : '{i18n>WindFarmName}',
            },
            {
                $Type : 'UI.DataField',
                Value : country,
                Label : '{i18n>Country1}',
            },
            {
                $Type : 'UI.DataField',
                Value : waterBody,
                Label : '{i18n>Sea}',
            }
        ],
    },

    UI.FieldGroup #EfficiencyCorrelations : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : densityEfficiencyProfile,
                Label: '{i18n>DensityefficiencyPattern}',
                Criticality : densityEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : heightEfficiencyProfile,
                Label: '{i18n>HeightefficiencyPattern}',
                Criticality : heightEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : areaEfficiencyProfile,
                Label: '{i18n>AreaefficiencyPattern}',
                Criticality : areaEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : rotorEfficiencyProfile,
                Label: '{i18n>RotorefficiencyPattern}',
                Criticality : rotorEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : turbineCountEfficiencyProfile,
                Label: '{i18n>TurbineCountefficiencyPattern}',
                Criticality : turbineCountEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : wtPowerEfficiencyProfile,
                Label: '{i18n>WtPowerefficiencyPattern}',
                Criticality : wtPowerEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : farmPowerEfficiencyProfile,
                Label: '{i18n>FarmPowerefficiencyPattern}',
                Criticality : farmPowerEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon
            }
        ],
    },

    UI.FieldGroup #CapacityFactorCorrelations : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : capacityDensityProfile,
                Label: '{i18n>CapacitydensityPattern}',
                Criticality : capacityDensityCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : turbineCountCapacityProfile,
                Label: '{i18n>TurbineCountcapacityPattern}',
                Criticality : turbineCountCapacityCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : rotorCapacityProfile,
                Label: '{i18n>RotorcapacityPattern}',
                Criticality : rotorCapacityCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : heightCapacityProfile,
                Label: '{i18n>HeightcapacityPattern}',
                Criticality : heightCapacityCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : farmPowerCapacityProfile,
                Label: '{i18n>FarmPowercapacityPattern}',
                Criticality : farmPowerCapacityCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : wtPowerCapacityProfile,
                Label: '{i18n>WtPowercapacityPattern}',
                Criticality : wtPowerCapacityCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : areaCapacityProfile,
                Label: '{i18n>AreacapacityPattern}',
                Criticality : areaCapacityCriticality,
                CriticalityRepresentation: #WithoutIcon
            }
        ],
    },

    UI.FieldGroup #RatedPowerCorrelations : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : densityRatedPowerProfile,
                Label: '{i18n>DensityratedPowerPattern}',
                Criticality : densityRatedPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : turbineCountRatedPowerProfile,
                Label: '{i18n>TurbineCountratedPowerPattern}',
                Criticality : turbineCountRatedPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : rotorRatedPowerProfile,
                Label: '{i18n>RotorratedPowerPattern}',
                Criticality : rotorRatedPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : heightRatedPowerProfile,
                Label: '{i18n>HeightratedPowerPattern}',
                Criticality : heightRatedPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : wtRatedPowerProfile,
                Label: '{i18n>WtratedPowerPattern}',
                Criticality : wtRatedPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : areaRatedPowerProfile,
                Label: '{i18n>ArearatedPowerPattern}',
                Criticality : areaRatedPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            }
        ],
    },

    UI.FieldGroup #WtPowerCorrelations : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : densityWtPowerProfile,
                Label: '{i18n>DensitywtPowerPattern}',
                Criticality : densityWtPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : turbineCountWtPowerProfile,
                Label: '{i18n>TurbineCountwtPowerPattern}',
                Criticality : turbineCountWtPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : rotorWtPowerProfile,
                Label: '{i18n>RotorwtPowerPattern}',
                Criticality : rotorWtPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : heightWtPowerProfile,
                Label: '{i18n>HeightwtPowerPattern}',
                Criticality : heightWtPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : areaWtPowerProfile,
                Label: '{i18n>AreawtPowerPattern}',
                Criticality : areaWtPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            }
        ],
    }
);

// Chart
annotate service.WindFarmCorrelationAnalysis with @(
    UI.Chart #corrMain : {
        Title               : '{i18n>PhysicalVsOperationalAnalysis}',
        ChartType           : #ColumnDual,
        DynamicMeasures     : [
            '@Analytics.AggregatedProperty#avgDensity',
            '@Analytics.AggregatedProperty#avgCapacityFactorCorr'
        ],
        Dimensions          : [ 'windFarm'],
        MeasureAttributes   : [
            {
                DynamicMeasure : '@Analytics.AggregatedProperty#avgDensity',
                Role      : #Axis1
            },
            {
                DynamicMeasure : '@Analytics.AggregatedProperty#avgCapacityFactorCorr',
                Role      : #Axis2
            }
        ],
        DimensionAttributes : [{
            Dimension : 'windFarm', 
            Role      : #Category
        }]
        
    },
);

// Header Info for Object Page
annotate service.WindFarmCorrelationAnalysis with @UI : {
    HeaderInfo : {
        TypeName       : '{i18n>WindFarmExtendedCorrelation}',
        TypeNamePlural : '{i18n>WindFarmExtendedCorrelation1}',
        Title          : { Value : 'Wind Farm Correlation Analysis' },
        Description    : { Value : '{i18n>ComprehensivePerformancePatternAnalysis}' },
        ImageUrl       : windFarmImageUrl
    },

    HeaderFacets : [
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'HeaderGeneralInfo',
      Target : '@UI.FieldGroup#HeadInfo',
      Label  : '{i18n>GeneralInformation}'
    }
  ],
    Identification : [
        { Value : windFarm },
       // { Value : performanceProfile },      // kommt zu task 4
       // { Value : performanceScore },         // kommt zu task 4
       // { Value : optimizationPotential },         // kommt zu task 4
        // Key Identifiers
        { Value : heightEfficiencyProfile },
        { Value : rotorCapacityProfile },
        { Value : densityRatedPowerProfile }
    ]
};
annotate service.WindFarmCorrelationAnalysis with {
    rotorDiameterM @Common.Label : '{i18n>RotorDiameterM}'
};

annotate service.WindFarmCorrelationAnalysis with {
    nacelleHeightM @Common.Label : '{i18n>NacelleHeightM}'
};

annotate service.WindFarmCorrelationAnalysis with {
    wtRatedPowerMW @Common.Label : '{i18n>WtRatedPowerMw}'
};

annotate service.WindFarmCorrelationAnalysis with {
    numberWT @Common.Label : '{i18n>NumberOfWindTurbines}'
};

annotate service.WindFarmCorrelationAnalysis with {
    windFarmAreaKm2 @Common.Label : '{i18n>WindFarmAreaKm}'
};

annotate service.WindFarmCorrelationAnalysis with {
    windFarmDensityMWKm2 @Common.Label : '{i18n>WindFarmDensityMwkm}'
};

annotate service.WindFarmCorrelationAnalysis with {
    windFarmRatedPowerMW @Common.Label : '{i18n>WindFarmRatedPower}'
};

annotate service.WindFarmCorrelationAnalysis with {
    capacityFactorReal @Common.Label : '{i18n>CapacityFactorReal}'
};

annotate service.WindFarmCorrelationAnalysis with {
    windFarmEfficiency @Common.Label : '{i18n>WindFarmEfficiency}'
};

