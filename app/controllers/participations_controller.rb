class ParticipationsController < ApplicationController

  # GET /participations/new
  def new
    @poll = Poll.find(params[:poll_id])
    @user = current_user
    @participation = @user.participations.build(:poll => @poll)

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /participations
  def create
    @participation = Participation.new
    @participation.user = User.find(params[:participation][:poll][:user_id])
    @participation.poll = Poll.find(params[:participation][:poll][:poll_id])
    
    answered_option_ids.each do |option_id|
      @participation.answers.build(:option_id => option_id)
    end

    respond_to do |format|
      if Participation.find(:first, :conditions => "poll_id IS #{@participation.poll.id} AND user_id IS #{@participation.user.id}").nil?
        if @participation.save
          format.html { redirect_to "/", notice: 'Participation was successfully created.' }
        else
          format.html { render action: "new" }
        end
      else
        format.html { redirect_to "/", notice: 'You already participated - not saved.' }
      end
    end
  end

private  
  def answered_option_ids
    option_ids = []
    params[:participation][:poll][:questions_attributes].each do |question|
      params[question[1][:id]].each do |selection|
        option_ids << selection
      end
    end
    option_ids
  end
end
