class CreateContacts < ActiveRecord::Migration[7.0]
  def change
    create_table :contacts do |t|
      t.string :cell_number
      t.string :telephone_number
      t.string :email
      t.string :observation

      t.belongs_to :person, foreign_key: true

      t.timestamps
    end
  end
end
