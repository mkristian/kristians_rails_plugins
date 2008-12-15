require 'test/unit'
require File.join(File.dirname(__FILE__), '../lib/referrer_check') 

class ReferrerCheckTest < Test::Unit::TestCase

  include ActionController::ReferrerCheck
    
  class Request
   
    def initialize(referrer, host)
      @map = { "HTTP_REFERER" => referrer, "HTTP_HOST" => host }
    end

    def env
      @map
    end

    def headers
      @map
    end

    def domain
      @map["HTTP_HOST"]
    end
  end

  def test_strict_ok
    @request = Request.new("http://localhost/mupage", "localhost")
    check_referrer
  end

  def test_strict_error
    @request = Request.new("http://google.com/mupage", "localhost")
    begin
      check_referrer
      fail("exception expected")
    rescue Exception => ex
      #puts ex.message
    end
  end

  def test_none_strict_ok
    check_referrer_mode :lenient
    @request = Request.new("http://localhost/mupage", "localhost")
    check_referrer
  end

  def test_none_strict_no_referrer_ok
    check_referrer_mode :lenient
    @request = Request.new(nil, "localhost")
    check_referrer
    check_referrer_mode :strict
    begin
      check_referrer
      fail("exception expected")
    rescue Exception => ex
      #puts ex.message
    end 
  end


  def test_none_strict_error
    check_referrer_mode :lenient
    @request = Request.new("http://google.com/mupage", "localhost")
    begin
      check_referrer
      fail("exception expected")
    rescue Exception => ex
      #puts ex.message
    end 
  end

  private 
  def request
    @request
  end
end
