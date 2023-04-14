module ApiHelper

  # Null and empty values allowed
  def is_number_in_range?(number, min, max)
    number.nil? || number.empty? || (min..max).include?(number.to_i)
  end

  def render_422_error(message)
    render json: { error: message }, status: :unprocessable_entity
  end

  def render_400_error(message)
    render json: { error: message }, status: :bad_request
  end

  def format_order(order)
    restaurant = Restaurant.find(order.restaurant_id)
    customer = Customer.find(order.customer_id)
    courier = Courier.find_by_id(order.courier_id)
    product_orders = ProductOrder.where(order_id: order.id)
    products = []
    product_orders.each {|product_order| 
        product_order_formatted = {
            product_id: product_order.product.id, 
            product_name: product_order.product.name, 
            quantity: product_order.product_quantity, 
            unity_cost: product_order.product.cost, 
            total_cost: (product_order.product_quantity * product_order.product.cost)
        }
        products.push(product_order_formatted)
    }

    return { 
        id: restaurant.id, 
        customer_id: customer.id, 
        customer_name: customer.user.name, 
        customer_address: customer.address.street_address, 
        restaurant_name: restaurant.name, 
        restaurant_address: restaurant.address.street_address, 
        courier_id: courier ? courier.id : "", 
        courier_name: courier ? courier.user.name : "", 
        status: order.order_status.name,
        products: products
    } 
  end
end