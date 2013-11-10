class OauthController < ApplicationController

  def index
    client = create_twitter_client(params[:twitter][:oauth_token], params[:twitter][:oauth_token_secret])

    if client.authorized?
      if current_user
        puts 'IS SIGNED IN'
        current_user.twitter = User::Twitter.new(
          oauth_token: params[:twitter][:oauth_token],
          oauth_token_secret: params[:twitter][:oauth_token_secret],
          user_name: client.info['name'],
          user_link: 'https://twitter.com/' + client.info['screen_name'],
          user_id: client.info['id_str']
        )
        current_user.name = client.info['name']

        current_user.save()
      else
        puts 'SIGN IN'
        user = User.where('twitter.user_id' => client.info['id_str']).first

        sign_in user
      end

      render json: {msg: 'success'}
    else
      render json: {msg: 'error'}, status: 401
    end

  end

  private
    def create_twitter_client(oauth_token, oauth_token_secret)
      TwitterOAuth::Client.new(
          consumer_key:    Rails.configuration.twitter_consumer_key,
          consumer_secret: Rails.configuration.twitter_consumer_secret,
          token:           oauth_token,
          secret:          oauth_token_secret
      )
    end

end
