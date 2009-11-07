class AddItunesAndPreshowToShows < ActiveRecord::Migration
  def self.up
    add_column :shows, :itunes, :string, :default => nil
    add_column :shows, :preshow, :integer, :default => 0
  end

  def self.down
    remove_column :shows, :itunes
    remove_column :shows, :preshow
  end
end
