module NewTodoAppService
    def self.message(name)
      "Welcome #{name} to the New Todo App!"
    end

    def self.get_tasks
      puts "Hello from NewTodoAppService"
      TodoApp.all
    end

    def self.create_task(todo_details)
      todo=TodoApp.new(todo_details)
      if todo.save
        { success: true, task: todo, message: "Task created successfully" }
      else
        { success: false, error: todo.errors.full_messages }
      end
    end

    def self.update_task(id, todo_details)
      todo = TodoApp.find_by(id: id)
      if todo.nil?
        return { success: false, error: "Task not found", status: 404 }
      end
      if todo.update(todo_details)
        { success: true, task: @todo, message: "Task updated successfully" }
      else
        { success: false, error: @todo.errors.full_messages, status: 400 }
      end
    end

    def self.delete_task(id)
      todo = TodoApp.find_by(id: id)
      if todo.nil?
        return { success: false, error: "Task not found", status: 404 }
      end
      if todo.destroy
        { success: true, message: "Task deleted successfully" }
      else
        { success: false, message: todo.errors.full_message, status: 400 }
      end
    end
end
