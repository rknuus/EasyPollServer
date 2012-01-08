class PollsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]
  
  # GET /polls
  def index
    reset_session
    @all_open_polls = Poll.get_all_active_polls
    @all_unanswered_polls = Array.new
    @all_answered_polls = Array.new
    if !current_user.nil?
      @all_unanswered_polls = Poll.get_all_active_unanswered_polls(current_user)
      @all_answered_polls = Poll.get_all_answered_polls(current_user)
    end
    @my_active_polls = Poll.get_my_active_polls(current_user)
    @my_closed_polls = Poll.get_my_closed_polls(current_user)

    respond_to do |format|
      format.html # index.html.erb
      format.xml
    end
  end
  
  # GET /polls/1
  def show
    if params[:id] == "index_unanswered"
      @all_unanswered_polls = Array.new
      if !current_user.nil?
        @all_unanswered_polls = Poll.get_all_active_unanswered_polls(current_user)
      end

      respond_to do |format|
        format.xml { render :action => "index_unanswered.xml.builder" }
      end
      
    elsif params[:id] == "index_answered"
      @all_answered_polls = Array.new
      if !current_user.nil?
        @all_answered_polls = Poll.get_all_answered_polls(current_user)
      end

      respond_to do |format|
        format.xml { render :action => "index_answered.xml.builder" }
      end
      
    else
      @poll = nil
      @poll = Poll.find(params[:id]) if Poll.exists?(params[:id])
      respond_to do |format|
        format.xml
      end
    end
  end
  
  # GET /polls/1/show_results
  def show_results
    @poll_result = nil
    @poll_result = Poll.find(params[:id]) if Poll.exists?(params[:id])
    respond_to do |format|
      format.html
      format.xml
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
    
    if was_button_pressed?(:delete_question)
      questions_to_delete = Array.new
      params[:delete_question].each do |delete_param|
        questions_to_delete.push( delete_param[0].to_i )
      end
      questions_to_delete.reverse.each do |q|
        @poll.questions.delete_at(q)
      end
    end
    
    @question = @poll.questions.pop || Question.new
    
    if was_button_pressed?(:cancel_button)
      reset_session
      respond_to do |format|
        format.html { redirect_to polls_url }
      end
      
    elsif was_button_pressed?(:new_question_button)
      if question_valid?
        @poll.questions << @question
      end
      @question = Question.new
      rerender_new

    elsif was_button_pressed?(:update_button)
      rerender_new

    else #was_button_pressed?(:publish_button)
      if poll_valid?
        if @poll.save
          reset_session
          respond_to do |format|
            format.html { redirect_to polls_url, notice: 'Poll was successfully created.' }
          end
        else
          rerender_new
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
      question.options_attributes = params[:poll][:questions_attributes][i.to_s][:options_attributes] if params[:poll][:questions_attributes] && params[:poll][:questions_attributes][i.to_s] && params[:poll][:questions_attributes][i.to_s][:options_attributes]
      # @poll.questions[i] = question
    end
    
    @question = Question.new
  end

  def was_button_pressed?(button)
    params[button]
  end
  
  def poll_valid?
    poll_validity = false
    if @poll.valid?
      valid_questions_count = 0
      @poll.questions.each do |question|
        valid_option_count = 0
        question.options.each do |option|
          valid_option_count += 1 if !option.text.blank?
        end
        valid_questions_count += 1 if question.valid? && valid_option_count > 1
      end
      poll_validity = true if valid_questions_count == @poll.questions.size
    end
    poll_validity
  end
  
  def question_valid?
    valid_option_count = 0
    @question.options.each do |option|
      valid_option_count += 1 if !option.text.blank?
    end
    @question.valid? && valid_option_count > 1
  end
end
