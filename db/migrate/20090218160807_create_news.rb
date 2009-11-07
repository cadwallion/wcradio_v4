class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.integer :user_id
      t.string :title
      t.text :desc
      t.boolean :active

      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
