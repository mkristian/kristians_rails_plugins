# AuditLog
module Audit
  module ActionController #:nodoc:
    module Base #:nodoc:
      def self.included(base)  
        base.send(:include, InstanceMethods)
      end
      module InstanceMethods #:nodoc:
  
        private

        def audit_logger
          @logger ||= Logger.new
        end

        protected
  
        def log_message(msg, level = :info)
          audit_logger.send(level, "[#{current_user.nil? ? "???": current_user.login}] #{msg}")
        end
        
        def log_action(msg, level = :info)
          log_message("#{params[:action]} #{params[:controller]} #{msg}", level)
        end
        
        def log_exception(exception, level = :error)
          log_action("- #{exception.class.name}: #{exception}", level)
        end
        
        def log(message = "", resource = nil)
          if message.instance_of? StandardError
            log_exception(message)
          elsif resource.nil?
            log_action("#{message}")
          else      
            log_action(resource_to_s(message, resource))
          end
        end

        def resource_to_s(message, resource)
          "#{resource.class}(#{resource.id})" unless resource.new_record?
        end
        
      end
    end
  end

  class Logger
    
    def self.initialize(logger)
      @@logger = logger
    end

    def fatal(msg)
      @@logger.fatal(msg)
    end

    def error(msg)
      @@logger.error(msg)
    end

    def warn(msg)
      @@logger.warn(msg)
    end

    def info(msg)
      @@logger.info(msg)
    end

    def debug(msg)
      @@logger.debug(msg)
    end
  end

end
