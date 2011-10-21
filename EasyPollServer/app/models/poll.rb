class Poll < ActiveRecord::Base
  attr_writer :current_step
  
  CATEGORIES = ['Political Poll', 'Commercial Poll']

  has_many :questions, :dependent => :destroy
  
  validates :title, :category, :published_at, :presence => true
  validates :category, :inclusion => CATEGORIES
  #FIXME: should title be unique?!
  #FIXME: validate_numericality_of questions.count > 0, :if => lambda { |p| p.current_step = p.steps.last }
  
  after_initialize :initialize_published_at
    
  def close
    self.closed_at = DateTime.now if self.closed_at.nil?
  end
  
  def steps
    %w[poll enter_questions]
  end
  
  def current_step
    @current_step || steps.first
  end
  
  def next_step
    self.current_step = steps.last
  end
  
  def previous_step
    self.current_step = steps.first
  end
  
  def first_step?
    current_step == steps.first
  end
  
  def last_step?
    current_step == steps.last
  end
  
private
  def initialize_published_at
    self.published_at = DateTime.now if self.published_at.nil?
  end
end
