require 'spec_helper'

describe "Answers" do
  describe "GET /answers" do
    it "works! (now write some real specs)" do
      visit answers_path
      response.status.should be(200)
    end
  end
end
