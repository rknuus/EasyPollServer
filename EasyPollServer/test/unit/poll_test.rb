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
  end
  
  test "should close poll" do
    p = polls(:one).dup
    p.close
    assert !p.closed_at.nil?
  end
end
