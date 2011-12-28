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
    # @show_existent_options = true
  end
  
  def next_question
    @question_index += 1
  end
  
  def question_index
    @question_index
  end
  
  def end_question_list
    @show_delete = false
    # @show_existent_options = false
  end
  
  def start_option_list
    @option_row = 0
  end
  
  def next_option
    @option_row = (@option_row + 1) % 5
  end
  
  def show_delete?
    @show_delete
  end
  
  # def show_existent_options?
  #   @show_existent_options
  # end
  # 
  # # def get_option_field_class(symbol)
  # #     if @option_index > @question.options.count && @option.errors[symbol].any?
  # #       'field_with_errors'
  # #     else
  # #       'field'
  # #     end
  # #   end
  # 
  # def start_option_list
  #   @option_index = 0
  # end
  # 
  # def next_option
  #   @option_index += 1
  # end
  
end
