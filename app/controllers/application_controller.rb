require File.dirname(__FILE__)+'/../../lib/lei/init'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :init_view_params, :set_time_zone
  
  
  def init_view_params
    @v = {}
  end
  
  def set_time_zone
    Time.zone = "Beijing"
  end
end
