sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/task3/test/integration/FirstJourney',
		'ns/task3/test/integration/pages/WindFarmAnalyticsList',
		'ns/task3/test/integration/pages/WindFarmAnalyticsObjectPage'
    ],
    function(JourneyRunner, opaJourney, WindFarmAnalyticsList, WindFarmAnalyticsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ns/task3') + '/index.html'
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