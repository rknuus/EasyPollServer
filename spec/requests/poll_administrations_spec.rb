require 'spec_helper'

module TestHelper #FIXME: merge with unit test_helper.rb
  def create_valid_poll(title = '2b|!2b?', category = Poll::CATEGORIES.first)
    poll = Poll.create(:title => title, :category => category)
    poll.questions << new_valid_question
    poll
  end

  def new_valid_poll(title = '2b|!2b?', category = Poll::CATEGORIES.first)
    poll = Poll.new(:title => title, :category => category)
    poll.questions << new_valid_question
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
end

describe "Poll administration" do
  describe "GET / polls" do
    it "should initially have no active and closed polls" do
      visit polls_path
      should_have_no_active_polls
      should_have_no_closed_polls
    end
  
    it "should open create poll page" do
      visit polls_path
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
    end
  
    #FIXME: how to test Cancel delete?
    it "should delete poll" do
      create_close_and_save_poll
      visit polls_path
      click_button 'Delete poll'
      should_have_no_closed_polls
    end
  end
  
  describe "GET/PUT/POST new poll" do
    it "should initially have only a single question" do
      visit new_poll_path
      page.should have_content('Question 1')
      page.should_not have_content('Question 2')
    end
    
    it "should cancel new poll" do
      visit new_poll_path
      click_button 'Cancel'
      should_have_no_active_polls
    end
  
    it "should fail to add new question and not append question when empty" do
      visit new_poll_path
      click_button 'Add question'
      page.should have_content("Text can't be blank")
      page.should have_content('Question 1')
      page.should have_xpath("//span[@class='field_with_errors']")
      page.should_not have_content('Question 2')
    end
  
    it "should add one question" do
      visit new_poll_path
      fill_in 'poll_questions_attributes_0_text', :with => 'A question'
      select Question::KINDS.last, :from => 'poll_questions_attributes_0_kind'
      click_button 'Add question'
      page.should have_content('Question 2')
    end

    it "should fail to publish without title and category" do
      visit new_poll_path
      click_button 'Publish'
      page.should have_content("Title can't be blank")
      page.should have_content("Category can't be blank")
      page.should have_xpath("//div[@class='field_with_errors']")
    end
    
    it "should fail to publish with empty question list" do
      visit new_poll_path
      fill_in 'poll_title', :with => 'A poll'
      select Poll::CATEGORIES.first, :from => 'poll_category'
      click_button 'Publish'
      page.should have_content('Poll must have at least 1 question')
    end
    
    it "should create a poll" do
      visit new_poll_path
      fill_in 'poll_title', :with => 'A poll'  #FIXME: factor out
      select Poll::CATEGORIES.first, :from => 'poll_category'  #FIXME: factor out
      fill_in 'poll_questions_attributes_0_text', :with => 'A question'  #FIXME: factor out
      select Question::KINDS.last, :from => 'poll_questions_attributes_0_kind'  #FIXME: factor out
      click_button 'Publish'
      page.should have_content('Poll was successfully created.')
      should_have_active_polls
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
