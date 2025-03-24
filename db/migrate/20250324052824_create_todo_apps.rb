class CreateTodoApps < ActiveRecord::Migration[8.0]
  def change
    create_table :todo_apps do |t|
      t.string :title
      t.string :isCompleted
      t.string :priority

      t.timestamps
    end
  end
end
