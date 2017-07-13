require 'test_helper'

class AcessoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get acesso_index_url
    assert_response :success
  end

end
