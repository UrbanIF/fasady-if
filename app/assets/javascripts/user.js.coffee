class UserLogic
  user: null

  constructor: ->
    $('#login').on 'click', ->
      $('#login-popup').addClass('active')


    $.ajax
      url: '/api/user'
      type: 'get'
    .done(@fillUserData)
    .fail ->
      log 'not auth'
    #            json.twitter.user_name, json.twitter.user_link


    OAuth.initialize('fxI7BSLMHlXJcXcq71qRpe6_O70')


    $('#login-facebook').on 'click', =>
      OAuth.popup 'facebook', (error, result) =>
        log result
        $.ajax
          url: '/login_with_socials/facebook'
          type: 'put'
          data:
            access_token: result.access_token
            expires_in:   result.expires_in
        .done(@fillUserData)
        .fail(@loginFail)

#        access_token

    $('#login-twitter').on 'click', =>
      OAuth.popup 'twitter', (error, result) =>
        $.ajax
          url: '/login_with_socials/twitter'
          type: 'put'
          data:
            oauth_token: result.oauth_token
            oauth_token_secret: result.oauth_token_secret
        .done(@fillUserData)
        .fail(@loginFail)



    $('#login-gplus').on 'click', =>
      OAuth.popup 'google', (error, result) =>
        log result

  fillUserData: (json)=>
    @user = json
    $('#login').hide()
    $('#show-profile').html(json.name).show()
#    json.twitter.user_name, json.twitter.user_link
    $('#login-popup').removeClass('active')
    log json

  loginFail: ->
    alert 'fail'


$ ->
  window.UserLogic = new UserLogic()
