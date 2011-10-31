require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test "should be invalid if missing attributes" do
    question = Question.new
    assert question.invalid?
    assert question.errors[:text].any?
    assert question.errors[:kind].any?
  end
  
  test "should whitelist kind" do
    question = Question.new(:text => 'why?', :kind => 'Absolutely Positively Surely Not Existing Kind')
    assert question.invalid?
    assert question.errors[:kind].any?
  end
  
  test "should be valid" do
    question = Question.new(:text => 'why not?', :kind => Question::KINDS.first)
    assert question.valid?
  end
end
