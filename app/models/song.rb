# frozen_string_literal: true
class Song < Valkyrie::Resource
  include Valkyrie::Resource::AccessControls
  attribute :id, Valkyrie::Types::ID.optional
  attribute :title, Valkyrie::Types::Set
  attribute :member_ids, Valkyrie::Types::Array
  attribute :viewing_hint, Valkyrie::Types::Set
  attribute :viewing_direction, Valkyrie::Types::Set
  attribute :a_member_of, Valkyrie::Types::Set
  attribute :thumbnail_id, Valkyrie::Types::Set
  attribute :representative_id, Valkyrie::Types::Set
  attribute :start_canvas, Valkyrie::Types::Set
  attribute :depositor
end
