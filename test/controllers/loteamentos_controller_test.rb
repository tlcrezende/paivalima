require "test_helper"

class LoteamentosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @loteamento = loteamentos(:one)
  end

  test "should get index" do
    get loteamentos_url, as: :json
    assert_response :success
  end

  test "should create loteamento" do
    assert_difference("Loteamento.count") do
      post loteamentos_url, params: { loteamento: { nome: @loteamento.nome, registro: @loteamento.registro, tamanho: @loteamento.tamanho } }, as: :json
    end

    assert_response :created
  end

  test "should show loteamento" do
    get loteamento_url(@loteamento), as: :json
    assert_response :success
  end

  test "should update loteamento" do
    patch loteamento_url(@loteamento), params: { loteamento: { nome: @loteamento.nome, registro: @loteamento.registro, tamanho: @loteamento.tamanho } }, as: :json
    assert_response :success
  end

  test "should destroy loteamento" do
    assert_difference("Loteamento.count", -1) do
      delete loteamento_url(@loteamento), as: :json
    end

    assert_response :no_content
  end
end
