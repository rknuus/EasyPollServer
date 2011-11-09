class Poll < ActiveRecord::Base
  has_many :questions, :dependent => :destroy
  accepts_nested_attributes_for :questions, :allow_destroy => true
  
  CATEGORIES = ['Political Poll', 'Commercial Poll']
  
  validates_presence_of :title, :category, :published_at
  validates_inclusion_of :category, :in => CATEGORIES
  validate :has_question?
  #FIXME: should title be unique?!
  
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
  
  def has_question?
    errors[:base] << 'Poll must have at least 1 question' if self.questions.blank?
  end
end
