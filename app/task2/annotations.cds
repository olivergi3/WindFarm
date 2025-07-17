using WindFarmService as service from '../../srv/windfarm-service';

annotate service.WindFarms with @(
    
    // Object Page Header Information
    UI.HeaderInfo: {
        $Type: 'UI.HeaderInfoType',
        TypeName: '{i18n>WindFarm}',
        TypeNamePlural: '{i18n>WindFarms}',
        Title: {
            $Type: 'UI.DataField',
            Value: windFarm
        },
        Description: {
            $Type: 'UI.DataField', 
            Value: country
        },
        ImageUrl: windFarmImageUrl
    },
    
    // Header Facets with KPIs
    UI.HeaderFacets: [
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'OverallRatingKPI',
            Target: '@UI.DataPoint#OverallRating'
        },
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'CapacityFactorKPI',
            Target: '@UI.DataPoint#CapacityFactor',
            ![@UI.Hidden],
        },
        {
            $Type: 'UI.ReferenceFacet', 
            ID: 'EfficiencyKPI',
            Target: '@UI.DataPoint#Efficiency',
            ![@UI.Hidden],
        },
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'PowerRatingKPI', 
            Target: '@UI.DataPoint#PowerRating',
            ![@UI.Hidden],
        },
        {
            $Type: 'UI.ReferenceFacet',
            ID: 'TurbineCountKPI',
            Target: '@UI.DataPoint#TurbineCount',
            ![@UI.Hidden],
        }
    ],
    
    
    UI.DataPoint #OverallRating: {
        $Type: 'UI.DataPointType',
        Value: overallRating,
        Title: '{i18n>OverallRating}',
        TargetValue: 5.0,
        Visualization: #Rating
    },

     UI.DataPoint #ListRating: {
        $Type: 'UI.DataPointType',
        Value: overallRating,
        Title: '{i18n>Rating}',
        TargetValue: 5.0,
        Visualization: #Rating,
        ![@Common.QuickInfo]: '{i18n>OverallRating}'
    },
    
    // Data Points with conditional criticality
    UI.DataPoint #CapacityFactor: {
        $Type: 'UI.DataPointType',
        Value: capacityFactorReal,
        Title: '{i18n>CapacityFactor}',
        Criticality: capacityFactorCriticality
    },
    
    UI.DataPoint #Efficiency: {
        $Type: 'UI.DataPointType', 
        Value: windFarmEfficiency,
        Title: '{i18n>WindFarmEfficiency}',
        Criticality: efficiencyCriticality
    },
    
    UI.DataPoint #PowerRating: {
        $Type: 'UI.DataPointType',
        Value: windFarmRatedPowerMW,
        Title: '{i18n>TotalCapacity}'
    },
    
    UI.DataPoint #TurbineCount: {
        $Type: 'UI.DataPointType',
        Value: numberWT,
        Title: '{i18n>WindTurbines}'
    },
    
    // Selection fields for filtering
    UI.SelectionFields: [
        country,
        overallRating,
        capacityFactorCategory,
        efficiencyCategory,
        powerRatingCategory,
        densityCategory,
        rotorDiameterCategory,
        nacelleHeightCategory,
        windFarmAreaCategory,
        turbineCountCategory        
    ],
    
    // Enhanced Presentation variant to force all columns visible
    UI.PresentationVariant: {
        $Type: 'UI.PresentationVariantType',
        Visualizations: ['@UI.LineItem'],
        RequestAtLeast: [
            windFarm,
            country,
            description,
            latitude,
            longitude,
            capacityFactorCategory,
            efficiencyCategory,
            powerRatingCategory,
            densityCategory,
            capacityFactorReal,
            windFarmEfficiency,
            windFarmRatedPowerMW,
            numberWT,
            windFarmAreaKm2,
            windFarmDensityMWKm2,
            rotorDiameterM,
            nacelleHeightM,
            wtRatedPowerMW,
            overallRating
        ],
        IncludeGrandTotal: true,
        InitialExpansionLevel: 1
    },
    
    // Comprehensive list view with checkAI button and ALL fields as separate columns
    UI.LineItem: [
        {
            $Type: 'UI.DataFieldForAction',
            Action: 'WindFarmService.EntityContainer/checkAI',
            Label: '{i18n>Askai}'
        },
        {
            $Type: 'UI.DataField',
            Value: windFarm,
            Label: '{i18n>WindFarmName}',
            ![@UI.Importance]: #High,
            ![@HTML5.CssDefaults]: {
                width: '20%'
            }
        },
        {
            $Type: 'UI.DataField', 
            Value: country,
            Label: '{i18n>Country}',
            ![@UI.Importance]: #High,
            ![@HTML5.CssDefaults]: {
                width: '20%'
            }
        },
        {
            $Type: 'UI.DataFieldForAnnotation',
            Target: '@UI.DataPoint#ListRating',
            Label: '{i18n>OverallRating}',
            ![@UI.Importance]: #High,
            ![@HTML5.CssDefaults]: {
                width: '20%'
            }
        },
        {
            $Type: 'UI.DataField',
            Value: description,
            Label: '{i18n>Description}',
            ![@UI.Importance]: #High,
            ![@HTML5.CssDefaults]: {
                width: '40%'
            }
        }
    ],
    
    UI.Identification: [
        {
            $Type: 'UI.DataField',
            Value: windFarm,
            Label: '{i18n>WindFarmName}'
        }
    ],
    
    // Field groups for object page sections
    UI.FieldGroup #OverviewGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : windFarm,
                Label : '{i18n>WindFarmName}'
            },
            {
                $Type : 'UI.DataField',
                Value : country,
                Label : '{i18n>LocationCountry}'
            },
            {
                $Type : 'UI.DataField',
                Value : waterBody,
                Label : '{i18n>Sea}'
            },
            {
                $Type : 'UI.DataField',
                Value : description,
                Label : '{i18n>Description}'
            }
        ]
    },

    // VEREINFACHTE LOCATION GROUP MIT INLINE HTML
    UI.FieldGroup #LocationGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : latitude,
                Label : '{i18n>Latitude}'
            },
            {
                $Type : 'UI.DataField',
                Value : longitude,
                Label : '{i18n>Longitude}'
            },
        ]
    },

    UI.FieldGroup #TechnicalSpecs : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : numberWT,
                Label : '{i18n>NumberOfTurbines}',
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmAreaKm2,
                Label : '{i18n>TotalAreaKm1}',
            },
            {
                $Type : 'UI.DataField',
                Value : rotorDiameterM,
                Label : '{i18n>AverageRotorDiameter}'
            },
            {
                $Type : 'UI.DataField',
                Value : nacelleHeightM,
                Label : '{i18n>AverageNacelleHeight}'
            },
        ]
    },

    UI.FieldGroup #PerformanceMetrics : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : capacityFactorReal,
                Label : '{i18n>CapacityFactor}'
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmEfficiency,
                Label : '{i18n>WindFarmEfficiency}'
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmRatedPowerMW,
                Label : '{i18n>TotalRatedPower}'
            },
            {
                $Type : 'UI.DataField',
                Value : wtRatedPowerMW,
                Label : '{i18n>WindTurbineRatedPower}'
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmDensityMWKm2,
                Label : '{i18n>PowerDensity}',
            },
        ]
    },

    UI.FieldGroup #ClassificationGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : turbineCountCategory,
                Label: '{i18n>TurbineCountClass}',
                Criticality: turbineCountCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmAreaCategory,
                Label: '{i18n>WindFarmAreaClass}',
                Criticality: windFarmAreaCriticality
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
                Value : capacityFactorCategory,
                Label: '{i18n>CapacityFactorClass}',
                Criticality: capacityFactorCriticality
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
                Value : wtRatedPowerCategory,
                Label: '{i18n>WtRatedPowerClass}',
                Criticality: wtRatedPowerCriticality
            }
        ]
    },
    
    // Object page facets
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'OverviewFacet',
            Label : '{i18n>WindFarmOverview}',
            Target : '@UI.FieldGroup#OverviewGroup'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'LocationMapFacet',
            Label : '{i18n>Location}',
            Target : '@UI.FieldGroup#LocationGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'TechnicalFacet',
            Label : '{i18n>TechnicalSpecifications}',
            Target : '@UI.FieldGroup#TechnicalSpecs'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'PerformanceFacet',
            Label : '{i18n>PerformanceMetrics}',
            Target : '@UI.FieldGroup#PerformanceMetrics'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'ClassificationFacet',
            Label : '{i18n>Classifications}',
            Target : '@UI.FieldGroup#ClassificationGroup'
        }
    ]
);

