using { windfarm } from '../db/schema';
 
@path: '/odata/v4/WindFarmService'
service WindFarmService {
     
    // Main Entities - Read/Write Access
    @odata.draft.enabled
    entity WindFarms as projection on windfarm.WindFarms;
   
    // ANALYTISCHE ENTITY FÜR ANALYTICAL LIST PAGE - NUR MIT EXISTIERENDEN FELDERN
    @readonly
    entity WindFarmAnalytics as projection on windfarm.WindFarmAnalytics {
        *,
        // Power Rating Categories (basierend auf windFarmRatedPowerMW)
        case 
            when windFarmRatedPowerMW <= 50 then '0-50 MW'
            when windFarmRatedPowerMW <= 100 then '50-100 MW'
            when windFarmRatedPowerMW <= 200 then '100-200 MW'
            when windFarmRatedPowerMW <= 500 then '200-500 MW'
            else '500+ MW'
        end as powerRatingCategory : String,
        
        // Capacity Factor Categories 
        case 
            when capacityFactorReal <= 30 then 'Low (≤30%)'
            when capacityFactorReal <= 40 then 'Medium (30-40%)'  
            when capacityFactorReal <= 50 then 'High (40-50%)'
            else 'Very High (>50%)'
        end as capacityFactorCategory : String,
        
        // Efficiency Categories
        case 
            when windFarmEfficiency <= 60 then 'Poor (<60%)'
            when windFarmEfficiency <= 70 then 'Average (60-70%)'
            when windFarmEfficiency <= 80 then 'Good (70-80%)'
            else 'Excellent (>80%)'
        end as efficiencyCategory : String,
        
        // Density Categories 
        case 
            when windFarmDensityMWKm2 <= 5 then 'Low Density (≤5)'
            when windFarmDensityMWKm2 <= 10 then 'Medium Density (5-10)'
            when windFarmDensityMWKm2 <= 15 then 'High Density (10-15)'
            else 'Very High Density (>15)'
        end as densityCategory : String
    };
   
    // Bestehende Analytical Views - Read Only
    @readonly
    entity WindFarmPerformance as projection on windfarm.WindFarmPerformance;
   
    @readonly
    entity TurbineAnalysis as projection on windfarm.TurbineAnalysis;
   
    @readonly
    entity GeographicAnalysis as projection on windfarm.GeographicAnalysis;
   
    @readonly
    entity CorrelationData as projection on windfarm.CorrelationData;
   
    // Custom Actions for Dashboard Tools
    action classifyByPerformance() returns array of {
        category: String;
        count: Integer;
        avgCapacityFactor: Decimal;
        avgEfficiency: Decimal;
        farms: array of String;
    };
   
    action classifyByDensity() returns array of {
        category: String;
        count: Integer;
        avgDensity: Decimal;
        farms: array of String;
    };
   
    action getCorrelationMatrix() returns {
        correlations: array of {
            variable1: String;
            variable2: String;
            correlation: Decimal;
            significance: String;
        };
    };
   
    action getPerformanceFactors() returns {
        topPerformers: array of {
            windFarm: String;
            capacityFactor: Decimal;
            efficiency: Decimal;
            characteristics: String;
        };
        insights: array of String;
    };
   
    action getRecommendations() returns {
        optimalCharacteristics: {
            densityRange: String;
            turbineSize: String;
            rotorDiameter: String;
        };
        improvements: array of {
            windFarm: String;
            currentPerformance: Decimal;
            potentialImprovement: String;
            recommendations: array of String;
        };
    };
   
    function getPerformanceDistribution() returns array of {
        range: String;
        count: Integer;
        percentage: Decimal;
    };
   
    function getDensityDistribution() returns array of {
        range: String;
        count: Integer;
        avgEfficiency: Decimal;
    };
   
    function getCountryComparison() returns array of {
        country: String;
        farmCount: Integer;
        avgPerformance: Decimal;
        totalCapacity: Decimal;
    };
}
 
// AGGREGATION UNTERSTÜTZUNG - NUR EXISTIERENDE FELDER
annotate WindFarmService.WindFarmAnalytics with @Aggregation.ApplySupported: {
    Transformations: [
        'aggregate',
        'groupby',
        'filter'
    ],
    GroupableProperties: [
        country,
        windFarm,
        powerRatingCategory,
        capacityFactorCategory,
        efficiencyCategory,
        densityCategory
    ],
    AggregatableProperties: [
        { Property: windFarmRatedPowerMW },
        { Property: capacityFactorReal },
        { Property: windFarmEfficiency },
        { Property: numberWT },
        { Property: windFarmDensityMWKm2 }
    ]
};
 
// BASIC UI ANNOTATIONS
annotate WindFarmService.WindFarmAnalytics with @(
    UI.SelectionFields: [
        country,
        powerRatingCategory,
        capacityFactorCategory
    ],
    UI.LineItem: [
        { Value: windFarm, Label: 'Wind Farm' },
        { Value: country, Label: 'Country' },
        { Value: windFarmRatedPowerMW, Label: 'Rated Power (MW)' },
        { Value: windFarmDensityMWKm2, Label: 'Density (MW/km²)' },
        { Value: capacityFactorReal, Label: 'Capacity Factor (%)' },
        { Value: windFarmEfficiency, Label: 'Efficiency (%)' },
        { Value: numberWT, Label: 'Turbines' },
        { Value: powerRatingCategory, Label: 'Power Category' }
    ]
);