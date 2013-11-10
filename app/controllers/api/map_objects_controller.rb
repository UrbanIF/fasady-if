class Api::MapObjectsController < ApplicationController

  def index
    map_objects = MapObject.includes(:category).order_by(:'address.street'.asc).all


    #categories = Category.all
    render json: map_objects, status: 200
    #, meta: {categories: categories.to_json}
  end

  def categories
    categories = Category.all
    render json: categories, status: 200
  end


  def create
    # puts 'xxxxxxxxxxxxxxxxxxxxx'
    # puts  map_object_params

    mo = MapObject.create! map_object_params
    mo.user = current_user
    mo.save!

    # puts  mo

    render json: mo, status: 200
    # render json: {}, status: 200
  end

  protected
    def map_object_params
      params.require(:map_object).permit(:name,  :category_id, :description,
                                   location: [],
                                   address:    [:prefix, :street, :building_number, :modifier],

                                   before_photos_attributes: [:link],
                                   after_photos_attributes:  [:link]
                                   #{ before_photos: :link },
                                   #{ after_photos: :link }
      )

   end

end
