class Participation < ActiveRecord::Base
  belongs_to :user
  belongs_to :poll
  
  has_many :answers
end
