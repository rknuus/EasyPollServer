require 'spec_helper'

describe "answers/new.html.erb" do
  before(:each) do
    assign(:answer, stub_model(Answer,
      :participation_id => 1,
      :option_id => 1
    ).as_new_record)
  end

  it "renders new answer form" do
    render

    rendered.should have_selector("form", :action => answers_path, :method => "post") do |form|
      form.should have_selector("input#answer_participation_id", :name => "answer[participation_id]")
      form.should have_selector("input#answer_option_id", :name => "answer[option_id]")
    end
  end
end
