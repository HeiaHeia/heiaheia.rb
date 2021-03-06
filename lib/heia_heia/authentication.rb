module HeiaHeia

  module Authentication

    # Indicates if the client was supplied  Basic Auth
    # username and password
    # @return [Boolean]
    def basic_authenticated?
      @login && @password
    end

    # Indicates if the client was supplied an OAuth
    # access token
    # @return [Boolean]
    def token_authenticated?
      !!@access_token
    end

    # Indicates if the client was supplied an OAuth
    # access token or Basic Auth username and password
    # @return [Boolean]
    def user_authenticated?
      basic_authenticated? || token_authenticated?
    end

    #TODO Check and remove method?
    # Indicates if the client has OAuth Application
    # client_id and secret credentials to make anonymous
    # requests at a higher rate limit
    # @return Boolean
    def application_authenticated?
      !!application_authentication
    end

    private

    def application_authentication
      if @client_id && @client_secret
        {
          client_id: @client_id,
          client_secret: @client_secret
        }
      end
    end

    #def login_from_netrc
    #  return unless netrc?
    #
    #  require 'netrc'
    #  info = Netrc.read netrc_file
    #  netrc_host = URI.parse(api_endpoint).host
    #  creds = info[netrc_host]
    #  self.login = creds.shift
    #  self.password = creds.shift
    #rescue LoadError
    #  warn "Please install netrc gem for .netrc support"
    #end

  end
end
