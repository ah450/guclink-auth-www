describe 'LoginController', ->
  beforeEach module 'guclinkAuth'
  $controller = null
  $httpBackend = null
  $rootScope = null
  $state = null
  beforeEach inject (_$controller_, _$httpBackend_, _$rootScope_, _$state_) ->
    $controller = _$controller_
    $httpBackend = _$httpBackend_
    $state = _$state_
    $rootScope = _$rootScope_
  beforeEach ->
    $httpBackend.when('GET', 'http://localhost:3000/api/configurations.json')
    .respond({
      default_token_exp: 30
      })
  afterEach inject (_UserAuth_) ->
    _UserAuth_.logout()

  it 'sets processing to true when submitting', ->
    $scope = {}
    controller = $controller 'LoginController', {$scope: $scope}
    $httpBackend.when('POST', 'http://localhost:3000/api/tokens.json')
      .respond 401
    $scope.submit()
    expect($scope.processing).to.be.true
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  it 'sets error for 401', ->
    $scope = {}
    controller = $controller 'LoginController', {$scope: $scope}
    $httpBackend.when('POST', 'http://localhost:3000/api/tokens.json')
      .respond 401
    $scope.submit()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    expect($scope.processing).to.be.false
    expect($scope.error).to.eql('Invalid email or password')

  it 'sets received error for 403', ->
    $scope = {}
    controller = $controller 'LoginController', {$scope: $scope}
    $httpBackend.when('POST', 'http://localhost:3000/api/tokens.json')
      .respond 403, {message: 'unverified'}
    $scope.submit()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    expect($scope.processing).to.be.false
    expect($scope.error).to.eql('unverified')

  it 'transitions to internal error for any other error', ->
    $scope = {}
    controller = $controller 'LoginController', {$scope: $scope}
    $httpBackend.when('POST', 'http://localhost:3000/api/tokens.json')
      .respond 500
    $scope.submit()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    $rootScope.$apply()
    expect($state.current.name).to.eql('public.internal_error')

  it 'transitions to profile page on successfull login', ->
    $scope = {}
    controller = $controller 'LoginController', {$scope: $scope}
    $httpBackend.when('POST', 'http://localhost:3000/api/tokens.json')
      .respond(201, {
        user:
          id: 24
          name: 'test user'
          email: 'test.user@guc.edu.eg'
          verified: true
          student: false
          super_user: false
          full_name: 'Test User'
          created_at: '2016-04-08T20:06:45.391Z'
          updated_at: '2016-04-08T20:06:45.391Z'
        token: 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPbmxpbmUgSldUIEJ1aWxkZXIiLCJpYXQiOjE0NjAyMDAyMzAsImV4cCI6MTQ5MTczNjIzMCwiYXVkIjoid3d3LmV4YW1wbGUuY29tIiwic3ViIjoianJvY2tldEBleGFtcGxlLmNvbSIsIkdpdmVuTmFtZSI6IkpvaG5ueSIsIlN1cm5hbWUiOiJSb2NrZXQiLCJFbWFpbCI6Impyb2NrZXRAZXhhbXBsZS5jb20iLCJSb2xlIjpbIk1hbmFnZXIiLCJQcm9qZWN0IEFkbWluaXN0cmF0b3IiXX0.Q82UHJ8ep8EUYLKBdwpiTa9S4j5lSxHFrTP3uePnln8'
        })
    $scope.submit()
    $httpBackend.flush()
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()
    $rootScope.$apply()
    expect($state.current.name).to.eql('private.profile')
