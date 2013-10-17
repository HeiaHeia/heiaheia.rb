module HeiaHeia

  module Configurable

    # @!attribute [w] access_token
    #   @return [String] OAuth2 access token for authentication
    # @!attribute api_endpoint
    #   @return [String] Base URL for API requests. default: https://api.heiaheia.com/
    # @!attribute auto_paginate
    #   @return [Boolean] Auto fetch next page of results until rate limit reached
    # @!attribute client_id
    #   @return [String] Configure OAuth app key
    # @!attribute [w] client_secret
    #   @return [String] Configure OAuth app secret
    # @!attribute connection_options
    #   @return [Hash] Configure connection options for Faraday
    # @!attribute login
    #   @return [String] HeiaHeia username for Basic Authentication
    # @!attribute middleware
    #   @see https://github.com/lostisland/faraday
    #   @return [Faraday::Builder] Configure middleware for Faraday
    # @!attribute [w] password
    #   @return [String] HeiaHeia password for Basic Authentication
    # @!attribute per_page
    #   @return [String] Configure page size for paginated results. API default: 20
    # @!attribute proxy
    #   @see https://github.com/lostisland/faraday
    #   @return [String] URI for proxy server
    # @!attribute user_agent
    #   @return [String] Configure User-Agent header for requests.

    attr_accessor :access_token, :api_endpoint, :auto_paginate, :client_id,
                  :connection_options, :login, :middleware, :per_page,
                  :proxy, :user_agent
    attr_writer :client_secret, :password

    class << self

      # List of configurable keys for {HeiaHeia::Client}
      # @return [Array] of option keys
      def keys
        @keys ||= [
          :access_token,
          :api_endpoint,
          :auto_paginate,
          :client_id,
          :client_secret,
          :connection_options,
          :login,
          :middleware,
          :per_page,
          :password,
          :proxy,
          :user_agent
        ]
      end
    end

    # Set configuration options using a block
    def configure
      yield self
    end

    # Reset configuration options to default values
    def reset!
      HeiaHeia::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", HeiaHeia::Default.options[key])
      end
      self
    end
    alias setup reset!

    def api_endpoint
      File.join(@api_endpoint, "")
    end

    def login
      @login ||= begin
        user.login if token_authenticated?
      end
    end

    private

    def options
      Hash[HeiaHeia::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

    def fetch_client_id_and_secret(overrides = {})
      opts = options.merge(overrides)
      opts.values_at :client_id, :client_secret
    end

  end

end
