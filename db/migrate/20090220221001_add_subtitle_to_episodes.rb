class AddSubtitleToEpisodes < ActiveRecord::Migration
  def self.up
    add_column :episodes, :subtitle, :string
  end

  def self.down
    remove_column :episodes, :subtitle
  end
end
