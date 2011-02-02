class WinesController < ApplicationController
  before_filter :authenticate_winery!, :except => [:rating, :index, :show]
  before_filter :verify_winery_subscription, :except => [:rating, :index, :show]
  before_filter :find_user_or_winery

  helper_method :sort_column, :sort_asc_or_desc
  
#  def ratecurrent_winery
#    @wine = Wine.find(params[:id])
#    @wine.rate(params[:stars], current_user, params[:dimension])
#    render :update do |page|
#      page.replace_html @wine.wrapper_dom_id(params), ratings_for(@wine, params.merge(:wrap => false))
#      page.visual_effect :highlight, @wine.wrapper_dom_id(params)
#      # Update Top Wines list with new result everytime user updates rating
#      @wines = Wine.all(:order => "rating_average DESC")
#      page.replace_html 'top_wines', :partial => 'home/top_wines',
#                                     :locals => {:top_wines=>@wines }   
#    end
#  end

  def rating
    rate ("Wine", params[:id], params[:stars])
    top_wines
  end

  def top_wines
    @wines = Wine.top_wines.all
    respond_to do |format|
      format.html { render :partial=>"shared/object_list", :locals => {:object_list => @wines, 
                                                                       :ordered_list => true, 
                                                                       :list_header => "Top 10 Wines" } }
      format.json { render :layout => false, :json => @wines }
#      format.js { render :layout => false, :wines => @wines }
    end
  end

  def index
    if current_winery
      @wines = current_winery.wines.paginate(:page => params[:page], :order => "created_at DESC")
    else  
      @wines = Wine.all.paginate(:page => params[:page], :order => "created_at DESC")
    end


    if request.xml_http_request?
      render :partial => "wines", :layout => false
    else
      respond_to do |format|
        format.html # index.html.erb
        format.js # index.js.erb
        format.mobile # index.mobile.erb
        format.json { render :layout => false, 
                             :json => @wines.to_json(:include => { :pictures => { :only => [:id, :photo_file_name] },
                                                                   :winery => {:only => :winery_name}  } )
                    }
      end
    end
    
  end

  def show
    @wine = Wine.find(params[:id], :include => :comments, :order => sort_column + " " + sort_asc_or_desc)
    @pic_idx = params[:pic_idx]||0
    respond_to do |format|
      format.mobile # show.mobile.erb
      format.html # index.html.erb
    end
    rescue Exception => exc
      logger.error("#{exc.message}")
      flash[:notice] = 'You are not authorized to view that wine.'
      redirect_to :action => "index"
  end

  def new
    @wine = Wine.new(:winery_id => current_winery.id)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @wine }
    end
  end

  # GET /wines/1/edit
  def edit
    @wine = current_winery.wines.find(params[:id])
  rescue Exception => exc
      logger.error("#{exc.message}")
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
        Juggernaut.publish("channel1", current_winery.winery_name.to_s + " added a new wine called " + @wine.name.to_s) rescue nil
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
  rescue Exception => exc
      logger.error("#{exc.message}")
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
  rescue Exception => exc
      logger.error("#{exc.message}")
      flash[:notice] = 'You are not authorized to delete that wine.'
      redirect_to :action => "index"
  end

  def delete
    @wine = current_winery.wines.find(params[:id])
    respond_to do |format|
      format.html # delete.html.erb
    end
  rescue Exception => exc
      logger.error("#{exc.message}")
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
  
  def find_user_or_winery
    @winery = Winery.find_by_id(params[:winery_id])
    @user = User.find_by_id(params[:user_id])
  end
end
