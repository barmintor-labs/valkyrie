# frozen_string_literal: true
require 'spec_helper'
require 'sleipnir/specs/shared_specs'
include ActionDispatch::TestProcess

RSpec.describe Sleipnir::FileRepository::DiskRepository do
  it_behaves_like "a Sleipnir::StorageAdapter"
  let(:storage_adapter) { described_class.new(base_path: ROOT_PATH.join("tmp", "repo_test")) }
  let(:file) { fixture_file_upload('files/example.tif', 'image/tiff') }
end