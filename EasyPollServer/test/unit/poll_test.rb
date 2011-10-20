require 'test_helper'

class PollTest < ActiveSupport::TestCase
  test "initially published at set" do
    p = Poll.create
    assert !p.published_at.nil?
  end
end
