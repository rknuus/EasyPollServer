require 'spec_helper'

describe "participations/show.html.erb" do
  before(:each) do
    @participation = assign(:participation, stub_model(Participation,
      :poll_id => 1,
      :user_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should contain(1.to_s)
    rendered.should contain(1.to_s)
  end
end
