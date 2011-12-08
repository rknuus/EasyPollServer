require 'spec_helper'

describe "participations/index.html.erb" do
  before(:each) do
    assign(:participations, [
      stub_model(Participation,
        :poll_id => 1,
        :user_id => 1
      ),
      stub_model(Participation,
        :poll_id => 1,
        :user_id => 1
      )
    ])
  end

  it "renders a list of participations" do
    render
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
    rendered.should have_selector("tr>td", :content => 1.to_s, :count => 2)
  end
end
