class EmailsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def incoming
    Juggernaut.publish("channel1", "text message from " + params[:sender] + ": " + params[:body]) rescue nil
    render :nothing => true
  end
end
