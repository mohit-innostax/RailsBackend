class CreateNewTodos < ActiveRecord::Migration[8.0]
  def change
    create_table :new_todos do |t|
      t.string :title
      t.string :status

      t.timestamps
    end
  end
end
