angular.module 'guclinkAuth'
  .controller 'ResetController', ($scope, AUTH_BASE_URL, $stateParams,
    $timeout, $state, $http, authConfigurations) ->
      $scope.processing = false
      $scope.done = false
      $scope.userData = {}

      $scope.resetPassword = ->
        return if $scope.processing
        $scope.processing = true
        url = [AUTH_BASE_URL, 'users', "#{$stateParams.id}",
          'confirm_reset.json'].join '/'
        $http.put(url, {
          token: $stateParams.token, pass: $scope.userData.password
        }).then ->
          $scope.processing = false
          $scope.done = true
          $timeout ->
            $state.go 'public.login'
          , 800
        .catch (response) ->
          if response.status is 404
            $scope.processing = false
            $scope.error = 'User does not exist'
          else if response.status is 422
            $scope.processing = false
            $scope.error = response.data.message
          else if response.status is 420
            authConfigurations.then (config) ->
              $scope.error = "Can only reset once every " +
                "#{config.pass_reset_resend_delay / 60} minutes"
              $scope.processing = false
          else
            $state.go 'public.internal_error'
