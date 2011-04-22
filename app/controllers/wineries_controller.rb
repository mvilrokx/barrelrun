class WineriesController < ApplicationController
#  before_filter :authenticate_winery!, :except => [:rating, :index, :show]

  def index
    @search = Winery.searchlogic(params[:search])
    @wineries = @search.all
    respond_to do |format|
      format.html
      format.json  { render :layout => false, :json => @wineries }
      format.mobile
    end
  end

  def show
    @winery = Winery.find(params[:id])
    
    respond_to do |format|
      format.html
      format.xml { render :xml => @winery }
      format.mobile
    end
  end

  def new
    @winery = Winery.new
  end

  def create
    @winery = Winery.new(params[:winery])
    @winery.ownership_status = 'WINERY'
    if @winery.save
      flash[:notice] = "Successfully created winery."
#      render :action => 'index'
    end    
    render :action => 'new'
  end


  def rating
    rate('Winery', params[:id], params[:stars])
    top_wineries
  end

  def top_wineries
    @wineries = Winery.top_wineries.all
    respond_to do |format|
      format.html { render :partial=>"shared/object_list", :locals => {:object_list => @wineries, 
                                                                       :ordered_list => true, 
                                                                       :list_header => "Top 10 Wineries" } }
      format.json { render :layout => false, :json => @wineries }
      format.js
    end
  end

end
