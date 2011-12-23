xml.instruct!
if !user_signed_in?
  xml.error("not signed in")
else
  xml.polls do
    @all_active_polls.each do |poll|
      xml.poll do
        xml.id(poll.id)
        xml.title(poll.title)
        xml.published_at(poll.published_at.to_date)
        xml.category(poll.category)
        xml.user_name(User.find(poll.user_id).full_name)
        xml.questions_count(poll.questions.count)
        xml.participations_count(poll.participations.count)
      end
    end
  end
end