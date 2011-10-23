class Poll < ActiveRecord::Base
  CATEGORIES = ['Political Poll', 'Commercial Poll']
  
  attr_writer :current_step
  
  validates :title, :category, :published_at, :presence => true
  validates :category, :inclusion => CATEGORIES
  #FIXME: should title be unique?!
  
  after_initialize :initialize_published_at
  
  def close
    self.closed_at = DateTime.now if self.closed_at.nil?
  end
  
  def steps
    %w[poll_title enter_question list_questions]
  end
  
  def current_step
    @current_step || steps.first
  end
  
  def next_step
     self.current_step = steps[steps.index(current_step)+1]
   end
  
  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end
  
  def is_first_step?
    current_step == steps.first
  end
  
  def is_last_step?
    current_step == steps.last
  end
  
private
  def initialize_published_at
    self.published_at = DateTime.now if self.published_at.nil?
  end
end
