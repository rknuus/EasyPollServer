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
  
  test "initially current_step should be first" do
    assert_equal polls(:one).steps.first, polls(:one).current_step
  end
  
  test "should proceed to next step" do
    polls(:one).next_step
    assert_not_equal polls(:one).steps.first, polls(:one).current_step
  end
  
  test "should proceed to previous step" do
    polls(:one).next_step
    s1 = polls(:one).current_step
    polls(:one).previous_step
    s2 = polls(:one).current_step
    assert_not_equal s1, s2
  end
  
  test "previous step should undo next step" do
    s1 = polls(:one).current_step
    polls(:one).next_step
    polls(:one).previous_step
    s2 = polls(:one).current_step
    assert_equal s1, s2
  end
  
  test "initially is first step" do
    assert polls(:one).is_first_step?
  end
  
  test "initially is not last step" do
    assert !polls(:one).is_last_step?
  end
  
  test "next step should wrap around" do
    polls(:one).next_step
    polls(:one).next_step
    polls(:one).next_step
    assert polls(:one).is_first_step?
  end
end
