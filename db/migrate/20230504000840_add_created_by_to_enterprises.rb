class AddCreatedByToEnterprises < ActiveRecord::Migration[7.0]
  def change
    add_reference :enterprises, :created_by, foreign_key: { to_table: :users }
  end
end
