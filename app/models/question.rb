class Question < ActiveRecord::Base
  
  belongs_to :poll
  has_many :options, :dependent => :destroy

  accepts_nested_attributes_for :options, :allow_destroy => true
  
  KINDS = ['single choice', 'multiple choice']

  validates_presence_of :text, :kind
  validates_inclusion_of :kind, :in => KINDS
  #validate :two_or_more_options?

  before_save :remove_empty_options
  
  after_initialize :build_options

private  
  def two_or_more_options?
    valid_count = 0
    self.options.each do |option|
      valid_count += 1 if option.valid?
    end
    errors[:base] << 'Question must have at least 2 options' if valid_count < 2
  end
  
  def build_options
    10.times { self.options.push Option.new } if self.options.empty?
  end
  
  def remove_empty_options
    self.options.delete_if { |option| option.text.blank? }
  end
end
