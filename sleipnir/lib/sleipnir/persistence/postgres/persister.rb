# frozen_string_literal: true
require 'sleipnir/persistence/postgres/orm_syncer'
require 'sleipnir/persistence/postgres/orm'
require 'sleipnir/persistence/postgres/resource_factory'
module Sleipnir::Persistence::Postgres
  class Persister
    class << self
      def save(model:)
        instance(model).persist
      end

      def delete(model:)
        instance(model).delete
      end

      def sync_object(model)
        ::Sleipnir::Persistence::Postgres::ORMSyncer.new(model: model)
      end

      def adapter
        Sleipnir::Persistence::Postgres::Adapter
      end

      def instance(model)
        new(sync_object: sync_object(model))
      end
    end

    attr_reader :sync_object
    delegate :model, to: :sync_object

    def initialize(sync_object: nil)
      @sync_object = sync_object
    end

    def persist
      sync_object.save
      model
    end

    def delete
      sync_object.delete
      model
    end
  end
end