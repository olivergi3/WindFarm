sap.ui.define(['sap/fe/test/ObjectPage'], function(ObjectPage) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ObjectPage(
        {
            appId: 'ns.task1',
            componentId: 'WindFarmAnalyticsObjectPage',
            contextPath: '/WindFarmAnalytics'
        },
        CustomPageDefinitions
    );
});