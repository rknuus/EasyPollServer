require 'spec_helper'

describe "answers/edit.html.erb" do
  before(:each) do
    @answer = assign(:answer, stub_model(Answer,
      :participation_id => 1,
      :option_id => 1
    ))
  end

  it "renders the edit answer form" do
    render

    rendered.should have_selector("form", :action => answer_path(@answer), :method => "post") do |form|
      form.should have_selector("input#answer_participation_id", :name => "answer[participation_id]")
      form.should have_selector("input#answer_option_id", :name => "answer[option_id]")
    end
  end
end
