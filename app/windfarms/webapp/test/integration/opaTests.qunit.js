sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/windfarms/test/integration/FirstJourney',
		'ns/windfarms/test/integration/pages/WindFarmsList',
		'ns/windfarms/test/integration/pages/WindFarmsObjectPage'
    ],
    function(JourneyRunner, opaJourney, WindFarmsList, WindFarmsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ns/windfarms') + '/index.html'
        });

       
        JourneyRunner.run(
            {
                pages: { 
					onTheWindFarmsList: WindFarmsList,
					onTheWindFarmsObjectPage: WindFarmsObjectPage
                }
            },
            opaJourney.run
        );
    }
);