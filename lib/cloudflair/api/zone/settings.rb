require 'cloudflair/api/zone/settings/development_mode'

module Cloudflair
  class Settings
    attr_reader :zone_id

    def initialize(zone_id)
      @zone_id = zone_id
    end

    def development_mode
      Cloudflair::DevelopmentMode.new @zone_id
    end
  end
end