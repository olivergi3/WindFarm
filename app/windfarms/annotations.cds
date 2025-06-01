using WindFarmService as service from '../../srv/windfarm-service';
annotate service.WindFarms with @(
    UI.FieldGroup #GeneratedGroup : {
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
                Value : windFarmRatedPowerMW,
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmDensityMWKm2,
            },
            {
                $Type : 'UI.DataField',
                Value : capacityFactorReal,
            },
            {
                $Type : 'UI.DataField',
                Value : capacityFactorModel,
            },
            {
                $Type : 'UI.DataField',
                Value : capacityFactorInfiniteFarm,
            },
            {
                $Type : 'UI.DataField',
                Value : capacityFactorIsolatedTurbine,
            },
            {
                $Type : 'UI.DataField',
                Value : ratioCapacityFactorRealModel,
            },
            {
                $Type : 'UI.DataField',
                Value : windFarmEfficiency,
            },
            {
                $Type : 'UI.DataField',
                Value : windLambda,
            },
            {
                $Type : 'UI.DataField',
                Value : windKw,
            },
            {
                $Type : 'UI.DataField',
                Value : numberWT,
            },
            {
                $Type : 'UI.DataField',
                Value : wtRatedPowerMW,
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
                Value : windFarmAreaKm2,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ]
);
 
 