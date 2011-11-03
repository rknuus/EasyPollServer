class Poll < ActiveRecord::Base
  has_many :questions, :dependent => :destroy
  accepts_nested_attributes_for :questions, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  
  CATEGORIES = ['Political Poll', 'Commercial Poll']
  
  validates :title, :category, :published_at, :presence => true
  validates :category, :inclusion => CATEGORIES
  #FIXME: should title be unique?!
  #FIXME: validate_numericality_of questions.count > 0, :if => lambda { |p| p.current_step = p.steps.last
  
  after_initialize :initialize_published_at
  
  def close
    self.closed_at = DateTime.now if self.closed_at.nil?
  end
  
  def self.get_active_polls
    find(:all, :conditions => 'closed_at IS NULL')
  end

  def self.get_closed_polls
    find(:all, :conditions => 'closed_at IS NOT NULL')
  end
    
private
  def initialize_published_at
    self.published_at = DateTime.now if self.published_at.nil?
  end
end
