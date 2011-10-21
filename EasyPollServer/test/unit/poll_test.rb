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
  
  test "steps count should be two" do
    assert_equal 2, polls(:one).steps.size
  end

  test "initially current_test is first step" do
    assert_equal polls(:one).steps.first, polls(:one).current_step
  end
  
  test "next_step should be last step" do
    assert_equal polls(:one).steps.last, polls(:one).next_step
  end
  
  test "previous_step should be first step" do
    assert_equal polls(:one).steps.first, polls(:one).previous_step
  end
  
  test "should be first step" do
    assert polls(:one).first_step?
  end
  
  test "should not be first step" do
    polls(:one).next_step
    assert !polls(:one).first_step?
  end
  
  test "should be last step" do
    polls(:one).next_step
    assert polls(:one).last_step?
  end
  
  test "should not be last step" do
    assert !polls(:one).last_step?
  end
end
