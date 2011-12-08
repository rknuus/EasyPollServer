require 'spec_helper'

describe "options/edit.html.erb" do
  before(:each) do
    @option = assign(:option, stub_model(Option,
      :text => "MyString",
      :question_id => 1
    ))
  end

  it "renders the edit option form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => options_path(@option), :method => "post" do
      assert_select "input#option_text", :name => "option[text]"
      assert_select "input#option_question_id", :name => "option[question_id]"
    end
  end
end
