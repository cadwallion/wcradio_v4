class LegacyBase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection "legacy"
end
