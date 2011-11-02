module PollsHelper
  def get_question_field_class(symbol)
    if @question_index > @poll.questions.count && @question.errors[symbol].any?
      'field_with_errors'
    else
      'field'
    end
  end
end
