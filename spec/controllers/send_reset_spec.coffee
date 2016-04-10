describe 'SendResetController', ->
  beforeEach module 'guclinkAuth'
  $controller = null
  $httpBackend = null
  $rootScope = null
  $state = null
  stateParams = {id: 1, token: 'token'}
  url = null
  email = 'test@guc.edu.eg'
  beforeEach inject (_$controller_, _$httpBackend_, _$rootScope_, _$state_) ->
    $controller = _$controller_
    $httpBackend = _$httpBackend_
    $state = _$state_
    $rootScope = _$rootScope_
    url = ['http://localhost:3000/api', 'users',
    encodeURIComponent(btoa(email)),
    'reset_password.json'].join '/'
  beforeEach ->
    $httpBackend.when('GET', 'http://localhost:3000/api/configurations.json')
    .respond({
      default_token_exp: 30,
      pass_reset_resend_delay: 120,
      pass_reset_expiration: 240
      })

  it 'sets processing to true when submitting', ->
    $httpBackend.when('GET', url)
      .respond 200
    $scope = {}
    controller = $controller 'SendResetController', {$scope: $scope}
    $scope.userData.email = email
    $scope.confirm()
    expect($scope.processing).to.be.true
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  it 'sets processing to false and done to true when successfull', ->
    $httpBackend.when('GET', url)
      .respond 200
    $scope = {}
    controller = $controller 'SendResetController', {$scope: $scope}
    $scope.userData.email = email
    $scope.confirm()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    expect($scope.processing).to.be.false
    expect($scope.done).to.be.true

  it 'sets error on 404', ->
    $httpBackend.when('GET', url)
      .respond 404
    $scope = {}
    controller = $controller 'SendResetController', {$scope: $scope}
    $scope.userData.email = email
    $scope.confirm()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    expect($scope.processing).to.be.false
    expect($scope.error).to.eql('User does not exist')

  it 'sets error on 422', ->
    $httpBackend.when('GET', url)
      .respond 422, {message: 'wtf'}
    $scope = {}
    controller = $controller 'SendResetController', {$scope: $scope}
    $scope.userData.email = email
    $scope.confirm()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    expect($scope.processing).to.be.false
    expect($scope.error).to.eql('wtf')

    it 'transitions to internal error state on other errors', ->
      $httpBackend.when('GET', url)
        .respond 500
      $scope = {}
      controller = $controller 'SendResetController', {$scope: $scope}
      $scope.userData.email = email
      $scope.confirm()
      $httpBackend.flush()
      $httpBackend.verifyNoOutstandingExpectation()
      $httpBackend.verifyNoOutstandingRequest()
      $rootScope.$apply()
      expect($state.current.name).to.eql('public.internal_error')
