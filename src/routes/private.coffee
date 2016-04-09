angular.module 'guclinkAuth'
  .config ($stateProvider) ->

    privateState =
      name: 'private'
      url: ''
      abstract: true
      data:
        authRule: (userAuth) ->
          if userAuth.signedIn
            {
              allowed: true
            }
          else
            {
              to: 'public.login'
              params: {}
              allowed: false
            }

    internalErrorState =
      name: 'private.internal_error'
      url: '/ooops'
      templateUrl: 'auth/public/internal_error.html'
      resolve:
        $title: ->
          'Oopsy'

    profileState =
      name: 'private.profile'
      url: '/profile'
      templateUrl: 'auth/private/profile.html'
      controller: 'ProfileController'
      resolve:
        $title: ->
          'GUCLINK| Profile'

    $stateProvider
      .state privateState
      .state internalErrorState
      .state profileState
