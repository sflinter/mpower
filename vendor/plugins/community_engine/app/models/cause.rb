class Cause < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :description
  
  belongs_to :user
  belongs_to :metro_area
end
