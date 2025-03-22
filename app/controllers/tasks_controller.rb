# frozen_string_literal: true

require 'commands/tasks/build'

# Controller for managing tasks.
class TasksController < BaseController
  class QueryTasks < Cuprum::Rails::Command
    private

    def process(status: nil, **)
      tasks = Task.includes(:project).order(:slug)

      if Task::Statuses.values.any? { |value| value.key == status }
        tasks = tasks.select { |task| task.status == status }
      end

      { 'tasks' => tasks }
    end
  end

  class NewTask < Cuprum::Rails::Command
    private

    def process(project_id: nil, task: {}, **)
      projects = Project.order(:name)
      project  = Project.find(project_id) if project_id
      task     = Task.new(project: project)

      { projects: projects, task: task }
    end
  end

  class CreateTask < Cuprum::Rails::Command
    private

    def build_task(attributes:, project:)
      Commands::Tasks::Build.new.call(attributes: attributes, project: project)
    end

    def process(project_id: nil, task: {}, **)
      project = Project.find(project_id)
      task    = step { build_task(attributes: task, project: project) }

      if task.save
        success({ task: task })
      else
        projects = Project.order(:name)
        error    = Cuprum::Collections::Errors::FailedValidation.new(
          entity_class: Task,
          errors:       task.errors
        )

        Cuprum::Result.new(
          value: { projects: projects, task: task },
          error: error
        )
      end
    end

    def scope_validation_errors(error)
      mapped_errors = Stannum::Errors.new

      error.errors.each do |err|
        mapped_errors
          .dig(resource.singular_name, *err[:path].map(&:to_s))
          .add(err[:type], message: err[:message], **err[:data])
      end

      Cuprum::Collections::Errors::FailedValidation.new(
        entity_class: error.entity_class,
        errors:       mapped_errors
      )
    end
  end

  def self.resource # rubocop:disable Metrics/MethodLength
    Cuprum::Rails::Resource.new(
      default_order:        :name,
      entity_class:         ::Task,
      permitted_attributes: %w[
        description
        name
        slug
        status
        task_type
        title
      ]
    )
  end

  middleware Cuprum::Rails::Actions::Middleware::LogRequest
  middleware Cuprum::Rails::Actions::Middleware::LogResult

  action :index,  Cuprum::Rails::Action.subclass(command_class: QueryTasks)
  action :new,    Cuprum::Rails::Action.subclass(command_class: NewTask)
  action :create, Cuprum::Rails::Action.subclass(command_class: CreateTask)

  def show
    @task                  = Task.find(params[:id])
    @relationships         = @task.relationships.includes(:target_task)
    @inverse_relationships = @task.inverse_relationships.includes(:source_task)
  end

  def edit
    @projects = Project.order(:name)
    @task     = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    @task.assign_attributes(task_params)

    if @task.save
      redirect_to task_path(@task)
    else
      @projects = Project.order(:name)

      render :edit
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    redirect_to tasks_path
  end

  private

  def build_task
    Commands::Tasks::Build
      .new
      .call(attributes: task_params, project: project)
  end

  def project
    Project.find(project_id)
  end

  def project_board_path?(path)
    path =~ %r{/projects/[a-z0-9-]+/board}
  end

  def project_id
    params.require(:project_id)
  end

  def query_tasks
    tasks = Task.includes(:project).order(:slug)

    if Task::Statuses.values.any? { |status| status.key == params[:status] }
      tasks = tasks.select { |task| task.status == params[:status] }
    end

    tasks
  end

  def redirect_board_path(referer)
    return referer unless @task.project && project_board_path?(referer)

    project_board_path(@task.project)
  end

  def referer_path
    return params[:referer_path] if params[:referer_path].present?

    return nil unless request.referer&.start_with?(root_url)

    referer = request.referer[root_url.size..]
    referer = "/#{referer}" unless referer.start_with?('/')
    referer
  end

  def task_params
    params.expect(task: %i[description status task_type title])
  end
end
