require 'spec_helper'

module TestHelper #FIXME: merge with unit test_helper.rb
  def create_valid_poll(title = '2b|!2b?', category = Poll::CATEGORIES.first)
    poll = Poll.create(:title => title, :category => category)
    poll.questions << new_valid_question
    poll.user = User.find_by_email('bob@example.org')
    poll
  end

  def new_valid_poll(title = '2b|!2b?', category = Poll::CATEGORIES.first)
    poll = Poll.new(:title => title, :category => category)
    poll.questions << new_valid_question
    poll.user = User.find_by_email('bob@example.org')
    poll
  end

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
  
  def new_valid_question
    Question.new(:text => 'why not?', :kind => Question::KINDS.first)
  end
  
  def should_have_active_polls
    page.should have_content('Active polls')
    page.should_not have_content('Found no active polls.')
  end
  
  def should_have_no_active_polls
    page.should have_content('Active polls')
    page.should have_content('Found no active polls.')
  end
  
  def should_have_closed_polls
    page.should have_content('Closed polls')
    page.should_not have_content('Found no closed polls.')
  end
  
  def should_have_no_closed_polls
    page.should have_content('Closed polls')
    page.should have_content('Found no closed polls.')
  end
  
  def login_as_new_user(email = 'bob@example.org', password = '654321', first_name = 'Bob', name = 'Taylor')
    visit "/"
    click_link('Register')
    fill_in 'user_email', :with => email
    fill_in 'user_password', :with => password
    fill_in 'user_password_confirmation', :with => password
    fill_in 'user_first_name', :with => first_name
    fill_in 'user_name', :with => name
    click_button 'Sign up'
  end

  def login_as(email, password)
    click_link('Login')
    fill_in 'user_email', :with => email
    fill_in 'user_password', :with => password
    click_button 'Sign in'
  end
end

