require 'thor'
require 'fileutils'
require 'awesome_print'
require "time"
require "clipboard"
require 'base/version'
require 'base/app_module'
require 'base/pivotal'
require 'base/format'
require 'base/navigation'
require 'base/stories'
require 'base/tracker'
require 'base/track'
require 'readline'

module SwiftlyPivotal
  class CLI < Thor

    include Thor::Actions
    include Helpers

    register SwiftlyPivotal::Track, "track", "track COMMAND type", "Retrieve info about type"

  end
end
