using WindFarmService as service from '../../srv/windfarm-service';

annotate service.WindFarms with @(
    
    // Object Page Header Information
    UI.HeaderInfo: {
        $Type: 'UI.HeaderInfoType',
        TypeName: 'Wind Farm',
        TypeNamePlural: 'Wind Farms',
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
        Title: 'Overall Rating',
        TargetValue: 5.0,
        Visualization: #Rating
    },

     UI.DataPoint #ListRating: {
        $Type: 'UI.DataPointType',
        Value: overallRating,
        Title: 'Rating',
        TargetValue: 5.0,
        Visualization: #Rating,
        ![@Common.QuickInfo]: 'Overall Rating'
    },
    
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
    
    UI.DataPoint #PowerRating: {
        $Type: 'UI.DataPointType',
        Value: windFarmRatedPowerMW,
        Title: 'Total Capacity (MW)'
    },
    
    UI.DataPoint #TurbineCount: {
        $Type: 'UI.DataPointType',
        Value: numberWT,
        Title: 'Wind Turbines'
    },
    
    // Selection fields for filtering
    UI.SelectionFields: [
        country,
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
            Label: '{i18n>Ask AI}'
        },
        {
            $Type: 'UI.DataField',
            Value: windFarm,
            Label: 'Wind Farm Name',
            ![@UI.Importance]: #High,
            ![@HTML5.CssDefaults]: {
                width: '20%'
            }
        },
        {
            $Type: 'UI.DataField', 
            Value: country,
            Label: 'Country',
            ![@UI.Importance]: #High,
            ![@HTML5.CssDefaults]: {
                width: '20%'
            }
        },
        {
            $Type: 'UI.DataFieldForAnnotation',
            Target: '@UI.DataPoint#ListRating',
            Label: 'Rating',
            ![@UI.Importance]: #High,
            ![@HTML5.CssDefaults]: {
                width: '20%'
            }
        },
        {
            $Type: 'UI.DataField',
            Value: description,
            Label: 'Description',
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
            Label: 'Wind Farm Name'
        }
    ],
    
    // Field groups for object page sections
    UI.FieldGroup #OverviewGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : windFarm,
                Label : 'Wind Farm Name'
            },
            {
                $Type : 'UI.DataField',
                Value : country,
                Label : 'Location Country'
            },
            {
                $Type : 'UI.DataField',
                Value : waterBody,
                Label : 'Sea'
            },
            {
                $Type : 'UI.DataField',
                Value : description,
                Label : 'Description'
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
                Label : 'Latitude'
            },
            {
                $Type : 'UI.DataField',
                Value : longitude,
                Label : 'Longitude'
            },
        ]
    },

    UI.FieldGroup #TechnicalSpecs : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : numberWT,
                Label : '{i18n>Number of Turbines}',
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmAreaKm2,
                Label : '{i18n>Total Area (km²)}',
            },
            {
                $Type : 'UI.DataField',
                Value : rotorDiameterM,
                Label : '{i18n>Average Rotor Diameter (m)}'
            },
            {
                $Type : 'UI.DataField',
                Value : nacelleHeightM,
                Label : '{i18n>Average Nacelle Height (m)}'
            },
        ]
    },

    UI.FieldGroup #PerformanceMetrics : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : capacityFactorReal,
                Label : '{i18n>Capacity Factor (%)}'
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmEfficiency,
                Label : '{i18n>Wind Farm Efficiency (%)}'
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmRatedPowerMW,
                Label : '{i18n>Total Rated Power (MW)}'
            },
            {
                $Type : 'UI.DataField',
                Value : wtRatedPowerMW,
                Label : '{i18n>Wind Turbine Rated Power (MW)}'
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmDensityMWKm2,
                Label : '{i18n>Power Density (MW/km²)}',
            },
        ]
    },

    UI.FieldGroup #ClassificationGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : turbineCountCategory,
                Label: '{i18n>Turbine Count Class}',
                Criticality: turbineCountCriticality
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmAreaCategory,
                Label: '{i18n>Wind Farm Area Class}',
                Criticality: windFarmAreaCriticality
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
                Value : capacityFactorCategory,
                Label: '{i18n>Capacity Factor Class}',
                Criticality: capacityFactorCriticality
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
                Value : wtRatedPowerCategory,
                Label: '{i18n>WT Rated Power Class}',
                Criticality: wtRatedPowerCriticality
            }
        ]
    },
    
    // Object page facets
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'OverviewFacet',
            Label : '{i18n>Wind Farm Overview}',
            Target : '@UI.FieldGroup#OverviewGroup'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'LocationMapFacet',
            Label : '{i18n>Location & Map}',
            Target : '@UI.FieldGroup#LocationGroup',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'TechnicalFacet',
            Label : '{i18n>Technical Specifications}',
            Target : '@UI.FieldGroup#TechnicalSpecs'
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'PerformanceFacet',
            Label : '{i18n>Performance Metrics}',
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

// Enhanced Value Help annotations for all filter fields
annotate service.WindFarms with {
    country @(
        Common.ValueList: {
            Label: 'Countries',
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
        Common.ValueList: {
            Label: 'Performance Categories',
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
        Common.ValueList: {
            Label: 'Efficiency Categories',
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
        Common.ValueList: {
            Label: 'Power Rating Categories',
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
        Common.ValueList: {
            Label: 'Density Categories',
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
        Common.ValueList: {
            Label: 'Turbine Count Categories',
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
        Common.ValueList: {
            Label: 'Rotor Diameter Categories',
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
        Common.ValueList: {
            Label: 'Nacelle Height Categories',
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
        Common.ValueList: {
            Label: 'Wind Farm Area Categories',
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

}
