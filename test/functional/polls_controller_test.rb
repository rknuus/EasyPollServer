require 'test_helper'

class PollsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:active_polls)
    assert_not_nil assigns(:closed_polls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  # test "should create poll" do
  #   poll = new_valid_poll
  #   assert_difference('Poll.count') do
  #     get :new
  #     post :create, poll: poll.attributes
  #   end
  # 
  #   assert_redirected_to poll_path(assigns(:poll))
  # end

  # test "should show poll" do
  #   get :show, id: create_valid_poll.to_param
  #   assert_response :success
  # end

  # test "should destroy poll" do
  #   poll = create_valid_poll
  #   assert_difference('Poll.count', -1) do
  #     delete :destroy, id: poll.to_param
  #   end
  # 
  #   assert_redirected_to polls_path
  # end
  
  # test "should close poll" do
  #   poll = create_valid_poll
  #   put :close, id: poll.to_param, poll: poll.attributes
  # 
  #   assert_redirected_to polls_path
  # end
  
  test "should cancel poll" do
    poll = create_valid_poll
    assert_no_difference('Poll.count') do
      get :new
      post :create, id: poll.to_param, :cancel_button => 'Cancel'
    end
  
    assert_redirected_to polls_path
  end
end
