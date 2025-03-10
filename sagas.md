# Sagas

Sagas are a collection of tasks representing an overarching project or goal; sagas can cross different projects.

## Data Modeling

- sagas
  - name
  - slug (indexed)
  - status (reuse Task statuses)
  - has_many :tasks, through: :saga_tasks
- saga_tasks
  - belongs to :saga
  - belongs to :task
  - relationship:string (blocks, belongs to) (actually we'll call this a V2 feature)
- migrations
  - create sagas
  - create saga tasks

## Todos

- update schema (migrations)
- update data models/specs
- generate controllers/views
- (ideally /saga/:id/tasks views)

(as much back end as possible)
