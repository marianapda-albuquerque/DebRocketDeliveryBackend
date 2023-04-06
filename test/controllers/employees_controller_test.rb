require "test_helper"

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  test "should get read" do
    get employees_read_url
    assert_response :success
  end
end
