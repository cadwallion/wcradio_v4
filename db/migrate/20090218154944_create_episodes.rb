class CreateEpisodes < ActiveRecord::Migration
  def self.up
    create_table :episodes do |t|
      t.integer :show_id
      t.string :name
      t.text :desc
      t.string :keywords
      t.string :file
      t.date :air_date
      t.time :duration
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :episodes
  end
end
