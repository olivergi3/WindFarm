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
        Common.Label : '{i18n>Country}'
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
        Common.Label : '{i18n>WindFarm}'
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

    performanceProfile @(
        Common.ValueList: {
            Label: '{i18n>PerformanceProfileCategories}',
            CollectionPath: 'PerformanceProfileValueHelp',
            SearchSupported: true,
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: performanceProfile,
                    ValueListProperty: 'performanceprofile'
                }
            ]
        },
        Common.Label : '{i18n>PerformanceProfile}',
    );

    optimizationPotential @(
        Common.ValueList: {
            Label: '{i18n>OptimizationPotentialCategories}',
            CollectionPath: 'OptimizationPotentialValueHelp',
            SearchSupported: true,
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: optimizationPotential,
                    ValueListProperty: 'optimizationpotential'
                }
            ]
        },
        Common.Label : '{i18n>OptimizationPotential}',
    );

    // Bessere Labels für Chart-Dimensionen
    windFarmDensityMWKm2 @(
        Common.Label : '{i18n>WindFarmDensity}'
    );
    
    efficiencyCategory @(
        Common.Label : '{i18n>EfficiencyCategory}'
    );
};

annotate service.WindFarmRecommendations with @(
    
    // Object Page Header Information
    UI.HeaderInfo: {
        $Type: 'UI.HeaderInfoType',
        TypeName: '{i18n>WindFarmRecommendations}',
        TypeNamePlural: '{i18n>WindFarmRecommendationsDashboard}',
        Title: { Value: 'Wind Farm Summary'},
        Description: { Value : '{i18n>GeneralInformationClassificationAnd}'},
        ImageUrl : windFarmImageUrl
    },
    
    // Header Facets with KPIs
    UI.HeaderFacets: [
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'HeaderGeneralInfo',
            Target : '@UI.FieldGroup#HeadInfo',
            Label  : '{i18n>GeneralInformation}'
        },
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'furtherStudyKPI',
            Target: '@UI.DataPoint#furtherStudy'
        },
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'PerformanceKPI',
            Target: '@UI.DataPoint#performanceProfile'
        },
        {
            $Type: 'UI.ReferenceFacet', 
            ID: 'OptimizationKPI',
            Target: '@UI.DataPoint#optimizationPotential'
        }
    ]
);

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
        optimizationPotential
    ],
    AggregatableProperties: [
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
        @Common.Label        : '{i18n>AvgEfficiency}'
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
            Label: '{i18n>Askai}'
        },
        {
            Value          : windFarm,
            Label          : '{i18n>WindFarm}',
            @UI.Importance : #High
        }, {
            Value          : country,
            Label          : '{i18n>Country}',
            @UI.Importance : #High
        }, {
            Value          : waterBody,
            Label          : '{i18n>Sea}',
            @UI.Importance : #High
        }, {
            Value          : efficiencyCategory,
            Label          : '{i18n>EfficiencyClass}',
            Criticality: efficiencyCriticality,
            @UI.Importance : #High
        }, {
            Value          : capacityFactorCategory,
            Label          : '{i18n>CapacityFactorClass}',
            Criticality: capacityFactorCriticality,
            @UI.Importance : #High
        }, {
            Value          : powerRatingCategory,
            Label          : '{i18n>PowerRatingClass}',
            Criticality: powerRatingCriticality,
            @UI.Importance : #High
        }, {
            Value          : densityCategory,
            Label          : '{i18n>DensityClass}',
            Criticality: densityCriticality,
            @UI.Importance : #High
        }, {
            Value          : rotorDiameterCategory,
            Label          : '{i18n>RotorDiameterClass}',
            @UI.Importance : #High,
            Criticality: rotorDiameterCriticality
        }, {
            Value          : nacelleHeightCategory,
            Label          : '{i18n>NacelleHeightClass}',
            Criticality: nacelleHeightCriticality,
            @UI.Importance : #High
        }, {
            Value          : windFarmAreaCategory,
            Label          : '{i18n>WindFarmAreaClass}',
            Criticality: windFarmAreaCriticality,
            @UI.Importance : #High
        }, {
            Value          : turbineCountCategory,
            Label          : '{i18n>TurbineCountClass}',
            Criticality: turbineCountCriticality,
            @UI.Importance : #High
        }, {
            Value          : wtRatedPowerCategory,
            Label          : '{i18n>WtRatedPowerClass}',
            Criticality: wtRatedPowerCriticality,
            @UI.Importance : #High
        }, {
            Value          : performanceProfile,   
            Label          : '{i18n>PerformanceProfile}',
            Criticality: performanceProfileCriticality,
            @UI.Importance : #High
        }, {
            Value          : optimizationPotential,       
            Label          : '{i18n>OptimizationPotential}',
            Criticality : optimizationPotentialCriticality,
            @UI.Importance : #High
        }
    ],

    UI.Identification: [
        {
            $Type: 'UI.DataField',
            Value: windFarm,
            Label: '{i18n>WindFarmName}'
        }
    ],

    // Presentation Variant
    UI.PresentationVariant : {
        Text: '{i18n>WindFarmRecommendationsDashboard}',
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
            Label : '{i18n>GeneralInformation}',
            Facets: [
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
                },
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
            Label : '{i18n>PerformanceAndRecommendation}',
            Target : '@UI.FieldGroup#Recommendation'
        }
    ],

    UI.FieldGroup #ClassificationGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : capacityFactorCategory,
                Label: '{i18n>CapacityFactorClass}',
                Criticality: capacityFactorCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : efficiencyCategory,
                Label: '{i18n>EfficiencyClass}',
                Criticality: efficiencyCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : powerRatingCategory,
                Label: '{i18n>PowerRatingClass}',
                Criticality: powerRatingCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : densityCategory,
                Label: '{i18n>DensityClass}',
                Criticality: densityCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : rotorDiameterCategory,
                Label: '{i18n>RotorDiameterClass}',
                Criticality: rotorDiameterCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : nacelleHeightCategory,
                Label: '{i18n>NacelleHeightClass}',
                Criticality: nacelleHeightCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmAreaCategory,
                Label: '{i18n>WindFarmAreaClass}',
                Criticality: windFarmAreaCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : turbineCountCategory,
                Label: '{i18n>TurbineCountClass}',
                Criticality: turbineCountCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : wtRatedPowerCategory,
                Label: '{i18n>WtRatedPowerClass}',
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
                Label : '{i18n>RatedPowerMw1}'
            },
            { 
                $Type : 'UI.DataField',
                Value : windFarmEfficiency, 
                Label : '{i18n>FarmEfficiency}'
            },
            { 
                $Type : 'UI.DataField',
                Value : windFarmDensityMWKm2, 
                Label : '{i18n>PowerDensityMwKm}'
            },
            { 
                $Type : 'UI.DataField',
                Value : ratioCapacityFactorRealModel, 
                Label : '{i18n>RealModelRatio}'
            }
        ]
    },

    UI.FieldGroup #CapacityFactors : { 
        $Type : 'UI.FieldGroupType',
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

    UI.FieldGroup #TurbineCharacteristics : { 
        $Type : 'UI.FieldGroupType',
         Data : [
            { 
                $Type : 'UI.DataField',
                Value : wtRatedPowerMW, 
                Label : '{i18n>TurbineRatedPowerMW}'
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

    UI.FieldGroup #WindCharacteristics : { 
        $Type : 'UI.FieldGroupType',
         Data : [
            { 
                $Type : 'UI.DataField',
                Value : windKw, 
                Label : '{i18n>WindSpeedKw1}'
            },
            { 
                $Type : 'UI.DataField',
                Value : windLambda, 
                Label : '{i18n>WindLambda}'
            }
        ]
    },

    UI.FieldGroup #HeadInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : windFarm,
                Label : '{i18n>WindFarm}'
            },
            {
                $Type : 'UI.DataField',
                Value : country,
                Label : '{i18n>Country}'
            },
            {
                $Type : 'UI.DataField',
                Value : waterBody,
                Label : '{i18n>Sea}'
            }
        ]
    },

    UI.FieldGroup #Recommendation : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : performanceProfile,
                Label: '{i18n>PerformanceProfile}',
                Criticality: performanceProfileCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : optimizationPotential,
                Label: '{i18n>OptimizationPotential}',
                Criticality: optimizationPotentialCriticality
            }
        ]
    }
);

