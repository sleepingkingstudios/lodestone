# frozen_string_literal: true

# Controller for managing task boards.
class BoardsController < Librum::Core::ViewController
  def self.resource
    @resource ||=
      Librum::Core::Resources::BaseResource.new(name: 'board', singular: true)
  end

  responder :html, Cuprum::Rails::Responders::Html::Resource

  action :show,
    Cuprum::Rails::Action.subclass(command_class: Boards::Commands::Show),
    member: false

  private

  def grouped_tasks
    tasks = Task.order(updated_at: :desc)
    tasks = tasks.where(project: project) if project
    tasks.group_by(&:status)
  end

  def project
    return @project if @project
    return nil      if project_id.blank?

    @project = Project.find(project_id)
  end

  def project_id
    params[:project_id]
  end
end
