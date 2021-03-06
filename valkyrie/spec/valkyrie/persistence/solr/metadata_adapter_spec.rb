# frozen_string_literal: true
require 'spec_helper'
require 'valkyrie/specs/shared_specs'

RSpec.describe Valkyrie::Persistence::Solr::MetadataAdapter do
  let(:adapter) { described_class.new(connection: client) }
  let(:client) { RSolr.connect(url: SOLR_TEST_URL) }
  it_behaves_like "a Valkyrie::MetadataAdapter"
end
