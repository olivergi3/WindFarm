sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/task4/test/integration/FirstJourney',
		'ns/task4/test/integration/pages/WindFarmRecommendationsList',
		'ns/task4/test/integration/pages/WindFarmRecommendationsObjectPage'
    ],
    function(JourneyRunner, opaJourney, WindFarmRecommendationsList, WindFarmRecommendationsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ns/task4') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheWindFarmRecommendationsList: WindFarmRecommendationsList,
					onTheWindFarmRecommendationsObjectPage: WindFarmRecommendationsObjectPage
                }
            },
            opaJourney.run
        );
    }
);