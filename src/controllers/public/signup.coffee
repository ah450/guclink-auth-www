angular.module 'guclinkAuth'
  .controller 'SignupController', ($scope, UserAuth, $state,
    parseModelErrors) ->
      $scope.processing = false
      $scope.userData = {}
      $scope.submit = ->
        return if $scope.processing
        $scope.processing = true
        UserAuth.signup $scope.userData
          .then ->
            $state.go 'public.welcome'
          .catch (response) ->
            if response.status is 422
              $scope.processing = false
              $scope.error = parseModelErrors response.data
            else
              $state.go 'public.internal_error'
