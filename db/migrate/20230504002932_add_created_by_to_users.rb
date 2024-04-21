class AddCreatedByToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :created_by, foreign_key: { to_table: :users }
  end
end
