class AutoCompleteTaskJob < ApplicationJob
  queue_as :default

  def perform(task_id)
    task = TodoApp.find_by(id: task_id)
    return unless task
    task.update(isCompleted: "Completed now by using Active Job")
    puts "Task #{task.id} has been now-completed by using Active job method"
  end
end
