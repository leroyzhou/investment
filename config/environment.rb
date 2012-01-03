# Load the rails application
require File.expand_path('../application', __FILE__)
puts File.dirname(__FILE__)
# Initialize the rails application
Investment::Application.initialize!

require File.expand_path('../../lib/lei/init', __FILE__)#File.dirname(__FILE__)+'/../lib/lei/init'



