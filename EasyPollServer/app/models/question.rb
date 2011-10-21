class Question < ActiveRecord::Base
  KINDS = ['Yes/No', 'Scale 1..10']

  belongs_to :poll
  
  validates :text, :kind, :presence => true  #TODO: :poll_id
  validates :kind, :inclusion => KINDS
end
