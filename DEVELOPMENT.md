# Development Notes

## Data Modeling

### Board

- has_many :project_boards
- has_many :projects, through: project_boards
- has_many :tasks, through: :board

### Milestone

- name:string
- slug:string

- belongs_to :project

### Project

- name:string
- slug:string
- active:boolean
- public:boolean
- description:text
- project_type:string (enum: application, library, script)
- repository:string

- has_many :boards, through: :project_boards
- has_many :milestones
- has_many :project_boards
- has_many :tasks

- has_many :project_dependencies,
    inverse: :inverse_dependency
- has_many :dependencies,
    class: Project,
    through: :project_dependencies
- has_many :inverse_project_dependencies,
    inverse: :dependency
- has_many :inverse_dependencies,
    class: Project,
    through: :inverse_project_dependencies

### ProjectBoard

- belongs_to :board
- belongs_to :project

### ProjectDependency

- belongs_to :dependency,
    class: Project,
    inverse: :inverse_project_dependencies
- belongs_to :inverse_dependency,
    class: Project,
    inverse: :project_dependencies

### Task

- slug:string (e.g. lodestone-0af)
  - Generated from ${project.slug}-${project_index.to_hex}
- title:text
- description:text (Markdown)
- status:string (enum ? icebox, todo, in_progress, done)
- steps:jsonb
  - An array of { name, description, complete, steps } objects.
- task_type:string (enum: bug, chore, feature, release)
- project_index:integer
  - Unique, scoped to :project_id
  - Generated, autoincremented on create/change project
    (part of Projects::Set command?)

- belongs_to :milestone, required: false
- belongs_to :project
- has_many :events, class: TaskEvent
- has_many :target_relationships,
    class: TaskRelationship,
    inverse: :source_task
- has_many :source_relationships,
    class: TaskRelationship,
    inverse: :target_task
- has_many :task_taggings
- has_many :tags,
    class: TaskTag,
    through: :task_taggings

- def relationships
    # Aggregates source, target relationships
    # Collects inverse Tasks

### TaskEvent

- event_type:string (enum)
- task_status:string
- notes:text (Markdown)

- belongs_to :task, inverse: :events

### TaskRelationship

- relationship_type:string (enum)
- inverse_relationship_type:string (enum)

- belongs_to :inverse_relationship, class: TaskRelationship, inverse: :original_relationship
- has_one :original_relationship, class: TaskRelationship, inverse: :inverse_relationship

### TaskTag

- name:string
- slug:string

- has_many :task_taggings
- has_many :tasks,
    through: :task_taggings

### TaskTagging

- belongs_to :task
- belongs_to :task_tag
