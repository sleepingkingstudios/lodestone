# frozen_string_literal: true

module Lodestone::Tasks::Middleware
  # Finds and assigns the current project and adds to the entity parameters.
  class FindProject < Cuprum::Rails::Action
    include Cuprum::Middleware

    private

    attr_reader \
      :repository,
      :request,
      :result

    def find_project
      Librum::Core::Commands::Queries::FindEntity
        .new(collection: projects_collection)
        .call(value: project_id)
    end

    def merge_task_params(task_params)
      params      = request.params || {}
      task_params = params.fetch('task', {}).merge(task_params)
      params      = params.merge('task' => task_params)

      Cuprum::Rails::Request.new(**request.properties, params:)
    end

    def merge_value(value)
      value = (result.value || {}).merge(value)

      build_result(**result.properties, value:)
    end

    def process(next_command, repository:, request:, **rest)
      @repository = repository
      @request    = request

      return super if project_id.blank?

      project = step { find_project }
      @result = next_command.call(
        repository:,
        request:    merge_task_params({ 'project' => project }),
        **rest
      )

      merge_value({ 'project' => project })
    end

    def project_id
      params['project_id']
    end

    def projects_collection
      repository['projects']
    end
  end
end
