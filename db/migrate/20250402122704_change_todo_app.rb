class ChangeTodoApp < ActiveRecord::Migration[8.0]
  def change
    add_column :todo_apps, :createdby, :integer
    add_index :todo_apps, :createdby
  end
end
