require 'test_helper'

class PollsControllerTest < ActionController::TestCase
  test "should not have access to show" do
    assert_raise(ActionController::RoutingError) do
      get :show, id: create_valid_poll.to_param
    end
  end

  test "should not have access to edit" do
    assert_raise(ActionController::RoutingError) do
      get :edit, id: create_valid_poll.to_param
    end
  end

  test "should not have access to update" do
    assert_raise(ActionController::RoutingError) do
      poll = create_valid_poll
      put :update, id: poll.to_param, poll: poll
    end
  end
end
