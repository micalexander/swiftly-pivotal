require 'Thor'
require 'pathname'
require 'awesome_print'

class String

  # Unindent heredocs so they look better
  def unindent

    gsub(/^[\t|\s]*|[\t]*/, "")

  end
end

module SwiftlyPivotal
  module Helpers
      # Instantiate thor
    # def something

    # end
    # def self.included(base)
    #   base.extend ClassMethods
    # end

    # module ClassMethods
    #   def project_names name = ''


    #     # arguments Cli.new
    #   end
    # end
    def self.register_signal_handlers

      thor = Thor.new

      %w(INT HUP TERM QUIT).each do |sig|
        next unless Signal.list[sig]

        Signal.trap(sig) do

          # Do as little work as possible in the signal context
          self.quit_app

        end
      end
    end

    self.register_signal_handlers

    def self.quit_app

      thor = Thor.new

      thor.say
      thor.say
      thor.say "\sExiting #{APP_NAME}...", :yellow
      abort
    end
  end
end

