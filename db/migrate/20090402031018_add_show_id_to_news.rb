class AddShowIdToNews < ActiveRecord::Migration
  def self.up
  	add_column :news, :show_id, :integer
  end

  def self.down
  	remove_column :news, :show_id
  end
end