describe "Poll administration" do
  
  describe "User login/logout" do
    
    # Executed before each test
    before(:each) do
      login_as_new_user('bob@example.org', '654321', 'Bob', 'Taylor')
    end
    
    it "should register" do
      click_link 'Logout'
      login_as_new_user('bob2@example.org', '654321', 'Bob', 'Taylor')
      page.should have_content('Logged in as bob2@example.org')
      page.should have_content('Welcome! You have signed up successfully.')
    end

    it "should log out" do
      click_link 'Logout'
      page.should have_content('Signed out successfully.')
      page.should have_link('Login')
    end

    it "should log in" do
      click_link 'Logout'
      login_as('bob@example.org', '654321')
      page.should have_content('Logged in as bob@example.org')
    end
    
  end
  
  describe "GET / polls" do
    
    # Executed before each test
    before(:each) do
      login_as_new_user('bob@example.org', '654321', 'Bob', 'Taylor')
      visit polls_path
    end
    
    it "should initially have no active and no closed polls" do
      should_have_no_active_polls
      should_have_no_closed_polls
    end
    
    it "should open create poll page" do
      click_link 'Create poll'
      page.should have_content('New question')
    end
  
    it "should have one active and one closed poll" do
      create_and_save_poll
      create_close_and_save_poll
      visit polls_path
      should_have_active_polls
      should_have_closed_polls
    end
  
    #FIXME: how to test Cancel close?
    it "should close poll" do
      create_and_save_poll
      visit polls_path
      click_button 'Close poll'
      should_have_no_active_polls
      should_have_closed_polls
      # page.should have_content('Poll was successfully closed.')
    end
    
    #FIXME: how to test Cancel delete?
    it "should delete poll" do
      create_close_and_save_poll
      visit polls_path
      click_button 'Delete poll'
      should_have_no_closed_polls
      # page.should have_content('Poll was successfully deleted.')
    end
  end
  
  describe "GET/PUT/POST new poll" do
    
    # Executed before each test
    before(:each) do
      login_as_new_user('bob@example.org', '654321', 'Bob', 'Taylor')
      visit new_poll_path
    end
    
    it "should initially have only a single question" do
      page.should have_content('Question 1')
      page.should_not have_content('Question 2')
    end
    
    it "should initially have no remove checkbox and no update button" do
      page.should_not have_button('Update')
      page.should_not have_field('poll_questions_attributes_0__destroy')
    end
    
    it "should cancel new poll" do
      click_button 'Cancel'
      should_have_no_active_polls
    end
  
    it "should fail to add new question and not append question when empty" do
      click_button 'Add question'
      page.should have_content("Text can't be blank")
      page.should have_content('Question 1')
      page.should have_xpath("//span[@class='field_with_errors']")
      page.should_not have_content('Question 2')
    end
  
    it "should add one question" do
      fill_in 'poll_questions_attributes_0_text', :with => 'A question'
      select Question::KINDS.last, :from => 'poll_questions_attributes_0_kind'
      click_button 'Add question'
      page.should have_content('Question 2')
    end
    
    it "should add ten questions" do
      1.upto(10) do |i|
        fill_in "poll_questions_attributes_#{i-1}_text", :with => 'A question'
        select Question::KINDS.last, :from => "poll_questions_attributes_#{i-1}_kind"
        click_button 'Add question'
      end
      page.should have_content('Question 11')
    end
    
    # it "should delete the only question" do
    #   visit new_poll_path
    #   fill_in 'poll_questions_attributes_0_text', :with => 'A question'
    #   select Question::KINDS.last, :from => 'poll_questions_attributes_0_kind'
    #   click_button 'Add question'
    #   click_button 'Delete question'
    #   page.should have_content('Question 1')
    #   page.should_not have_content('Question 2')
    # end
  
    it "should fail to publish without title and category" do
      click_button 'Publish'
      page.should have_content("Title can't be blank")
      page.should have_content("Category can't be blank")
      page.should have_xpath("//div[@class='field_with_errors']")
    end
    
    it "should fail to publish with empty question list" do
      fill_in 'poll_title', :with => 'A poll'
      select Poll::CATEGORIES.first, :from => 'poll_category'
      click_button 'Publish'
      page.should have_content('Poll must have at least 1 question')
    end
    
    it "should fail to publish if first question entered but not added" do
      fill_in 'poll_title', :with => 'A poll'  #FIXME: factor out
      select Poll::CATEGORIES.first, :from => 'poll_category'  #FIXME: factor out
      fill_in 'poll_questions_attributes_0_text', :with => 'A question'  #FIXME: factor out
      select Question::KINDS.last, :from => 'poll_questions_attributes_0_kind'  #FIXME: factor out
      click_button 'Publish'
      page.should have_content('Poll must have at least 1 question')
    end
    
    it "should create a poll" do
      fill_in 'poll_title', :with => 'A poll'  #FIXME: factor out
      select Poll::CATEGORIES.first, :from => 'poll_category'  #FIXME: factor out
      fill_in 'poll_questions_attributes_0_text', :with => 'A question'  #FIXME: factor out
      select Question::KINDS.last, :from => 'poll_questions_attributes_0_kind'  #FIXME: factor out
      click_button 'Add question'
      click_button 'Publish'
      page.should have_content('Poll was successfully created.')
      should_have_active_polls
    end
    
    it "should update an already added question" do
      fill_in 'poll_title', :with => 'A poll'  #FIXME: factor out
      select Poll::CATEGORIES.first, :from => 'poll_category'  #FIXME: factor out
      fill_in 'poll_questions_attributes_0_text', :with => 'A question'  #FIXME: factor out
      select Question::KINDS.last, :from => 'poll_questions_attributes_0_kind'  #FIXME: factor out
      click_button 'Add question'
      fill_in 'poll_questions_attributes_0_text', :with => 'changed question'  #FIXME: factor out
      select Question::KINDS.first, :from => 'poll_questions_attributes_0_kind'  #FIXME: factor out
      click_button 'Publish'
      poll = Poll.find(:all).first
      poll.questions.first.text.should == 'changed question'
      poll.questions.first.kind.should == Question::KINDS.first
    end
    
    it "should fail if invalidating an already added question" do
      fill_in 'poll_title', :with => 'A poll'  #FIXME: factor out
      select Poll::CATEGORIES.first, :from => 'poll_category'  #FIXME: factor out
      3.times do |i|
        fill_in "poll_questions_attributes_#{i}_text", :with => "Q#{i}"  #FIXME: factor out
        select Question::KINDS.last, :from => "poll_questions_attributes_#{i}_kind"  #FIXME: factor out
        click_button 'Add question'
      end
      fill_in 'poll_questions_attributes_1_text', :with => ''  #FIXME: factor out
      click_button 'Publish'
      page.should have_content("Questions text can't be blank")
      page.should have_xpath("//div[@class='field_with_errors']/input[@id='poll_questions_attributes_1_text']")
    end
    
    it "should delete the only question" do
      fill_in 'poll_title', :with => 'A poll'  #FIXME: factor out
      select Poll::CATEGORIES.first, :from => 'poll_category'  #FIXME: factor out
      fill_in 'poll_questions_attributes_0_text', :with => 'A question'  #FIXME: factor out
      select Question::KINDS.last, :from => 'poll_questions_attributes_0_kind'  #FIXME: factor out
      click_button 'Add question'
      check 'poll_questions_attributes_0__destroy'
      click_button 'Update'
      page.should_not have_content('Question 2')
    end
    
    it "should delete the second question" do
      fill_in 'poll_title', :with => 'A poll'  #FIXME: factor out
      select Poll::CATEGORIES.first, :from => 'poll_category'  #FIXME: factor out
      3.times do |i|
        fill_in "poll_questions_attributes_#{i}_text", :with => "Q#{i}"  #FIXME: factor out
        select Question::KINDS.last, :from => "poll_questions_attributes_#{i}_kind"  #FIXME: factor out
        click_button 'Add question'
      end
      check 'poll_questions_attributes_1__destroy'
      click_button 'Update'
      page.should_not have_content('Question 4')
    end
  end
  
  include TestHelper
end


  
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
