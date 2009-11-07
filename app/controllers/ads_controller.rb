class AdsController < ApplicationController
	def new
		@ad = Ad.new
	end
	
	def create
		@ad = Ad.new(params[:ad])
		if simple_captcha_valid?
			if @ad.save
				flash[:notice] = "Advertisement Reported!"
				redirect_to ads_path
			else
				render :action => "new"
			end
		else
			flash[:error] = "Sorry, but the code was incorrect."
			render :action => "new"
		end
	end
	
	def index
		# stub
	end
	
  def list
    page = params[:page] || 1
	  @ads = Ad.paginate(:page => page)
	end
end
