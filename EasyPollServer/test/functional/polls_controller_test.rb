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
    poll = create_valid_poll
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
  
  # test "should create poll with two questions" do
  #   poll = create_valid_poll
  #   get :new
  #   poll.questions << Question.create(:text => 'why not?', :kind => Question::KINDS.first)
  #   {
  #     "utf8"=>"✓",
  #     "authenticity_token"=>"d5x4cSYakiZuduLJdlidM1TCudLjad6p1P6u4VMQYZE=",
  #     "poll"=>{
  #       "title"=>"P105",
  #       "category"=>"Political Poll",
  #       "questions_attributes"=>{
  #         "0"=>{"text"=>"Q1", "kind"=>"Yes/No"}
  #       }
  #     },
  #     "new_question_button"=>"Add question"
  #   }
  #   
  #   post :create, id: poll.to_param, :new_question_button => 'Add question', :poll => {}
  #   post :create, poll: poll.attributes
  # end
  
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
