require 'spec_helper'

describe "Poll administration" do
  it "should have only a single question at first" do
    visit new_poll_path
    page.should have_content('Question 1')
    page.should_not have_content('Question 2')
  end
  
  it "should fail to add new question when empty" do
    visit new_poll_path
    click_button 'Add question'
    page.should have_content("Questions text can't be blank")
    page.should have_content('Question 1')
    page.should_not have_content('Question 2')
  end
end
