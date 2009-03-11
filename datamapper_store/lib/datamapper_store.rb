require 'dm-core'
if RAILS_GEM_VERSION >= '2.3.0'
  require File.expand_path(File.dirname(__FILE__) + '/action_controller/session/datamapper_store')
else
  require File.expand_path(File.dirname(__FILE__) + '/cgi/session/datamapper_store')
end
