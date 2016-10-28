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
    def self.register_signal_handlers

      thor = Thor.new

      %w(INT HUP TERM QUIT).each do |sig|
        next unless Signal.list[sig]

        Signal.trap(sig) do

          # Do as little work as possible in the signal context
          thor.say
          thor.say
          thor.say_status "#{APP_NAME}", 'Exiting...', :yellow
          abort

        end
      end
    end

    self.register_signal_handlers

    def self.paginate items_name, expandable_name, directions_messaage, non_found_message = 'No more items', state = ''

      thor = Thor.new

      # Start the loaded at zero
      loaded = 0

      # Go out and get 5 stories
      items = SwiftlyPivotal::PivotalTracker.send items_name, loaded, state

      # Format the retrieved stories
      SwiftlyPivotal::Format.send items_name, items, loaded

      # Create an array to store items ids
      item_ids = []

      # Create a map of stores associated by number
      items.each do |item|

        item_ids << item['id']
      end

      # Set the initial allowed answers
      allowed = ['y', '1', '2', '3', '4', '5']

      # Ask a question and as long as the answers to the question are allowed
      while answer = thor.ask(thor.set_color(directions_messaage, :yellow, :bold ),  :limited_to => allowed)

        # Increment the loaded by 5
        loaded = loaded + 5

        # Go out and get 5 more items
        items = SwiftlyPivotal::PivotalTracker.send items_name, loaded, state

        # Loop throut the loaded numbers
        loaded.times do |number|

          # Add them to the allowed array
          allowed << items.length + (number+1)
        end

        # Check to see if a number was passed
        if answer.to_i  > 0

          # If so, do something with it and break out of this loop
          self.expand_selection expandable_name, item_ids, answer.to_i

          break
        end

        # Format the retrieved items
        SwiftlyPivotal::Format.send items_name, items, loaded

        # Create a map of stores associated by number
        items.each do |item|

          item_ids << item['id']
        end


        # Jump out of this loop if there are no more items
        break unless items.length > 4
      end

      thor.say non_found_message
    end

    def self.expand_selection expandable_name, ids, answer

      answer = answer -1
      items = SwiftlyPivotal::PivotalTracker.send expandable_name, ids[answer]

      SwiftlyPivotal::Format.send expandable_name, items

    end
  end
end

