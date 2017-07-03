# frozen_string_literal: true
require 'sleipnir/persistence/postgres/dynamic_klass'
module Sleipnir::Persistence::Postgres
  class ResourceFactory
    class << self
      def to_model(orm_object)
        ::Sleipnir::Persistence::Postgres::DynamicKlass.new(orm_object.all_attributes)
      end

      def from_model(resource)
        ::Sleipnir::Persistence::Postgres::ORM::Resource.find_or_initialize_by(id: resource.id.to_s).tap do |orm_object|
          orm_object.internal_model = resource.internal_model
          orm_object.metadata.merge!(resource.attributes.except(:id, :internal_model, :created_at, :updated_at))
        end
      end
    end
  end
end