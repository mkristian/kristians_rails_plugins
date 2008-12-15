require File.join(File.dirname(__FILE__), 'lib/referrer_check') 

ActionController::Base.class_eval do
  include ActionController::ReferrerCheck
end
