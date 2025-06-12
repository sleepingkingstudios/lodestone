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
      project_index = step { next_project_index(attributes) }

      attributes = attributes.merge('project_index' => project_index)

      super
    end

    def generate_slug(attributes)
      return attributes['slug'] if attributes['slug'].present?

      project = attributes['project']
      index   = attributes['project_index']

      return nil if project.blank? || index.blank?

      "#{project['slug']}-#{index}"
    end

    def next_project_index(attributes)
      project = attributes['project']

      return nil if project.blank?

      result = collection.find_matching.call(
        limit: 1,
        order: { project_index: :desc },
        where: { project_id: project['id'] }
      )
      last_task = result.success? ? result.value.first : nil

      (last_task&.[]('project_index') || -1) + 1
    end
  end
end
