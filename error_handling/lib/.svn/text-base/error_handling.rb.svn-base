module ErrorHandling

  def rescue_action_locally(exception)
    # use usual error pages for development 
    if consider_all_requests_local
      super
    elsif exception.class == ActionView::TemplateError
      # TODO maybe there is a better way
      super
    else
      dispatch_exception(exception)
    end
  end
  
  def rescue_action_in_public(exception)
    dispatch_exception(exception)
  end

  def unknown_exception
    render :text => "unknown exception: #{@exception.class} (#{@exception.message}):<br />" +
              clean_backtrace(@exception).join("<br />    ")
  end

  def dump_error
    log_error(@exception)
  end

  def dump_header(logger, header)
    logger.error("\n===================================================================\n#{header}\n===================================================================\n");
  end

  def dump_environment(logger, exception)
    dump_header(logger, "REQUEST DUMP");
    dump_hashmap(logger, request.env)
    
    dump_header(logger, "RESPONSE DUMP");
    dump_hashmap(logger, response.headers)
    
    dump_header(logger, "SESSION DUMP");
    dump_hashmap(logger, session.instance_variable_get("@data"))
    
    dump_header(logger, "PARAMETER DUMP");
    map = {}
    dump_hashmap(logger, params.each{ |k,v| map[k]=v })
    
    dump_header(logger, "EXCEPTION");
    logger.error("#{exception.class}:#{exception.message}")
    logger.error("\t" + exception.backtrace.join("\n\t"))
  end

  private 
  def dump_hashmap(logger, map)
    for key,value in map
      logger.error("\t#{key} => #{value}")
    end
  end

  def dispatch_exception(exception)
    @exception = exception
    dump_error
    exp = exception.class.name.underscore.gsub(/\//, "_")
    if respond_to? exp
      send(exp) 
    else
      unknown_exception
    end
  end

end
