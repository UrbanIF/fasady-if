class OauthController < ApplicationController

  def twitter
    client = TwitterOAuth::Client.new(
      consumer_key:    Rails.configuration.twitter_consumer_key,
      consumer_secret: Rails.configuration.twitter_consumer_secret,
      token:           params[:oauth_token],
      secret:          params[:oauth_token_secret]
    )

    if client.authorized?
      user = current_user ||
             User.where('twitter.uid' => client.info['id_str']).first ||
             User.new

      user.twitter = User::Twitter.new(
        oauth_token:        params[:oauth_token],
        oauth_token_secret: params[:oauth_token_secret],
        user_name:          client.info['name'],
        user_link:          'https://twitter.com/' + client.info['screen_name'],
        uid:                client.info['id_str']
      )

      user.name ||= client.info['name']
      user.avatar ||= client.info['profile_image_url']
      user.save(validate: false)
      sign_in user

      render json: user, serializer: CurrentUserSerializer
    else
      render json: {msg: 'bad token or secret'}, status: 401
    end
  end


  def facebook
    begin
      facebook_user = FbGraph::User.me(params[:access_token]).fetch

      user = current_user ||
             User.where('facebook.uid' => facebook_user.identifier).first ||
             User.new

      user.facebook = User::Facebook.new(
          access_token: params[:access_token],
          expires_in:  DateTime.now + (params[:expires_in].to_i - 60) / (3600 * 24), # "- 60" cause ajax delay
          user_name: facebook_user.name,
          user_link: facebook_user.link,
          uid:       facebook_user.identifier
      )

      user.name ||= facebook_user.name
      user.avatar ||= facebook_user.picture
      user.save(validate: false)
      sign_in user

      render json: user, serializer: CurrentUserSerializer
    rescue FbGraph::InvalidToken => e
      render json: {msg: 'bad token'}, status: 401
    end
  end

end
