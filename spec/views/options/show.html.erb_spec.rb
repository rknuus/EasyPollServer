require 'spec_helper'

describe "options/show.html.erb" do
  before(:each) do
    @option = assign(:option, stub_model(Option,
      :text => "Text",
      :question_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Text/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
