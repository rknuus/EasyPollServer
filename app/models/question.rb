class Question < ActiveRecord::Base
  KINDS = ['single choice', 'multiple choice']
  
  validates_presence_of :text, :kind
  validates_inclusion_of :kind, :in => KINDS
  # validate :two_or_more_options
  
  before_save :remove_empty_options
  after_initialize :build_options
  
  belongs_to :poll
  has_many :options, :dependent => :destroy
  accepts_nested_attributes_for :options, :allow_destroy => true

private  
  def two_or_more_options
    valid_count = 0
    self.options.each { |option| valid_count += 1 if option.valid? }
    errors[:base] << 'Question must have at least 2 options' if valid_count < 2
  end
  
  def build_options
    self.options.clear
    10.times { self.options.push Option.new }
  end
  
  def remove_empty_options
    self.options.delete_if { |option| option.blank? }
  end
end
