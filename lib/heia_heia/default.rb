require 'heia_heia/response/raise_error'
require 'heia_heia/version'

module HeiaHeia

  # Default configuration options for {Client}
  module Default

    # Default API endpoint
    API_ENDPOINT = "https://api.heiaheia.com".freeze

    # Default User Agent header string
    USER_AGENT   = "HeiaHeia Ruby Gem #{HeiaHeia::VERSION}".freeze

    #Default pagination preference
    AUTO_PAGINATE = true


    # Default Faraday middleware stack
    MIDDLEWARE = Faraday::Builder.new do |builder|
      builder.use HeiaHeia::Response::RaiseError
      builder.adapter Faraday.default_adapter
    end


    class << self

      # Configuration options
      # @return [Hash]
      def options
        Hash[HeiaHeia::Configurable.keys.map{|key| [key, send(key)]}]
      end


      # Default access token from ENV
      # @return [String]
      def access_token
        ENV['HEIAHEIA_ACCESS_TOKEN']
      end

      # Default API endpoint from {API_ENDPOINT}
      # @return [String]
      def api_endpoint
        API_ENDPOINT
      end

      # Default pagination preference from ENV
      # @return [Boolean]
      def auto_paginate
        AUTO_PAGINATE
      end

      # Default OAuth app key from ENV
      # @return [String]
      def client_id
        ENV['HEIAHEIA_CLIENT_ID']
      end

      # Default OAuth app secret from ENV
      # @return [String]
      def client_secret
        ENV['HEIAHEIA_SECRET']
      end

      # Default HeiaHeia username for Basic Auth from ENV
      # @return [String]
      def login
        ENV['HEIAHEIA_LOGIN']
      end

      # Default HeiaHeia password for Basic Auth from ENV
      # @return [String]
      def password
        ENV['HEIAHEIA_PASSWORD']
      end

      # Default proxy server URI for Faraday connection from ENV
      # @return [String]
      def proxy
        ENV['HEIAHEIA_PROXY']
      end

      # Default options for Faraday::Connection
      # @return [Hash]
      def connection_options
        {
          headers: {
            accept: 'application/json',
            user_agent: user_agent
          }
        }
      end

      # Default middleware stack for Faraday::Connection
      # from {MIDDLEWARE}
      # @return [String]
      def middleware
        MIDDLEWARE
      end

      # Default pagination page size
      # @return [Fixnum] Page size
      def per_page
        20
      end

      # Default User-Agent header string from {USER_AGENT}
      # @return [String]
      def user_agent
        USER_AGENT
      end

    end


  end

end
