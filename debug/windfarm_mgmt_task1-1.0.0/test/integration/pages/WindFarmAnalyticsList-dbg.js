sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'ns.task1',
            componentId: 'WindFarmAnalyticsList',
            contextPath: '/WindFarmAnalytics'
        },
        CustomPageDefinitions
    );
});