# frozen_string_literal: true
class Node < Valkyrie::Model
  attribute :label, Valkyrie::Types::Set
  attribute :proxy, Valkyrie::Types::ID.optional
  attribute :nodes, Valkyrie::Types::Array.member(Node)
end
class Structure < Valkyrie::Model
  attribute :label, Valkyrie::Types::Set
  attribute :nodes, Valkyrie::Types::Array.member(Node)
end
class Book < Valkyrie::Model
  include Valkyrie::Model::AccessControls
  attribute :id, Valkyrie::Types::ID.optional
  attribute :title, Valkyrie::Types::Set
  attribute :author, Valkyrie::Types::Set
  attribute :testing, Valkyrie::Types::Set
  attribute :member_ids, Valkyrie::Types::Array
  attribute :a_member_of, Valkyrie::Types::Set
  attribute :viewing_hint, Valkyrie::Types::Set
  attribute :viewing_direction, Valkyrie::Types::Set
  attribute :thumbnail_id, Valkyrie::Types::Set
  attribute :representative_id, Valkyrie::Types::Set
  attribute :start_canvas, Valkyrie::Types::Set
  attribute :structure, Valkyrie::Types::Array.member(Structure.optional).optional
  attribute :source_metadata_identifier, Valkyrie::Types::Set
end
