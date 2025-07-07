namespace windfarm;
 
using { managed } from '@sap/cds/common';
 
entity WindFarms : managed {
    key ID            : Integer @title: 'ID';
    // basic identification
    windFarm          : String(100) @title: 'Wind Farm Name';
    country           : String(10)  @title: 'Country';
    waterBody         : String(10)  @title: 'Sea';

      // NEUES FELD FÜR DESCRIPTION
    description       : String(500) @title: 'Description';
   
    // NEUE FELDER FÜR KOORDINATEN
    latitude          : Decimal(10,7) @title: 'Latitude';
    longitude         : Decimal(10,7) @title: 'Longitude';
   
    // NEUES FELD für Bild-URLs
    windFarmImageUrl  : String(500) @title: 'Wind Farm Image URL';
   
    // power and performance metrics
    windFarmRatedPowerMW     : Decimal(10,2) @title: 'Wind Farm Rated Power (MW)';
    windFarmDensityMWKm2     : Decimal(10,2) @title: 'Wind Farm Density (MW/km²)';
   
    // capacity factors
    capacityFactorReal          : Decimal(5,2) @title: 'Capacity Factor Real (%)';
    capacityFactorModel         : Decimal(5,2) @title: 'Capacity Factor Model (%)';
    capacityFactorInfiniteFarm  : Decimal(5,2) @title: 'Capacity Factor Infinite Farm (%)';
    capacityFactorIsolatedTurbine : Decimal(5,2) @title: 'Capacity Factor Isolated Turbine (%)';
   
    // efficiency and performance ratios
    ratioCapacityFactorRealModel : Decimal(6,2) @title: 'Ratio CF Real/Model (%)';
    windFarmEfficiency          : Decimal(5,2) @title: 'Wind Farm Efficiency (%)';
   
    // wind characteristics
    windLambda        : Decimal(6,2) @title: 'Wind Lambda';
    windKw            : Decimal(5,2) @title: 'Wind Kw';
   
    // turbine specifications
    numberWT          : Integer     @title: 'Number of Wind Turbines';
    wtRatedPowerMW    : Decimal(8,2) @title: 'WT Rated Power (MW)';
    rotorDiameterM    : Decimal(6,2) @title: 'Rotor Diameter (m)';
    nacelleHeightM    : Decimal(6,2) @title: 'Nacelle Height (m)';
   
    // area
    windFarmAreaKm2   : Decimal(10,2) @title: 'Wind Farm Area (km²)';
}


 
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

// task 1 view
view WindFarmAnalytics as select from WindFarms {
    *
};

// task 3 view 
view WindFarmCorrelationData as select from WindFarms {
    // all basic fields
    ID,
    windFarm,
    country,
    waterBody,
    windFarmImageUrl, 
    windFarmRatedPowerMW,
    windFarmDensityMWKm2,
    capacityFactorReal,
    capacityFactorModel,
    capacityFactorInfiniteFarm,
    capacityFactorIsolatedTurbine,
    ratioCapacityFactorRealModel,
    windFarmEfficiency,
    windLambda,
    windKw,
    numberWT,
    wtRatedPowerMW,
    rotorDiameterM,
    nacelleHeightM,
    windFarmAreaKm2,
    
    

};

// task 4 view

view WindFarmRecommendations as select from WindFarms {
    // all basic fields
    ID,
    windFarm,
    country,
    waterBody,
    windFarmImageUrl, 
    windFarmRatedPowerMW,
    windFarmDensityMWKm2,
    capacityFactorReal,
    capacityFactorModel,
    capacityFactorInfiniteFarm,
    capacityFactorIsolatedTurbine,
    ratioCapacityFactorRealModel,
    windFarmEfficiency,
    windLambda,
    windKw,
    numberWT,
    wtRatedPowerMW,
    rotorDiameterM,
    nacelleHeightM,
    windFarmAreaKm2,


}

 



