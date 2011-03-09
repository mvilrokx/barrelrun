class CommentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:index]

  def index  
    @commentable = find_commentable
    @comments = @commentable.comments.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml
      format.js
      format.mobile
      format.json { render :layout => false, :json => @comments }
    end
  end  

  def create
    @commentable = find_commentable  
    @comment = @commentable.comments.build(params[:comment])
    @comment.user = current_user
    if @comment.save
      flash[:notice] = "Successfully saved comment."  
      Juggernaut.publish("channel1", @comment.user.username + " commented on " + @commentable.name + " ("+ @commentable.class.name + "): '" + @comment.content + "'") rescue nil
    #     redirect_to :id => nil
#      redirect_to root_url
    else
      flash[:notice] = "Could not save comment, please try again later."  
#      render :action => 'new'
    end
  end

  def find_commentable  
    params.each do |name, value|  
       if name =~ /(.+)_id$/  
          return $1.classify.constantize.find(value)  
       end  
    end  
    nil  
  end  

end
