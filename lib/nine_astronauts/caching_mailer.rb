module NineAstronauts
  module CachingMailer
    
    module VERSION #:nodoc:
      MAJOR = 1
      MINOR = 0
      TINY  = 0
      
      STRING = [MAJOR, MINOR, TINY].join('.')
    end
    
    def self.included(base) #:nodoc:
      base.extend CachingMethods
    end
    
    module CachingMethods
      
      # Brings Rails' fragment caching functionality into ActionMailer
      #
      # Usage:
      #
      #   class HelloMailer < ActionMailer::Base
      #     
      #     include_fragment_caching
      #     
      #     def hello
      #       subject     "Hello, World"
      #       recipients  "you@foo.com"
      #       from        "me@bar.com"
      #       sent_on     Time.now
      #     end
      #   end
      #
      def include_fragment_caching
        self.extend(ClassMethods)
        self.send(:include, InstanceMethods)
        self.send(:include, ActionController::Caching::Fragments)
      end
    end
    
    module ClassMethods #:nodoc:
      delegate :cache_store, :perform_caching, :cache_configured?, :benchmark, :silence, :to => ActionController::Base
    end
    
    module InstanceMethods #:nodoc:
      def self.included(base)
        base.delegate :cache_store, :perform_caching, :cache_configured?, :to => base
      end
    protected
      ### Copied from "action_controller/caching.rb", line 57-64 (in 2.2.2):
      # Convenience accessor
      def cache(key, options = {}, &block)
        if cache_configured?
          cache_store.fetch(ActiveSupport::Cache.expand_cache_key(key, :controller), options, &block)
        else
          yield
        end
      end
    end
    
  end
end
