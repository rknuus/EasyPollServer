ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# require 'capybara'
require 'capybara/rails'
require 'capybara/rspec'

class ActiveSupport::TestCase
  def create_valid_poll(title = '2b|!2b?', category = Poll::CATEGORIES.first)
    poll = Poll.create(:title => title, :category => category)
    poll.questions << new_valid_question
    poll
  end

  def new_valid_poll(title = '2b|!2b?', category = Poll::CATEGORIES.first)
    poll = Poll.new(:title => title, :category => category)
    poll.questions << new_valid_question
    poll
  end

  def create_and_save_poll
    poll = create_valid_poll
    poll.save
    poll
  end
  
  def create_close_and_save_poll
    poll = create_valid_poll
    poll.close
    poll.save
    poll
  end
  
  def new_valid_question
    Question.new(:text => 'why not?', :kind => Question::KINDS.first)
  end

  include Capybara::DSL
end
