# frozen_string_literal: true
module Valkyrie::Persistence::Solr
  class QueryService
    attr_reader :connection, :resource_factory
    def initialize(connection:, resource_factory:)
      @connection = connection
      @resource_factory = resource_factory
    end

    def find_by(id:)
      Valkyrie::Persistence::Solr::Queries::FindByIdQuery.new(id, connection: connection, resource_factory: resource_factory).run
    end

    def find_all
      Valkyrie::Persistence::Solr::Queries::FindAllQuery.new(connection: connection, resource_factory: resource_factory).run
    end

    def find_parents(model:)
      Valkyrie::Persistence::Solr::Queries::FindParentQuery.new(model: model, connection: connection, resource_factory: resource_factory).run
    end

    def find_members(model:)
      Valkyrie::Persistence::Solr::Queries::FindMembersQuery.new(model: model, connection: connection, resource_factory: resource_factory).run
    end
  end
end
