class UserLogic

  constructor: ->
    $('#login').on 'click', ->
      $('#login-popup').addClass('active')


    $.ajax
      url: '/api/user'
      type: 'get'
    .done (json)->
      $('#login').hide()
      $('#show-profile').html(json.name).show()
    .fail ->
      log 'not auth'
    #            json.twitter.user_name, json.twitter.user_link


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
        .done (json)->
          $('#login').hide()
          $('#show-profile').html(json.name).show()
#            json.twitter.user_name, json.twitter.user_link

          $('#login-popup').removeClass('active')
          log json
        .fail (json)->
          alert 'FAIL'



    $('#login-gplus').on 'click', ->
      OAuth.popup 'google', (error, result) ->
        log result


$ ->
  window.UserLogic = new UserLogic()
