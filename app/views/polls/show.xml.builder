xml.instruct!
if !user_signed_in?
  xml.error("not signed in")
elsif @active_poll.nil?
  xml.error("invalid poll id")
else
  xml.poll do
    xml.id(@active_poll.id)
    xml.title(@active_poll.title)
    xml.published_at(@active_poll.published_at.to_date)
    xml.category(@active_poll.category)
    xml.user_name(User.find(@active_poll.user_id).full_name)
    xml.my_user_id(current_user.id)
    xml.questions_count(@active_poll.questions.count)
    xml.participations_count(@active_poll.participations.count)
    xml.questions do
      @active_poll.questions.each do |question|
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