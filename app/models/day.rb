class Day < ActiveRecord::Base
  default_scope { order('date DESC') }
  belongs_to :user
  validates_uniqueness_of :date, scope: [:user_id]

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      #csv << column_names
      column_names = %w(date content)
      csv << column_names
      all.each do |day|
        csv << day.attributes.values_at(*column_names)
      end
    end
  end
end