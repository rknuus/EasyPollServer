require 'spec_helper'

describe "participations/new.html.erb" do
  before(:each) do
    assign(:participation, stub_model(Participation,
      :poll_id => 1,
      :user_id => 1
    ).as_new_record)
  end

  it "renders new participation form" do
    render

    rendered.should have_selector("form", :action => participations_path, :method => "post") do |form|
      form.should have_selector("input#participation_poll_id", :name => "participation[poll_id]")
      form.should have_selector("input#participation_user_id", :name => "participation[user_id]")
    end
  end
end
