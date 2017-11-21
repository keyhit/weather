class CreateForecasts < ActiveRecord::Migration[5.0]
  def change
    create_table :forecasts do |t|
      t.integer :accuweather_temp_min
      t.integer :accuweather_temp_max
      t.integer :accuweather_precipitation
      t.integer :darksky_temp_min
      t.integer :darksky_temp_max
      t.integer :darksky_precipitation
      t.string  :city
      t.references :user, index: true

      t.timestamps
    end
  end
end
