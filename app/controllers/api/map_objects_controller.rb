class Api::MapObjectsController < ApplicationController
  before_filter :authenticate_user!, only: :create

  def index
    map_objects = MapObject.includes(:category).order_by(:'address.street'.asc).all

    #categories = Category.all
    render json: map_objects, status: 200  #, meta: {categories: categories.to_json}
  end

  def categories
    categories = Category.all
    render json: categories, status: 200
  end


  def create
    mo = MapObject.create! map_object_params
    mo.user = current_user
    mo.save!

    render json: mo, status: 200
  end

  protected
    def map_object_params
      params.require(:map_object).permit(:name,  :category_id, :description, :before_photo, :after_photo,
                                   location: [],
                                   address:    [:prefix, :street, :building_number, :modifier]
      )
   end

end
