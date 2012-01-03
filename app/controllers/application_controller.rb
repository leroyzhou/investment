require File.dirname(__FILE__)+'/../../lib/lei/init'

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :init_view_params
  
  
  def init_view_params
    @v = {}
  end
end
