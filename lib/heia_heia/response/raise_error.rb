require 'faraday'
require 'heia_heia/error'

module HeiaHeia

  # Faraday response middleware
  module Response

    # This class raises an exception based
    # HTTP status codes returned by the API
    class RaiseError <  Faraday::Response::Middleware

      private

      def on_complete(response)
        if error = HeiaHeia::Error.from_response(response)
          raise error
        end
      end
    end
  end
end
