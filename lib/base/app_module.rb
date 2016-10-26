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


  end
end

