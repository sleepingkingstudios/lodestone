# frozen_string_literal: true

module Lodestone::Tasks::Commands
  # Builds and persists a Task with generated uuid ID, slug, and project index.
  class Create < Librum::Core::Commands::Resources::Create
    ATTRIBUTE_NAMES_FOR_SLUG = %i[title].freeze
    private_constant :ATTRIBUTE_NAMES_FOR_SLUG

    private

    def attribute_names_for_slug
      ATTRIBUTE_NAMES_FOR_SLUG
    end

    def build_entity(attributes:)
      attributes = attributes.merge(
        'project_index' => step { next_project_index(attributes) }
      )

      super
    end

    def next_project_index(attributes)
      project_id = attributes['project_id']

      return nil if project_id.blank?

      result = collection.find_matching.call(
        limit: 1,
        order: { project_index: :desc },
        where: { project_id: }
      )
      last_task = result.success? ? result.value.first : nil

      (last_task&.[]('project_index') || -1) + 1
    end
  end
end
