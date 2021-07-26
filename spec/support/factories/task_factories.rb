# frozen_string_literal: true

FactoryBot.define do
  factory :task, class: 'Task' do
    id { SecureRandom.uuid }

    transient do
      sequence(:task_index) { |i| i }
    end

    title        { "Task #{task_index}" }
    slug         { "task-#{task_index}" }
    description  { "The description for task #{task_index}." }
    status       { Task::Statuses::TO_DO.key }
    task_type    { Task::TaskTypes::CHORE }

    project_index do
      (Task.order(project_index: :desc).first&.project_index || 0) + 1
    end
  end
end
