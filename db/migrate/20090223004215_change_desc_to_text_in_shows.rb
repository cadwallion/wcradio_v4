class ChangeDescToTextInShows < ActiveRecord::Migration
  def self.up
  	change_column :shows, :desc, :text
  end

  def self.down
  	change_column :shows, :desc, :text
  end
end
