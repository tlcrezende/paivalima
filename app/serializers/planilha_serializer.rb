class PlanilhaSerializer < ActiveModel::Serializer
  attributes :id, :data_referencia, :user_name, :created_at

  def user_name 
    object.user.name
  end
end
