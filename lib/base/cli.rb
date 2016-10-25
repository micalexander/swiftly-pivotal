require 'thor'
require 'base/app_module'

module Base
  class CLI < Thor

    include Thor::Actions
    include Helpers

    register Base::Action,    "action",    "action COMMAND SOMETHING",           "Do something"

  end
end
