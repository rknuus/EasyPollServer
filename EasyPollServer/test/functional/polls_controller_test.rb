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

  test "should create poll" do
    poll = new_valid_poll
    assert_difference('Poll.count') do
      get :new
      post :create, poll: poll.attributes
    end

    assert_redirected_to poll_path(assigns(:poll))
  end

  test "should show poll" do
    get :show, id: create_valid_poll.to_param
    assert_response :success
  end

  test "should destroy poll" do
    poll = create_valid_poll
    assert_difference('Poll.count', -1) do
      delete :destroy, id: poll.to_param
    end

    assert_redirected_to polls_path
  end
  
  test "should close poll" do
    poll = create_valid_poll
    put :close, id: poll.to_param, poll: poll.attributes

    assert_redirected_to polls_path
  end

  test "should cancel poll" do
    poll = create_valid_poll
    assert_no_difference('Poll.count') do
      get :new
      post :create, id: poll.to_param, :cancel_button => 'Cancel'
    end

    assert_redirected_to polls_path
  end
  
  test "new question should not create poll" do
    poll = new_valid_poll
    get :new
    poll.questions << Question.create(:text => 'why not?', :kind => Question::KINDS.first)
    post :create, id: poll.to_param, poll: poll.attributes, :new_question_button => 'Add question'
    assert_raise(ActiveRecord::RecordNotFound) { Poll.find(poll.id) }

    #FIXME: assert_redirected_to poll_path(assigns(:poll))
  end
  
  # test "at first new poll should have only one empty question" do
  #   #FIXME: 
  #   # poll = new_valid_poll
  #   # get :new
  #   # post :create, id: poll.to_param, poll: poll.attributes
  # end
  
  # test "publishing without any question should fail" do
  # end
  
  #FIXME: test story poll creation and closing
  # Alice gets a list of all open polls
  # Alice logs in
  # Alice gets a list of all open polls and all polls created by Alice
  # Alice creates a new poll with 3 questions
  # Alice closes a poll
  
  #FIXME: test story poll participation
  # Alice gets a list of all open polls
  # Alice selects a poll
  # Alice clicks 'participate'
  # Alice is asked to log in and logs in
  # Alice fills in the poll questions and sends the answers
end
