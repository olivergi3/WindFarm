using WindFarmService as service from '../../srv/windfarm-service';

annotate service.WindFarmRecommendations with {
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
        }
    );

    performanceProfile @(
        Common.ValueList: {
            Label: 'Performance Profile Categories',
            CollectionPath: 'PerformanceProfileValueHelp',
            SearchSupported: true,
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: performanceProfile,
                    ValueListProperty: 'performanceprofile'
                }
            ]
        }
    );

    optimizationPotential @(
        Common.ValueList: {
            Label: 'Optimization Potential Categories',
            CollectionPath: 'OptimizationPotentialValueHelp',
            SearchSupported: true,
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: optimizationPotential,
                    ValueListProperty: 'optimizationpotential'
                }
            ]
        }
    );
};



annotate service.WindFarmRecommendations with @(
    
    // Object Page Header Information
    UI.HeaderInfo: {
        $Type: 'UI.HeaderInfoType',
        TypeName: 'Wind Farm Recommendations',
        TypeNamePlural: 'Wind Farm Recommendations Dashboard',
        Title: { Value: 'Wind Farm Summary'},
        Description: { Value : 'General Information, Classification and Recommendations'},
        ImageUrl : windFarmImageUrl
    },
    
    // Header Facets with KPIs
    UI.HeaderFacets: [
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'HeaderGeneralInfo',
            Target : '@UI.FieldGroup#HeadInfo',
            Label  : 'General Information'
        },
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'furtherStudyKPI',
            Target: '@UI.DataPoint#furtherStudy',

        },
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'PerformanceKPI',
            Target: '@UI.DataPoint#performanceProfile',

        },
        {
            $Type: 'UI.ReferenceFacet', 
            ID: 'OptimizationKPI',
            Target: '@UI.DataPoint#optimizationPotential',
        }
    ]
);

// task 4 annotations

// aggregation support

annotate service.WindFarmRecommendations with @Aggregation.ApplySupported : {
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
        capacityFactorCategory,
        efficiencyCategory,
        powerRatingCategory,
        densityCategory,
        rotorDiameterCategory,
        nacelleHeightCategory,
        windFarmAreaCategory,
        turbineCountCategory,
        wtRatedPowerCategory,

        
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
        performanceProfile,     
        optimizationPotential, 

        
    ],
    AggregatableProperties: [
        // count
        { Property: capacityFactorReal },
        { Property: windFarmEfficiency }
    ]    
};

