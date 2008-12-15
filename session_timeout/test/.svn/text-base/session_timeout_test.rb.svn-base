require 'test/unit'
require 'session_timeout'

class MockRequest

  def headers
    @headers ||= {'REMOTE_ADDR' => "remote.adress" }
  end
end

class SessionTimeoutTest < Test::Unit::TestCase

  private

  def request
    @request ||= MockRequest.new
  end

  def session
    if @session.nil?
      @session = {}
      def @session.close
      end
    end
    @session
  end

  def reset_session
    @session = nil
    session
  end
  
  include SessionTimeout

  def new_session_timeout
    @new_session_timeout
  end

  @session_expired_called = false
  def session_expired
    @session_expired_called = true
  end

  public
  def test_no_ip_binding
    assert check_session_ip_binding
    assert_equal 1, session.size
    assert !@session_expired_called
    request.headers['REMOTE_ADDR'] = 'another.remote.address'
    assert !check_session_ip_binding
    assert @session_expired_called
    assert_equal 0, session.size
  end

  def test_ip_binding
    assert check_session_expiry
    assert_equal 1, session.size
    assert !@session_expired_called
    assert check_session_expiry
    assert_equal 1, session.size
    assert !@session_expired_called
  end

  def test_idle_timeout
    @new_session_timeout = Time.now
    assert check_session_expiry
    assert !check_session_expiry
    assert @session_expired_called
    assert_equal 0, session.size
  end

  def test_idle_no_timeout
    @new_session_timeout = Time.now + 1000
    assert check_session_expiry
    assert_equal 1, session.size
    assert check_session_expiry
    assert !@session_expired_called
    assert_equal 1, session.size
  end
  
end
