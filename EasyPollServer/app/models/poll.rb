class Poll < ActiveRecord::Base
  validates :title, :published_at, :presence => true
  #FIXME: should title be unique?!
  
  after_initialize :initialize_published_at
  
private
  def initialize_published_at
    self.published_at = DateTime.now
  end
end
