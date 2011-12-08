require 'test_helper'

class OptionTest < ActiveSupport::TestCase
  test "should be invalid if missing attributes" do
    option = Option.new
    assert option.invalid?
    assert option.errors[:text].any?
  end
  
  test "should be valid" do
    option = Option.new(:text => 'yesyes')
    assert option.valid?
  end
end
