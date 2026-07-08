# frozen_string_literal: true

require 'cuprum/rails/actions/middleware/associations/find'
require 'cuprum/rails/actions/middleware/resources/find'

# Controller for managing tasks.
class TasksController < ViewController
  # Responder for handling HTML requests.
  class Responder < Librum::Core::Responders::Html::ResourceResponder
    action :status do
      match :success do |result|
        record  = result.value[resource.singular_name]
        status  = format_status(record.status)
        path    = routes.show_path(record.slug)
        message = "Updated task status to #{status}"
        flash   = { success: { icon: 'circle-check', message: } }

        redirect_to(path, flash:, status: 303) # rubocop:disable Rails/HttpStatus
      end

      match :failure do
        message = 'Unable to update task status'
        flash   =
          { warning: { icon: 'exclamation-triangle', message: } }

        redirect_back(flash:, status: 303)
      end
    end

    private

    def format_status(status)
      Lodestone::Tasks::View::Components.format_status(status)
    end
  end

  def self.resource # rubocop:disable Metrics/MethodLength
    Librum::Core::Resource.new(
      components:           Lodestone::Tasks::View::Components,
      default_order:        :slug,
      entity_class:         ::Task,
      permitted_attributes: %w[
        description
        project
        project_id
        slug
        status
        task_type
        title
      ],
      title_attribute:      'title'
    )
  end

  responder :html, Responder

  middleware Lodestone::Tasks::Middleware::FindProject.new
  middleware \
    Cuprum::Rails::Actions::Middleware::Resources::Find.new(
      entity_class:      Project,
      order:             { name: :asc },
      only_form_actions: true
    ),
    actions: { only: %i[create new edit update] }
  middleware \
    Cuprum::Rails::Actions::Middleware::Associations::Find.new(
      association_type: :has_many,
      entity_class:     TaskRelationship,
      foreign_key_name: :source_task_id,
      name:             'relationships'
    ),
    actions: { only: %i[show] }
  middleware \
    Cuprum::Rails::Actions::Middleware::Associations::Find.new(
      association_type: :has_many,
      entity_class:     TaskRelationship,
      foreign_key_name: :target_task_id,
      name:             'inverse_relationships'
    ),
    actions: { only: %i[show] }

  action :create,
    Cuprum::Rails::Actions::Resources::Create,
    command_class: Lodestone::Tasks::Commands::Create
  action :destroy,
    Cuprum::Rails::Actions::Resources::Destroy,
    command_class: Librum::Core::Commands::Resources::Destroy,
    member:        true
  action :edit,
    Cuprum::Rails::Actions::Resources::Edit,
    command_class: Lodestone::Tasks::Commands::Edit,
    member:        true
  action :index,
    Cuprum::Rails::Actions::Resources::Index
  action :new,
    Cuprum::Rails::Actions::Resources::New,
    command_class: Lodestone::Tasks::Commands::New
  action :show,
    Cuprum::Rails::Actions::Resources::Show,
    command_class: Librum::Core::Commands::Resources::Show,
    member:        true
  action :status,
    Cuprum::Rails::Actions::Resources::Update,
    command_class: Lodestone::Tasks::Commands::Status,
    member:        true
  action :update,
    Cuprum::Rails::Actions::Resources::Update,
    command_class: Lodestone::Tasks::Commands::Update,
    member:        true
end
