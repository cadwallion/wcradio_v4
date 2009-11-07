class AddOnAirFlagToShows < ActiveRecord::Migration
  def self.up
    add_column :shows, :on_air, :boolean
  end

  def self.down
    remove_column :shows, :on_air
  end
end
