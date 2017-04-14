# frozen_string_literal: true
require 'rails_helper'

RSpec.describe BookForm do
  subject(:form) { described_class.new(book) }
  let(:book) { Book.new(title: "Test") }

  describe "#title" do
    it "delegates down appropriately" do
      expect(form.title).to eq ["Test"]
    end
    it "requires a title be set" do
      form.title = []
      expect(form).not_to be_valid
    end
  end

  describe "#append_id" do
    it "coerces it to a Valkyrie::ID" do
      form.validate(append_id: "Test")
      expect(form.append_id).to be_kind_of Valkyrie::ID
    end
  end
end
