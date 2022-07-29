# frozen_string_literal: true

class BaseSerializer < ActiveModel::Serializer
  def serialize(resource)
    ActiveModelSerializers::SerializableResource.new(resource).as_json
  end
end
