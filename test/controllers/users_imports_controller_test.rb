require 'test_helper'

class UsersImportsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get users_imports_new_url
    assert_response :success
  end

  test "should get create" do
    get users_imports_create_url
    assert_response :success
  end

end
