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

  # POST /polls
  def create
    load_session_variables(must_split_last?)

    if params[:cancel_button]
      reset_session

      respond_to do |format|
        format.html { redirect_to @poll }
      end
    elsif params[:new_question_button]
      if @question.valid?
        @poll.questions << @question
        @question = Question.new
      end

      rerender_new
    #FIXME: process remove request
    else #params[:publish_button]
      if @poll.save
        reset_session

        respond_to do |format|
          format.html { redirect_to @poll, notice: 'Poll was successfully created.' }
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
        format.html { redirect_to polls_url, notice: 'Poll was successfully closed.' }
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

  def reset_session
    session[:poll_params] = {}
  end
  
  def setup_new_session
    session[:poll_params] ||= {}
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
    @poll.questions = questions.compact.collect { |q| Question.new(q) }
  end
  
  def must_split_last?
    !params[:new_question_button].nil? || !params[:publish_button].nil?
  end
end
