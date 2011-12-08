module ParticipationsHelper
  def option_tag_for(option, question)
    if question.kind = 'single choice'
      radio_button_tag('options', option.text)
    else #multiple choice
      check_box_tag(option.text)
    end
  end
end
