class ParticipationsController < ApplicationController
  # GET /participations
  def index
    @participations = Participation.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /participations/1
  def show
    @participation = Participation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /participations/new
  def new
    @participation = Participation.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /participations/1/edit
  def edit
    @participation = Participation.find(params[:id])
  end

  # POST /participations
  def create
    @poll = Poll.find(params[:poll_id])
    @user = current_user
    @participation = @user.participations.build(:poll => @poll)

    if !was_button_pressed?(:answer_button)
      respond_to do |format|
        format.html { render action: "new" }
      end
    else
      respond_to do |format|
        if @participation.save
          format.html { redirect_to "/", notice: 'Participation was successfully created.' }
        else
          format.html { render action: "new" }
        end
      end
    end
  end

  # PUT /participations/1
  def update
    @participation = Participation.find(params[:id])

    respond_to do |format|
      if @participation.update_attributes(params[:participation])
        format.html { redirect_to @participation, notice: 'Participation was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /participations/1
  def destroy
    @participation = Participation.find(params[:id])
    @participation.destroy

    respond_to do |format|
      format.html { redirect_to participations_url }
    end
  end

private  
  def was_button_pressed?(button)
    params[button]
  end
end
