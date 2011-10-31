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
    poll = create_valid_poll
    assert poll.valid?
  end
  
  test "whitelist category" do
    poll = Poll.new(:title => '2b|!2b?', :category => 'Absolutely Positively Surely Not Existing Category')
    assert poll.invalid?
    assert poll.errors[:category].any?
  end
  
  test "should close poll" do
    poll = create_valid_poll
    poll.close
    assert !poll.closed_at.nil?
  end
  
private
  #FIXME: move to test helper
  def create_valid_poll(title = '2b|!2b?', category = Poll::CATEGORIES.first)
    Poll.new(:title => title, :category => category)
  end
end
