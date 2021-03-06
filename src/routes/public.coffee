angular.module 'guclinkAuth'
  .config ($stateProvider) ->
    publicState =
      name: 'public'
      url: ''
      abstract: true
      templateUrl: 'auth/public/root.html'
      data:
        authRule: (userAuth) ->
          if userAuth.signedIn
            {
              to: 'private.profile'
              params: {}
              allowed: false
            }
          else
            {
              allowed: true
            }

    loginState =
      name: 'public.login'
      url: '/login'
      views:
        "":
          templateUrl: 'auth/public/login.html'
          controller: 'LoginController'
      resolve:
        $title: ->
          'GUCLINK| Login'

    signupState =
      name: 'public.signup'
      url: '/signup'
      views:
        "":
          templateUrl: 'auth/public/signup.html'
          controller: 'SignupController'
      resolve:
        $title: ->
          'GUCLINK| Signup'

    verifyAccount =
      name: 'public.verify'
      url: '/verify/:id?token'
      views:
        "":
          templateUrl: 'auth/generic/wait_message.html'
          controller: 'VerifyController'
      resolve:
        $title: ->
          'Confirm Email'


    resetPass =
      name: 'public.reset'
      url: '/reset/:id?token'
      views:
        "":
          templateUrl: 'auth/public/reset.html'
          controller: 'ResetController'
      resolve:
        $title: ->
          'Confirm Reset'


    sendReset =
      name: 'public.reset_send'
      url: '/resetpass'
      views:
        "":
          templateUrl: 'auth/public/reset_send.html'
          controller: 'SendResetController'
      resolve:
        $title: ->
          'Reset Password'

    sendVerification =
      name: 'public.verify_send'
      url: '/reverify'
      views:
        "":
          templateUrl: 'auth/public/verify_send.html'
          controller: 'SendVerifyController'
      resolve:
        $title: ->
          'Resend Verification'

    welcomeState =
      name: 'public.welcome'
      url: '/welcome'
      views:
        "":
          templateUrl: 'auth/public/welcome.html'

    internalErrorState =
      name: 'public.internal_error'
      url: '/oops'
      views:
        "":
          templateUrl: 'auth/public/internal_error.html'
      resolve:
        $title: ->
          'Oopsy'

    $stateProvider
      .state publicState
      .state loginState
      .state signupState
      .state internalErrorState
      .state resetPass
      .state verifyAccount
      .state sendReset
      .state sendVerification
      .state welcomeState
