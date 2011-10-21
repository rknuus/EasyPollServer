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
  #FIXME: delete
  def edit
    @poll = Poll.find(params[:id])
  end

  # POST /polls
  def create
    #debugger
    session[:poll_params].deep_merge!(params[:poll]) if params[:poll]
    @poll = Poll.new(session[:poll_params])
    @poll.current_step = session[:poll_step]
    if params[:back_button]
      @poll.previous_step
    elsif params[:publish_button]
      @poll.save
    else
      @poll.next_step
    end
    session[:poll_step] = @poll.current_step
    
    respond_to do |format|
      if @poll.new_record?
        format.html { render action: "new" }
      else
        session[:poll_step] = session[:poll_params] = nil
        format.html { redirect_to @poll, notice: 'Poll was successfully created.' }
      end
    end
  end

  # PUT /polls/1
  #FIXME: delete
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
