class PagesController < ApplicationController
  def biz_terms_of_service
    if request.xhr?
      render :layout => false
    end
  end

  def user_terms_of_service
    if request.xhr?
      render :layout => false
    end
  end

  def privacy
    if request.xhr?
      render :layout => false
    end
  end
end
