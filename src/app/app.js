angular

    .module('samplePortal', [
        'ui.router',
        'samplePortal.homeServices'
    ])

    .constant('CONFIG',
    {
        DebugMode: true,
        StepCounter: 0,
        APIHost: 'http://localhost:12017'
    });
