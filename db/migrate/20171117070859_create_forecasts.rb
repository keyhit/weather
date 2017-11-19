class CreateForecasts < ActiveRecord::Migration[5.0]
  def change
    create_table :forecasts do |t|
      t.integer :temp_min
      t.integer :temp_max
      t.string :precipitation
      t.string :city
      t.string :source
      t.references :user, index: true

      t.timestamps
    end
  end
end
