describe 'ResetController', ->
  beforeEach module 'guclinkAuth'
  $controller = null
  $httpBackend = null
  $rootScope = null
  $state = null
  stateParams = {id: 1, token: 'token'}
  url = null
  beforeEach inject (_$controller_, _$httpBackend_, _$rootScope_, _$state_) ->
    $controller = _$controller_
    $httpBackend = _$httpBackend_
    $state = _$state_
    $rootScope = _$rootScope_
    url = ['http://localhost:3000/api', 'users', '1',
    'confirm_reset.json'].join '/'
  beforeEach ->
    $httpBackend.when('GET', 'http://localhost:3000/api/configurations.json')
    .respond({
      default_token_exp: 30,
      pass_reset_resend_delay: 120
      })

  it 'sets processing to true when submitting', ->
    $httpBackend.when('PUT', url)
      .respond 200
    $scope = {}
    controller = $controller 'ResetController', {$scope: $scope,
    $stateParams: stateParams}
    $scope.resetPassword()
    expect($scope.processing).to.be.true
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  it 'sets error for 404', ->
    $httpBackend.when('PUT', url)
      .respond 404
    $scope = {}
    controller = $controller 'ResetController', {$scope: $scope,
    $stateParams: stateParams}
    $scope.resetPassword()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    expect($scope.error).to.eql('User does not exist')
    expect($scope.processing).to.be.false

  it 'sets error for 422', ->
    $httpBackend.when('PUT', url)
      .respond 422, {message: 'error'}
    $scope = {}
    controller = $controller 'ResetController', {$scope: $scope,
    $stateParams: stateParams}
    $scope.resetPassword()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    expect($scope.error).to.eql('error')
    expect($scope.processing).to.be.false

  it 'sets error for 420', ->
    $httpBackend.when('PUT', url)
      .respond 420
    $scope = {}
    controller = $controller 'ResetController', {$scope: $scope,
    $stateParams: stateParams}
    $scope.resetPassword()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    expect($scope.error).to.eql("Can only reset once every " +
      "2 minutes")
    expect($scope.processing).to.be.false

  it 'transitions to internal error for any other error', ->
    $httpBackend.when('PUT', url)
      .respond 500
    $scope = {}
    controller = $controller 'ResetController', {$scope: $scope,
    $stateParams: stateParams}
    $scope.resetPassword()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    $rootScope.$apply()
    expect($state.current.name).to.eql('public.internal_error')
