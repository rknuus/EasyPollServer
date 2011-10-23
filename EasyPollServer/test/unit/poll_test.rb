require 'test_helper'

class PollTest < ActiveSupport::TestCase
  test "initially published_at set" do
    p = Poll.create
    assert !p.published_at.nil?
  end

  test "invalid if missing attributes" do
    p = Poll.create
    p.published_at = nil
    assert p.invalid?
    assert p.errors[:title].any?
    assert p.errors[:published_at].any?
    assert p.errors[:category].any?
  end
  
  test "whitelist category" do
    p = polls(:one).dup
    p.category = 'Absolutely Positively Surely Not Existing Category'
    assert p.invalid?
    assert p.errors[:category].any?
  end
  
  test "should close poll" do
    p = polls(:one).dup
    p.close
    assert !p.closed_at.nil?
  end
  
  test "should have steps" do
    assert_equal 3, polls(:one).steps.count
  end
end
