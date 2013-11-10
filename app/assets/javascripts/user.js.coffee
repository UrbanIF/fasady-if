class UserLogic

  constructor: ->
    $('#login').on 'click', ->
      $('#login-popup').addClass('active')



    OAuth.initialize('fxI7BSLMHlXJcXcq71qRpe6_O70')


    $('#login-facebook').on 'click', ->
      OAuth.popup 'facebook', (error, result) ->
        log result

    $('#login-twitter').on 'click', ->
      OAuth.popup 'twitter', (error, result) ->
        log result
        $.ajax
          url: '/login_with_oauth'
          type: 'put'
          data:
            twitter:
              oauth_token: result.oauth_token
              oauth_token_secret: result.oauth_token_secret
          done: (json)->
            log json



    $('#login-gplus').on 'click', ->
      OAuth.popup 'google', (error, result) ->
        log result


$ ->
  window.UserLogic = new UserLogic()
