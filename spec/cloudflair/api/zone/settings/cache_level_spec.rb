require 'spec_helper'

describe Cloudflair::CacheLevel do
  let(:faraday_stubs) { Faraday::Adapter::Test::Stubs.new }
  let(:faraday) do
    Faraday.new(url: 'https://api.cloudflare.com/client/v4/', headers: Cloudflair::Connection.headers) do |faraday|
      faraday.adapter :test, faraday_stubs
      faraday.request :json
      faraday.response :json, content_type: /\bjson$/
    end
  end

  let(:zone_identifier) { '023e105f4ecef8ad9ca31a8372d0c353' }
  let(:response_json) { File.read('spec/cloudflair/fixtures/zone/cache_level.json') }
  let(:url) { "/client/v4/zones/#{zone_identifier}/settings/cache_level" }
  let(:subject) { Cloudflair.zone(zone_identifier).settings.cache_level }

  before do
    faraday_stubs.get(url) do |_env|
      [200, { content_type: 'application/json' }, response_json]
    end
    allow(Faraday).to receive(:new).and_return faraday
  end

  it 'returns the correct zone_id' do
    expect(subject.zone_id).to eq zone_identifier
  end

  describe 'fetch values' do
    it 'fetches relevant values' do
      expect(subject.value).to eq 'aggressive'
      expect(subject.editable).to be true
    end
  end

  describe 'put values' do
    before do
      faraday_stubs.patch(url, 'value' => 'simplified') do |_env|
        [200, { content_type: 'application/json' }, response_json]
      end
    end

    it 'saves the values' do
      expect(faraday).to receive(:patch).and_call_original
      subject.value = 'simplified'
      subject.save

      expect(subject.value).to eq 'aggressive'
    end
  end
end