class Day < ActiveRecord::Base
  default_scope order: 'date DESC'
  belongs_to :user
end
