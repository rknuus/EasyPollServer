class Question < ActiveRecord::Base
  belongs_to :poll

  KINDS = ['Yes/No', 'Rate 1..10']
end
