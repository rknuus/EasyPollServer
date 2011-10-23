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
    session[:poll_params] ||= {}
    @poll = Poll.new(session[:poll_params])
    @poll.current_step = session[:poll_step]

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
    session[:poll_params].deep_merge!(params[:poll]) if params[:poll]
    @poll = Poll.new(session[:poll_params])
    @poll.current_step = session[:poll_step]

    if params[:continue_button]
      @poll.next_step
      show_wizard
    elsif params[:back_button]
      @poll.previous_step
      show_wizard
    elsif params[:new_question_button]
      @poll.next_step
      show_wizard
    elsif params[:create_question_button]
      @poll.previous_step
      show_wizard
    elsif params[:cancel_button]
      @poll.previous_step
      show_wizard
    else #params[:publish_button]
      if @poll.save
        respond_to do |format|
          format.html { redirect_to @poll, notice: 'Poll was successfully created.' }
        end
      else
        show_wizard
      end
    end
  end
  
  def show_wizard
    session[:poll_step] = @poll.current_step
    
    respond_to do |format|
      format.html { render action: "new" }
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
end
