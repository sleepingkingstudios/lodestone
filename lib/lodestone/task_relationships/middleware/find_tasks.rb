# frozen_string_literal: true

module Lodestone::TaskRelationships::Middleware
  # Finds tasks for defining a task relationship and groups by project.
  class FindTasks < Cuprum::Rails::Action
    include Cuprum::Middleware

    private

    attr_reader \
      :projects,
      :repository,
      :request,
      :result,
      :source_task,
      :tasks

    def find_projects
      source_project = step { find_source_project }
      other_projects = step { find_other_projects }

      [source_project, *other_projects]
    end

    def find_other_projects
      project_id = source_task.project_id

      projects_collection.find_matching.call(order: :name) do |query|
        { id: query.not_equal(project_id) }
      end
    end

    def find_source_project
      projects_collection.find_one.call(primary_key: source_task.project_id)
    end

    def find_source_task
      return nil if source_task_id.blank?

      Librum::Core::Commands::Queries::FindEntity
        .new(collection: tasks_collection)
        .call(value: source_task_id)
    end

    def find_tasks
      task_id = source_task.id

      tasks_collection.find_matching.call(order: { created_at: :desc }) \
      do |query|
        { id: query.not_equal(task_id) }
      end
    end

    def group_tasks_by_project
      grouped       = Hash.new { |hsh, key| hsh[key] = [] }
      project_names = projects.to_h { |project| [project.id, project.name] }

      tasks.each do |task|
        project_name = project_names[task.project_id]

        grouped[project_name] << task
      end

      grouped
    end

    def merge_request # rubocop:disable Metrics/MethodLength
      relationship_params =
        request
        .params
        .fetch('task_relationship', {})
        .merge('source_task_id' => source_task.id)
      params = request.params.merge(
        'task_relationship' => relationship_params
      )

      Cuprum::Rails::Request.new(
        **request.properties,
        params:
      )
    end

    def merge_value(value)
      value = (result.value || {}).merge(value)

      build_result(**result.properties, value:)
    end

    def process(next_command, repository:, request:, **rest) # rubocop:disable Metrics/MethodLength
      @repository  = repository
      @request     = request
      @source_task = step { find_source_task }

      return super if source_task.blank?

      @request = merge_request
      @result  = next_command.call(repository:, request: @request, **rest)

      return result unless rendered_response?

      @projects = step { find_projects }
      @tasks    = step { find_tasks }

      merge_value({
        'source_task' => source_task,
        'tasks'       => group_tasks_by_project
      })
    end

    def projects_collection
      repository['projects']
    end

    def rendered_response?
      return true if request.http_method == :get

      result.failure?
    end

    def source_task_id
      request.params['task_id']
    end

    def tasks_collection
      repository['tasks']
    end
  end
end
