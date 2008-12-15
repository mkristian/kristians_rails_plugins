module CacheHeaders

  # Date: <ServercurrentDate>
  # Expires: Fri, 01 Jan 1990 00:00:00 GMT
  # Pragma: no-cache
  # Cache-control: no-cache, must-revalidate
  def no_caching(no_store = true)
    #TODO assert input
    response.headers["Date"] = timestamp
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    response.headers["Pragma"] = "no-cache"
    response.headers["Cache-Control"] = "no-cache, must-revalidate" + (", no-store" if no_store).to_s
  end

  # Date: <ServercurrentDate>
  # Expires: Fri, 01 Jan 1990 00:00:00 GMT
  # Cache-control: private, max-age=<1dayInSeconds>
  def only_browser_can_cache(no_store = true, max_age_in_seconds = 0)
    #TODO assert input
    response.headers["Date"] = timestamp
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
    response.headers["Cache-Control"] = "private, max-age=#{max_age_in_seconds}" + (", no-store" if no_store).to_s
  end

  # Date: <ServercurrentDate>
  # Expires: <ServerCurrentDate + 1month>
  # Cache-control: public, max-age=<1month>
  def allow_browser_and_proxy_to_cache(no_store = true, max_age_in_seconds = 0)
    #TODO assert input
    now = Today.now
    response.headers["Date"] = timestamp(now)
    response.headers["Expires"] = timestamp(now + max_age_in_seconds)
    response.headers["Cache-Control"] = "public, max-age=#{max_age_in_seconds}" + (", no-store" if no_store).to_s
  end

  private
  def timestamp(now = Time.now)
    now.utc.strftime "%a, %d %b %Y %H:%M:%S %Z"
  end
end
