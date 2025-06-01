namespace windfarm;
 
using { cuid, managed } from '@sap/cds/common';
 
entity WindFarms : cuid, managed {
    // Basic Identification
    windFarm          : String(100) @title: 'Wind Farm Name';
    country           : String(10)  @title: 'Country';
   
    // Power and Performance Metrics
    windFarmRatedPowerMW     : Decimal(10,2) @title: 'Wind Farm Rated Power (MW)';
    windFarmDensityMWKm2     : Decimal(10,2) @title: 'Wind Farm Density (MW/km²)';
   
    // Capacity Factors
    capacityFactorReal          : Decimal(5,2) @title: 'Capacity Factor Real (%)';
    capacityFactorModel         : Decimal(5,2) @title: 'Capacity Factor Model (%)';
    capacityFactorInfiniteFarm  : Decimal(5,2) @title: 'Capacity Factor Infinite Farm (%)';
    capacityFactorIsolatedTurbine : Decimal(5,2) @title: 'Capacity Factor Isolated Turbine (%)';
   
    // Efficiency and Performance Ratios
    ratioCapacityFactorRealModel : Decimal(6,2) @title: 'Ratio CF Real/Model (%)';
    windFarmEfficiency          : Decimal(5,2) @title: 'Wind Farm Efficiency (%)';
   
    // Wind Characteristics
    windLambda        : Decimal(6,2) @title: 'Wind Lambda';
    windKw            : Decimal(5,2) @title: 'Wind Kw';
   
    // Turbine Specifications
    numberWT          : Integer     @title: 'Number of Wind Turbines';
    wtRatedPowerMW    : Decimal(8,2) @title: 'WT Rated Power (MW)';
    rotorDiameterM    : Decimal(6,2) @title: 'Rotor Diameter (m)';
    nacelleHeightM    : Decimal(6,2) @title: 'Nacelle Height (m)';
   
    // Area
    windFarmAreaKm2   : Decimal(10,2) @title: 'Wind Farm Area (km²)';
}
 
// BESTEHENDE VIEWS
view WindFarmPerformance as select from WindFarms {
    ID,
    windFarm,
    country,
    capacityFactorReal,
    windFarmEfficiency,
    windFarmRatedPowerMW,
    windFarmDensityMWKm2,
    numberWT,
    windFarmAreaKm2,
    case
        when capacityFactorReal >= 46.0 then 'Good'
        when capacityFactorReal >= 36.0 then 'Average'
        else 'Poor'
    end as performanceCategory : String(10) @title: 'Performance Category',
   
    case
        when windFarmDensityMWKm2 >= 12.0 then 'High'
        when windFarmDensityMWKm2 >= 7.0 then 'Medium'
        else 'Low'
    end as densityCategory : String(10) @title: 'Density Category'
};
 
view TurbineAnalysis as select from WindFarms {
    ID,
    windFarm,
    country,
    numberWT,
    wtRatedPowerMW,
    rotorDiameterM,
    nacelleHeightM,
    windFarmEfficiency,
    capacityFactorReal,
    windFarmEfficiency / wtRatedPowerMW as efficiencyPerMW : Decimal(8,2) @title: 'Efficiency per MW'
};
 
view GeographicAnalysis as select from WindFarms {
    key country,
    count(*) as farmCount : Integer @title: 'Number of Farms',
    avg(capacityFactorReal) as avgCapacityFactor : Decimal(5,2) @title: 'Average Capacity Factor',
    avg(windFarmEfficiency) as avgEfficiency : Decimal(5,2) @title: 'Average Efficiency',
    sum(windFarmRatedPowerMW) as totalPowerMW : Decimal(12,2) @title: 'Total Power (MW)',
    sum(windFarmAreaKm2) as totalAreaKm2 : Decimal(12,2) @title: 'Total Area (km²)'
} group by country;
 
view CorrelationData as select from WindFarms {
    ID,
    windFarm,
    windFarmDensityMWKm2,
    capacityFactorReal,
    windFarmEfficiency,
    rotorDiameterM,
    numberWT,
    windFarmAreaKm2,
    nacelleHeightM,
    wtRatedPowerMW
};
 
// MAIN ANALYTICAL VIEW
view WindFarmAnalytics as select from WindFarms {
    ID,
    windFarm,
    country,
    windFarmRatedPowerMW,
    capacityFactorReal,
    windFarmEfficiency,
    numberWT,
    windFarmAreaKm2,
    windFarmDensityMWKm2,
    rotorDiameterM,
    nacelleHeightM,
    wtRatedPowerMW,
    createdAt,
    modifiedAt
};
 
// NEUE VIEWS FÜR DATA VISUALIZATION
 
// 1. Performance Distribution - Zeigt Verteilung der Performance-Kategorien
view PerformanceDistribution as select from WindFarms {
    key case
        when capacityFactorReal >= 46.0 then 'Excellent (>46%)'
        when capacityFactorReal >= 36.0 then 'Good (36-46%)'
        when capacityFactorReal >= 26.0 then 'Average (26-36%)'
        else 'Poor (<26%)'
    end as performanceCategory : String(20) @title: 'Performance Category',
   
    count(*) as farmCount : Integer @title: 'Number of Farms',
    avg(capacityFactorReal) as avgCapacityFactor : Decimal(5,2) @title: 'Average Capacity Factor',
    avg(windFarmEfficiency) as avgEfficiency : Decimal(5,2) @title: 'Average Efficiency',
    sum(windFarmRatedPowerMW) as totalPower : Decimal(12,2) @title: 'Total Power (MW)',
   
    // Percentage calculation
    cast(count(*) * 100.0 / (select count(*) from WindFarms) as Decimal(5,2)) as percentage : Decimal(5,2) @title: 'Percentage (%)'
} group by case
    when capacityFactorReal >= 46.0 then 'Excellent (>46%)'
    when capacityFactorReal >= 36.0 then 'Good (36-46%)'
    when capacityFactorReal >= 26.0 then 'Average (26-36%)'
    else 'Poor (<26%)'
