# frozen_string_literal: true

require 'cuprum/rails/actions/middleware/associations/find'
require 'cuprum/rails/actions/middleware/resources/find'

# Controller for managing tasks.
class TasksController < ViewController
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
      skip_authentication:  legacy_authentication?,
      title_attribute:      'title'
    )
  end

  responder :html, Librum::Core::Responders::Html::ResourceResponder

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
  action :update,
    Cuprum::Rails::Actions::Resources::Update,
    command_class: Lodestone::Tasks::Commands::Update,
    member:        true
end
