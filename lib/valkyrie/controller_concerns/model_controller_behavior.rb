# frozen_string_literal: true
module Valkyrie::ControllerConcerns
  module ModelControllerBehavior
    extend ActiveSupport::Concern
    included do
      class_attribute :change_set_class, :resource_class
    end

    def new
      @change_set = change_set_class.new(resource_class.new).prepopulate!
      authorize! :create, resource_class
      @collections = ::Draper::CollectionDecorator.decorate(query_service.find_all_of_model(model: Collection))
    end

    def create
      @change_set = change_set_class.new(resource_class.new)
      authorize! :create, @change_set.resource
      if @change_set.validate(resource_params)
        @change_set.sync
        obj = nil
        persister.buffer_into_index do |buffered_adapter|
          obj = change_set_persister(buffered_adapter).save(change_set: @change_set)
        end
        redirect_to contextual_path(obj.id, @change_set.append_id).show
      else
        render :new
      end
    end

    def change_set_persister(metadata_adapter)
      ChangeSetPersister.new(metadata_adapter: metadata_adapter, storage_adapter: Valkyrie.config.storage_adapter)
    end

    def edit
      @change_set = change_set_class.new(find_resource(params[:id])).prepopulate!
      authorize! :update, @change_set.resource
      @collections = query_service.find_all_of_model(model: Collection)
      render :edit
    end

    def update
      @change_set = change_set_class.new(find_resource(params[:id]))
      authorize! :update, @change_set.resource
      if @change_set.validate(resource_params)
        @change_set.sync
        obj = nil
        persister.buffer_into_index do |buffered_adapter|
          obj = change_set_persister(buffered_adapter).save(change_set: @change_set)
        end
        parents = query_service.find_inverse_references_by(resource: obj, property: :member_ids)
        parent = parents.try(:first)
        redirect_to contextual_path(obj.id, parent.try(:id)).show
      else
        render :edit
      end
    end

    def destroy
      @change_set = change_set_class.new(find_resource(params[:id]))
      authorize! :destroy, @change_set.resource
      persister.buffer_into_index do |buffered_adapter|
        change_set_persister(buffered_adapter).delete(change_set: @change_set)
      end
      flash[:alert] = "Deleted #{@change_set.resource}"
      redirect_to root_path
    end

    private

      # Include 'records' in the search path for views, while prefering
      # our local paths. Thus we are unable to just override `self.local_prefixes`
      def _prefixes
        @_prefixes ||= super + ['records']
      end

      def contextual_path(obj_id, parent_id)
        ContextualPath.new(obj_id, parent_id)
      end

      def find_resource(id)
        QueryService.find_by(id: Valkyrie::ID.new(id.to_s))
      end

      def persister
        Valkyrie::MetadataAdapter.find(:indexing_persister).persister
      end

      def adapter
        Valkyrie::MetadataAdapter.find(:indexing_persister)
      end

      def query_service
        Valkyrie::MetadataAdapter.find(:indexing_persister).query_service
      end

      def solr_adapter
        Valkyrie::MetadataAdapter.find(:index_solr)
      end
  end
end
