require 'test_helper'

class EquipamentoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get equipamento_index_url
    assert_response :success
  end

end
