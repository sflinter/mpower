class Cause < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :description
  
  belongs_to :user
  belongs_to :metro_area

  def first_image_in_body(size = nil, options = {})
    doc = Hpricot(self.description)
    image = doc.at("img")
    image ? image['src'] : nil
  end
  
  def tag_for_first_image_in_body
    image = first_image_in_body
    image.nil? ? '' : "<img src='#{image}' />"
  end
end
