class AddBadgeToShows < ActiveRecord::Migration
  def self.up
  	add_column :shows, :badge, :string
  end

  def self.down
  	remove_column :shows, :badge
  end
end
