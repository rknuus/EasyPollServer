class PollsController < ApplicationController
  # GET /polls
  def index
    @active_polls = Poll.find(:all, :conditions => 'closed_at IS NULL')
    @closed_polls = Poll.find(:all, :conditions => 'closed_at IS NOT NULL')

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /polls/1
  def show
    @poll = Poll.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
    end
  end

  # GET /polls/new
  def new
    setup_new_session
    load_session_variables(false)

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /polls/1/edit
  def edit
    @poll = Poll.find(params[:id])
  end

  # POST /polls
  def create
    load_session_variables(must_split_last?)

    if params[:continue_button]
      @poll.next_step
      show_wizard
    elsif params[:back_button] || params[:cancel_button]
      @poll.previous_step
      show_wizard
    elsif params[:new_question_button]
      @poll.questions << @question
      @question = Question.new
      show_wizard
    else #params[:publish_button]
      @poll.questions << @question
      if @poll.save
        reset_session

        respond_to do |format|
          format.html { redirect_to @poll, notice: 'Poll was successfully created.' }
        end
      else
        show_wizard
      end
    end
  end
    
  # PUT /polls/1
  def update
    @poll = Poll.find(params[:id])

    respond_to do |format|
      if @poll.update_attributes(params[:poll])
        format.html { redirect_to @poll, notice: 'Poll was successfully updated.' }
      else
        format.html { render action: "edit" }
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
        format.html { redirect_to polls_url, notice: 'Poll was successfully closed.' }
      else
        format.html { redirect_to polls_url }
      end
    end
  end
private
  def show_wizard
    session[:poll_step] = @poll.current_step
    session[:new_question] = @question  #FIXME: can we avoid new_question?
  
    respond_to do |format|
      format.html { render action: "new" }
    end
  end
  
  def reset_session
    session[:poll_params] = {}
    session[:new_question] = Question.new
    @poll = Poll.new
  end
  
  def setup_new_session
    session[:poll_params] ||= {}
    session[:new_question] ||= Question.new
  end
  
  def load_session_variables(split_last)
    session[:poll_params].deep_merge!(params[:poll]) if params[:poll]

    questions = []
    questions = session[:poll_params]['questions_attributes'].values if session[:poll_params]['questions_attributes']
    @question = Question.new
    if split_last
      @question = Question.new(questions.pop)
    end

    @poll = Poll.new(session[:poll_params])
    @poll.current_step = session[:poll_step]
    @poll.questions = questions.compact.collect { |q| Question.new(q) }
  end
  
  def must_split_last?
    !params[:new_question_button].nil? || !params[:publish_button].nil?
  end
end
