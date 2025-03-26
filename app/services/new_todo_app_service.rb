module NewTodoAppService
    def self.message(name)
      "Welcome #{name} to the New Todo App!"
    end

    def self.get_tasks
      puts "Hello from NewTodoAppService"
      sql="Select * from todo_apps where id>14"
      result=ActiveRecord::Base.connection.execute(sql)
      result.to_a
    end

    def self.create_task(todo_details)
      puts todo_details
      sql=<<~Sql_Query
              Insert into todo_apps ("title","isCompleted","priority","created_at","updated_at")
              Values ('#{todo_details["title"]}','#{todo_details["isCompleted"]}','#{todo_details["priority"]}',NOW(),NOW())
              Returning *
            Sql_Query
      result=ActiveRecord::Base.connection.execute(sql)
      if result.present?
        { success: true, task: result.first, message: "Task created successfully" }
      else
        { success: false, error: "Fail" }
      end
    end

    def self.update_task(id, todo_details)
      puts id, todo_details
      sql = <<~SQL
            UPDATE todo_apps
            SET title = '#{todo_details["title"]}',
            "isCompleted" = '#{todo_details["isCompleted"]}',
            priority = '#{todo_details["priority"]}',
            updated_at = NOW()
          WHERE id = #{id}
            SQL
      result=ActiveRecord::Base.connection.execute(sql)
      if !result.present?
        return { success: false, error: "Task not found", status: 404 }
      end
      { success: true, task: result.first, message: "Task updated successfully" }
    end

    def self.delete_task(id)
      sql="Delete from todo_apps where id='#{id}'"
      result=ActiveRecord::Base.connection.execute(sql)
      if result.cmd_tuples <= 0
        return { success: false, error: "Task not found", status: 404 }
      end
      { success: true, message: "Task deleted successfully" }
    end
end
