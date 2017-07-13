require 'test_helper'

class UsuarioControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get usuario_index_url
    assert_response :success
  end

end
