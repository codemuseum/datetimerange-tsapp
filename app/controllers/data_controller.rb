class DataController < ApplicationController

  def index
    logger.debug "GOT DATE TIME'S CONTROLLER (YAY!) PARAMS: #{params.inspect}."
    
    # @data = PageObject.find(:all, :conditions => { :urn => params[:from], :start_datetime => params[:options][:between].first })
    page_objects = PageObject.find(:all, :conditions => ['urn IN (?) AND starts_datetime >= ? AND starts_datetime <= ?', params[:from], params[:options][:between][0], params[:options][:between][1]], :order => "starts_datetime ASC, ends_datetime ASC")
    
    @data = Array.new
    page_objects.each do |po|
      @data << { :urn => po.urn, :start => po.starts_datetime, :end => po.ends_datetime }
    end
    
    respond_to do |format|
      format.xml  { render :xml => @data }
    end
  end
end
