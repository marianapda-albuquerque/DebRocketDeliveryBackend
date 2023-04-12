class Api::RestaurantsController < ApplicationController
  include ApiHelper
  
  def index
    if params['rating'] != nil || params['price_range'] != nil
      if !is_number_in_range?(params['rating'], 1, 5)
        render_422_error('Invalid rating or price range')
      elsif !is_number_in_range?(params['price_range'], 1, 3)
        render_422_error('Invalid rating or price range')
      else
        @restaurants = Restaurant.joins(:orders).where(["price_range = ? and orders.restaurant_rating = ?", params['price_range'], params['rating']]).select('restaurant_id as id, name, price_range, orders.restaurant_rating as rating')

        if @restaurants.length == 0
          render_422_error('No restaurants found')
        else
          render json: @restaurants, status: 200
        end
      end
    else
      @restaurants = Restaurant.all
    end
  end

  def show
      @element = Restaurant.find(params[:id])
  end

  def new
      render
  end

  def create
      m = ''
      transaction_succeeded = false
  
      ActiveRecord::Base.transaction do
        user = User.where(email: restaurant_params[:user_email]).first
        
        if !user 
          m = 'User not found.'
          raise ActiveRecord::Rollback
        end
  
        address = Address.find_or_create_by!(street_address: restaurant_params[:street_address], city: restaurant_params[:city], postal_code: restaurant_params[:postal_code])
  
        restaurant = Restaurant.where(address_id: address.id).first
        
        if restaurant
          m = 'Address already in use.'
          raise ActiveRecord::Rollback
        end
  
        response = Restaurant.create(user_id: user.id, address_id: address.id, name: restaurant_params[:name], price_range: restaurant_params[:price_range], email: restaurant_params[:email], phone: restaurant_params[:phone])

        if !response
          m = 'Failed to create restaurant.'
          raise ActiveRecord::Rollback
        end
  
        transaction_succeeded = true
      end
  
      if transaction_succeeded
        flash[:notice] = "Restaurant created!"
        redirect_to api_restaurants_url
      else
        flash[:notice] = m
        redirect_to new_api_restaurant_path
      end
  end

  def edit
      @element = Restaurant.find(params[:id])
  end

  def update
      m = ''
      transaction_succeeded = false

      ActiveRecord::Base.transaction do
        @element = Restaurant.find(params[:id])
  
        user = User.where(email: restaurant_params[:user_email]).first
        
        if !user 
          m = 'User not found.'
          raise ActiveRecord::Rollback
        end

        address = Address.find_or_create_by!(street_address: restaurant_params[:street_address], city: restaurant_params[:city], postal_code: restaurant_params[:postal_code])
  
        response = @element.update(user_id: user.id, address_id: address.id, name: restaurant_params[:name], price_range: restaurant_params[:price_range], email: restaurant_params[:email], phone: restaurant_params[:phone], active: restaurant_params[:active])
        
        if !response
          m = 'Failed to update restaurant.'
          raise ActiveRecord::Rollback
        end

        transaction_succeeded = true
      end
  
      if transaction_succeeded
          flash[:notice] = "Restaurant updated!"
          redirect_to(api_restaurant_path(@element.id))
      else
          flash[:notice] = m
          redirect_to(api_restaurant_path(@element.id))
      end
  end

  def restaurant_params
      params.require(:restaurant).permit(:user_email, :name, :price_range, :email, :phone, :street_address, :city, :postal_code, :active)
  end
end
