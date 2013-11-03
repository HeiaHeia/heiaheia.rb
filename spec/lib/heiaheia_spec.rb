require 'spec_helper'

describe HeiaHeia do

  before do
    HeiaHeia.reset!
  end

  it "sets defaults" do
    HeiaHeia::Configurable.keys.each do |key|
      expect(HeiaHeia.instance_variable_get(:"@#{key}")).to eq HeiaHeia::Default.send(key)
    end
  end

  describe ".client" do
    it "creates an HeiaHeia::Client" do
      expect(HeiaHeia.client).to be_kind_of HeiaHeia::Client
    end

    it "caches the client when the same options are passed" do
      expect(HeiaHeia.client).to eq HeiaHeia.client
    end

    it "returns a fresh client when options are not the same" do
      client = HeiaHeia.client
      HeiaHeia.access_token = "87614b09dd141c22800f96f11737ade5226d7ba8"
      client_two = HeiaHeia.client
      client_three = HeiaHeia.client
      expect(client).to_not eq(client_two)
      expect(client_three).to eq(client_two)
    end
  end

  describe ".configure" do
    HeiaHeia::Configurable.keys.each do |key|
      it "sets the #{key.to_s.gsub('_', ' ')}" do
        HeiaHeia.configure do |config|
          config.send("#{key}=", key)
        end
        expect(HeiaHeia.instance_variable_get(:"@#{key}")).to eq key
      end
    end
  end

end
