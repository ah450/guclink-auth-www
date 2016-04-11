angular.module 'guclinkAuth', ['ui.router', 'ui.router.title',
  'guclinkAuthTemplates', 'satellizer', 'ngCookies', 'ngAnimate',
  'angulartics', 'angulartics.google.analytics', 'ngMaterial', 'ngMessages',
  'guclinkAuthModules', 'guclinkConstants', 'guclinkCommon',
  'ngClickToggle', 'ngClickRemove'
  ]


angular.module 'guclinkAuth'
  .config ($compileProvider) ->
    $compileProvider.debugInfoEnabled false

angular.module 'guclinkAuth'
  .config ($cookiesProvider) ->
    $cookiesProvider.defaults =
      path: '/'
      domain: 'guclink.in'
      secure: true

angular.module 'guclinkAuth'
  .config ($urlMatcherFactoryProvider) ->
    $urlMatcherFactoryProvider.strictMode false
