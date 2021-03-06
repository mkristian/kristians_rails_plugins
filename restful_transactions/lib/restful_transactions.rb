module RestfulTransactions

  class Rollback < StandardError
  end

  module Base
    def self.included(base)
      base.prepend_around_filter(TransactionFilter)
    end
  end
  
  class TransactionFilter
    def self.filter(controller)
      case controller.request.method
      when :post, :put, :delete then
        begin
          DataMapper::Transaction.new(DataMapper.repository(:default)) do |*block_args|
            if block_given? 
              yield (*block_args)
              # added rollback for all actions which just render
              # a page with validation errors and do not redirect to new idem potent 
              # page (http-method get is idem potent within the
              # restful paradigma
              unless controller.response.redirected_to
                raise RestfulTransactions::Rollback      
              end
            end
          end
        rescue RestfulTransactions::Rollback 
          # ignore, 
          # this is just needed to trigger the rollback on the transaction
        end
      else
        yield if block_given?
      end
    end
  end

end
