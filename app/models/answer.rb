class Answer < ActiveRecord::Base
  belongs_to :participation
  belongs_to :option
end
