# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :prepare_for_mobile, :set_subscription
  after_filter :flash_to_headers

  def verify_winery_subscription
    unless session[:subscription] == 1
      flash[:alert]  = "You have not chosen a subscription level yet."
      redirect_to subscriptions_path
    end
  end
  
  private
  
    def mobile_devise?
      if session[:mobile_param]
        session[:mobile_param] == "1"
      else
        request.user_agent =~ /Mobile|webOS/
      end
    end
    helper_method :mobile_devise?
    
    def prepare_for_mobile
      session[:mobile_param] = params[:mobile] if params[:mobile]
      request.format = :mobile if mobile_devise?
    end
    
    def set_subscription
      if winery_signed_in?
        if session[:subscription].blank?
          if Subscription.exists?(:winery_id => current_winery.id)
            session[:subscription] = 1
          else
            session[:subscription] = 0
          end
        end
      end
    end

    def rate (object_type, id, rating)
      object = object_type.classify.constantize.find(id)
      user_rating = object.ratings.find_or_initialize_by_user_id(current_user.id)
      user_rating.rate = rating
      if user_rating.save
        flash[:notice] = "Successfully saved your " + object_type + " rating."
      end
    end

    def flash_to_headers
      return unless request.xhr?
#      response.headers['X-Message'] = flash[:error]  unless flash[:error].blank?
      response.headers['X-Message'] = flash[:notice]  unless flash[:notice].blank?
      # repeat for other flash types...

      flash.discard  # don't want the flash to appear when you reload page
    end

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
end
