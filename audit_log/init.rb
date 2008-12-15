require 'audit_log'
ActionController::Base.send(:include, Audit::ActionController::Base)
