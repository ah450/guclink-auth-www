angular.module 'guclinkAuth'
  .controller 'LoginController', ($scope, $state, UserAuth, redirect,
  $window) ->
    $scope.userData =
      remember: false
    $scope.processing = false
    $scope.submit = ->
      return if $scope.processing
      if $scope.userData.remember
        $scope.userData.expiration = 168
      UserAuth.login $scope.userData, $scope.userData.expiration
        .then ->
          if redirect.empty
            $state.go 'private.account'
          else
            dest = redirect.pop()
            if dest.external
              $window.location.href = dest.url
            else
              $state.go dest.state, dest.params
        .catch (response) ->
          if response.status is 401
            $scope.processing = false
            $scope.error = 'Invalid email or password'
          else if response.status is 403
            $scope.processing = false
            $scope.error = response.data.message
          else
            $state.go 'public.internal_error'
