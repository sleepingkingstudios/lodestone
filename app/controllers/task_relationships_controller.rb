# frozen_string_literal: true

# Controller for managing task relationships.
class TaskRelationshipsController < BaseController
  # Responder for handling HTML requests.
  class Responder < Cuprum::Rails::Responders::Html::Resource
    include Rails.application.routes.url_helpers

    action :create do
      match(:success) { |result| redirect_to_task(result) }
    end

    action :destroy do
      match(:success) { |result| redirect_to_task(result) }
    end

    action :update do
      match(:success) { |result| redirect_to_task(result) }
    end

    private

    def redirect_to_task(result)
      relationship = result.value['task_relationship']
      source_task  = relationship.source_task

      redirect_to task_path(source_task)
    end
  end

  def self.resource
    Cuprum::Rails::Resource.new(
      actions:              %i[create destroy edit new update],
      base_path:            '/tasks/:task_id/relationships',
      entity_class:         ::TaskRelationship,
      permitted_attributes: %w[
        relationship_type
        source_task_id
        target_task_id
      ]
    )
  end

  responder :html, TaskRelationshipsController::Responder

  middleware Lodestone::TaskRelationships::Middleware::FindTasks.new,
    only: %i[create edit new update]

  action :create,
    Cuprum::Rails::Actions::Resources::Create
  action :destroy,
    Cuprum::Rails::Actions::Resources::Destroy,
    member: true
  action :edit,
    Cuprum::Rails::Actions::Resources::Edit,
    member: true
  action :new,
    Cuprum::Rails::Actions::Resources::New
  action :update,
    Cuprum::Rails::Actions::Resources::Update, member: true
end
