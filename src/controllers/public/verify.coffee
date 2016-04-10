angular.module 'guclinkAuth'
  .controller 'VerifyController', ($scope, $stateParams, $timeout,
    $state, $http, authConfigurations, AUTH_BASE_URL,
    UserAuth, $auth, $cookies, User) ->
      $scope.done = false
      $scope.message = "Account verified!" +
        " Please wait you will be redirected soon."
      $scope.success = false
      url = [AUTH_BASE_URL,
      'users', $stateParams.id, 'verify.json'].join '/'
      $http.put url, {token: $stateParams.token}
        .then (response) ->
          $scope.success = true
          $scope.done = true
          $timeout ->
            data = response.data.data
            $auth.setToken data.token
            $cookies.putObject 'currentUser', data.user
            UserAuth.currentUserData = data
            UserAuth.currentUser = new User data
            $state.go 'private.profile'
          , 800
        .catch (response) ->
          $scope.success = false
          if response.status is 422
            authConfigurations.then (config) ->
              $scope.message = "Incorrect token. Please note tokens expire " +
                "after #{config.verification_expiration / 60 / 60} hours."
              $scope.done = true
          else if response.status is 420
            authConfigurations.then (config) ->
              $scope.message = "Can only send email once every " +
                "#{config.user_verification_resend_delay / 60} minutes"
              $scope.done = true
          else
            $state.go 'public.internal_error'