// Field-level annotations for computed fields
annotate service.WindFarms with {
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
    overallRating @Core.Computed: true;
}

// Field Labels for Filter Display
annotate service.WindFarms with {
    country @(
        Common.Label: '{i18n>Country}',
        Common.ValueList: {
            Label: '{i18n>Countries}',
            CollectionPath: 'CountryValueHelp',
            SearchSupported: true,
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: country,
                    ValueListProperty: 'country'
                }
            ]
        }
    );
    
    capacityFactorCategory @(
        Common.Label: '{i18n>CapacityFactorCategory}',
        Common.ValueList: {
            Label: '{i18n>CapacityFactorCategories}',
            CollectionPath: 'CapacityFactorCategoryValueHelp',
            SearchSupported: true,
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: capacityFactorCategory,
                    ValueListProperty: 'capacityFactorCategory'
                }
            ]
        }
    );
    
    efficiencyCategory @(
        Common.Label: '{i18n>EfficiencyCategory}',
        Common.ValueList: {
            Label: '{i18n>EfficiencyCategories}',
            CollectionPath: 'EfficiencyCategoryValueHelp',
            SearchSupported: true,
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: efficiencyCategory,
                    ValueListProperty: 'efficiencyCategory'
                }
            ]
        }
    );
    
    powerRatingCategory @(
        Common.Label: '{i18n>PowerRatingCategory}',
        Common.ValueList: {
            Label: '{i18n>PowerRatingCategories}',
            CollectionPath: 'PowerRatingCategoryValueHelp',
            SearchSupported: true,
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: powerRatingCategory,
                    ValueListProperty: 'powerRatingCategory'
                }
            ]
        }
    );
    
    densityCategory @(
        Common.Label: '{i18n>DensityCategory}',
        Common.ValueList: {
            Label: '{i18n>DensityCategories}',
            CollectionPath: 'DensityCategoryValueHelp',
            SearchSupported: true,
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: densityCategory,
                    ValueListProperty: 'densityCategory'
                }
            ]
        }
    );
    
    turbineCountCategory @(
        Common.Label: '{i18n>TurbineCountCategory}',
        Common.ValueList: {
            Label: '{i18n>TurbineCountCategories}',
            CollectionPath: 'TurbineCountCategoryValueHelp',
            SearchSupported: true,
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: turbineCountCategory,
                    ValueListProperty: 'turbineCountCategory'
                }
            ]
        }
    );
    
    rotorDiameterCategory @(
        Common.Label: '{i18n>RotorDiameterCategory}',
        Common.ValueList: {
            Label: '{i18n>RotorDiameterCategories}',
            CollectionPath: 'RotorDiameterCategoryValueHelp',
            SearchSupported: true,
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: rotorDiameterCategory,
                    ValueListProperty: 'rotorDiameterCategory'
                }
            ]
        }
    );
    
    nacelleHeightCategory @(
        Common.Label: '{i18n>NacelleHeightCategory}',
        Common.ValueList: {
            Label: '{i18n>NacelleHeightCategories}',
            CollectionPath: 'NacelleHeightCategoryValueHelp',
            SearchSupported: true,
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: nacelleHeightCategory,
                    ValueListProperty: 'nacelleHeightCategory'
                }
            ]
        }
    );
    
    windFarmAreaCategory @(
        Common.Label: '{i18n>WindFarmAreaCategory}',
        Common.ValueList: {
            Label: '{i18n>WindFarmAreaCategories}',
            CollectionPath: 'WindFarmAreaCategoryValueHelp',
            SearchSupported: true,
            Parameters: [
                {
                    $Type: 'Common.ValueListParameterInOut',
                    LocalDataProperty: windFarmAreaCategory,
                    ValueListProperty: 'windFarmAreaCategory'
                }
            ]
        }
    );

    overallRating @(
        Common.Label: '{i18n>OverallRating}'
    );
}