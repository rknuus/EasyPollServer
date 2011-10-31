require 'test_helper'

class PollsControllerTest < ActionController::TestCase
  setup do
    @poll = create_valid_poll
  end

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

  test "should create poll" do
    assert_difference('Poll.count') do
      get :new
      post :create, poll: @poll.attributes
    end

    assert_redirected_to poll_path(assigns(:poll))
  end

  test "should show poll" do
    get :show, id: @poll.to_param
    assert_response :success
  end

  test "should destroy poll" do
    assert_difference('Poll.count', -1) do
      delete :destroy, id: @poll.to_param
    end

    assert_redirected_to polls_path
  end
  
  test "should close poll" do
    put :close, id: @poll.to_param, poll: @poll.attributes

    assert_redirected_to polls_path
  end

  test "should cancel poll" do
    assert_no_difference('Poll.count') do
      get :new
      post :create, id: @poll.to_param, :cancel_button => 'Cancel'
    end

    assert_redirected_to polls_path
  end
  
  # test "should reject publish if no poll title" do  # and category
  #   assert_no_difference('Poll.count') do
  #     poll = @poll.dup
  #     poll.title = ''
  #     get :new
  #     post :create, poll: poll.attributes, :cancel_button => 'Cancel'
  #   end
  # 
  #   assert_redirected_to poll_path(assigns(:poll))
  # end
end
