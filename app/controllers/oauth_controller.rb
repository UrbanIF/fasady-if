class OauthController < ApplicationController

  def index
    twitter_client = TwitterOAuth::Client.new({
      consumer_key:    Rails.configuration.twitter_consumer_key,
      consumer_secret: Rails.configuration.twitter_consumer_secret,
      token:           params[:twitter][:oauth_token],
      secret:          params[:twitter][:oauth_token_secret]
    })

    if twitter_client.authorized?
      user = current_user ||
             User.where('twitter.user_id' => twitter_client.info['id_str']).first ||
             User.new

      user.twitter = create_user_twitter(params[:twitter][:oauth_token],
                                         params[:twitter][:oauth_token_secret],
                                         twitter_client)
      user.name ||= twitter_client.info['name']
      user.save(validate: false)
      sign_in user

      render json: user
    else
      render json: {msg: 'error'}, status: 401
    end

  end

  private

    def create_user_twitter(oauth_token, oauth_token_secret, client)
      User::Twitter.new(
          oauth_token: oauth_token,
          oauth_token_secret: oauth_token_secret,
          user_name: client.info['name'],
          user_link: 'https://twitter.com/' + client.info['screen_name'],
          uid: client.info['id_str']
      )
    end

end
