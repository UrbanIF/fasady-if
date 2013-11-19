class User
  user: null
  loged_in: false

  constructor: ->
    $('#login').on 'click', ->
      $('#login-popup').addClass('active')

    $('#show-profile').on 'click', ->
      $('#profile-popup').addClass('active')



    $.ajax
      url: '/api/user'
      type: 'get'
    .done(@fillUserData)
    .fail ->
      log 'not auth'


    OAuth.initialize('fxI7BSLMHlXJcXcq71qRpe6_O70')

    $('.facebook_login_action').on 'click', =>
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

    $('.twitter_login_action').on 'click', =>
      OAuth.popup 'twitter', (error, result) =>
        $.ajax
          url: '/login_with_socials/twitter'
          type: 'put'
          data:
            oauth_token: result.oauth_token
            oauth_token_secret: result.oauth_token_secret
        .done(@fillUserData)
        .fail(@loginFail)

#    $('gplus_login_action').on 'click', =>
#      OAuth.popup 'google', (error, result) =>
#        log result

  fillUserData: (json)=>
    @user = json
    @loged_in = true
    $('#login').hide()
    $('#show-profile, #profile-popup_author_name').html(json.name)

    all = ''
    for object in json.map_objects
      all += "<li>#{object.name}, #{object.prefix} #{object.street}, #{object.building_number}</li>"
    $('#user_added_objects').html all
    $('#show-profile').show()

    $('#profile-popup_author_avatar').prop('src', json.avatar) if json.avatar?

    if json.facebook
      $('.facebook_login_action').hide()
      $('.social_account_facebook').show()
      $('.btn_social_facebook.btn_social_mini, .facebook_username').prop('href', json.facebook.user_link)
      $('.facebook_username').html(json.facebook.user_name)
    else
      $('.facebook_login_action').show()
      $('.social_account_facebook').hide()

    if json.twitter
      $('.twitter_login_action').hide()
      $('.social_account_twitter').show()
      $('.btn_social_twitter.btn_social_mini, .twitter_username').prop('href', json.twitter.user_link)
      $('.twitter_username').html(json.twitter.user_name)
    else
      $('.twitter_login_action').show()
      $('.social_account_twitter').hide()

    if json.twitter and json.facebook
      $('.profile-popup_connect_accounts').hide()
    else
      $('.profile-popup_connect_accounts').show()

    if !json.twitter and !json.facebook
      $('.profile-popup_connected_accounts').hide()
    else
      $('.profile-popup_connected_accounts').show()

    $('#login-popup').removeClass('active')
    $('#add_object').trigger 'click' if $('#login').data('showForm')

  loginFail: ->
    @loged_in = false
    alert 'fail'


$ ->
  window.user = new User()
