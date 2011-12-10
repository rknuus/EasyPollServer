class PollsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  
  # GET /polls
  def index
    reset_session
    @all_active_polls = Poll.get_all_active_polls
    @my_active_polls = Poll.get_my_active_polls(current_user)
    @my_closed_polls = Poll.get_my_closed_polls(current_user)

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
      
      # puts "Params before delete"
      # puts params
      # destroy_options_if_required
      # puts "Params after delete"
      # puts params
      # load_session_variables
      # puts "Params after load_session_variables"
      # puts params
      
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

  # PUT /polls/1/answer
  def answer
    @poll = Poll.find(params[:id])

    respond_to do |format|
      format.html # answer.html.erb
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
    params[:poll] = {}
  end
  
  #FIXME: delete?
  def setup_new_session
    session[:poll_params] ||= {}
    params[:poll] ||= {}
  end
  
  def load_session_variables
    #FIXME: can we use params[:poll] instead?
    session[:poll_params].deep_merge!(params[:poll]) if params[:poll]
    @poll = Poll.new(session[:poll_params])
    @poll.questions_attributes = session[:poll_params][:questions_attributes] if session[:poll_params][:questions_attributes]
    @poll.questions.each_with_index do |question, i|
      question.options = []
      question.options_attributes = params[:poll][:questions_attributes][i.to_s][:options_attributes] if params[:poll][:questions_attributes] && params[:poll][:questions_attributes][i.to_s][:options_attributes]
      # @poll.questions[i] = question
    end
    @question = Question.new
  end
  
  # def destroy_options_if_required
  #   params[:poll][:questions_attributes].each_with_index do |dummy_i, i|
  #     if !params[:poll][:questions_attributes][i.to_s][:_destroy].nil? && params[:poll][:questions_attributes][i.to_s][:_destroy] == "1"
  #       params[:poll][:questions_attributes].delete :i
  #     end
  #   end
  #   session[:poll_params].deep_merge!(params[:poll]) if params[:poll]
  # end
  
  def was_button_pressed?(button)
    params[button]
  end
end
