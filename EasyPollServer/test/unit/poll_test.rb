require 'test_helper'

class PollTest < ActiveSupport::TestCase
  test "initially published_at set" do
    poll = Poll.new
    assert !poll.published_at.nil?
  end

  test "invalid if missing attributes" do
    poll = Poll.new
    poll.published_at = nil
    assert poll.invalid?
    assert poll.errors[:title].any?
    assert poll.errors[:published_at].any?
    assert poll.errors[:category].any?
  end
  
  test "whitelist category" do
    poll = polls(:one).dup
    poll.category = 'Absolutely Positively Surely Not Existing Category'
    assert poll.invalid?
    assert poll.errors[:category].any?
  end
  
  test "should close poll" do
    poll = polls(:one).dup
    poll.close
    assert !poll.closed_at.nil?
  end
end