end;
 
// 2. Characteristics Analysis - Analysiert Wind Farm Eigenschaften
view CharacteristicsAnalysis as select from WindFarms {
    key case
        when windFarmDensityMWKm2 >= 15.0 then 'Very High Density'
        when windFarmDensityMWKm2 >= 10.0 then 'High Density'
        when windFarmDensityMWKm2 >= 5.0 then 'Medium Density'
        else 'Low Density'
    end as densityCategory : String(20) @title: 'Density Category',
   
    count(*) as farmCount : Integer @title: 'Number of Farms',
    avg(rotorDiameterM) as avgRotorDiameter : Decimal(6,2) @title: 'Average Rotor Diameter (m)',
    avg(nacelleHeightM) as avgNacelleHeight : Decimal(6,2) @title: 'Average Nacelle Height (m)',
    avg(windFarmEfficiency) as avgEfficiency : Decimal(5,2) @title: 'Average Efficiency (%)',
    avg(windFarmDensityMWKm2) as avgDensity : Decimal(6,2) @title: 'Average Density (MW/km²)',
    sum(windFarmRatedPowerMW) as totalPower : Decimal(12,2) @title: 'Total Power (MW)'
} group by case
    when windFarmDensityMWKm2 >= 15.0 then 'Very High Density'
    when windFarmDensityMWKm2 >= 10.0 then 'High Density'
    when windFarmDensityMWKm2 >= 5.0 then 'Medium Density'
    else 'Low Density'
end;
 
// 3. Country Aggregates - Umfassende Länder-Statistiken
view CountryAggregates as select from WindFarms {
    key country,
    count(*) as farmCount : Integer @title: 'Number of Farms',
   
    // Power Statistics
    sum(windFarmRatedPowerMW) as totalPowerMW : Decimal(12,2) @title: 'Total Power (MW)',
    avg(windFarmRatedPowerMW) as avgPowerMW : Decimal(8,2) @title: 'Average Power per Farm (MW)',
    max(windFarmRatedPowerMW) as maxPowerMW : Decimal(8,2) @title: 'Largest Farm (MW)',
   
    // Performance Statistics  
    avg(capacityFactorReal) as avgCapacityFactor : Decimal(5,2) @title: 'Average Capacity Factor (%)',
    avg(windFarmEfficiency) as avgEfficiency : Decimal(5,2) @title: 'Average Efficiency (%)',
   
    // Combined Performance Score (weighted average)
    cast((avg(capacityFactorReal) * 0.6 + avg(windFarmEfficiency) * 0.4) as Decimal(5,2)) as avgPerformanceScore : Decimal(5,2) @title: 'Performance Score',
   
    // Physical Characteristics
    avg(windFarmDensityMWKm2) as avgDensity : Decimal(6,2) @title: 'Average Density (MW/km²)',
    avg(rotorDiameterM) as avgRotorDiameter : Decimal(6,2) @title: 'Average Rotor Diameter (m)',
    avg(numberWT) as avgTurbineCount : Decimal(8,2) @title: 'Average Turbine Count',
   
    // Total Statistics
    sum(numberWT) as totalTurbines : Integer @title: 'Total Turbines',
    sum(windFarmAreaKm2) as totalAreaKm2 : Decimal(12,2) @title: 'Total Area (km²)'
} group by country;
 
// 4. Size Classification - Klassifikation nach Farm-Größe
view SizeClassification as select from WindFarms {
    key case
        when windFarmRatedPowerMW >= 500.0 then 'Mega (≥500 MW)'
        when windFarmRatedPowerMW >= 200.0 then 'Large (200-500 MW)'
        when windFarmRatedPowerMW >= 50.0 then 'Medium (50-200 MW)'
        else 'Small (<50 MW)'
    end as sizeCategory : String(20) @title: 'Size Category',
   
    count(*) as farmCount : Integer @title: 'Number of Farms',
    sum(windFarmRatedPowerMW) as totalPower : Decimal(12,2) @title: 'Total Power (MW)',
    avg(windFarmRatedPowerMW) as avgPower : Decimal(8,2) @title: 'Average Power (MW)',
    avg(capacityFactorReal) as avgCapacityFactor : Decimal(5,2) @title: 'Average Capacity Factor (%)',
    avg(windFarmEfficiency) as avgEfficiency : Decimal(5,2) @title: 'Average Efficiency (%)',
    avg(windFarmDensityMWKm2) as avgDensity : Decimal(6,2) @title: 'Average Density (MW/km²)',
   
    // Market share calculation
    cast(sum(windFarmRatedPowerMW) * 100.0 / (select sum(windFarmRatedPowerMW) from WindFarms) as Decimal(5,2)) as marketShare : Decimal(5,2) @title: 'Market Share (%)'
} group by case
    when windFarmRatedPowerMW >= 500.0 then 'Mega (≥500 MW)'
    when windFarmRatedPowerMW >= 200.0 then 'Large (200-500 MW)'
    when windFarmRatedPowerMW >= 50.0 then 'Medium (50-200 MW)'
    else 'Small (<50 MW)'
end;