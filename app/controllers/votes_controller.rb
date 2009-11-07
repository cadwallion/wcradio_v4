class VotesController < ApplicationController
  def index
    @previous_vote = Vote.find(:first, :conditions => {:voter_ip => request.env['REMOTE_ADDR']})
  end
  
  def new
    @vote = Vote.new
    @previous_vote = Vote.find(:first, :conditions => {:voter_ip => request.env['REMOTE_ADDR']})
  end
  
  def create
    @vote = Vote.new(params[:vote])
    @vote.voter_ip = request.env['REMOTE_ADDR']
    if @vote.save
      flash[:notice] = "Successfully created vote."
      redirect_to votes_url
    else
      render :action => 'new'
    end
  end
end
