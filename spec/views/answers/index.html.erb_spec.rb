require 'spec_helper'

describe "answers/index.html.erb" do
  before(:each) do
    assign(:answers, [
      stub_model(Answer,
        :participation_id => 1,
        :option_id => 1
      ),
      stub_model(Answer,
        :participation_id => 1,
        :option_id => 1
      )
    ])
  end

  it "renders a list of answers" do
    render
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
  end
end