// Aggregated Properties 
annotate service.WindFarmRecommendations with @(
    Analytics.AggregatedProperty #avgCapacityFactorCorr :
    {
        Name                 : 'avgCapacityFactorCorr',
        AggregationMethod    : 'average',
        AggregatableProperty : 'capacityFactorReal',
        @Common.Label        : '{i18n>AvgCapacityFactor}'
    },
    Analytics.AggregatedProperty #avgEfficiencyCorr :
    {
        Name                 : 'avgEfficiencyCorr',
        AggregationMethod    : 'average',
        AggregatableProperty : 'windFarmEfficiency',
        @Common.Label        : '{i18n>Avgefficiency}'
    }
);
// ui annotations
annotate service.WindFarmRecommendations with @(
    // selection fields filter
     UI.SelectionFields : [
        country,
        windFarm,
        waterBody,
        performanceProfile,   
        optimizationPotential   
     ],

     // lineitem with everything
    UI.LineItem : [
        {
            $Type: 'UI.DataFieldForAction',
            Action: 'WindFarmService.EntityContainer/checkAI',
            Label: '{i18n>Ask AI}'
        },
        {
            Value          : windFarm,
            Label          : '{i18n>WindFarm}',
            @UI.Importance : #High
        }, {
            Value          : country,
            Label          : 'Country',
            @UI.Importance : #High
        }, {
            Value          : waterBody,
            Label          : 'Sea',
            @UI.Importance : #High
        }, {
            Value          : efficiencyCategory,
            Label          : 'Efficiency Class',
            Criticality: efficiencyCriticality,
            @UI.Importance : #High
        }, {
            Value          : capacityFactorCategory,
            Label          : 'Capacity Factor Class',
            Criticality: capacityFactorCriticality,
            @UI.Importance : #High
        }, {
            Value          : powerRatingCategory,
            Label          : 'Power Rating Class',
            Criticality: powerRatingCriticality,
            @UI.Importance : #High
        }, {
            Value          : densityCategory,
            Label          : 'Density Class',
            Criticality: densityCriticality,
            @UI.Importance : #High
        }, {
            Value          : rotorDiameterCategory,
            Label          : 'Rotor Diameter Class',
            @UI.Importance : #High,
            Criticality: rotorDiameterCriticality
        }, {
            Value          : nacelleHeightCategory,
            Label          : 'Nacelle Height Class',
            Criticality: nacelleHeightCriticality,
            @UI.Importance : #High
        }, {
            Value          : windFarmAreaCategory,
            Label          : 'Wind Farm Area Class',
            Criticality: windFarmAreaCriticality,
            @UI.Importance : #High
        }, {
            Value          : turbineCountCategory,
            Label          : 'Turbine Count Class',
            Criticality: turbineCountCriticality,
            @UI.Importance : #High
        }, {
            Value          : wtRatedPowerCategory,
            Label          : 'WT Rated Power Class',
            Criticality: wtRatedPowerCriticality,
            @UI.Importance : #High
        }, 
        // existing correlation patterns
        {
            Value          : performanceProfile,   
            Label          : 'Performance Profile',
            Criticality: performanceProfileCriticality,
            @UI.Importance : #High
        },
        {
            Value          : optimizationPotential,       
            Label          : 'Optimization Potential',
            Criticality : optimizationPotentialCriticality,
            @UI.Importance : #High
        }, 

    ],

    UI.Identification: [
        {
            $Type: 'UI.DataField',
            Value: windFarm,
            Label: 'Wind Farm Name'
        }
    ],

    // Presentation Variant
    UI.PresentationVariant : {
        Text: 'Wind Farm Recommendations Dashboard',
        Visualizations : [
            '@UI.Chart#recommendationMain',
            '@UI.LineItem'
        ],
        SortOrder : [{
            Property : 'windFarmDensityMWKm2',
            Descending : true
        }]
    },

    // Facets
    UI.Facets : [
        {
            $Type : 'UI.CollectionFacet',
            ID : 'GeneratedFacet1',
            Label : '{i18n>General Information}',
            Facets: [
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
                },
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
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'ClassificationFacet',
            Label : '{i18n>Classifications}',
            Target : '@UI.FieldGroup#ClassificationGroup'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'RecommendationFacet',
            Label : '{i18n>Performance and Recommendation}',
            Target : '@UI.FieldGroup#Recommendation'
        }
    ],



    UI.FieldGroup #ClassificationGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : capacityFactorCategory,
                Label: '{i18n>Capacity Factor Class}',
                Criticality: capacityFactorCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : efficiencyCategory,
                Label: '{i18n>Efficiency Class}',
                Criticality: efficiencyCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : powerRatingCategory,
                Label: '{i18n>Power Rating Class}',
                Criticality: powerRatingCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : densityCategory,
                Label: '{i18n>Density Class}',
                Criticality: densityCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : rotorDiameterCategory,
                Label: '{i18n>Rotor Diameter Class}',
                Criticality: rotorDiameterCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : nacelleHeightCategory,
                Label: '{i18n>Nacelle Height Class}',
                Criticality: nacelleHeightCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmAreaCategory,
                Label: '{i18n>Wind Farm Area Class}',
                Criticality: windFarmAreaCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : turbineCountCategory,
                Label: '{i18n>Turbine Count Class}',
                Criticality: turbineCountCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : wtRatedPowerCategory,
                Label: '{i18n>WT Rated Power Class}',
                Criticality: wtRatedPowerCriticality
            }
        ]
    },

    UI.FieldGroup #PowerPerformance : {
        $Type : 'UI.FieldGroupType',
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
        ],
    },

    UI.FieldGroup #CapacityFactors : { 
        $Type : 'UI.FieldGroupType',
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

    UI.FieldGroup #TurbineCharacteristics : { 
        $Type : 'UI.FieldGroupType',
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

    UI.FieldGroup #WindCharacteristics : { 
        $Type : 'UI.FieldGroupType',
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
    },

    UI.FieldGroup #HeadInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : windFarm,
            },
            {
                $Type : 'UI.DataField',
                Value : country,
            },
            {
                $Type : 'UI.DataField',
                Value : waterBody,
            }
        ],
    },

    UI.FieldGroup #Recommendation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : performanceProfile,
                Label: '{i18n>Performance Profile}',
                Criticality: performanceProfileCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : optimizationPotential,
                Label: '{i18n>Optimization Potential}',
                Criticality: optimizationPotentialCriticality
            }
        ],
    },


);

