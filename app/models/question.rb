class Question < ActiveRecord::Base
  belongs_to :poll
  has_many :options, :dependent => :destroy
  accepts_nested_attributes_for :options, :allow_destroy => true #, :reject_if => :all_blank

  KINDS = ['single choice', 'multiple choice']
  
  validates_presence_of :text, :kind
  validates_inclusion_of :kind, :in => KINDS
  
end
