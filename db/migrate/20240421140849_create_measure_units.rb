class CreateMeasureUnits < ActiveRecord::Migration[7.0]
  def change
    create_table :measure_units do |t|
      t.string :description
      t.string :abbreviation

      t.references :enterprise, foreign_key: true

      t.timestamps
    end
  end
end
