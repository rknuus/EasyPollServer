class Poll < ActiveRecord::Base
  CATEGORIES = ['Political Poll', 'Commercial Poll']
  
  validates :title, :category, :published_at, :presence => true
  validates :category, :inclusion => CATEGORIES
  #FIXME: should title be unique?!
  
  after_initialize :initialize_published_at
  
  def close
    self.closed_at = DateTime.now if self.closed_at.nil?
  end
  
private
  def initialize_published_at
    self.published_at = DateTime.now if self.published_at.nil?
  end
end
