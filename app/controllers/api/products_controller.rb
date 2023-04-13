class Api::ProductsController < ApplicationController
    include ApiHelper
    
    def index 
        if params[:restaurant]
            @products = Product.where(restaurant_id: params[:restaurant]).select('id, name, cost')
            
            if @products.length == 0
                render_422_error("Invalid restaurant ID")
                return
            else
                render json: @products, status: 200 
                return  
            end
        end
        
        @products = Product.all
        render json: {success: true}, status: 200
    end
end