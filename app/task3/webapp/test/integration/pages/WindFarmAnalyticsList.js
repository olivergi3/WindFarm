sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'ns.task3',
            componentId: 'WindFarmAnalyticsList',
            contextPath: '/WindFarmAnalytics'
        },
        CustomPageDefinitions
    );
});