xml.instruct!
if !user_signed_in?
  xml.error("not signed in")
elsif @poll_result.nil?
  xml.error("invalid poll id")
else
  xml.poll do
    xml.id(@poll_result.id)
    xml.title(@poll_result.title)
    xml.published_at(@poll_result.published_at.to_date)
    @poll_result.closed_at.nil? ? xml.closed_at() : xml.closed_at(@poll_result.closed_at.to_date)
    xml.category(@poll_result.category)
    xml.user_name(User.find(@poll_result.user_id).full_name)
    xml.my_user_id(current_user.id)
    xml.questions_count(@poll_result.questions.count)
    xml.participations_count(@poll_result.participations.count)
    xml.questions do
      @poll_result.questions.each do |question|
        xml.question do
          xml.id(question.id)
          xml.text(question.text)
          xml.kind(question.kind)
          xml.options do
            question.options.each do |option|
              xml.option do
                xml.id(option.id)
                xml.text(option.text)
                xml.answers_count(option.answers.count)
                @poll_result.participations.count == 0 ? xml.answers_percent() : xml.answers_percent(((option.answers.count.to_f / @poll_result.participations.count.to_f) * 100).round(2))
              end
            end
          end
        end
      end
    end
  end
end