require 'cgi'
require 'cgi/session'
require 'digest/md5'

class CGI
  class Session
 
    # A session store backed by an Active Record class.  A default class is
    # provided, but any object duck-typing to an Active Record Session class
    # with text +session_id+ and +data+ attributes is sufficient.
    #
    # The default assumes a +sessions+ tables with columns:
    #   +session_id+ (primary key - text, or longtext if your session data exceeds 65K), and
    #   +data+ (text or longtext; careful if your session data exceeds 65KB).
    # The +session_id+ column should always be indexed for speedy lookups.
    # Session data is marshaled to the +data+ column in Base64 format.
    # If the data you write is larger than the column's size limit,
    # ActionController::SessionOverflowError will be raised.
    #
    # Since the default class is a simple DataMapper resource, you get timestamps
    # for free if you add +created_at+ and +updated_at+ datetime columns to
    # the +sessions+ table, making periodic session expiration a snap.
    #
    # You may provide your own session class implementation, whether a
    # feature-packed Active Record or a bare-metal high-performance SQL
    # store, by setting
    #   CGI::Session::ActiveRecordStore.session_class = MySessionClass
    # You must implement these methods:
    #   self.find_by_session_id(session_id)
    #   initialize(hash_of_session_id_and_data)
    #   attr_reader :session_id
    #   attr_accessor :data
    #   save
    #   destroy
    #
    # The example SqlBypass class is a generic SQL session store.  You may
    # use it as a basis for high-performance database-specific stores.
    class DataMapperStore
      class Session

        include DataMapper::Resource

        def self.name
          "session"
        end

        property :session_id, String, :key => true

        property :serialized_data, Text, :nullable => false, :field => "data", :default => ActiveSupport::Base64.encode64(Marshal.dump({}))

        property :updated_at, DateTime, :nullable => false

        attr_writer :data

        before :save, :marshal_data!

        class << self
          
          def marshal(data)   ActiveSupport::Base64.encode64(Marshal.dump(data)) if data end
          def unmarshal(data) Marshal.load(ActiveSupport::Base64.decode64(data)) if data end

        end

        # Lazy-unmarshal session state.
        def data
          @data ||= self.class.unmarshal(attribute_get(:serialized_data)) || {}
        end     

        private

        def marshal_data!
          return false if @data.nil?
          attribute_set(:serialized_data, self.class.marshal(self.data))
          true
        end
      end


      # The class used for session storage.  Defaults to
      # CGI::Session::DataMapperStore::Session.
      cattr_accessor :session_class
      self.session_class = Session

      # Find or instantiate a session given a CGI::Session.
      def initialize(session, option = nil)
        session_id = session.session_id
        unless @session = @@session_class.get(session_id)
          unless session.new_session
            raise CGI::Session::NoSession, 'uninitialized session'
          end
          @session = @@session_class.new(:session_id => session_id)
          
          # session saving can be lazy again, because of improved component implementation
          # therefore next line gets commented out:
          # @session.save

          # clean up old sessions
          @@session_class.all(:updated_at.lt => -1.days.from_now).destroy!
        end
      end

      # Access the underlying session model.
      def model
        @session
      end

      # Restore session state.  The session model handles unmarshaling.
      def restore
        if @session
          @session.data
        end
      end

      # Save session store.
      def update
        if @session
          @session.save
        end
      end

      # Save and close the session store.
      def close
        if @session
          update
          @session = nil
        end
      end

      # Delete and close the session store.
      def delete
        if @session
          @session.destroy
          @session = nil
        end
      end
    end
  end
end
