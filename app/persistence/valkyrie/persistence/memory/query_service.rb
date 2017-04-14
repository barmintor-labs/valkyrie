# frozen_string_literal: true
module Valkyrie::Persistence::Memory
  class QueryService
    attr_reader :adapter
    delegate :cache, to: :adapter
    def initialize(adapter:)
      @adapter = adapter
    end

    def find_by(id:)
      cache[Valkyrie::ID.new(id.to_s)] || raise(::Persister::ObjectNotFoundError)
    end

    def find_all
      cache.values
    end

    def find_members(model:)
      model.member_ids.map do |id|
        find_by(id: id)
      end
    end

    def find_parents(model:)
      cache.values.select do |record|
        (record.member_ids || []).include?(model.id)
      end
    end
  end
end
