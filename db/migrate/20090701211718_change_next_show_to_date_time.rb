class ChangeNextShowToDateTime < ActiveRecord::Migration
  def self.up
    change_column :shows, :next_show, :datetime
    Show.find(:all).each do |s|
      require 'parsedate'
      
      time = ParseDate.parsedate(s.time.to_s)  
      # add in the date
      time[0] = s.next_show.year
      time[1] = s.next_show.month
      time[2] = s.next_show.day

      # prep UTC time
      upcoming = Time.utc(*time)
      s.update_attribute :next_show, upcoming
    end
    remove_column :shows, :time
  end

  def self.down
    add_column :shows, :time, :time
    Show.find(:all).each do |s|
      s.update_attribute :time, s.next_show
    end
    change_column :shows, :next_show, :date
  end
end
