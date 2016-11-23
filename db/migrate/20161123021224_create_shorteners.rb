class CreateShorteners < ActiveRecord::Migration[5.0]
  def change
    create_table :shorteners do |t|
      t.string :title
      t.string :long_url
      t.string :short_url
      t.integer :num_click

      t.timestamps
    end
  end
end
