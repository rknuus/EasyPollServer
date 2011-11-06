module PollsHelper
  #FIXME: remove?
  def get_question_field_class(symbol)
    if @question_index > @poll.questions.count && @question.errors[symbol].any?
      'field_with_errors'
    else
      'field'
    end
  end
  
  def add_question_button(name)
    button_to_function(name) do |page|
      page.insert_html :bottom, :questions, :partial => 'question', :object => Question.new
    end
  end
end
