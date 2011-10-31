require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test "invalid if missing attributes" do
    question = Question.new
    assert question.invalid?
    assert question.errors[:text].any?
    assert question.errors[:kind].any?
  end
  
  test "whitelist kind" do
    question = Question.new(:text => 'why?', :kind => 'Absolutely Positively Surely Not Existing Kind')
    assert question.invalid?
    assert question.errors[:kind].any?
  end
end
