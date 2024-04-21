class CreateWhiteLabels < ActiveRecord::Migration[7.0]
  def change
    create_table :white_labels do |t|
      t.string :kind_cd
      t.string :description

      t.boolean :active, default: true

      t.timestamps
    end
  end
end
