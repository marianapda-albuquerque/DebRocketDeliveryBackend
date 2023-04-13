class Api::OrdersController < ApplicationController
    include ApiHelper
    
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
end