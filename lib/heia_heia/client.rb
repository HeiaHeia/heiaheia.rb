require 'heia_heia/configurable'

module HeiaHeia

  # Client for the HeiaHeia API
  #
  # @see http://developers.heiaheia.com
  class Client
    include HeiaHeia::Configurable

    def initialize(options = {})
      HeiaHeia::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || HeiaHeia.instance_variable_get(:"@#{key}"))
      end
    end


  end

end
