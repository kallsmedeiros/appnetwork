require 'test_helper'

class GraficoControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get grafico_index_url
    assert_response :success
  end

end
