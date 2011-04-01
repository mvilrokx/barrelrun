class SearchesController < ApplicationController
  include Geokit::Geocoders
require 'ap'

  def all_objects
    with_params = params.select{|k,v| k=='vintage'||k=='average_rating'}
    with_params = Hash[*with_params.flatten]
    condition_params = params.select{|k,v| k=='winery_name'||k=='wine_name'||k=='wine_description'||k=='name'||k=='description'||k=='varietal'||k=='wine_type'}
    condition_params = Hash[*condition_params.flatten]
    if !params[:nearby].blank?
      res=MultiGeocoder.geocode(params[:nearby])
      geo=[(res.lat/360)*Math::PI*2, (res.lng/360)*Math::PI*2]
      # 1_000.0 = 1km
      with_params["@geodist"] = 0.0..10.miles.to.meters.to_f
    end
ap with_params
ap condition_params
ap params

    if params[:class] then
	    @search_results = ThinkingSphinx.search(
		    params[:search],
		    :star => true,
		    :page => params[:page], 
		    :per_page => 10,
		    :with => with_params,
		    :conditions => condition_params,
		    :classes => [params[:class].classify.constantize],
        :geo => geo, :latitude_attr => "latitude", :longitude_attr => "longitude",
        :order => "@geodist ASC, @relevance DESC"
	    )
ap @search_results
      @search_result_facets = ThinkingSphinx.facets(
    		params[:search],
		    :star => true,
		    :page => params[:page], 
		    :per_page => 10,
		    :with => with_params,
		    :conditions => condition_params,
		    :classes => [params[:class].classify.constantize],
        :geo => geo, :latitude_attr => "latitude", :longitude_attr => "longitude",
        :order => "@geodist ASC, @relevance DESC"
	    )
  	else
	    @search_results = ThinkingSphinx.search(
		    params[:search],
		    :star => true,
		    :page => params[:page], 
		    :per_page => 10,
		    :with => with_params,
		    :conditions => condition_params,
        :geo => geo, :latitude_attr => "latitude", :longitude_attr => "longitude"
#        :order => "@geodist ASC, @relevance DESC"
	    )
      @search_result_facets = ThinkingSphinx.facets(
		    params[:search],
		    :star => true,
		    :page => params[:page], 
		    :per_page => 10,
		    :with => with_params,
		    :conditions => condition_params,
        :geo => geo, :latitude_attr => "latitude", :longitude_attr => "longitude",
        :order => "@geodist ASC, @relevance DESC"
	    )
p @search_results
    end	
  end

end
