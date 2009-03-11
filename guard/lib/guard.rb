module Guard
  module ActionController #:nodoc:
    module Base #:nodoc:
      def self.included(base)  
        #base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
      end
      module InstanceMethods #:nodoc:
        
        protected
        
        def guard
          unless current_user.nil? or ::Guard::Guard.check(params[:controller], params[:action], current_user.roles)
            u = current_user
            throw ::Guard::PermissionDenied.new("permission denied for {#{u.roles.each{|r| r.name}.join ',' }} on #{params[:controller]}##{params[:action]}")
          end
          return true
        end
      end
    end
  end

  module ActionView #:nodoc:
    module Base #:nodoc:
      # Inclusion hook to make #allowed
      # available as ActionView helper methods.
      def self.included(base)
        base.send(:include, InstanceMethods)
      end
      
      module InstanceMethods #:nodoc:
        def allowed(controller, action)
          current = helpers.controller.send(:current_user)
          ::Guard::Guard.check(controller, action, current.nil? ? [] : current.roles)
        end
      end
    end
  end

  class Guard
    
    @@map = {}

    def self.load(logger = Logger(STDOUT), superuser = :root, guard_dir = "#{RAILS_ROOT}/app/guards")
      @@logger = logger
      @@superuser = superuser
      Dir.new(guard_dir).to_a.each do |f|
        if f.match(".rb$")
          require(guard_dir + "/" + f)
        end
      end
    end
    
    def self.initialize(controller, map)
      msg = map.collect{ |k,v| "\n\t#{k} => [#{v.join(',')}]"}
      @@logger.info("#{controller} guard: #{msg}")
      @@map[controller] = map
    end
    
    def self.check(controller, action, roles)
      controller = controller.to_sym
      if (@@map.key? controller)
        action = action.to_sym
        allowed = @@map[controller][action]
        if (allowed.nil?)
          throw GuardException.new("GuardException: unknown action #{action} for controller #{controller}")
        else
          allowed << @@superuser
          for role in roles
            if allowed.member? role.name.to_sym
              return true
            end
          end
          return false
        end
      else
        @@logger.warn("Guard: unknown controller #{controller}")
        throw GuardException.new("GuardException: unknown controller #{controller}")
      end
    end
  end

  class GuardException < Exception; end
  class PermissionDenied < GuardException; end
end

ActionController::Base.send(:include, Guard::ActionController::Base)
ActionView::Base.send(:include, Guard::ActionView::Base)

module Erector
  class Widget
    def allowed(controller, action)
      if helpers.controller.respond_to? :current_user
        # send bypasses the protected check of a method
        current = helpers.controller.send(:current_user)
        Guard::Guard.check(controller, action, current.nil? ? []: current.roles)
      else 
        true
      end
    end
  end
end
