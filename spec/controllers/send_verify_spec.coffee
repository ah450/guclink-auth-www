describe 'SendVerifyController', ->
  beforeEach module 'guclinkAuth'
  $controller = null
  $httpBackend = null
  $rootScope = null
  $state = null
  url = null
  email = 'test@guc.edu.eg'
  beforeEach inject (_$controller_, _$httpBackend_, _$rootScope_, _$state_) ->
    $controller = _$controller_
    $httpBackend = _$httpBackend_
    $state = _$state_
    $rootScope = _$rootScope_
    url = ['http://localhost:3000/api', 'users',
    encodeURIComponent(btoa(email)),
    'resend_verify.json'].join '/'
  beforeEach ->
    $httpBackend.when('GET', 'http://localhost:3000/api/configurations.json')
    .respond({
      default_token_exp: 30,
      pass_reset_resend_delay: 120,
      pass_reset_expiration: 240,
      user_verification_resend_delay: 120
      })

  it 'sets processing to true and done to false', ->
    $httpBackend.when('GET', url)
      .respond 200
    $scope = {}
    controller = $controller 'SendVerifyController', {$scope: $scope}
    $scope.userData.email = email
    $scope.verify()
    expect($scope.processing).to.be.true
    expect($scope.done).to.be.false
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  it 'sets correct error on 404', ->
    $httpBackend.when('GET', url)
      .respond 404
    $scope = {}
    controller = $controller 'SendVerifyController', {$scope: $scope}
    $scope.userData.email = email
    $scope.verify()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    expect($scope.processing).to.be.false
    expect($scope.done).to.be.false
    expect($scope.error).to.eql('User does not exist')

  it 'sets correct error on 422', ->
    $httpBackend.when('GET', url)
      .respond 422, {message: 'error'}
    $scope = {}
    controller = $controller 'SendVerifyController', {$scope: $scope}
    $scope.userData.email = email
    $scope.verify()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    expect($scope.processing).to.be.false
    expect($scope.done).to.be.false
    expect($scope.error).to.eql('error')

  it 'sets correct error on 420', ->
    $httpBackend.when('GET', url)
      .respond 420
    $scope = {}
    controller = $controller 'SendVerifyController', {$scope: $scope}
    $scope.userData.email = email
    $scope.verify()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    expect($scope.processing).to.be.false
    expect($scope.done).to.be.false
    expect($scope.error).to.eql('Must wait 2 minutes between requests')

  it 'transitions to internal_error state otherwise', ->
    $httpBackend.when('GET', url)
      .respond 500
    $scope = {}
    controller = $controller 'SendVerifyController', {$scope: $scope}
    $scope.userData.email = email
    $scope.verify()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    $rootScope.$apply()
    expect($state.current.name).to.eql('public.internal_error')

  it 'sets processing to false and done to true on success', ->
    $httpBackend.when('GET', url)
      .respond 200
    $scope = {}
    controller = $controller 'SendVerifyController', {$scope: $scope}
    $scope.userData.email = email
    $scope.verify()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    expect($scope.processing).to.be.false
    expect($scope.done).to.be.true
