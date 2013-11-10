class Api::UserController < ApplicationController
  before_filter :authenticate_user!

  def index
    render json: current_user, status: 200
  end

end
