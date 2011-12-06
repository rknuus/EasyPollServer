class Question < ActiveRecord::Base
  belongs_to :poll
  has_many :options, :dependent => :destroy
  accepts_nested_attributes_for :options, :allow_destroy => true

  KINDS = ['single choice', 'multiple choice']
  
  validates :text, :kind, :presence => true
  validates :kind, :inclusion => KINDS
  
end
