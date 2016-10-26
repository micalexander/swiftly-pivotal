require 'base/package'

module SwiftlyPivotal
  class Tracker < Package

    attr_accessor :token
    attr_accessor :id

    @package_type  = :tracker

    def self.defaults

      false
    end
  end
end