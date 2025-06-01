sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/windfarm1/test/integration/FirstJourney',
		'ns/windfarm1/test/integration/pages/WindFarmAnalyticsList',
		'ns/windfarm1/test/integration/pages/WindFarmAnalyticsObjectPage'
    ],
    function(JourneyRunner, opaJourney, WindFarmAnalyticsList, WindFarmAnalyticsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ns/windfarm1') + '/index.html'
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