// Chart
annotate service.WindFarmRecommendations with @(
    UI.Chart #recommendationMain : {
        Title               : '{i18n>RecommendationsAndForecasts}',
        ChartType           : #HeatMap,
        DynamicMeasures     : [
            '@Analytics.AggregatedProperty#avgEfficiencyCorr',
            '@Analytics.AggregatedProperty#avgCapacityFactorCorr'
        ],
        Dimensions          : [ 'windFarm', 'windFarmDensityMWKm2', 'efficiencyCategory'],
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
        DimensionAttributes : [
            {
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
            }
        ]
    }
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
        Title: '{i18n>CapacityFactorPercent}',
        Criticality: capacityFactorCriticality
    },
    
    UI.DataPoint #Efficiency: {
        $Type: 'UI.DataPointType', 
        Value: windFarmEfficiency,
        Title: '{i18n>WindFarmEfficiencyPercent}',
        Criticality: efficiencyCriticality
    },
    
    UI.DataPoint #performanceProfile: {
        $Type: 'UI.DataPointType',
        Value: performanceProfile,
        Title: '{i18n>Performance}',
        Criticality: performanceProfileCriticality
    },
    
    UI.DataPoint #optimizationPotential: {
        $Type: 'UI.DataPointType',
        Value: optimizationPotential,
        Title: '{i18n>OptimizationRecommendation}',
        Criticality: optimizationPotentialCriticality
    },

    UI.DataPoint #furtherStudy: {
        $Type: 'UI.DataPointType',
        Value: furtherStudy,
        Title: '{i18n>FurtherStudyPotential}',
        Criticality: furtherStudyCriticality
    }
);
annotate service.WindFarmRecommendations with {
    rotorDiameterM @Common.Label : '{i18n>RotorDiameterM}'
};

annotate service.WindFarmRecommendations with {
    nacelleHeightM @Common.Label : '{i18n>NacelleHeightM}'
};

annotate service.WindFarmRecommendations with {
    wtRatedPowerMW @Common.Label : '{i18n>WtRatedPowerMw}'
};

annotate service.WindFarmRecommendations with {
    numberWT @Common.Label : '{i18n>NumberOfWindTurbines}'
};

annotate service.WindFarmRecommendations with {
    windFarmAreaKm2 @Common.Label : '{i18n>WindFarmAreaKm}'
};

annotate service.WindFarmRecommendations with {
    windFarmRatedPowerMW @Common.Label : '{i18n>WindFarmRatedPower}'
};

annotate service.WindFarmRecommendations with {
    capacityFactorReal @Common.Label : '{i18n>CapacityFactorReal}'
};

annotate service.WindFarmRecommendations with {
    windFarmEfficiency @Common.Label : '{i18n>WindFarmEfficiency}'
};

