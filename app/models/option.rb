class Option < ActiveRecord::Base
  belongs_to :question
  
  has_many :answers
  
  #validates_presence_of :text
end
