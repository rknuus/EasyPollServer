require 'spec_helper'

describe "options/index.html.erb" do
  before(:each) do
    assign(:options, [
      stub_model(Option,
        :text => "Text",
        :question_id => 1
      ),
      stub_model(Option,
        :text => "Text",
        :question_id => 1
      )
    ])
  end

  it "renders a list of options" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Text".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
