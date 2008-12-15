require 'test/unit'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-timestamps'
require "restful_transactions"

$KCODE = 'u'

DataMapper.setup(:default, {
                   :adapter  => 'sqlite3',
                   :database => "test/test.sqlite3"
                 })

DataMapper::Logger.new(STDOUT, 0)

class Email 

  include DataMapper::Resource

  property :id, Integer, :serial => true

  property :address, String, :nullable => false , :format => /^[^<'&">]*$/, :length => 32

end

class Controller

  class RequestResponse
    def initialize(method, redirect)
      @method = method
      @redirect = redirect
    end
    
    def method
      @method
    end

    def redirected_to
      @redirect
    end
  end

  def initialize(method, redirect = nil)
    @request_response = RequestResponse.new(method, redirect)
  end

  def request
    @request_response
  end

  def response
    @request_response
  end
end

class RestfulTransactionsTest < Test::Unit::TestCase

  def setup
    Email.auto_upgrade!
    @email = Email.create(:address => "something");
  end

  def test_get
    controller = Controller.new(:get)
    begin
      RestfulTransactions::TransactionFilter.filter(controller) do
        @email.update_attributes(:address => "nothing")
        throw StandardError.new("fall through")
      end
    rescue
      assert_equal "nothing", @email.address
    end
    RestfulTransactions::TransactionFilter.filter(controller) do
      @email.update_attributes(:address => "nothing else")
    end
    assert_equal "nothing else", @email.address
    controller = Controller.new(:put, "some/other/url")
    RestfulTransactions::TransactionFilter.filter(controller) do
      @email.update_attributes(:address => "something else")
    end
    assert_equal "something else", @email.address
  end

  def test_post
    do_test(:post)
  end

  def test_put
    do_test(:put)
  end

  def test_delete
    do_test(:delete)
  end

  def do_test(method)
    controller = Controller.new(method)
    begin
      RestfulTransactions::TransactionFilter.filter(controller) do
        @email.update_attributes(:address => "nothing")
        throw StandardError.new("fall through")
      end
    rescue
      assert_equal "something", Email.first.address
    end
    begin
      RestfulTransactions::TransactionFilter.filter(controller) do
        @email.update_attributes(:address => "something else")
      end
    rescue
      assert_equal "something", Email.first.address
    end
    controller = Controller.new(:put, "some/other/url")
    RestfulTransactions::TransactionFilter.filter(controller) do
      @email.update_attributes(:address => "something else")
    end
    assert_equal "something else", @email.address
  end
end
