if !user_signed_in?
  xml.error("not signed in")
else
  @all_active_polls.each do |poll|
    xml.poll do
      xml.id(poll.id)
      xml.title(poll.title)
      xml.published_at(poll.published_at)
      xml.created_at(poll.created_at)
      xml.category(poll.category)
      xml.user_id(poll.user_id)
    end
  end
end