class AddIpToVote < ActiveRecord::Migration
  def self.up
    add_column :votes, :voter_ip, :string
  end

  def self.down
    remove_column :votes, :voter_ip
  end
end