// Chart
annotate service.WindFarmRecommendations with @(
    UI.Chart #recommendationMain : {
        Title               : 'Recommendations and Forecasts',
        ChartType           : #HeatMap,
        DynamicMeasures     : [
            '@Analytics.AggregatedProperty#avgEfficiencyCorr',
            '@Analytics.AggregatedProperty#avgCapacityFactorCorr',
        ],
        Dimensions          : [ 'windFarm', 'windFarmDensityMWKm2', 'efficiencyCategory',],
        MeasureAttributes   : [
            {
                DynamicMeasure : '@Analytics.AggregatedProperty#avgEfficiencyCorr',
                Role      : #Axis1
            },
            {
                DynamicMeasure : '@Analytics.AggregatedProperty#avgCapacityFactorCorr',
                Role      : #Axis1
            }
        ],
        DimensionAttributes : [{
            Dimension : 'windFarm',
            Role      : #Category
        },
        {
            Dimension: 'windFarmDensityMWKm2',
            Role     : #Category
        },
        {
            Dimension: 'efficiencyCategory',
            Role: #Category2
        }]
    },
);


// Field-level annotations for computed fields
annotate service.WindFarmRecommendations with {
    capacityFactorCriticality @Core.Computed: true;
    efficiencyCriticality @Core.Computed: true;
    powerRatingCriticality @Core.Computed: true;
    densityCriticality @Core.Computed: true;
    rotorDiameterCriticality @Core.Computed: true;
    nacelleHeightCriticality @Core.Computed: true;
    windFarmAreaCriticality @Core.Computed: true;
    turbineCountCriticality @Core.Computed: true;
    capacityFactorCategory @Core.Computed: true;
    efficiencyCategory @Core.Computed: true;
    powerRatingCategory @Core.Computed: true;
    densityCategory @Core.Computed: true;
    rotorDiameterCategory @Core.Computed: true;
    nacelleHeightCategory @Core.Computed: true;
    windFarmAreaCategory @Core.Computed: true;
    turbineCountCategory @Core.Computed: true;
    wtRatedPowerCategory @Core.Computed: true;
};


annotate service.WindFarmRecommendations with @(



    // Data Points with conditional criticality
    UI.DataPoint #CapacityFactor: {
        $Type: 'UI.DataPointType',
        Value: capacityFactorReal,
        Title: 'Capacity Factor (%)',
        Criticality: capacityFactorCriticality
    },
    
    UI.DataPoint #Efficiency: {
        $Type: 'UI.DataPointType', 
        Value: windFarmEfficiency,
        Title: 'Wind Farm Efficiency (%)',
        Criticality: efficiencyCriticality
    },
    
    UI.DataPoint #performanceProfile: {
        $Type: 'UI.DataPointType',
        Value: performanceProfile,
        Title: 'Performance',
        Criticality: performanceProfileCriticality
    },
    
    UI.DataPoint #optimizationPotential: {
        $Type: 'UI.DataPointType',
        Value: optimizationPotential,
        Title: 'Optimization Recommendation',
        Criticality: optimizationPotentialCriticality
    },

    UI.DataPoint #furtherStudy: {
        $Type: 'UI.DataPointType',
        Value: furtherStudy,
        Title: 'further Study Potential',
        Criticality: furtherStudyCriticality
    }
);


