class Api::OrdersController < ApplicationController
    include ApiHelper
    skip_before_action :verify_authenticity_token
    
    def index
        types = ['customer', 'restaurant', 'courier']
        type = request.params['type']
        id = request.params['id']

        if (type == nil && id == nil)
            render_400_error("Both 'user type' and 'id' parameters are required")
            return
        end

        if !(types.include? type)
            render_422_error("Invalid user type")
            return
        end
        
        @orders = Order.joins(:customer, :user).where("#{type}_id = #{id}")

        response = []
        
        @orders.each {|order|
            order_formatted = format_order(order)
            response.push(order_formatted)
        }

        if @orders.length != 0
            render json: response, status: 200
            return
        else
            render json: [], status: 200
            return
        end
    end

    def status 
        begin
            @order = Order.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
            render_422_error("Invalid order")
            return
        end
        
        order_status = OrderStatus.where(name: request.params['status']).first
 
        if order_status
            @order.update(order_status_id: order_status.id)
            render json: {success: true}, status: 200
        else
            render_422_error("Invalid order status")
        end
    end

    def create
        required_params = ["restaurant_id", "customer_id", "products"]

        if !((required_params - request.params.keys).empty?)
            render_400_error("Restaurant ID, customer ID, and products are required")
            return
        end

        # find restaurant
        begin
            restaurant = Restaurant.find(request.params["restaurant_id"])
        rescue ActiveRecord::RecordNotFound => e
            render_422_error("Invalid restaurant or customer ID")
            return
        end

        # find customer
        begin
            customer = Customer.find(request.params["customer_id"])
        rescue ActiveRecord::RecordNotFound => e
            render_422_error("Invalid restaurant or customer ID")
            return
        end

        ActiveRecord::Base.transaction do
            # create order_status
            order_status = OrderStatus.find_or_create_by!(name: "pending")

            # create order
            @order = Order.create(restaurant_id: restaurant.id, customer_id: customer.id, order_status_id: order_status.id)

            # create product_orders
            request.params["products"].each { |product|
                begin
                    product_in_db = Product.find(product["id"])
                rescue ActiveRecord::RecordNotFound => e
                    render_422_error("Invalid product ID")
                    return
                end

                product_order = ProductOrder.create(product_id: product_in_db.id, order_id: @order.id, product_quantity: product["quantity"], product_unit_cost: product_in_db.cost)
            }
        end    

        response = format_order(@order)
        
        render json: response, status: 200
    end
end