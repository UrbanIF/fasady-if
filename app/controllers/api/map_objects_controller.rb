class Api::MapObjectsController < ApplicationController
  before_filter :authenticate_user!, only: :create
  before_filter :default_json
  def index
    map_objects = MapObject.includes(:category).order_by(:'address.street'.asc).active

    #categories = Category.all
    render json: map_objects, status: 200  #, meta: {categories: categories.to_json}
  end

  def categories
    categories = Category.all
    render json: categories, status: 200
  end


  def create
    mo = MapObject.create(map_object_params)
    mo.user = current_user
    if mo.save
      render json: mo, status: 200
    else
      render json: {message: 'Invalid parameters', errors: mo.errors}, status: 422
    end
  end

  protected
    def default_json
      request.format = :json if params[:format].nil?
    end
    def map_object_params
      params.require(:map_object).permit(:name,  :category_id, :description, :before_photo, :after_photo,
                                   location: [],
                                   address:    [:prefix, :street, :building_number, :modifier]
      )
   end

end
