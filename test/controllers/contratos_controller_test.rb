require "test_helper"

class ContratosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @contrato = contratos(:one)
  end

  test "should get index" do
    get contratos_url, as: :json
    assert_response :success
  end

  test "should create contrato" do
    assert_difference("Contrato.count") do
      post contratos_url, params: { contrato: { cliente_id: @contrato.cliente_id, data_inicio: @contrato.data_inicio, datetime: @contrato.datetime, integer: @contrato.integer, lote_id: @contrato.lote_id, qnt_parcelas: @contrato.qnt_parcelas } }, as: :json
    end

    assert_response :created
  end

  test "should show contrato" do
    get contrato_url(@contrato), as: :json
    assert_response :success
  end

  test "should update contrato" do
    patch contrato_url(@contrato), params: { contrato: { cliente_id: @contrato.cliente_id, data_inicio: @contrato.data_inicio, datetime: @contrato.datetime, integer: @contrato.integer, lote_id: @contrato.lote_id, qnt_parcelas: @contrato.qnt_parcelas } }, as: :json
    assert_response :success
  end

  test "should destroy contrato" do
    assert_difference("Contrato.count", -1) do
      delete contrato_url(@contrato), as: :json
    end

    assert_response :no_content
  end
end
