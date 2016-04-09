angular.module 'guclinkAuth'
  .config ($urlRouterProvider) ->
    $urlRouterProvider.when '', '/login'
