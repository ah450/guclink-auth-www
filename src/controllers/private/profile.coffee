angular.module 'guclinkAuth'
  .controller 'ProfileController', ($scope, UserAuth, $state,
    parseModelErrors) ->
      $scope.processing = false
      $scope.user = UserAuth.user
      $scope.userData = {}
      $scope.loading = true
      $scope.user.reload().then ->
        $scope.loading = false

      $scope.update = ->
        return if $scope.processing
        $scope.processing = true
        passwordChanged = $scope.userData.password? &&
          $scope.userData.password.length > 2
        if passwordChanged
          $scope.user.password = $scope.userData.password
        $scope.user.$update().then ->
          postUpdate = ->
            $scope.user = UserAuth.user if passwordChanged
            $scope.processing = false

          if passwordChanged
            UserAuth.logout()
            UserAuth.login({
              email: $scope.user.email,
              password: $scope.userData.password
              }).then(postUpdate).catch ->
                $state.go 'public.internal_error'
          else
            postUpdate()
        .catch (response) ->
          if response.status is 422
            $scope.processing = false
            $scope.error = parseModelErrors response.data
          else
            $state.go '^.internal_error'
