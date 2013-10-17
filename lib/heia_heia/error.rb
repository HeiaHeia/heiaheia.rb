module HeiaHeia

  # Custom error class for rescuing from all HeiaHeia errors
  class Error < StandardError

    # Returns the appropriate HeiaHeia::Error sublcass based
    # on status and response message
    #
    # @param [Hash] response HTTP response
    # @return [HeiaHeia::Error]
    def self.from_response(response)
      status  = response[:status].to_i
      body    = response[:body].to_s
      headers = response[:response_headers]

      if klass =  case status
                    when 400      then HeiaHeia::BadRequest
                    when 401      then HeiaHeia::Unauthorized
                    when 403      then HeiaHeia::Forbidden
                    when 404      then HeiaHeia::NotFound
                    when 406      then HeiaHeia::NotAcceptable
                    when 415      then HeiaHeia::UnsupportedMediaType
                    when 422      then HeiaHeia::UnprocessableEntity
                    when 400..499 then HeiaHeia::ClientError
                    when 500      then HeiaHeia::InternalServerError
                    when 501      then HeiaHeia::NotImplemented
                    when 502      then HeiaHeia::BadGateway
                    when 503      then HeiaHeia::ServiceUnavailable
                    when 500..599 then HeiaHeia::ServerError
                  end
        klass.new(response)
      end
    end

    def initialize(response=nil)
      @response = response
      super(build_error_message)
    end

    private

    def data
      @data ||=
        if (body = @response[:body]) && !body.empty?
          if body.is_a?(String) &&
            @response[:response_headers] &&
            @response[:response_headers][:content_type] =~ /json/

            Sawyer::Agent.serializer.decode(body)
          else
            body
          end
        else
          nil
        end
    end

    def response_message
      case data
        when Hash
          data[:message]
        when String
          data
      end
    end

    def response_error
      "Error: #{data[:error]}" if data.is_a?(Hash) && data[:error]
    end

    def response_error_summary
      return nil unless data.is_a?(Hash) && !Array(data[:errors]).empty?

      summary = "\nError summary:\n"
      summary << data[:errors].map do |hash|
        hash.map { |k,v| "  #{k}: #{v}" }
      end.join("\n")

      summary
    end

    def build_error_message
      return nil if @response.nil?

      message =  "#{@response[:method].to_s.upcase} "
      message << "#{@response[:url].to_s}: "
      message << "#{@response[:status]} - "
      message << "#{response_message}" unless response_message.nil?
      message << "#{response_error}" unless response_error.nil?
      message << "#{response_error_summary}" unless response_error_summary.nil?
      #message << " // See: #{documentation_url}" unless documentation_url.nil?
      message
    end
  end

  # Raised on errors in the 400-499 range
  class ClientError < Error; end

  # Raised when HeiaHeia returns a 400 HTTP status code
  class BadRequest < ClientError; end

  # Raised when HeiaHeia returns a 401 HTTP status code
  class Unauthorized < ClientError; end

  # Raised when HeiaHeia returns a 403 HTTP status code
  class Forbidden < ClientError; end

  # Raised when HeiaHeia returns a 404 HTTP status code
  class NotFound < ClientError; end

  # Raised when HeiaHeia returns a 406 HTTP status code
  class NotAcceptable < ClientError; end

  # Raised when HeiaHeia returns a 414 HTTP status code
  class UnsupportedMediaType < ClientError; end

  # Raised when HeiaHeia returns a 422 HTTP status code
  class UnprocessableEntity < ClientError; end

  # Raised on errors in the 500-599 range
  class ServerError < Error; end

  # Raised when HeiaHeia returns a 500 HTTP status code
  class InternalServerError < ServerError; end

  # Raised when HeiaHeia returns a 501 HTTP status code
  class NotImplemented < ServerError; end

  # Raised when HeiaHeia returns a 502 HTTP status code
  class BadGateway < ServerError; end

  # Raised when HeiaHeia returns a 503 HTTP status code
  class ServiceUnavailable < ServerError; end
end
