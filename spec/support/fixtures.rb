# frozen_string_literal: true

module Spec::Support
  module Fixtures
    # Sample data for Project objects.
    PROJECTS_FIXTURES = [
      {
        'id'           => '0196c6d2-9904-735a-8034-364fe2a7976f',
        'active'       => true,
        'description'  => 'An example application.',
        'name'         => 'Example Application',
        'slug'         => 'example-application',
        'project_type' => Project::ProjectTypes::APPLICATION,
        'public'       => true,
        'repository'   => 'http://www.example.com/example-application'
      }.freeze,
      {
        'id'           => '0196c6d3-f533-7f5e-8aca-5c0d2058a35b',
        'active'       => true,
        'description'  => 'An example library.',
        'name'         => 'Example Library',
        'slug'         => 'example-library',
        'project_type' => Project::ProjectTypes::LIBRARY,
        'public'       => true,
        'repository'   => ''
      }.freeze,
      {
        'id'           => '0196c6d4-7eae-772f-a226-f283ee0726f5',
        'active'       => false,
        'description'  => 'An inactive project.',
        'name'         => 'Inactive Project',
        'slug'         => 'inactive-project',
        'project_type' => Project::ProjectTypes::LIBRARY,
        'public'       => true,
        'repository'   => ''
      }.freeze
    ].freeze

    # Sample data for Task objects.
    TASKS_FIXTURES = [
      {
        'id'            => '0196c6d6-86d2-7f20-9dc9-e37c6a03150b',
        'project_id'    => PROJECTS_FIXTURES.first['id'],
        'title'         => 'Feature Task',
        'slug'          => 'feature-task',
        'description'   => 'An example task',
        'project_index' => 0,
        'status'        => Task::Statuses::TO_DO.key,
        'task_type'     => Task::TaskTypes::FEATURE
      }.freeze,
      {
        'id'            => '0196c6d8-68a4-7ff1-ac50-a678077ed555',
        'project_id'    => PROJECTS_FIXTURES.first['id'],
        'title'         => 'Chore Task',
        'slug'          => 'chore-task',
        'description'   => 'An example task',
        'project_index' => 1,
        'status'        => Task::Statuses::IN_PROGRESS.key,
        'task_type'     => Task::TaskTypes::CHORE
      }.freeze,
      {
        'id'            => '0196c6d9-01d4-78ee-89aa-12597c264fb6',
        'project_id'    => PROJECTS_FIXTURES.first['id'],
        'title'         => 'Bugfix Task',
        'slug'          => 'bugfix-task',
        'description'   => 'An example task',
        'project_index' => 2,
        'status'        => Task::Statuses::DONE.key,
        'task_type'     => Task::TaskTypes::BUGFIX
      }.freeze,
      {
        'id'            => '0196c6da-3a79-7f5a-9d70-6bf064cc4a5c',
        'project_id'    => PROJECTS_FIXTURES.first['id'],
        'title'         => 'Release Task',
        'slug'          => 'release-task',
        'description'   => 'An example task',
        'project_index' => 3,
        'status'        => Task::Statuses::ICEBOX.key,
        'task_type'     => Task::TaskTypes::RELEASE
      }.freeze,
      {
        'id'            => '0196c6da-61b3-7c2d-a29d-de2041f6243a',
        'project_id'    => PROJECTS_FIXTURES[1]['id'],
        'title'         => 'Cancelled Task',
        'slug'          => 'cancelled-task',
        'description'   => 'An example task',
        'project_index' => 0,
        'status'        => Task::Statuses::WONT_DO.key,
        'task_type'     => Task::TaskTypes::INVESTIGATION
      }.freeze
    ].freeze
  end
end
