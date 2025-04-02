module NewTodoAppService
    def self.message(name)
      "Welcome #{name} to the New Todo App!"
    end

    def self.get_tasks(title = nil)
      puts "Hello from NewTodoAppService"
      sql="Select * from todo_apps order by id"
      if title.present?
        sql = "Select * from todo_apps where title ilike '%#{title}%'"
      end
      result=ActiveRecord::Base.connection.execute(sql)
      result.to_a
    end

    def self.create_task(todo_details)
      puts todo_details
      sql=<<~Sql_Query
              Insert into todo_apps ("title","isCompleted","priority","created_at","updated_at","createdby")
              Values ('#{todo_details["title"]}','#{todo_details["isCompleted"]}','#{todo_details["priority"]}',NOW(),NOW(),'#{todo_details["createdby"]}')
              Returning *
            Sql_Query
      result=ActiveRecord::Base.connection.execute(sql)
      if result.present?
        { success: true, task: result.first, message: "Task created successfully" }
      else
        { success: false, error: "Fail" }
      end
    end

    def self.update_task(id, title)
      puts id, title
      sql = <<~SQL
            UPDATE todo_apps
            SET title = '#{title}',
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
