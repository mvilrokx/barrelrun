class WineriesController < ApplicationController
#  before_filter :authenticate_winery!, :except => [:rating, :index, :show]

  def index
    if params[:search]
      @search = Winery.metasearch(params[:search])
      @wineries = @search.all
    else
      @wineries = Winery.cached_all
    end
    respond_to do |format|
      format.html
      format.json { render :layout => false, :json => @wineries }
#      format.json { render :layout => false,
#                           :json => @wineries.to_json(:include => { :pictures => { :only => [:id, :photo_file_name] } } )
#                  }
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
    @winery.credit_cards.build
#    @winery.build_subscription
#    ap @winery.credit_cards[0]
  end

  def create
    @winery = Winery.new(params[:winery])
    @winery.ownership_status = 'CLAIMED'
    if @winery.save
      ap @winery
      flash[:notice] = "Successfully created winery."
      redirect_to :credit_card
#      render :action => 'index'
    else
      render :action => 'new'
    end
    render :action => 'new'
  end

  def rating
    rate('Winery', params[:id], params[:stars])
    top_wineries
  end

  def top_wineries
    @wineries = Winery.top_wineries
    respond_to do |format|
      format.html { render :partial=>"shared/object_list", :locals => {:object_list => @wineries,
                                                                       :list_type => :ol,
                                                                       :map_it => true,
                                                                       :title => "Top Wineries" } }
      format.json { render :layout => false, :json => @wineries }
#      format.json { render :layout => false,
#                           :json => @wineries.to_json(:include => { :pictures => { :only => [:id, :photo_file_name] } } )
#                  }
      format.js
      format.mobile
    end
  end

end

