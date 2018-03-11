require 'test_helper'

class AuthorsControllerTest < ActionDispatch::IntegrationTest
  test "should get generate" do
    get authors_generate_url
    assert_response :success
  end

end
