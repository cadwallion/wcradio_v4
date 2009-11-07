class CreateShowTypes < ActiveRecord::Migration
  def self.up
    create_table :show_types do |t|
      t.string :name

      t.timestamps
    end
    
    add_column :shows, :show_type_id, :integer
  end

  def self.down
    drop_table :show_types
    remove_column :shows, :show_type_id
  end
end
