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
        }
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
        @Common.Label        : 'Total Wind Farms'
    },
    Analytics.AggregatedProperty #countWindFarmsCorr :
    {
        Name                 : 'countWindFarmsCorr',
        AggregationMethod    : 'countdistinct',
        AggregatableProperty : 'windFarm',
        @Common.Label        : 'Count of Wind Farms'
    },

    // physical characteristics aggregations (PPC = Physical Performance Characteristic)
    Analytics.AggregatedProperty #avgRotorDiameter :
    {
        Name                 : 'avgRotorDiameter',
        AggregationMethod    : 'average',
        AggregatableProperty : 'rotorDiameterM',
        @Common.Label        : 'Avg Rotor Diameter (m) (PPC)'
    },
    Analytics.AggregatedProperty #avgNacelleHeight :
    {
        Name                 : 'avgNacelleHeight',
        AggregationMethod    : 'average',
        AggregatableProperty : 'nacelleHeightM',
        @Common.Label        : 'Avg Nacelle Height (m) (PPC)'
    },
    Analytics.AggregatedProperty #avgTurbinePower :
    {
        Name                 : 'avgTurbinePower',
        AggregationMethod    : 'average',
        AggregatableProperty : 'wtRatedPowerMW',
        @Common.Label        : 'Avg Turbine Power (MW) (PPC)'
    },
    Analytics.AggregatedProperty #totalTurbines :
    {
        Name                 : 'totalTurbines',
        AggregationMethod    : 'sum',
        AggregatableProperty : 'numberWT',
        @Common.Label        : 'Total Turbines (PPC)'
    },
    Analytics.AggregatedProperty #totalArea :
    {
        Name                 : 'totalArea',
        AggregationMethod    : 'sum',
        AggregatableProperty : 'windFarmAreaKm2',
        @Common.Label        : 'Total Area (km²) (PPC)'
    },
    Analytics.AggregatedProperty #avgDensity :
    {
        Name                 : 'avgDensity',
        AggregationMethod    : 'average',
        AggregatableProperty : 'windFarmDensityMWKm2',
        @Common.Label        : 'Avg Density (MW/km²) (PPC)'
    },

    // operational performance aggregations (OPC = Operational Performance Characteristic)
    Analytics.AggregatedProperty #avgCapacityFactorCorr :
    {
        Name                 : 'avgCapacityFactorCorr',
        AggregationMethod    : 'average',
        AggregatableProperty : 'capacityFactorReal',
        @Common.Label        : 'Avg Capacity Factor (%) (OPC)'
    },
    Analytics.AggregatedProperty #totalPowerCorr :
    {
        Name                 : 'totalPowerCorr',
        AggregationMethod    : 'sum',
        AggregatableProperty : 'windFarmRatedPowerMW',
        @Common.Label        : 'Total Power (MW) (OPC)'
    },
    Analytics.AggregatedProperty #avgEfficiencyCorr :
    {
        Name                 : 'avgEfficiencyCorr',
        AggregationMethod    : 'average',
        AggregatableProperty : 'windFarmEfficiency',
        @Common.Label        : 'Avg Efficiency (%) (OPC)'
    }
);

