class PlanilhaSerializer < ActiveModel::Serializer
  attributes :id, :data

  has_one :user
end
