require 'test_helper'

class PollTest < ActiveSupport::TestCase
  test "on creation should set published_at" do
    poll = Poll.new
    assert !poll.published_at.nil?
  end

  test "should be invalid if missing attributes" do
    poll = Poll.new
    poll.published_at = nil
    assert poll.invalid?
    assert poll.errors[:title].any?
    assert poll.errors[:published_at].any?
    assert poll.errors[:category].any?
  end
  
  test "should be valid if all attributes defined" do
    poll = new_valid_poll
    assert poll.valid?
  end
  
  test "whitelist category" do
    poll = Poll.new(:title => '2b|!2b?', :category => 'Absolutely Positively Surely Not Existing Category')
    assert poll.invalid?
    assert poll.errors[:category].any?
  end
  
  test "should close poll" do
    poll = new_valid_poll
    poll.close
    assert !poll.closed_at.nil?
  end
  
  test "initially should return no closed polls" do
    polls = Poll.get_closed_polls
    assert_equal 0, polls.count
  end
  
  test "should return no closed polls when creating only open polls" do
    create_and_save_poll
    create_and_save_poll
    polls = Poll.get_closed_polls
    assert_equal 0, polls.count
  end
  
  test "should return one closed poll" do
    poll = create_close_and_save_poll
    polls = Poll.get_closed_polls
    assert_equal 1, polls.count
    assert_equal poll, polls.first
  end
  
private
  def create_and_save_poll
    poll = create_valid_poll
    poll.save
    poll
  end
  
  def create_close_and_save_poll
    poll = create_valid_poll
    poll.close
    poll.save
    poll
  end
end
