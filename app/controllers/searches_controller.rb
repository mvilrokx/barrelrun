class SearchesController < ApplicationController
  include Geokit::Geocoders
  before_filter :prep_conditions
  require 'ap'
  
  PER_PAGE = 10
  MILES = 25

  def search
    @search_results = ThinkingSphinx.search(
      params[:search],
      :star => true,
      :page => params[:page],
      :per_page => PER_PAGE,
      :with => @with_params,
      :geo => @geo, :latitude_attr => "latitude", :longitude_attr => "longitude",
      :order => @order + "@relevance DESC"
    )
    facets
    if request.xml_http_request?
          	puts "1 block"
    	respond_to do |format|
      	format.html   {render :partial => "search_results", :layout => false}
      	format.mobile {render :all_objects, :layout => false}
      end     
    else
          	puts "2 block"
      respond_to do |format|
      	format.html {render :all_objects}
      	format.mobile {render :all_objects, :layout => false}
      end
    end
  end

  def faceted_search
    @search_results = ThinkingSphinx.search(
      params[:search],
      :star => true,
      :page => params[:page], 
      :per_page => PER_PAGE,
      :with => @with_params,
      :classes => @classes,
#	    :conditions => condition_params,
      :geo => @geo, :latitude_attr => "latitude", :longitude_attr => "longitude",
      :order => @order + "@relevance DESC"
    )
    facets
    if request.xml_http_request?
          	puts "3 block"
    	respond_to do |format|
      	format.html {render :partial => "search_results", :layout => false}
      	format.mobile {render :all_objects, :layout => false}
      end  
    else
          	puts "4 block"
    	respond_to do |format|
      	format.html {render :all_objects}
				format.mobile {render :all_objects, :layout => false}
      end  
    end
  end

  def facets
    if params[:nearby].blank?
      @facets = ThinkingSphinx.facets(
        params[:search],
        :star => true,
        :all_facets => true,
        :class_facet => false
      )
    else
      @facets = ThinkingSphinx.facets(
        params[:search],
        :star => true,
        :with => {"@geodist" => @with_params["@geodist"]},
        :geo => @geo, :latitude_attr => "latitude", :longitude_attr => "longitude",
        :all_facets => true,
        :class_facet => false
      )
    end
    
  end

  private
    def prep_conditions
      ap params
      @order = ""
      @with_params = {}
      @classes = []
      if !params[:nearby].blank?
        res=MultiGeocoder.geocode(params[:nearby])
        @geo=[(res.lat/360)*Math::PI*2, (res.lng/360)*Math::PI*2]
        # 1_000.0 = 1000 meters = 1km
        if params[:distance].blank?
          params[:distance] = MILES
        end
        @with_params["@geodist"] = 0.0..params[:distance].to_f.miles.to.meters.to_f
        @order = "@geodist ASC, "
      end
      
      @with_params[:price] = params[:min_price][/\d.+/].to_f..params[:max_price][/\d.+/].to_f if params[:min_price] && params[:max_price]
      
      @with_params[:vintage] = params[:vintage] if params[:vintage]
      @with_params[:varietal_facet] = params[:varietal].collect {|x| x.to_crc32} if params[:varietal]
      @with_params[:wine_type_facet] = params[:wine_type].collect {|x| x.to_crc32} if params[:wine_type]
      @with_params[:average_rating] = params[:average_rating] if params[:average_rating]
      @classes = [Wine] if params[:wine_type] || params[:vintage] || params[:varietal] || params[:min_price] || params[:max_price]
      
      ap @with_params
    end
end
