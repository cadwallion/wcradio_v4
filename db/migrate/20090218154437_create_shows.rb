class CreateShows < ActiveRecord::Migration
  def self.up
    create_table :shows do |t|
      t.string :name
      t.string :desc
      t.string :hosts
      t.string :email
      t.text :keywords
      t.date :next_show
      t.time :time
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :shows
  end
end
