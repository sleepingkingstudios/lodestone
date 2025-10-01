# frozen_string_literal: true

module Lodestone::Tasks::View
  # View displaying the current task.
  class Show < Librum::Components::Views::Resources::Show
    private

    def create_relationship
      return unless resource_data

      {
        button: true,
        icon:   'plus',
        text:   'Create Relationship',
        url:    "/tasks/#{resource_data['slug']}/relationships/new"
      }
    end

    def inverse_relationships
      result.value&.[]('inverse_relationships') || []
    end

    def relationships
      result.value&.[]('relationships') || []
    end

    def render_after_content
      return if resource_data.blank?

      buffer = ActiveSupport::SafeBuffer.new

      buffer << render_description
      buffer << "\n\n"
      buffer << render_relationships_heading
      buffer << render_relationships_table
    end

    def render_before_content
      return if resource_data&.project.blank?

      component = components::Link.new(
        color: 'link',
        icon:  'rectangle-list',
        text:  'Project Board',
        url:   "/projects/#{resource_data.project['slug']}/board"
      )

      content_tag('p') { render(component) }
    end

    def render_description
      CommonMarker
        .render_html(
          resource_data.description,
          :DEFAULT,
          %i[table tasklist strikethrough tagfilter]
        )
        .html_safe # rubocop:disable Rails/OutputSafety
    end

    def render_relationships_heading
      component = components::Heading.new(
        actions: [create_relationship],
        level:   2,
        text:    'Relationships'
      )

      render(component)
    end

    def render_relationships_table # rubocop:disable Metrics/MethodLength
      task     = result.value&.[]('task')
      resource = TaskRelationshipsController.resource
      params   = request.path_params.merge({ task_id: task&.[]('slug') })
      routes   = resource.routes.with_wildcards(params)

      component = Lodestone::Tasks::View::Components::Relationships::Table.new(
        inverse_relationships:,
        relationships:,
        resource:,
        routes:,
        task:
      )

      render(component)
    end
  end
end
