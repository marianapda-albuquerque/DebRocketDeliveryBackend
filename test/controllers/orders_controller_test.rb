require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create!(name: "User 1", email: "test@test.com", password: "password")
    @address = Address.create!(street_address: "Street 1", city: "City 1", postal_code: "11111")
    @restaurant = Restaurant.create!(user: @user, address: @address, name: "Restaurant 1", phone: "123456", price_range: 2)
    @customer = Customer.create!(user: @user, address: @address, phone: "123456")
    @product = Product.create!(name: "Product 1", cost: 10, restaurant: @restaurant)
    @product2 = Product.create!(name: "Product 2", cost: 15, restaurant: @restaurant)
    @order_status = OrderStatus.create(name: "pending")
    OrderStatus.create(name: "in progress")
    OrderStatus.create(name: "delivered")
    @courier_status = CourierStatus.create(name: "free")
    CourierStatus.create(name: "busy")
    CourierStatus.create(name: "full")
    CourierStatus.create(name: "offline")
    @courier = Courier.create(user_id: @user.id, address_id: @address.id, phone: "123456", courier_status_id: @courier_status.id)
    @order = Order.create!(restaurant: @restaurant, customer: @customer, order_status: @order_status, restaurant_rating: 4, courier: @courier)
    @product_order = ProductOrder.create(product_id: @product.id, order_id: @order.id, product_quantity: 1, product_unit_cost: @product.cost)
    @product_order2 = ProductOrder.create(product_id: @product2.id, order_id: @order.id, product_quantity: 1, product_unit_cost: @product2.cost)

    @products = [
      {product_id: @product_order.product.id, product_name: @product_order.product.name, quantity: @product_order.product_quantity, unity_cost: @product_order.product.cost, total_cost: (@product_order.product_quantity * @product_order.product.cost)}, 
      {product_id: @product_order2.product.id, product_name: @product_order2.product.name, quantity: @product_order2.product_quantity, unity_cost: @product_order2.product.cost, total_cost: (@product_order2.product_quantity * @product_order2.product.cost)}
    ]
  end

  test "update order status to 'pending'" do
    post "/api/order/#{@order.id}/status", params: { status: "pending" }
    assert_response :success
    assert_equal "pending", @order.reload.order_status.name
  end

  test "update order status to 'in progress'" do
    post "/api/order/#{@order.id}/status", params: { status: "in progress" }
    assert_response :success
    assert_equal "in progress", @order.reload.order_status.name
  end

  test "update order status to 'delivered'" do
    post "/api/order/#{@order.id}/status", params: { status: "delivered" }
    assert_response :success
    assert_equal "delivered", @order.reload.order_status.name
  end

  test "return 422 error for invalid status" do
    post "/api/order/#{@order.id}/status", params: { status: "invalid" }
    assert_response 422
  end

  test "return 422 error for invalid order" do
    post "/api/order/0/status", params: { status: "pending" }
    assert_response 422
  end

  test "return a list of orders for valid customer" do
    get "/api/orders", params: { type: "customer", id: @customer.id }
    assert_response 200
    assert_equal [{id: @restaurant.id, customer_id: @customer.id, customer_name: @customer.user.name, customer_address: @customer.address.street_address, restaurant_name: @restaurant.name, restaurant_address: @restaurant.address.street_address, courier_id: @courier.id, courier_name: @courier.user.name, status: @order.order_status.name, products: @products}].to_json, response.body
  end

  test "return a list of orders for valid restaurant" do
    get "/api/orders", params: { type: "restaurant", id: @restaurant.id }
    assert_response 200
    assert_equal [{id: @restaurant.id, customer_id: @customer.id, customer_name: @customer.user.name, customer_address: @customer.address.street_address, restaurant_name: @restaurant.name, restaurant_address: @restaurant.address.street_address, courier_id: @courier.id, courier_name: @courier.user.name, status: @order.order_status.name, products: @products}].to_json, response.body
  end

  test "return a list of orders for valid courier" do
    get "/api/orders", params: { type: "courier", id: @courier.id }
    assert_response 200
    assert_equal [{id: @restaurant.id, customer_id: @customer.id, customer_name: @customer.user.name, customer_address: @customer.address.street_address, restaurant_name: @restaurant.name, restaurant_address: @restaurant.address.street_address, courier_id: @courier.id, courier_name: @courier.user.name, status: @order.order_status.name, products: @products}].to_json, response.body
  end

  test "return 422 for invalid user type" do
    get "/api/orders", params: { type: "nobody", id: "1" }
    assert_response 422
    assert_equal "Invalid user type", JSON.parse(response.body)["error"]
  end

  test "return 200 for ID not found" do
    get "/api/orders", params: { type: "customer", id: 3000 }
    assert_response 200
    assert_equal [], JSON.parse(response.body)
  end

  test "return 400 for inexistent user type and ID" do
    get "/api/orders", params: {}
    assert_response 400
    assert_equal "Both 'user type' and 'id' parameters are required", JSON.parse(response.body)["error"]
  end

  test "return the newly created order" do
    post "/api/orders", params: { restaurant_id: @restaurant.id, customer_id: @customer.id, products: [{id: @product.id, quantity: 1}, {id: @product2.id, quantity: 1}]}
    assert_response 200
    assert_equal ({id: @restaurant.id, customer_id: @customer.id, customer_name: @customer.user.name, customer_address: @customer.address.street_address, restaurant_name: @restaurant.name, restaurant_address: @restaurant.address.street_address, courier_id: "", courier_name: "", status: @order.order_status.name, products: @products}).to_json, response.body
  end

  test "return 400 for request missing parameters" do
    post "/api/orders", params: { customer_id: @customer.id, products: [{id: @product.id, quantity: 1}, {id: @product2.id, quantity: 1}]}
    assert_response 400
    assert_equal "Restaurant ID, customer ID, and products are required", JSON.parse(response.body)["error"]
  end

  test "return 422 for invalid restaurant ID" do
    post "/api/orders", params: { restaurant_id: "banana", customer_id: @customer.id, products: [{id: @product.id, quantity: 1}, {id: @product2.id, quantity: 1}]}
    assert_response 422
    assert_equal "Invalid restaurant or customer ID", JSON.parse(response.body)["error"]
  end

  test "return 422 for invalid customer ID" do
    post "/api/orders", params: { restaurant_id: @restaurant.id, customer_id: "banana", products: [{id: @product.id, quantity: 1}, {id: @product2.id, quantity: 1}]}
    assert_response 422
    assert_equal "Invalid restaurant or customer ID", JSON.parse(response.body)["error"]
  end

  test "return 422 for invalid product ID" do
    post "/api/orders", params: { restaurant_id: @restaurant.id, customer_id: @customer.id, products: [{id: "banana", quantity: 1}, {id: @product2.id, quantity: 1}]}
    assert_response 422
    assert_equal "Invalid product ID", JSON.parse(response.body)["error"]
  end
end