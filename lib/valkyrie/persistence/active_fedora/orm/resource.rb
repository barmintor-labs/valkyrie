# frozen_string_literal: true
module Valkyrie::Persistence::ActiveFedora::ORM
  class Schema < ActiveTriples::Schema
    property :title, predicate: ::RDF::Vocab::DC.title
    property :author, predicate: ::RDF::Vocab::DC.creator
    property :testing, predicate: ::RDF::URI("http://test.com/testing")
    property :a_member_of, predicate: ::RDF::URI("http://test.com/member_of")
    property :viewing_hint, predicate: ::RDF::Vocab::IIIF.viewingHint
    property :viewing_direction, predicate: ::RDF::Vocab::IIIF.viewingDirection
    property :thumbnail_id, predicate: ::RDF::URI("http://test.com/thumbnail_id")
    property :representative_id, predicate: ::RDF::URI("http://test.com/representative_id")
    property :start_canvas, predicate: ::RDF::URI("http://test.com/start_canvas")
    property :internal_model, predicate: ::RDF::URI("http://test.com/internal_model"), multiple: false
    property :file_identifiers, predicate: ::RDF::URI("http://test.com/file_identifiers")
    property :label, predicate: ::RDF::URI("http://test.com/label")
    property :mime_type, predicate: ::RDF::URI("http://test.com/mime_type")
    property :original_filename, predicate: ::RDF::URI("http://test.com/original_filename")
    property :use, predicate: ::RDF::URI("http://test.com/use")
    property :nested_resource, predicate: ::RDF::URI("http://test.com/nested_resource")
  end
  class NestedResource < ActiveTriples::Resource
    def initialize(uri = RDF::Node.new, _parent = ActiveTriples::Resource.new)
      uri = if uri.try(:node?)
              RDF::URI("#nested_resource_#{uri.to_s.gsub('_:', '')}")
            elsif uri.to_s.include?('#')
              RDF::URI(uri)
            end
      super
    end

    def persisted?
      !new_record?
    end

    def new_record?
      id.start_with?('#')
    end

    # configure type: ::RDF::URI("http://test.com/nested_resource_type")
    apply_schema Schema
    property :read_groups, predicate: ::RDF::URI("http://test.com/read_groups")
    property :read_users, predicate: ::RDF::URI("http://test.com/read_users")
    property :edit_groups, predicate: ::RDF::URI("http://test.com/edit_groups")
    property :edit_users, predicate: ::RDF::URI("http://test.com/edit_users")
  end
  class Resource < ActiveFedora::Base
    include Hydra::AccessControls::Permissions
    include Hydra::Works::WorkBehavior
    apply_schema Schema, ActiveFedora::SchemaIndexingStrategy.new(
      ActiveFedora::Indexers::GlobalIndexer.new([:symbol, :stored_searchable, :facetable])
    )
    property :nested_resource, predicate: ::RDF::URI("http://test.com/nested_resource"), class_name: "Valkyrie::Persistence::ActiveFedora::ORM::NestedResource"
    accepts_nested_attributes_for :nested_resource

    def to_solr(doc = {})
      super.merge(
        uri_ssi: uri.to_s
      )
    end
  end
end
