module ActionController #:nodoc:
 
  class ReferrerMismatchError < RuntimeError
    def initialize(*args)
      super(*args)
    end
  end

  module ReferrerCheck
    
    def check_referrer_mode(mode)
      @strict = mode.to_s == "strict"
    end

    def check_referrer
      @strict = false if @strict.nil?

      # strict => referrer header MUST be present and match the host
      # !strict => no referrer present or if present it MUST match the host
      referrer = request.env["HTTP_REFERER"]
  
      referrer_host = referrer.sub(/https?:\/\//, "").sub(/[:\/].*/,"") unless referrer.nil?
      local_host = request.host.sub(/https?:\/\//, "").sub(/[:\/].*/,"")
      if @strict 
        if(referrer.nil? or referrer_host != local_host)
          throw ReferrerMismatchError.new("host '#{request.host}' received a request from alien url '#{referrer}'")        
        end
      else
        if !referrer.nil? and referrer_host != local_host
            throw ReferrerMismatchError.new("host '#{request.host}' received a request from alien url '#{referrer}'")
        end
      end
      true
    end
  end

end
