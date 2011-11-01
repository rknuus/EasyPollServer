ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# require 'capybara'
require 'capybara/rails'
require 'capybara/rspec'

class ActiveSupport::TestCase
  def create_valid_poll(title = '2b|!2b?', category = Poll::CATEGORIES.first)
    Poll.create(:title => title, :category => category)
  end

  def new_valid_poll(title = '2b|!2b?', category = Poll::CATEGORIES.first)
    Poll.new(:title => title, :category => category)
  end

  include Capybara::DSL
end