// ui annotations
annotate service.WindFarmCorrelationAnalysis with @(
    // selection fields filter
    UI.SelectionFields : [
        country,
        windFarm,
        waterBody
        // filter for efficiency correlation
        //heightEfficiencyProfile,
        //eaEfficiencyProfile,
        //rotorEfficiencyProfile,
        //turbineCountEfficiencyProfile,
        //wtPowerEfficiencyProfile,
        //farmPowerEfficiencyProfile,
        //densityEfficiencyProfile,
        // filter for capacity factor correlation
        //rotorCapacityProfile,
        //heightCapacityProfile,
        //farmPowerCapacityProfile,
        // filter for rated power correlation
        //densityRatedPowerProfile,
        //turbineCountRatedPowerProfile,
        // filter for wt power correlation
        //densityWtPowerProfile,
        //turbineCountWtPowerProfile
    ],
    
    // lineitem with all correlations
    UI.LineItem : [
        {
            $Type: 'UI.DataFieldForAction',
            Action: 'WindFarmService.EntityContainer/checkAI',
            Label: '{i18n>Ask AI}'
        },
        {
            Value          : windFarm,
            Label          : 'Wind Farm',
            @UI.Importance : #High
        }, {
            Value          : country,
            Label          : 'Country',
            @UI.Importance : #High
        }, {
            Value          : waterBody,
            Label          : 'Sea',
            @UI.Importance : #High
        }, 
        // efficiency correlation patterns
        {
            Value          : heightEfficiencyProfile,
            Label          : 'Height-Efficiency Pattern',
            @UI.Importance : #Medium,
            Criticality    : heightEfficiencyCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : areaEfficiencyProfile,
            Label          : 'Area-Efficiency Pattern',
            @UI.Importance : #Medium,
            Criticality    : areaEfficiencyCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : rotorEfficiencyProfile,
            Label          : 'Rotor-Efficiency Pattern',
            @UI.Importance : #Medium,
            Criticality    : rotorEfficiencyCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : turbineCountEfficiencyProfile,
            Label          : 'Turbine Count-Efficiency Pattern',
            @UI.Importance : #Medium,
            Criticality    : turbineCountEfficiencyCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : wtPowerEfficiencyProfile,
            Label          : 'WT Power-Efficiency Pattern',
            @UI.Importance : #Medium,
            Criticality    : wtPowerEfficiencyCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : farmPowerEfficiencyProfile,
            Label          : 'Farm Power-Efficiency Pattern',
            @UI.Importance : #Medium,
            Criticality    : farmPowerEfficiencyCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : densityEfficiencyProfile,
            Label          : 'Density-Efficiency Pattern',
            @UI.Importance : #High,
            Criticality    : densityEfficiencyCriticality,
            CriticalityRepresentation: #WithoutIcon
        },
        // capacity factor correlation patterns
        {
            Value          : turbineCountCapacityProfile,
            Label          : 'Turbine Count-Capacity Pattern',
            @UI.Importance : #Medium,
            Criticality    : turbineCountCapacityCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : rotorCapacityProfile,
            Label          : 'Rotor-Capacity Pattern',
            @UI.Importance : #Medium,
            Criticality    : rotorCapacityCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : heightCapacityProfile,
            Label          : 'Height-Capacity Pattern',
            @UI.Importance : #Medium,
            Criticality    : heightCapacityCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : farmPowerCapacityProfile,
            Label          : 'Farm Power-Capacity Pattern',
            @UI.Importance : #Medium,
            Criticality    : farmPowerCapacityCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : wtPowerCapacityProfile,
            Label          : 'WT Power-Capacity Pattern',
            @UI.Importance : #Medium,
            Criticality    : wtPowerCapacityCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : areaCapacityProfile,
            Label          : 'Area-Capacity Pattern',
            @UI.Importance : #Medium,
            Criticality    : areaCapacityCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : capacityDensityProfile,
            Label          : 'Capacity-Density Pattern',
            @UI.Importance : #Medium,
            Criticality    : capacityDensityCriticality,
            CriticalityRepresentation: #WithoutIcon
        },
        // rated power correlation patterns
        {
            Value          : densityRatedPowerProfile,
            Label          : 'Density-Rated Power Pattern',
            @UI.Importance : #Medium,
            Criticality    : densityRatedPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : turbineCountRatedPowerProfile,
            Label          : 'Turbine Count-Rated Power Pattern',
            @UI.Importance : #Medium,
            Criticality    : turbineCountRatedPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : rotorRatedPowerProfile,
            Label          : 'Rotor-Rated Power Pattern',
            @UI.Importance : #Medium,
            Criticality    : rotorRatedPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : heightRatedPowerProfile,
            Label          : 'Height-Rated Power Pattern',
            @UI.Importance : #Medium,
            Criticality    : heightRatedPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : wtRatedPowerProfile,
            Label          : 'WT-Rated Power Pattern',
            @UI.Importance : #Medium,
            Criticality    : wtRatedPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : areaRatedPowerProfile,
            Label          : 'Area-Rated Power Pattern',
            @UI.Importance : #Medium,
            Criticality    : areaRatedPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        },
        // wt power correlation patterns
        {
            Value          : densityWtPowerProfile,
            Label          : 'Density-WT Power Pattern',
            @UI.Importance : #Medium,
            Criticality    : densityWtPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : turbineCountWtPowerProfile,
            Label          : 'Turbine Count-WT Power Pattern',
            @UI.Importance : #Medium,
            Criticality    : turbineCountWtPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : rotorWtPowerProfile,
            Label          : 'Rotor-WT Power Pattern',
            @UI.Importance : #Medium,
            Criticality    : rotorWtPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : heightWtPowerProfile,
            Label          : 'Height-WT Power Pattern',
            @UI.Importance : #Medium,
            Criticality    : heightWtPowerCriticality,
            CriticalityRepresentation: #WithoutIcon
        }, {
            Value          : areaWtPowerProfile,
            Label          : 'Area-WT Power Pattern',
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
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneralInfo',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'EfficiencyCorrelationFacet',
            Label : 'Efficiency Correlation Patterns',
            Target : '@UI.FieldGroup#EfficiencyCorrelations',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'CapacityFactorCorrelationFacet',
            Label : 'Capacity Factor Correlation Patterns',
            Target : '@UI.FieldGroup#CapacityFactorCorrelations',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'RatedPowerCorrelationFacet',
            Label : 'Rated Power Correlation Patterns',
            Target : '@UI.FieldGroup#RatedPowerCorrelations',
        },
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'WtPowerCorrelationFacet',
            Label : 'WT Power Correlation Patterns',
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
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmDensityMWKm2,
                Criticality : windFarmDensityCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : capacityFactorReal,
                Criticality : capacityFactorCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmEfficiency,
                Criticality : windFarmEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : numberWT,
            },
            {
                $Type : 'UI.DataField',
                Value : rotorDiameterM,
            },
            {
                $Type : 'UI.DataField',
                Value : nacelleHeightM,
            },
            {
                $Type : 'UI.DataField',
                Value : wtRatedPowerMW,
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmAreaKm2,
            }
        ],
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

    UI.FieldGroup #EfficiencyCorrelations : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : densityEfficiencyProfile,
                Label: 'Density-Efficiency Pattern',
                Criticality : densityEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : heightEfficiencyProfile,
                Label: 'Height-Efficiency Pattern',
                Criticality : heightEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : areaEfficiencyProfile,
                Label: 'Area-Efficiency Pattern',
                Criticality : areaEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : rotorEfficiencyProfile,
                Label: 'Rotor-Efficiency Pattern',
                Criticality : rotorEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : turbineCountEfficiencyProfile,
                Label: 'Turbine Count-Efficiency Pattern',
                Criticality : turbineCountEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : wtPowerEfficiencyProfile,
                Label: 'WT Power-Efficiency Pattern',
                Criticality : wtPowerEfficiencyCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : farmPowerEfficiencyProfile,
                Label: 'Farm Power-Efficiency Pattern',
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
                Label: 'Capacity-Density Pattern',
                Criticality : capacityDensityCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : turbineCountCapacityProfile,
                Label: 'Turbine Count-Capacity Pattern',
                Criticality : turbineCountCapacityCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : rotorCapacityProfile,
                Label: 'Rotor-Capacity Pattern',
                Criticality : rotorCapacityCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : heightCapacityProfile,
                Label: 'Height-Capacity Pattern',
                Criticality : heightCapacityCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : farmPowerCapacityProfile,
                Label: 'Farm Power-Capacity Pattern',
                Criticality : farmPowerCapacityCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : wtPowerCapacityProfile,
                Label: 'WT Power-Capacity Pattern',
                Criticality : wtPowerCapacityCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : areaCapacityProfile,
                Label: 'Area-Capacity Pattern',
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
                Label: 'Density-Rated Power Pattern',
                Criticality : densityRatedPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : turbineCountRatedPowerProfile,
                Label: 'Turbine Count-Rated Power Pattern',
                Criticality : turbineCountRatedPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : rotorRatedPowerProfile,
                Label: 'Rotor-Rated Power Pattern',
                Criticality : rotorRatedPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : heightRatedPowerProfile,
                Label: 'Height-Rated Power Pattern',
                Criticality : heightRatedPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : wtRatedPowerProfile,
                Label: 'WT-Rated Power Pattern',
                Criticality : wtRatedPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : areaRatedPowerProfile,
                Label: 'Area-Rated Power Pattern',
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
                Label: 'Density-WT Power Pattern',
                Criticality : densityWtPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : turbineCountWtPowerProfile,
                Label: 'Turbine Count-WT Power Pattern',
                Criticality : turbineCountWtPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : rotorWtPowerProfile,
                Label: 'Rotor-WT Power Pattern',
                Criticality : rotorWtPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : heightWtPowerProfile,
                Label: 'Height-WT Power Pattern',
                Criticality : heightWtPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            },
            {
                $Type : 'UI.DataField',
                Value : areaWtPowerProfile,
                Label: 'Area-WT Power Pattern',
                Criticality : areaWtPowerCriticality,
                CriticalityRepresentation: #WithoutIcon
            }
        ],
    }
);

// Chart
annotate service.WindFarmCorrelationAnalysis with @(
    UI.Chart #corrMain : {
        Title               : 'Physical vs Operational Analysis',
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
        TypeName       : 'Wind Farm Extended Correlation Analysis',
        TypeNamePlural : 'Wind Farm Extended Correlation Analysis Dashboard',
        Title          : { Value : 'Wind Farm Correlation Analysis' },
        Description    : { Value : 'Comprehensive Performance Pattern Analysis with Correlation Patterns' },
        ImageUrl       : windFarmImageUrl
    },

    HeaderFacets : [
    {
      $Type  : 'UI.ReferenceFacet',
      ID     : 'HeaderGeneralInfo',
      Target : '@UI.FieldGroup#HeadInfo',
      Label  : 'General Information'
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