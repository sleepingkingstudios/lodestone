# frozen_string_literal: true

module Lodestone::Tasks::Commands
  # Builds and persists a Task with generated uuid ID, slug, and project index.
  class Create < Librum::Core::Commands::Resources::Create
    private

    attr_reader :project

    def build_entity(attributes:)
      project_index = step { next_project_index }

      attributes = attributes.merge('project_index' => project_index)

      super
    end

    def find_project(attributes)
      project = attributes.fetch('project', attributes[:project])

      return project if project.present?

      project_id = attributes.fetch('project_id', attributes[:project_id])

      return nil if project_id.blank?

      Librum::Core::Commands::Queries::FindEntity
        .new(collection: projects_collection)
        .call(value: project_id)
    end

    def generate_slug(attributes)
      slug = attributes.fetch('slug', attributes[:slug])

      return slug if slug.present?

      index = attributes.fetch('project_index', attributes[:project_index])

      return nil if project.blank? || index.blank?

      "#{project.slug}-#{index}"
    end

    def next_project_index
      return nil if project.blank?

      result = collection.find_matching.call(
        limit: 1,
        order: { project_index: :desc },
        where: { project_id: project['id'] }
      )
      last_task = result.success? ? result.value.first : nil

      (last_task&.[]('project_index') || -1) + 1
    end

    def process(attributes:, **)
      @project   = step { find_project(attributes) }
      attributes = attributes.merge(
        'project'    => project,
        'project_id' => project&.id
      )

      super
    end

    def projects_collection
      repository['projects']
    end
  end
end
