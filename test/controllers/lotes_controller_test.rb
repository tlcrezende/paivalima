require "test_helper"

class LotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @lote = lotes(:one)
  end

  test "should get index" do
    get lotes_url, as: :json
    assert_response :success
  end

  test "should create lote" do
    assert_difference("Lote.count") do
      post lotes_url, params: { lote: { loteamento_id: @lote.loteamento_id, numero: @lote.numero, tamanho: @lote.tamanho, valor: @lote.valor } }, as: :json
    end

    assert_response :created
  end

  test "should show lote" do
    get lote_url(@lote), as: :json
    assert_response :success
  end

  test "should update lote" do
    patch lote_url(@lote), params: { lote: { loteamento_id: @lote.loteamento_id, numero: @lote.numero, tamanho: @lote.tamanho, valor: @lote.valor } }, as: :json
    assert_response :success
  end

  test "should destroy lote" do
    assert_difference("Lote.count", -1) do
      delete lote_url(@lote), as: :json
    end

    assert_response :no_content
  end
end
