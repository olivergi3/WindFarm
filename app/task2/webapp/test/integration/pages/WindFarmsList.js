sap.ui.define(['sap/fe/test/ListReport'], function(ListReport) {
    'use strict';

    var CustomPageDefinitions = {
        actions: {},
        assertions: {}
    };

    return new ListReport(
        {
            appId: 'ns.task2',
            componentId: 'WindFarmsList',
            contextPath: '/WindFarms'
        },
        CustomPageDefinitions
    );
});