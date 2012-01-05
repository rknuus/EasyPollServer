class Poll < ActiveRecord::Base
  belongs_to :user
  has_many :questions, :dependent => :destroy
  accepts_nested_attributes_for :questions, :allow_destroy => true
  has_many :participations, :dependent => :destroy  #FIXME: not sure whether OK if both user and poll can delete a participation
  
  CATEGORIES = ['Political', 'Commercial', 'Private']
  
  validates_presence_of :title, :category, :published_at
  validates_inclusion_of :category, :in => CATEGORIES
  #validate :has_question?
  # validate :hay_valid_questions?
  
  after_initialize :initialize_published_at
  
  def close
    self.closed_at = DateTime.now if self.closed_at.nil?
  end
  
  def self.get_all_active_polls
    find(:all, :conditions => 'closed_at IS NULL', :order => "published_at ASC")
  end
  
  def self.get_all_active_unanswered_polls(user)
    all_active_unanswered_polls = Array.new
    polls = find(:all, :conditions => 'closed_at IS NULL', :order => "published_at ASC");
    polls.each do |poll|
      if Participation.find(:first, :conditions => "poll_id IS #{poll.id} AND user_id IS #{user.id}").nil?
        all_active_unanswered_polls << poll
      end
    end
    all_active_unanswered_polls
  end
  
  def self.get_all_answered_polls(user)
    find(:all, :joins => :participations, :conditions => { :participations => { :user_id => user.id } }, :order => "published_at ASC")
  end
  
  def self.get_my_active_polls(user)
    find(:all, :conditions => { :closed_at => nil, :user_id => user.id } ) unless user.nil?
  end

  def self.get_my_closed_polls(user)
    find(:all, :conditions => "closed_at IS NOT NULL AND user_id IS #{user.id}") unless user.nil?
  end
    
private
  def initialize_published_at
    self.published_at = DateTime.now if self.published_at.nil?
  end
  
  # def has_question?
  #   if self.questions.empty? or self.questions.all? {|question| question.marked_for_destruction? }
  #     errors[:base] << 'Poll must have at least 1 question'
  #   end
  # end
  
  # def hay_valid_questions?
  #   if !self.questions.empty?
  #     self.questions.each do |question|
  #       
  #     end
  #   end
  # end
end
