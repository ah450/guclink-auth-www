describe 'VerifyController', ->
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
    '1', 'verify.json'].join '/'
    stateParams = {id: 1, token: 'token'}
  beforeEach ->
    $httpBackend.when('GET', 'http://localhost:3000/api/configurations.json')
    .respond({
      default_token_exp: 30,
      pass_reset_resend_delay: 120,
      pass_reset_expiration: 240,
      verification_expiration: 3600
      })

  it 'sets done and success to false initially', ->
    $httpBackend.when('PUT', url)
      .respond 200
    $scope = {}
    controller = $controller 'VerifyController', {$scope: $scope,
    $stateParams: stateParams}
    expect($scope.done).to.be.false
    expect($scope.success).to.be.false
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  it 'sets success to false and done to true on 422', ->
    $httpBackend.when('PUT', url)
      .respond 422
    $scope = {}
    controller = $controller 'VerifyController', {$scope: $scope,
    $stateParams: stateParams}
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    expect($scope.done).to.be.true
    expect($scope.success).to.be.false

  it 'sets success to false and done to true on 420', ->
    $httpBackend.when('PUT', url)
      .respond 420
    $scope = {}
    controller = $controller 'VerifyController', {$scope: $scope,
    $stateParams: stateParams}
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    expect($scope.done).to.be.true
    expect($scope.success).to.be.false

  it 'transitions to internal error on other errors', ->
    $httpBackend.when('PUT', url)
      .respond 404
    $scope = {}
    controller = $controller 'VerifyController', {$scope: $scope,
    $stateParams: stateParams}
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    $rootScope.$apply()
    expect($state.current.name).to.eql('public.internal_error')
