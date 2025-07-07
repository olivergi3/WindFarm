using { windfarm } from '../db/schema';
 
@path: '/odata/v4/WindFarmService'
service WindFarmService {
    action checkAI (Query: String);
    
    // main entities 
    @odata.draft.enabled
    entity WindFarms as projection on windfarm.WindFarms {
        *,
        // performance categories task 2
        case
            when capacityFactorReal >= 45 then 'High (45%+)'
            when capacityFactorReal >= 35 then 'Medium (35-45%)'
            else 'Low (<35%)'
        end as capacityFactorCategory : String,
       
        // efficiency categories
        case
            when windFarmEfficiency >= 75 then 'Excellent (75%+)'
            when windFarmEfficiency >= 65 then 'Good (65-75%)'
            when windFarmEfficiency >= 55 then 'Average (55-65%)'
            else 'Poor (<55%)'
        end as efficiencyCategory : String,
       
        // power rating categories
        case
            when windFarmRatedPowerMW <= 50 then '0-50 MW'
            when windFarmRatedPowerMW <= 100 then '50-100 MW'
            when windFarmRatedPowerMW <= 200 then '100-200 MW'
            when windFarmRatedPowerMW <= 500 then '200-500 MW'
            else '500+ MW'
        end as powerRatingCategory : String,
       
        // density categories
        case
            when windFarmDensityMWKm2 <= 3 then 'Low Density (≤3)'
            when windFarmDensityMWKm2 <= 7 then 'Medium Density (3-7)'
            else 'High Density (>7)'
        end as densityCategory : String,

         // rotor diameter categories 
        case
            when rotorDiameterM <= 80 then 'Small (≤80m)'
            when rotorDiameterM <= 120 then 'Medium (80-120m)'
            else 'Large (>120m)'
        end as rotorDiameterCategory : String,
        
        // nacelle height categories
        case
            when nacelleHeightM <= 80 then 'Low (<80m)'
            when nacelleHeightM <= 120 then 'Medium (80-120m)'
            else 'High (>120m)'
        end as nacelleHeightCategory : String,
        
        // wind farm area categories
        case
            when windFarmAreaKm2 <= 10 then 'Small (<10 km²)'
            when windFarmAreaKm2 <= 50 then 'Medium (10-50 km²)'
            else 'Large (>50 km²)'
        end as windFarmAreaCategory : String,
        
        // turbine count categories
        case
            when numberWT <= 25 then 'Small (<25 turbines)'
            when numberWT <= 50 then 'Medium (25-50 turbines)'
            when numberWT <= 100 then 'Large (50-100 turbines)'
            else 'Very Large (>100 turbines)'
        end as turbineCountCategory : String,

        // wind turbine rated Power categories
        case
            when wtRatedPowerMW < 4 then '0-4 MW'
            when wtRatedPowerMW < 8 then '4-8 MW'
            when wtRatedPowerMW < 12 then '8-12 MW'
            else '12+ MW'
        end as wtRatedPowerCategory : String,

        // criticality fields - using the original field values directly
        case
            when capacityFactorReal >= 45 then 3       // green - good performance
            when capacityFactorReal >= 35 then 2       // yellow - average performance  
            when capacityFactorReal < 35 then 1        // red - poor performance
            else 0                                     // neutral
        end as capacityFactorCriticality : Integer,
        
        case
            when windFarmEfficiency >= 75 then 3       // green - excellent
            when windFarmEfficiency >= 65 then 3       // green - good
            when windFarmEfficiency >= 55 then 2       // yellow - average
            when windFarmEfficiency < 55 then 1        // red - poor
            else 0                                     // neutral
        end as efficiencyCriticality : Integer,
        
        case
            when windFarmRatedPowerMW > 500 then 3     // green - large capacity
            when windFarmRatedPowerMW > 200 then 3     // green - large capacity
            when windFarmRatedPowerMW > 100 then 2     // yellow - medium capacity
            when windFarmRatedPowerMW > 50 then 2      // yellow - medium capacity
            when windFarmRatedPowerMW <= 50 then 1     // red - small capacity
            else 0                                     // neutral
        end as powerRatingCriticality : Integer,
        
        case
            when windFarmDensityMWKm2 > 7 then 3       // green - high density
            when windFarmDensityMWKm2 > 3 then 2       // yellow - medium density
            when windFarmDensityMWKm2 <= 3 then 1      // red - low density
            else 0                                     // neutral
        end as densityCriticality : Integer,

        case
            when rotorDiameterM > 120 then 3           // Green - Large rotor
            when rotorDiameterM > 80 then 2            // Yellow - Medium rotor
            when rotorDiameterM <= 80 then 1           // Red - Small rotor
            else 0                                     // Neutral
        end as rotorDiameterCriticality : Integer,
        
        case
            when nacelleHeightM >= 120 then 3          // Green - High nacelle
            when nacelleHeightM >= 80 then 2           // Yellow - Medium nacelle  
            when nacelleHeightM < 80 then 1            // Red - Low nacelle
            else 0                                     // Neutral
        end as nacelleHeightCriticality : Integer,
        
        case
            when windFarmAreaKm2 > 50 then 3           // Green - Large area
            when windFarmAreaKm2 > 10 then 2           // Yellow - Medium area
            when windFarmAreaKm2 <= 10 then 1          // Red - Small area
            else 0                                     // Neutral
        end as windFarmAreaCriticality : Integer,
        
        case
            when numberWT >= 100 then 3                // Green - Large count
            when numberWT >= 50 then 3                 // Green - Large count  
            when numberWT >= 25 then 2                 // Yellow - Medium count
            when numberWT < 25 then 1                  // Red - Small count
            else 0                                     // Neutral
        end as turbineCountCriticality : Integer,

        case
            when wtRatedPowerMW >= 12 then 3           // Green - Large count
            when wtRatedPowerMW >= 8 then 3            // Green - Large count  
            when wtRatedPowerMW >= 4 then 2            // Yellow - Medium count
            when wtRatedPowerMW < 3.9 then 1           // Red - Small count
            else 0                                     // Neutral
        end as wtRatedPowerCriticality : Integer,

        // Overall Rating - Jedes grüne Feld = 0.5 Sterne, 9 Felder = 5.0 Bonus
        case
            // 9 grüne Felder = 5.0 Sterne (BONUS für perfekt!)
            when ((case when capacityFactorReal >= 45 then 1 else 0 end) +
                  (case when windFarmEfficiency >= 65 then 1 else 0 end) +
                  (case when windFarmRatedPowerMW > 200 then 1 else 0 end) +
                  (case when windFarmDensityMWKm2 > 7 then 1 else 0 end) +
                  (case when rotorDiameterM > 120 then 1 else 0 end) +
                  (case when nacelleHeightM > 120 then 1 else 0 end) +
                  (case when windFarmAreaKm2 > 50 then 1 else 0 end) +
                  (case when numberWT > 50 then 1 else 0 end) +
                  (case when wtRatedPowerMW >= 8 then 1 else 0 end)) = 9 then 5.0
            // 8 grüne Felder = 4.0 Sterne (8 × 0.5)
            when ((case when capacityFactorReal >= 45 then 1 else 0 end) +
                  (case when windFarmEfficiency >= 65 then 1 else 0 end) +
                  (case when windFarmRatedPowerMW > 200 then 1 else 0 end) +
                  (case when windFarmDensityMWKm2 > 7 then 1 else 0 end) +
                  (case when rotorDiameterM > 120 then 1 else 0 end) +
                  (case when nacelleHeightM > 120 then 1 else 0 end) +
                  (case when windFarmAreaKm2 > 50 then 1 else 0 end) +
                  (case when numberWT > 50 then 1 else 0 end) +
                  (case when wtRatedPowerMW >= 8 then 1 else 0 end)) = 8 then 4.0
            // 7 grüne Felder = 3.5 Sterne (7 × 0.5)
            when ((case when capacityFactorReal >= 45 then 1 else 0 end) +
                  (case when windFarmEfficiency >= 65 then 1 else 0 end) +
                  (case when windFarmRatedPowerMW > 200 then 1 else 0 end) +
                  (case when windFarmDensityMWKm2 > 7 then 1 else 0 end) +
                  (case when rotorDiameterM > 120 then 1 else 0 end) +
                  (case when nacelleHeightM > 120 then 1 else 0 end) +
                  (case when windFarmAreaKm2 > 50 then 1 else 0 end) +
                  (case when numberWT > 50 then 1 else 0 end) +
                  (case when wtRatedPowerMW >= 8 then 1 else 0 end)) = 7 then 3.5
            // 6 grüne Felder = 3.0 Sterne (6 × 0.5)
            when ((case when capacityFactorReal >= 45 then 1 else 0 end) +
                  (case when windFarmEfficiency >= 65 then 1 else 0 end) +
                  (case when windFarmRatedPowerMW > 200 then 1 else 0 end) +
                  (case when windFarmDensityMWKm2 > 7 then 1 else 0 end) +
                  (case when rotorDiameterM > 120 then 1 else 0 end) +
                  (case when nacelleHeightM > 120 then 1 else 0 end) +
                  (case when windFarmAreaKm2 > 50 then 1 else 0 end) +
                  (case when numberWT > 50 then 1 else 0 end) +
                  (case when wtRatedPowerMW >= 8 then 1 else 0 end)) = 6 then 3.0
            // 5 grüne Felder = 2.5 Sterne (5 × 0.5)
            when ((case when capacityFactorReal >= 45 then 1 else 0 end) +
                  (case when windFarmEfficiency >= 65 then 1 else 0 end) +
                  (case when windFarmRatedPowerMW > 200 then 1 else 0 end) +
                  (case when windFarmDensityMWKm2 > 7 then 1 else 0 end) +
                  (case when rotorDiameterM > 120 then 1 else 0 end) +
                  (case when nacelleHeightM > 120 then 1 else 0 end) +
                  (case when windFarmAreaKm2 > 50 then 1 else 0 end) +
                  (case when numberWT > 50 then 1 else 0 end) +
                  (case when wtRatedPowerMW >= 8 then 1 else 0 end)) = 5 then 2.5
            // 4 grüne Felder = 2.0 Sterne (4 × 0.5)
            when ((case when capacityFactorReal >= 45 then 1 else 0 end) +
                  (case when windFarmEfficiency >= 65 then 1 else 0 end) +
                  (case when windFarmRatedPowerMW > 200 then 1 else 0 end) +
                  (case when windFarmDensityMWKm2 > 7 then 1 else 0 end) +
                  (case when rotorDiameterM > 120 then 1 else 0 end) +
                  (case when nacelleHeightM > 120 then 1 else 0 end) +
                  (case when windFarmAreaKm2 > 50 then 1 else 0 end) +
                  (case when numberWT > 50 then 1 else 0 end) +
                  (case when wtRatedPowerMW >= 8 then 1 else 0 end)) = 4 then 2.0
            // 3 grüne Felder = 1.5 Sterne (3 × 0.5)
            when ((case when capacityFactorReal >= 45 then 1 else 0 end) +
                  (case when windFarmEfficiency >= 65 then 1 else 0 end) +
                  (case when windFarmRatedPowerMW > 200 then 1 else 0 end) +
                  (case when windFarmDensityMWKm2 > 7 then 1 else 0 end) +
                  (case when rotorDiameterM > 120 then 1 else 0 end) +
                  (case when nacelleHeightM > 120 then 1 else 0 end) +
                  (case when windFarmAreaKm2 > 50 then 1 else 0 end) +
                  (case when numberWT > 50 then 1 else 0 end) +
                  (case when wtRatedPowerMW >= 8 then 1 else 0 end)) = 3 then 1.5
            // 2 grüne Felder = 1.0 Stern (2 × 0.5)
            when ((case when capacityFactorReal >= 45 then 1 else 0 end) +
                  (case when windFarmEfficiency >= 65 then 1 else 0 end) +
                  (case when windFarmRatedPowerMW > 200 then 1 else 0 end) +
                  (case when windFarmDensityMWKm2 > 7 then 1 else 0 end) +
                  (case when rotorDiameterM > 120 then 1 else 0 end) +
                  (case when nacelleHeightM > 120 then 1 else 0 end) +
                  (case when windFarmAreaKm2 > 50 then 1 else 0 end) +
                  (case when numberWT > 50 then 1 else 0 end) +
                  (case when wtRatedPowerMW >= 8 then 1 else 0 end)) = 2 then 1.0
            // 1 grünes Feld = 0.5 Sterne (1 × 0.5)
            when ((case when capacityFactorReal >= 45 then 1 else 0 end) +
                  (case when windFarmEfficiency >= 65 then 1 else 0 end) +
                  (case when windFarmRatedPowerMW > 200 then 1 else 0 end) +
                  (case when windFarmDensityMWKm2 > 7 then 1 else 0 end) +
                  (case when rotorDiameterM > 120 then 1 else 0 end) +
                  (case when nacelleHeightM > 120 then 1 else 0 end) +
                  (case when windFarmAreaKm2 > 50 then 1 else 0 end) +
                  (case when numberWT > 50 then 1 else 0 end) +
                  (case when wtRatedPowerMW >= 8 then 1 else 0 end)) = 1 then 0.5
            else 0.0  // 0 grüne Felder = 0.0 Sterne
        end as overallRating : Decimal(2,1)
    };

    // value help entities with static category values
    @readonly
    entity CountryValueHelp as projection on windfarm.WindFarms {
        key country
    } group by country;

    // static Sea categories
    @readonly
    entity windFarmValueHelp as projection on windfarm.WindFarms {
        key windFarm
    } group by windFarm;

    // static Sea categories
    @readonly
    entity waterBodyValueHelp as projection on windfarm.WindFarms {
        key waterBody
    } group by waterBody;

    // static capacity factor categories
    @readonly
    entity CapacityFactorCategoryValueHelp {
        key capacityFactorCategory : String;
    }
    
    // static efficiency categories  
    @readonly
    entity EfficiencyCategoryValueHelp {
        key efficiencyCategory : String;
    }
    
    // static power rating categories
    @readonly
    entity PowerRatingCategoryValueHelp {
        key powerRatingCategory : String;
    }
    
    // static density categories
    @readonly
    entity DensityCategoryValueHelp {
        key densityCategory : String;
    }

    // analytical entity task 1
    @readonly
    entity WindFarmAnalytics as projection on windfarm.WindFarmAnalytics {
        *
    };

    //  TASK 3 ENTITY - FULL CORRELATION ANALYSIS
    @readonly
    entity WindFarmCorrelationAnalysis as projection on windfarm.WindFarmCorrelationData {
        *,

        // efficiency correlations
        case
            when (nacelleHeightM > 100 and windFarmEfficiency > 65) then 'High Height + High Efficiency'
            when (nacelleHeightM <= 80 and windFarmEfficiency > 65) then 'Low Height + High Efficiency'
            when (nacelleHeightM > 100 and windFarmEfficiency <= 65) then 'High Height + Low Efficiency'
            else 'Low Height + Low Efficiency'
        end as heightEfficiencyProfile : String,
        
        case
            when (windFarmAreaKm2 > 50 and windFarmEfficiency > 65) then 'Large Area + High Efficiency'
            when (windFarmAreaKm2 <= 25 and windFarmEfficiency > 65) then 'Small Area + High Efficiency'
            when (windFarmAreaKm2 > 50 and windFarmEfficiency <= 65) then 'Large Area + Low Efficiency'
            else 'Small Area + Low Efficiency'
        end as areaEfficiencyProfile : String,
        
        case
            when (rotorDiameterM > 120 and windFarmEfficiency > 65) then 'Large Rotor + High Efficiency'
            when (rotorDiameterM <= 100 and windFarmEfficiency > 65) then 'Small Rotor + High Efficiency'
            when (rotorDiameterM > 120 and windFarmEfficiency <= 65) then 'Large Rotor + Low Efficiency'
            else 'Small Rotor + Low Efficiency'
        end as rotorEfficiencyProfile : String,
        
        case
            when (numberWT > 50 and windFarmEfficiency > 65) then 'Many Turbines + High Efficiency'
            when (numberWT <= 25 and windFarmEfficiency > 65) then 'Few Turbines + High Efficiency'
            when (numberWT > 50 and windFarmEfficiency <= 65) then 'Many Turbines + Low Efficiency'
            else 'Few Turbines + Low Efficiency'
        end as turbineCountEfficiencyProfile : String,
        
        case
            when (wtRatedPowerMW > 3.0 and windFarmEfficiency > 65) then 'High WT Power + High Efficiency'
            when (wtRatedPowerMW <= 2.0 and windFarmEfficiency > 65) then 'Low WT Power + High Efficiency'
            when (wtRatedPowerMW > 3.0 and windFarmEfficiency <= 65) then 'High WT Power + Low Efficiency'
            else 'Low WT Power + Low Efficiency'
        end as wtPowerEfficiencyProfile : String,
        
        case
            when (windFarmRatedPowerMW > 200 and windFarmEfficiency > 65) then 'High Farm Power + High Efficiency'
            when (windFarmRatedPowerMW <= 100 and windFarmEfficiency > 65) then 'Low Farm Power + High Efficiency'
            when (windFarmRatedPowerMW > 200 and windFarmEfficiency <= 65) then 'High Farm Power + Low Efficiency'
            else 'Low Farm Power + Low Efficiency'
        end as farmPowerEfficiencyProfile : String,

        case
            when (windFarmDensityMWKm2 > 8 and windFarmEfficiency > 65) then 'High Density + High Efficiency'
            when (windFarmDensityMWKm2 <= 5 and windFarmEfficiency > 65) then 'Low Density + High Efficiency'
            when (windFarmDensityMWKm2 > 8 and windFarmEfficiency <= 65) then 'High Density + Low Efficiency'
            else 'Low Density + Low Efficiency'
        end as densityEfficiencyProfile : String,
        
        // capacity factor correlations
        case
            when (numberWT > 50 and capacityFactorReal > 40) then 'Many Turbines + High Capacity'
            when (numberWT <= 25 and capacityFactorReal > 40) then 'Few Turbines + High Capacity'
            when (numberWT > 50 and capacityFactorReal <= 40) then 'Many Turbines + Low Capacity'
            else 'Few Turbines + Low Capacity'
        end as turbineCountCapacityProfile : String,
        
        case
            when (rotorDiameterM > 120 and capacityFactorReal > 40) then 'Large Rotor + High Capacity'
            when (rotorDiameterM <= 100 and capacityFactorReal > 40) then 'Small Rotor + High Capacity'
            when (rotorDiameterM > 120 and capacityFactorReal <= 40) then 'Large Rotor + Low Capacity'
            else 'Small Rotor + Low Capacity'
        end as rotorCapacityProfile : String,
        
        case
            when (nacelleHeightM > 100 and capacityFactorReal > 40) then 'High Height + High Capacity'
            when (nacelleHeightM <= 80 and capacityFactorReal > 40) then 'Low Height + High Capacity'
            when (nacelleHeightM > 100 and capacityFactorReal <= 40) then 'High Height + Low Capacity'
            else 'Low Height + Low Capacity'
        end as heightCapacityProfile : String,
        
        case
            when (windFarmRatedPowerMW > 200 and capacityFactorReal > 40) then 'High Farm Power + High Capacity'
            when (windFarmRatedPowerMW <= 100 and capacityFactorReal > 40) then 'Low Farm Power + High Capacity'
            when (windFarmRatedPowerMW > 200 and capacityFactorReal <= 40) then 'High Farm Power + Low Capacity'
            else 'Low Farm Power + Low Capacity'
        end as farmPowerCapacityProfile : String,
        
        case
            when (wtRatedPowerMW > 3.0 and capacityFactorReal > 40) then 'High WT Power + High Capacity'
            when (wtRatedPowerMW <= 2.0 and capacityFactorReal > 40) then 'Low WT Power + High Capacity'
            when (wtRatedPowerMW > 3.0 and capacityFactorReal <= 40) then 'High WT Power + Low Capacity'
            else 'Low WT Power + Low Capacity'
        end as wtPowerCapacityProfile : String,
        
        case
            when (windFarmAreaKm2 > 50 and capacityFactorReal > 40) then 'Large Area + High Capacity'
            when (windFarmAreaKm2 <= 25 and capacityFactorReal > 40) then 'Small Area + High Capacity'
            when (windFarmAreaKm2 > 50 and capacityFactorReal <= 40) then 'Large Area + Low Capacity'
            else 'Small Area + Low Capacity'
        end as areaCapacityProfile : String,

        case
            when (capacityFactorReal > 40 and windFarmDensityMWKm2 > 8) then 'High Cap + High Density'
            when (capacityFactorReal > 40 and windFarmDensityMWKm2 <= 8) then 'High Cap + Low Density'
            when (capacityFactorReal <= 40 and windFarmDensityMWKm2 > 8) then 'Low Cap + High Density'
            else 'Low Cap + Low Density'
        end as capacityDensityProfile : String,
        
        // rated power correlations
        case
            when (windFarmDensityMWKm2 > 8 and windFarmRatedPowerMW > 200) then 'High Density + High Rated Power'
            when (windFarmDensityMWKm2 <= 5 and windFarmRatedPowerMW > 200) then 'Low Density + High Rated Power'
            when (windFarmDensityMWKm2 > 8 and windFarmRatedPowerMW <= 200) then 'High Density + Low Rated Power'
            else 'Low Density + Low Rated Power'
        end as densityRatedPowerProfile : String,
        
        case
            when (numberWT > 50 and windFarmRatedPowerMW > 200) then 'Many Turbines + High Rated Power'
            when (numberWT <= 25 and windFarmRatedPowerMW > 200) then 'Few Turbines + High Rated Power'
            when (numberWT > 50 and windFarmRatedPowerMW <= 200) then 'Many Turbines + Low Rated Power'
            else 'Few Turbines + Low Rated Power'
        end as turbineCountRatedPowerProfile : String,
        
        case
            when (rotorDiameterM > 120 and windFarmRatedPowerMW > 200) then 'Large Rotor + High Rated Power'
            when (rotorDiameterM <= 100 and windFarmRatedPowerMW > 200) then 'Small Rotor + High Rated Power'
            when (rotorDiameterM > 120 and windFarmRatedPowerMW <= 200) then 'Large Rotor + Low Rated Power'
            else 'Small Rotor + Low Rated Power'
        end as rotorRatedPowerProfile : String,
        
        case
            when (nacelleHeightM > 100 and windFarmRatedPowerMW > 200) then 'High Height + High Rated Power'
            when (nacelleHeightM <= 80 and windFarmRatedPowerMW > 200) then 'Low Height + High Rated Power'
            when (nacelleHeightM > 100 and windFarmRatedPowerMW <= 200) then 'High Height + Low Rated Power'
            else 'Low Height + Low Rated Power'
        end as heightRatedPowerProfile : String,
        
        case
            when (wtRatedPowerMW > 3.0 and windFarmRatedPowerMW > 200) then 'High WT Power + High Rated Power'
            when (wtRatedPowerMW <= 2.0 and windFarmRatedPowerMW > 200) then 'Low WT Power + High Rated Power'
            when (wtRatedPowerMW > 3.0 and windFarmRatedPowerMW <= 200) then 'High WT Power + Low Rated Power'
            else 'Low WT Power + Low Rated Power'
        end as wtRatedPowerProfile : String,
        
        case
            when (windFarmAreaKm2 > 50 and windFarmRatedPowerMW > 200) then 'Large Area + High Rated Power'
            when (windFarmAreaKm2 <= 25 and windFarmRatedPowerMW > 200) then 'Small Area + High Rated Power'
            when (windFarmAreaKm2 > 50 and windFarmRatedPowerMW <= 200) then 'Large Area + Low Rated Power'
            else 'Small Area + Low Rated Power'
        end as areaRatedPowerProfile : String,
        
        //  wt rated power correlations
        case
            when (windFarmDensityMWKm2 > 8 and wtRatedPowerMW > 3.0) then 'High Density + High WT Power'
            when (windFarmDensityMWKm2 <= 5 and wtRatedPowerMW > 3.0) then 'Low Density + High WT Power'
            when (windFarmDensityMWKm2 > 8 and wtRatedPowerMW <= 3.0) then 'High Density + Low WT Power'
            else 'Low Density + Low WT Power'
        end as densityWtPowerProfile : String,
        
        case
            when (numberWT > 50 and wtRatedPowerMW > 3.0) then 'Many Turbines + High WT Power'
            when (numberWT <= 25 and wtRatedPowerMW > 3.0) then 'Few Turbines + High WT Power'
            when (numberWT > 50 and wtRatedPowerMW <= 3.0) then 'Many Turbines + Low WT Power'
            else 'Few Turbines + Low WT Power'
        end as turbineCountWtPowerProfile : String,
        
        case
            when (rotorDiameterM > 120 and wtRatedPowerMW > 3.0) then 'Large Rotor + High WT Power'
            when (rotorDiameterM <= 100 and wtRatedPowerMW > 3.0) then 'Small Rotor + High WT Power'
            when (rotorDiameterM > 120 and wtRatedPowerMW <= 3.0) then 'Large Rotor + Low WT Power'
            else 'Small Rotor + Low WT Power'
        end as rotorWtPowerProfile : String,
        
        case
            when (nacelleHeightM > 100 and wtRatedPowerMW > 3.0) then 'High Height + High WT Power'
            when (nacelleHeightM <= 80 and wtRatedPowerMW > 3.0) then 'Low Height + High WT Power'
            when (nacelleHeightM > 100 and wtRatedPowerMW <= 3.0) then 'High Height + Low WT Power'
            else 'Low Height + Low WT Power'
        end as heightWtPowerProfile : String,
        
        case
            when (windFarmAreaKm2 > 50 and wtRatedPowerMW > 3.0) then 'Large Area + High WT Power'
            when (windFarmAreaKm2 <= 25 and wtRatedPowerMW > 3.0) then 'Small Area + High WT Power'
            when (windFarmAreaKm2 > 50 and wtRatedPowerMW <= 3.0) then 'Large Area + Low WT Power'
            else 'Small Area + Low WT Power'
        end as areaWtPowerProfile : String,

        // Basic Metric Criticalities
        case
            when capacityFactorReal >= 45 then 3
            when capacityFactorReal >= 35 then 2
            else 1
        end as capacityFactorCriticality : Integer,
        
        case
            when windFarmEfficiency >= 75 then 3
            when windFarmEfficiency >= 60 then 2
            else 1
        end as windFarmEfficiencyCriticality : Integer,
        
        case
            when windFarmDensityMWKm2 > 7 then 3
            when windFarmDensityMWKm2 > 3 then 2
            else 1
        end as windFarmDensityCriticality : Integer,

        // Rated Power Profile Criticalities 
        case
            when (windFarmDensityMWKm2 > 8 and windFarmRatedPowerMW > 200) then 3
            when (windFarmDensityMWKm2 <= 5 and windFarmRatedPowerMW > 200) then 2
            when (windFarmDensityMWKm2 > 8 and windFarmRatedPowerMW <= 200) then 2
            else 1
        end as densityRatedPowerCriticality : Integer,

        case
            when (numberWT > 50 and windFarmRatedPowerMW > 200) then 3
            when (numberWT <= 25 and windFarmRatedPowerMW > 200) then 2
            when (numberWT > 50 and windFarmRatedPowerMW <= 200) then 2
            else 1
        end as turbineCountRatedPowerCriticality : Integer,

        case
            when (rotorDiameterM > 120 and windFarmRatedPowerMW > 200) then 3
            when (rotorDiameterM <= 100 and windFarmRatedPowerMW > 200) then 2
            when (rotorDiameterM > 120 and windFarmRatedPowerMW <= 200) then 2
            else 1
        end as rotorRatedPowerCriticality : Integer,

        case
            when (nacelleHeightM > 100 and windFarmRatedPowerMW > 200) then 3
            when (nacelleHeightM <= 80 and windFarmRatedPowerMW > 200) then 2
            when (nacelleHeightM > 100 and windFarmRatedPowerMW <= 200) then 2
            else 1
        end as heightRatedPowerCriticality : Integer,

        case
            when (wtRatedPowerMW > 3.0 and windFarmRatedPowerMW > 200) then 3
            when (wtRatedPowerMW <= 2.0 and windFarmRatedPowerMW > 200) then 2
            when (wtRatedPowerMW > 3.0 and windFarmRatedPowerMW <= 200) then 2
            else 1
        end as wtRatedPowerCriticality : Integer,

        case
            when (windFarmAreaKm2 > 50 and windFarmRatedPowerMW > 200) then 3
            when (windFarmAreaKm2 <= 25 and windFarmRatedPowerMW > 200) then 2
            when (windFarmAreaKm2 > 50 and windFarmRatedPowerMW <= 200) then 2
            else 1
        end as areaRatedPowerCriticality : Integer,
        
        case
            when (windFarmDensityMWKm2 > 8 and wtRatedPowerMW > 3.0) then 3
            when (windFarmDensityMWKm2 <= 5 and wtRatedPowerMW > 3.0) then 2
            when (windFarmDensityMWKm2 > 8 and wtRatedPowerMW <= 3.0) then 2
            else 1
        end as densityWtPowerCriticality : Integer,

        case
            when (numberWT > 50 and wtRatedPowerMW > 3.0) then 3
            when (numberWT <= 25 and wtRatedPowerMW > 3.0) then 2
            when (numberWT > 50 and wtRatedPowerMW <= 3.0) then 2
            else 1
        end as turbineCountWtPowerCriticality : Integer,

        case
            when (rotorDiameterM > 120 and wtRatedPowerMW > 3.0) then 3
            when (rotorDiameterM <= 100 and wtRatedPowerMW > 3.0) then 2
            when (rotorDiameterM > 120 and wtRatedPowerMW <= 3.0) then 2
            else 1
        end as rotorWtPowerCriticality : Integer,

        case
            when (nacelleHeightM > 100 and wtRatedPowerMW > 3.0) then 3
            when (nacelleHeightM <= 80 and wtRatedPowerMW > 3.0) then 2
            when (nacelleHeightM > 100 and wtRatedPowerMW <= 3.0) then 2
            else 1
        end as heightWtPowerCriticality : Integer,

        case
            when (windFarmAreaKm2 > 50 and wtRatedPowerMW > 3.0) then 3
            when (windFarmAreaKm2 <= 25 and wtRatedPowerMW > 3.0) then 2
            when (windFarmAreaKm2 > 50 and wtRatedPowerMW <= 3.0) then 2
            else 1
        end as areaWtPowerCriticality : Integer,

        // Capacity Factor Profile Criticalities
        case
            when (numberWT > 50 and capacityFactorReal > 40) then 3
            when (numberWT <= 25 and capacityFactorReal > 40) then 2
            when (numberWT > 50 and capacityFactorReal <= 40) then 2
            else 1
        end as turbineCountCapacityCriticality : Integer,
        
        case
            when (rotorDiameterM > 120 and capacityFactorReal > 40) then 3
            when (rotorDiameterM <= 100 and capacityFactorReal > 40) then 2
            when (rotorDiameterM > 120 and capacityFactorReal <= 40) then 2
            else 1
        end as rotorCapacityCriticality : Integer,
        
        case
            when (nacelleHeightM > 100 and capacityFactorReal > 40) then 3
            when (nacelleHeightM <= 80 and capacityFactorReal > 40) then 2
            when (nacelleHeightM > 100 and capacityFactorReal <= 40) then 2
            else 1
        end as heightCapacityCriticality : Integer,
        
        case
            when (windFarmRatedPowerMW > 200 and capacityFactorReal > 40) then 3
            when (windFarmRatedPowerMW <= 100 and capacityFactorReal > 40) then 2
            when (windFarmRatedPowerMW > 200 and capacityFactorReal <= 40) then 2
            else 1
        end as farmPowerCapacityCriticality : Integer,
        
        case
            when (wtRatedPowerMW > 3.0 and capacityFactorReal > 40) then 3
            when (wtRatedPowerMW <= 2.0 and capacityFactorReal > 40) then 2
            when (wtRatedPowerMW > 3.0 and capacityFactorReal <= 40) then 2
            else 1
        end as wtPowerCapacityCriticality : Integer,
        
        case
            when (windFarmAreaKm2 > 50 and capacityFactorReal > 40) then 3
            when (windFarmAreaKm2 <= 25 and capacityFactorReal > 40) then 2
            when (windFarmAreaKm2 > 50 and capacityFactorReal <= 40) then 2
            else 1
        end as areaCapacityCriticality : Integer,
        
        case
            when (capacityFactorReal > 40 and windFarmDensityMWKm2 > 8) then 3
            when (capacityFactorReal > 40 and windFarmDensityMWKm2 <= 8) then 2
            when (capacityFactorReal <= 40 and windFarmDensityMWKm2 > 8) then 2
            else 1
        end as capacityDensityCriticality : Integer,

        // CRITICALITY FIELDS
        case
            when (nacelleHeightM > 100 and windFarmEfficiency > 65) then 3
            when (nacelleHeightM <= 80 and windFarmEfficiency > 65) then 2
            when (nacelleHeightM > 100 and windFarmEfficiency <= 65) then 2
            else 1
        end as heightEfficiencyCriticality : Integer,
        
        case
            when (windFarmAreaKm2 > 50 and windFarmEfficiency > 65) then 3
            when (windFarmAreaKm2 <= 25 and windFarmEfficiency > 65) then 2
            when (windFarmAreaKm2 > 50 and windFarmEfficiency <= 65) then 2
            else 1
        end as areaEfficiencyCriticality : Integer,
        
        case
            when (rotorDiameterM > 120 and windFarmEfficiency > 65) then 3
            when (rotorDiameterM <= 100 and windFarmEfficiency > 65) then 2
            when (rotorDiameterM > 120 and windFarmEfficiency <= 65) then 2
            else 1
        end as rotorEfficiencyCriticality : Integer,
        
        case
            when (numberWT > 50 and windFarmEfficiency > 65) then 3
            when (numberWT <= 25 and windFarmEfficiency > 65) then 2
            when (numberWT > 50 and windFarmEfficiency <= 65) then 2
            else 1
        end as turbineCountEfficiencyCriticality : Integer,
        
        case
            when (wtRatedPowerMW > 3.0 and windFarmEfficiency > 65) then 3
            when (wtRatedPowerMW <= 2.0 and windFarmEfficiency > 65) then 2
            when (wtRatedPowerMW > 3.0 and windFarmEfficiency <= 65) then 2
            else 1
        end as wtPowerEfficiencyCriticality : Integer,
        
        case
            when (windFarmRatedPowerMW > 200 and windFarmEfficiency > 65) then 3
            when (windFarmRatedPowerMW <= 100 and windFarmEfficiency > 65) then 2
            when (windFarmRatedPowerMW > 200 and windFarmEfficiency <= 65) then 2
            else 1
        end as farmPowerEfficiencyCriticality : Integer,
        
        case
            when (windFarmDensityMWKm2 > 8 and windFarmEfficiency > 65) then 3
            when (windFarmDensityMWKm2 <= 5 and windFarmEfficiency > 65) then 2
            when (windFarmDensityMWKm2 > 8 and windFarmEfficiency <= 65) then 2
            else 1
        end as densityEfficiencyCriticality : Integer
    };

    // task 4 entity Forecast/Recommendation Tool
    @readonly
    entity WindFarmRecommendations as projection on windfarm.WindFarmRecommendations {
        *,

        // classifications
        case                               
            when (capacityFactorReal > 40 and windFarmEfficiency > 70) then 'High Performance'
            when (capacityFactorReal > 35 and windFarmEfficiency > 60) then 'Good Performance'
            when (capacityFactorReal > 30 and windFarmEfficiency > 50) then 'Average Performance'
            else 'Below Average'
        end as performanceProfile : String,
        
        case                          
            when (capacityFactorReal >= 35 and 
                  windFarmEfficiency >= 60 and 
                  windFarmDensityMWKm2 between 1 and 7) then 'Optimal Range'
            when (capacityFactorReal >= 30 and windFarmEfficiency >= 55 and windFarmDensityMWKm2 between 1 and 13) then 'Good Range'
            else 'Improvement Potential'
        end as optimizationPotential : String,

        // criticality fields 
        case
            when capacityFactorReal >= 45 then 3       // green - good performance
            when capacityFactorReal >= 35 then 2       // yellow - average performance  
            when capacityFactorReal < 35 then 1        // red - poor performance
            else 0                                     // neutral
        end as capacityFactorCriticality : Integer,
        
        case
            when windFarmEfficiency >= 75 then 3       // green - excellent
            when windFarmEfficiency >= 65 then 3       // green - good
            when windFarmEfficiency >= 55 then 2       // yellow - average
            when windFarmEfficiency < 55 then 1        // red - poor
            else 0                                     // neutral
        end as efficiencyCriticality : Integer,
        
        case
            when windFarmRatedPowerMW > 500 then 3     // green - large capacity
            when windFarmRatedPowerMW > 200 then 3     // green - large capacity
            when windFarmRatedPowerMW > 100 then 2     // yellow - medium capacity
            when windFarmRatedPowerMW > 50 then 2      // yellow - medium capacity
            when windFarmRatedPowerMW <= 50 then 1     // red - small capacity
            else 0                                     // neutral
        end as powerRatingCriticality : Integer,
        
        case
            when windFarmDensityMWKm2 > 7 then 3       // green - high density
            when windFarmDensityMWKm2 > 3 then 2       // yellow - medium density
            when windFarmDensityMWKm2 <= 3 then 1      // red - low density
            else 0                                     // neutral
        end as densityCriticality : Integer,

        case
            when rotorDiameterM > 120 then 3           // Green - Large rotor
            when rotorDiameterM > 80 then 2            // Yellow - Medium rotor
            when rotorDiameterM <= 80 then 1           // Red - Small rotor
            else 0                                     // Neutral
        end as rotorDiameterCriticality : Integer,
        
        case
            when nacelleHeightM >= 120 then 3          // Green - High nacelle
            when nacelleHeightM >= 80 then 2           // Yellow - Medium nacelle  
            when nacelleHeightM < 80 then 1            // Red - Low nacelle
            else 0                                     // Neutral
        end as nacelleHeightCriticality : Integer,
        
        case
            when windFarmAreaKm2 > 50 then 3           // Green - Large area
            when windFarmAreaKm2 > 10 then 2           // Yellow - Medium area
            when windFarmAreaKm2 <= 10 then 1          // Red - Small area
            else 0                                     // Neutral
        end as windFarmAreaCriticality : Integer,
        
        case
            when numberWT >= 100 then 3                // Green - Large count
            when numberWT >= 50 then 3                 // Green - Large count  
            when numberWT >= 25 then 2                 // Yellow - Medium count
            when numberWT < 25 then 1                  // Red - Small count
            else 0                                     // Neutral
        end as turbineCountCriticality : Integer,

        case
            when wtRatedPowerMW >= 12 then 3           // Green - Large count
            when wtRatedPowerMW >= 8 then 3            // Green - Large count  
            when wtRatedPowerMW >= 4 then 2            // Yellow - Medium count
            when wtRatedPowerMW < 3.9 then 1           // Red - Small count
            else 0                                     // Neutral
        end as wtRatedPowerCriticality : Integer,

        // performance profile und optimization potential
        case                               
            when (capacityFactorReal > 40 and windFarmEfficiency > 70) then 3  // Green - High Performance
            when (capacityFactorReal > 35 and windFarmEfficiency > 60) then 3  // Green - Good Performance
            when (capacityFactorReal > 30 and windFarmEfficiency > 50) then 2  // Yellow - Average Performance
            else 1                                                             // Red - Below Average
        end as performanceProfileCriticality : Integer,

        case                          
            when (capacityFactorReal  >= 35 and 
                  windFarmEfficiency >= 60 and 
                  windFarmDensityMWKm2 between 1 and 7) then 3                  // Green - Optimal Range
            when (capacityFactorReal >= 30 and windFarmEfficiency >= 55 
                 and windFarmDensityMWKm2 between 1 and 13) then 2               // Yellow - Good Range
            else 1                                                               // Red - Improvement Potential
        end as optimizationPotentialCriticality : Integer,

        case                          
            when (capacityFactorReal > 40 and 
                  windFarmEfficiency > 70 and 
                  windFarmDensityMWKm2 between 1 and 7) then 3                  // Green - Optimal Range
            when (capacityFactorReal > 35 and windFarmEfficiency > 60 
                  and windFarmDensityMWKm2 between 1 and 13) then 2              // Yellow - Good Range
            else 1                                                               // Red - Improvement Potential
        end as furtherStudyCriticality : Integer,

        // suggestion
        case
           when (capacityFactorReal > 40 and
                 windFarmEfficiency > 70 and
                 windFarmDensityMWKm2 between 1 and 7) then 'suggest further Study'
           when (capacityFactorReal > 35 and windFarmEfficiency > 60 
                and windFarmDensityMWKm2 between 1 and 13) then 'maybe consider further Study'
           else 'further Study shouldn´t be considered'
        end as furtherStudy : String,

        // performance categories 
        case
            when capacityFactorReal >= 45 then 'High (45%+)'
            when capacityFactorReal >= 35 then 'Medium (35-45%)'
            else 'Low (<35%)'
        end as capacityFactorCategory : String,
       
        // efficiency categories
        case
            when windFarmEfficiency >= 75 then 'Excellent (75%+)'
            when windFarmEfficiency >= 65 then 'Good (65-75%)'
            when windFarmEfficiency >= 55 then 'Average (55-65%)'
            else 'Poor (<55%)'
        end as efficiencyCategory : String,
       
        // power rating categories
        case
            when windFarmRatedPowerMW <= 50 then '0-50 MW'
            when windFarmRatedPowerMW <= 100 then '50-100 MW'
            when windFarmRatedPowerMW <= 200 then '100-200 MW'
            when windFarmRatedPowerMW <= 500 then '200-500 MW'
            else '500+ MW'
        end as powerRatingCategory : String,
       
        // density categories
        case
            when windFarmDensityMWKm2 <= 3 then 'Low Density (≤3)'
            when windFarmDensityMWKm2 <= 7 then 'Medium Density (3-7)'
            else 'High Density (>7)'
        end as densityCategory : String,

         // rotor diameter categories 
        case
            when rotorDiameterM <= 80 then 'Small (≤80m)'
            when rotorDiameterM <= 120 then 'Medium (80-120m)'
            else 'Large (>120m)'
        end as rotorDiameterCategory : String,
        
        // nacelle height categories
        case
            when nacelleHeightM <= 80 then 'Low (<80m)'
            when nacelleHeightM <= 120 then 'Medium (80-120m)'
            else 'High (>120m)'
        end as nacelleHeightCategory : String,
        
        // wind farm area categories
        case
            when windFarmAreaKm2 <= 10 then 'Small (<10 km²)'
            when windFarmAreaKm2 <= 50 then 'Medium (10-50 km²)'
            else 'Large (>50 km²)'
        end as windFarmAreaCategory : String,
        
        // turbine count categories
        case
            when numberWT <= 25 then 'Small (<25 turbines)'
            when numberWT <= 50 then 'Medium (25-50 turbines)'
            when numberWT <= 100 then 'Large (50-100 turbines)'
            else 'Very Large (>100 turbines)'
        end as turbineCountCategory : String,

        // wind turbine rated Power categories
        case
            when wtRatedPowerMW < 4 then '0-4 MW'
            when wtRatedPowerMW < 8 then '4-8 MW'
            when wtRatedPowerMW < 12 then '8-12 MW'
            else '12+ MW'
        end as wtRatedPowerCategory : String
    };
   
    //  analytical views 
    @readonly
    entity CorrelationData as projection on windfarm.CorrelationData;
   
    // actions 
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

    // new action for correlation analysis
    action analyzeEfficiencyCorrelations() returns array of {
        correlationType: String;
        pattern: String;
        count: Integer;
        avgEfficiency: Decimal;
        farms: array of String;
    };

    action analyzeCapacityFactorCorrelations() returns array of {
        correlationType: String;
        pattern: String;
        count: Integer;
        avgCapacityFactor: Decimal;
        farms: array of String;
    };

    action analyzeRatedPowerCorrelations() returns array of {
        correlationType: String;
        pattern: String;
        count: Integer;
        avgRatedPower: Decimal;
        farms: array of String;
    };

    action analyzeWtPowerCorrelations() returns array of {
        correlationType: String;
        pattern: String;
        count: Integer;
        avgWtPower: Decimal;
        farms: array of String;
    };
}