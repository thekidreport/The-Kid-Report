class FeedbacksController < ApplicationController

	def new
    @feedback = Feedback.new
	  session[:feedback_redirect_url] = request.referer
    @feedback.referrer = session[:feedback_redirect_url]
  end


	def create
    @feedback = Feedback.new(params[:feedback])
    if params[:commit] != 'Cancel'
      @feedback.attributes = {:subject => @feedback.body[0,40], :referrer => session[:feedback_redirect_url], :browser => request.env['HTTP_USER_AGENT'], :user => current_user }
    	if @feedback.save
    	  Mailer::site_feedback(@feedback).deliver
    	  flash[:notice] = 'Thanks for your feedback'
    	  redirect_to session[:feedback_redirect_url]
    	  return false
    	else
    	  render :action => :new
    	  return false
  	  end
	  else  
  	  redirect_to session[:feedback_redirect_url]
  	  return false
    end
  end

end