module PollsHelper
  #FIXME: remove?
  def get_question_field_class(symbol)
    if @question_index > @poll.questions.count && @question.errors[symbol].any?
      'field_with_errors'
    else
      'field'
    end
  end
  
  def start_question_list
    @question_index = 0
    @show_delete = true
  end
  
  def next_question
    @question_index += 1
  end
  
  def question_index
    @question_index
  end
  
  def end_question_list
    @show_delete = false
  end
  
  def show_delete?
    @show_delete
  end
end
