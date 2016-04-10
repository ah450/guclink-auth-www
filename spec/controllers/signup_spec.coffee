describe 'SignupController', ->
  beforeEach module 'guclinkAuth'
  $controller = null
  $httpBackend = null
  $rootScope = null
  $state = null
  url = null
  sampleUser =
    id: 24
    name: 'test user'
    email: 'test.user@guc.edu.eg'
    verified: false
    student: false
    super_user: false
    full_name: 'Test User'
    created_at: '2016-04-08T20:06:45.391Z'
    updated_at: '2016-04-08T20:06:45.391Z'
  beforeEach inject (_$controller_, _$httpBackend_, _$rootScope_, _$state_) ->
    $controller = _$controller_
    $httpBackend = _$httpBackend_
    $state = _$state_
    $rootScope = _$rootScope_
    url = ['http://localhost:3000/api', 'users.json'].join '/'
  beforeEach ->
    $httpBackend.when('GET', 'http://localhost:3000/api/configurations.json')
    .respond({
      default_token_exp: 30,
      pass_reset_resend_delay: 120,
      pass_reset_expiration: 240,
      verification_expiration: 3600
      })

  it 'sets processing to true', ->
    $httpBackend.when('POST', url)
      .respond 201, sampleUser
    $scope = {}
    controller = $controller 'SignupController', {$scope: $scope}
    $scope.userData = sampleUser
    $scope.submit()
    expect($scope.processing).to.be.true
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  it 'transitions to welcome state', ->
    $httpBackend.when('POST', url)
      .respond 201, sampleUser
    $scope = {}
    controller = $controller 'SignupController', {$scope: $scope}
    $scope.userData = sampleUser
    $scope.submit()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    $rootScope.$apply()
    expect($state.current.name).to.eql('public.welcome')
