class RestaurantsController < ApplicationController
    def index
        @elements = Restaurant.all
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
          redirect_to restaurants_url
        else
          flash[:notice] = m
          redirect_to new_restaurant_path
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
            redirect_to(@element)
        else
            flash[:notice] = m
            redirect_to(@element)
        end
    end

    def restaurant_params
        params.require(:restaurant).permit(:user_email, :name, :price_range, :email, :phone, :street_address, :city, :postal_code, :active)
    end
end
