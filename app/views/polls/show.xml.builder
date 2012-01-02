xml.instruct!
if !user_signed_in?
  xml.error("not signed in")
elsif @poll.nil?
  xml.error("invalid poll id")
else
  xml.poll do
    xml.id(@poll.id)
    xml.title(@poll.title)
    xml.published_at(@poll.published_at.to_date)
    xml.category(@poll.category)
    xml.user_name(User.find(@poll.user_id).full_name)
    xml.my_user_id(current_user.id)
    xml.questions_count(@poll.questions.count)
    xml.participations_count(@poll.participations.count)
    xml.questions do
      @poll.questions.each do |question|
        xml.question do
          xml.id(question.id)
          xml.text(question.text)
          xml.kind(question.kind)
          xml.options do
            question.options.each do |option|
              xml.option do
                xml.id(option.id)
                xml.text(option.text)
              end
            end
          end
        end
      end
    end
  end
end