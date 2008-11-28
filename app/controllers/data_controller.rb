class DataController < ApplicationController
  PER_PAGE = 50

  def index
    logger.debug "GOT DATE TIME'S CONTROLLER (YAY!) PARAMS: #{params.inspect}."
    
    page_count_hash = {}
    # A few different options for searching for data
    if params[:options] && params[:options][:conditions] && params[:options][:conditions][:start]
      # Time Range
      if params[:options][:conditions][:start].is_a?(Array)
        page_objects = PageObject.find(:all, :conditions => ['urn IN (?) AND starts_datetime >= ? AND starts_datetime <= ?', 
          params[:from], params[:options][:conditions][:start][0], params[:options][:conditions][:start][1]], 
          :order => "starts_datetime ASC, ends_datetime ASC")

      # Specific page (50 events to a page)
      elsif params[:options][:conditions][:start][:page]
        page_count_hash[:page_count] = (params[:from].size / 50) + 1
        current_page = params[:options][:conditions][:start][:page].to_i
        current_page = 1 if current_page < 1
        
        page_objects = PageObject.find(:all, :conditions => {:urn => params[:from]}, 
          :offset => (current_page - 1) * PER_PAGE, :limit => PER_PAGE, 
          :order => "starts_datetime DESC, ends_datetime ASC")
        
      end
    end
    
    # Find everything (no options)
    if !page_objects
      page_objects = PageObject.find(:all, :conditions => {:urn => params[:from]}, :order => "starts_datetime ASC, ends_datetime ASC")
    end
    
    @data = page_objects.map { |po| { :urn => po.urn, :start => po.starts_datetime, :end => po.ends_datetime }.merge(page_count_hash) }
    respond_to do |format|
      format.xml  { render :xml => @data }
    end
  end
end
