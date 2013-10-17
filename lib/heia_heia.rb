require "heia_heia/version"
require 'heia_heia/client'
require 'heia_heia/default'

module HeiaHeia

  class << self
    include HeiaHeia::Configurable

    # API client based on configured options {Configurable}
    #
    # @return [HeiaHeia::Client] API wrapper
    def client
      @client = HeiaHeia::Client.new(options) unless defined?(@client)
      @client
    end

    # @private
    def respond_to_missing?(method_name, include_private=false); client.respond_to?(method_name, include_private); end

    private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    end

  end

end

HeiaHeia.setup
