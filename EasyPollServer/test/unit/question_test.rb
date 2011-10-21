require 'test_helper'

class QuestionTest < ActiveSupport::TestCase
  test "invalid if missing attributes" do
    q = Question.create
    assert q.invalid?
    assert q.errors[:text].any?
    assert q.errors[:kind].any?
    # assert q.errors[:poll_id].any?
  end
  
  test "whitelist kind" do
    p = questions(:one).dup
    p.kind = 'Absolutely Positively Surely Not Existing Kind'
    assert p.invalid?
    assert p.errors[:kind].any?
  end
end
