require 'thor'
require 'base/version'
require 'base/tracker'
require 'base/app_module'
require 'base/track'

module SwiftlyPivotal
  class CLI < Thor

    include Thor::Actions
    include Helpers

    register SwiftlyPivotal::Track, "track", "track COMMAND type", "Retrieve info about type"

  end
end
