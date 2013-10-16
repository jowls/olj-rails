class Day < ActiveRecord::Base
  default_scope order: 'date DESC'
  belongs_to :user
  validates_uniqueness_of :date, scope: [:user_id]
end
