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

  end
end

