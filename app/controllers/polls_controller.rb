class PollsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  
  # GET /polls
  def index
    @active_polls = Poll.get_active_polls
    @closed_polls = Poll.get_closed_polls

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /polls/new
  def new
    setup_new_session
    load_session_variables

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # POST /polls
  def create
    load_session_variables
    @question = @poll.questions.pop || Question.new

    if was_button_pressed?(:cancel_button)
      reset_session

      respond_to do |format|
        format.html { redirect_to polls_url }
      end
    elsif was_button_pressed?(:new_question_button)
      if @question.valid?
        @poll.questions << @question
        @question = Question.new
      end

      rerender_new
    elsif was_button_pressed?(:update_button)
      rerender_new
    else #was_button_pressed?(:publish_button)
      if @poll.save
        reset_session

        respond_to do |format|
          format.html { redirect_to polls_url, notice: 'Poll was successfully created.' }
        end
      else
        rerender_new
      end
    end
  end
  
  # DELETE /polls/1
  def destroy
    @poll = Poll.find(params[:id])
    @poll.destroy

    respond_to do |format|
      format.html { redirect_to polls_url }
    end
  end

  # PUT /polls/1/close
  def close
    @poll = Poll.find(params[:id])
    @poll.close

    respond_to do |format|
      if @poll.save
        format.html { redirect_to polls_url }
      else
        format.html { redirect_to polls_url }
      end
    end
  end
  
private
  def rerender_new
    respond_to do |format|
      format.html { render action: "new" }
    end
  end

  #FIXME: delete?
  def reset_session
    session[:poll_params] = {}
  end
  
  #FIXME: delete?
  def setup_new_session
    session[:poll_params] ||= {}
  end
  
  def load_session_variables
    #FIXME: can we use params[:poll] instead?
    session[:poll_params].deep_merge!(params[:poll]) if params[:poll]

    @poll = Poll.new(session[:poll_params])
    @poll.questions_attributes = session[:poll_params][:questions_attributes] if session[:poll_params][:questions_attributes]
    @question = Question.new
  end
  
  def was_button_pressed?(button)
    params[button]
  end
end
