require 'spec_helper'

describe "participations/edit.html.erb" do
  before(:each) do
    @participation = assign(:participation, stub_model(Participation,
      :poll_id => 1,
      :user_id => 1
    ))
  end

  it "renders the edit participation form" do
    render

    rendered.should have_selector("form", :action => participation_path(@participation), :method => "post") do |form|
      form.should have_selector("input#participation_poll_id", :name => "participation[poll_id]")
      form.should have_selector("input#participation_user_id", :name => "participation[user_id]")
    end
  end
end
