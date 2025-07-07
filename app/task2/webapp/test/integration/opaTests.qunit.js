sap.ui.require(
    [
        'sap/fe/test/JourneyRunner',
        'ns/task2/test/integration/FirstJourney',
		'ns/task2/test/integration/pages/WindFarmsList',
		'ns/task2/test/integration/pages/WindFarmsObjectPage'
    ],
    function(JourneyRunner, opaJourney, WindFarmsList, WindFarmsObjectPage) {
        'use strict';
        var JourneyRunner = new JourneyRunner({
            // start index.html in web folder
            launchUrl: sap.ui.require.toUrl('ns/task2') + '/index.html'
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