sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/task1/test/integration/FirstJourney',
		'ns/task1/test/integration/pages/WindFarmAnalyticsList',
		'ns/task1/test/integration/pages/WindFarmAnalyticsObjectPage'
    ],
    function(JourneyRunner, opaJourney, WindFarmAnalyticsList, WindFarmAnalyticsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            
            launchUrl: sap.ui.require.toUrl('ns/task1') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheWindFarmAnalyticsList: WindFarmAnalyticsList,
					onTheWindFarmAnalyticsObjectPage: WindFarmAnalyticsObjectPage
                }
            },
            opaJourney.run
        );
    }
);