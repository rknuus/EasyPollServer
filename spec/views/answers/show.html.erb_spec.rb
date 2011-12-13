require 'spec_helper'

describe "answers/show.html.erb" do
  before(:each) do
    @answer = assign(:answer, stub_model(Answer,
      :participation_id => 1,
      :option_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain(1.to_s)
    rendered.should contain(1.to_s)
  end
end
