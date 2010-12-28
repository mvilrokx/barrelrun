class WinesController < ApplicationController
#  before_filter :authenticate_winery!, :except => [:rate, :all_wines]

  helper_method :sort_column, :sort_asc_or_desc
  
  def rate
    @wine = Wine.find(params[:id])
    @wine.rate(params[:stars], current_user, params[:dimension])
    render :update do |page|
      page.replace_html @wine.wrapper_dom_id(params), ratings_for(@wine, params.merge(:wrap => false))
      page.visual_effect :highlight, @wine.wrapper_dom_id(params)
      # Update Top Wines list with new result everytime user updates rating
      @wines = Wine.all(:order => "rating_average DESC")
      page.replace_html 'top_wines', :partial => 'home/top_wines',
                                     :locals => {:top_wines=>@wines }   
    end
  end

  def rating
    @wine = Wine.find(params[:id])
    @user_rating = @wine.ratings.find_or_initialize_by_user_id(current_user.id)
    @user_rating.rate = params[:stars]
    if @user_rating.save
      flash[:notice] = "Successfully saved your rating."
    end
    @wines = Wine.top_wines.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml
      format.js
    end
   
  end

  # GET /wines
  # GET /wines.xml
  def index
    if  current_winery
      @wines = current_winery.wines.paginate(:page => params[:page], :order => "created_at DESC")
    else  
      @wines = Wine.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @wines }
      format.js
      format.mobile # show.mobile.erb
#      format.json  { render :layout => false, :json => @wines }
      format.json  { render :layout => false, 
                            :json => @wines.to_json(:include => { :pictures => { :only => [:id, :photo_file_name] },
                                                                  :winery => {:only => :winery_name} 
                                                                }
                                                    ) 
                   }
    end
  end

  # GET /wines/1
  # GET /wines/1.xml
  def show
    @wine = Wine.find(params[:id], :include => :comments, :order => sort_column + " " + sort_asc_or_desc)
    
    respond_to do |format|
      format.mobile # show.mobile.erb
      format.html # index.html.erb
    end
    rescue
      flash[:notice] = 'You are not authorized to view that wine.'
      redirect_to :action => "index"
  end

  # GET /wines/new
  # GET /wines/new.xml
  def new
    @wine = Wine.new(:winery_id => current_winery.id)
#    1.times {@wine.pictures.build}
#    @wine.winery = current_winery

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @wine }
    end
  end

  # GET /wines/1/edit
  def edit
    @wine = current_winery.wines.find(params[:id])
#    3.times {@wine.pictures.build}
  rescue
      flash[:notice] = 'You are not authorized to edit that wine.'
      redirect_to :action => "index"
  end

  # POST /wines
  # POST /wines.xml
  def create
    @wine = Wine.new(params[:wine])
    @wine.winery = current_winery

    respond_to do |format|
      if @wine.save
        flash[:notice] = 'Wine was successfully created.'
        format.html {redirect_to wines_url}
        format.xml  { render :xml => @wine, :status => :created, :location => @wine }
        Juggernaut.publish("channel1", current_winery.winery_name.to_s + " added a new wine called " + @wine.name.to_s)
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @wine.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /wines/1
  # PUT /wines/1.xml
  def update
    @wine = Wine.find(params[:id])

    respond_to do |format|
      if @wine.update_attributes(params[:wine])
        flash[:notice] = 'Wine was successfully updated.'
        format.html { redirect_to wines_url }
        format.xml  { head :ok }
    else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @wine.errors, :status => :unprocessable_entity }
      end
    end
  rescue
      flash[:notice] = 'You are not authorized to update that wine.'
      redirect_to :action => "index"
  end

  # DELETE /wines/1
  # DELETE /wines/1.xml
  def destroy
    @wine = current_winery.wines.find(params[:id])
    redirect_to(wines_url) and return if params[:cancel]
    @wine.destroy

    respond_to do |format|
      flash[:notice] = 'Wine was successfully deleted.'
      format.html { redirect_to(wines_url) }
      format.xml  { head :ok }
    end
  rescue
      flash[:notice] = 'You are not authorized to delete that wine.'
      redirect_to :action => "index"
  end

  def delete
    @wine = current_winery.wines.find(params[:id])
    respond_to do |format|
      format.html # delete.html.erb
    end
  rescue
      flash[:notice] = 'You are not authorized to delete that wine.'
      redirect_to :action => "index"
  end
  
  def distinct_varietals
#    @distinct_varietals = Wine.connection.select_values('select distinct(varietal) from wines')
        
    @varietals = Wine.distinct_varietals.all(:conditions => ["varietal like ?","%#{params[:term]}%"])
    @varietals_hash = []
    @varietals.each do |varietal|
      @varietals_hash << {"label" => varietal.varietal}
    end
    render :json => @varietals_hash
  end

  def distinct_wine_types
    @wine_types = Wine.distinct_wine_types.all(:conditions => ["wine_type like ?","%#{params[:term]}%"])
    @wine_types_hash = []
    @wine_types.each do |wine_type|
      @wine_types_hash << {"label" => wine_type.wine_type}
    end
    render :json => @wine_types_hash
  end

  private

  def sort_column
    %w[comments.created_at comments.average_rating].include?(params[:sort]) ? params[:sort] : "comments.created_at"
  end
  
  def sort_asc_or_desc
    %w[asc desc].include?(params[:asc_or_desc]) ? params[:asc_or_desc] : "desc"
  end
end
