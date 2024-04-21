class AddCreatedByToUserRoles < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_roles, :created_by, foreign_key: { to_table: :users }
  end
end
