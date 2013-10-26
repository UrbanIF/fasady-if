class Api::MapObjectsController < ApplicationController

  def index
    map_objects = MapObject.includes(:category).all
    categories = Category.all
    render json: map_objects, status: 200
    #, meta: {categories: categories.to_json}
  end

  def categories
    categories = Category.all
    render json: categories, status: 200
  end

  def default_serializer_options
    {
        root: false
    }
  end

end
