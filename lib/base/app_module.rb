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
          self.exit_app

        end
      end
    end

    self.register_signal_handlers

    def self.exit_app

      thor = Thor.new

      thor.say
      thor.say
      thor.say "\sExiting #{APP_NAME}...", :yellow
      abort
    end

    def self.paginate items_name, expandable_name, non_found_message = 'No more items', state = ''

      thor = Thor.new

      # Start the loaded at zero
      loaded = 0

      # Go out and get 5 stories
      fetched_items = SwiftlyPivotal::PivotalTracker.send items_name, 0, state

      # Format the retrieved stories
      SwiftlyPivotal::Format.send items_name, fetched_items, state, 0

      # Set the initial allowed answers
      allowed = ['q','n']

      fetched_items.length.times do |number|

        allowed << (number+1).to_s
      end

      directions_messaage = "\n-----------------------------------------------------------------------\n"
      directions_messaage << "\sq=Quit n=Next #=Select\n\n Available Selections\n"

      # Ask a question and as long as the answers to the question are allowed
      while answer = thor.ask(thor.set_color(directions_messaage, :yellow ),  :limited_to => allowed)

        self.exit_app if answer == 'q'

        loaded = loaded + fetched_items.length

        # Go out and get 5 more items
        new_items = SwiftlyPivotal::PivotalTracker.send items_name, loaded, state

        if !new_items.include? 'Sorry'

          # Add them to the fetched items
          fetched_items += new_items

          # Loop through the loaded numbers
          new_items.length.times do |number|

            # Add them to the allowed array
            allowed << loaded + (number+1)
          end

        end

        # Check to see if a number was passed
        if answer.to_i  > 0

          # If so, do something with it and break out of this loop
          self.expand_selection expandable_name, fetched_items[answer.to_i-1]

        end

        if new_items.include?('Sorry') || new_items.length < 5

          allowed.delete_if { |v| v == 'n' }

        end

        # Format the retrieved items
        SwiftlyPivotal::Format.send items_name, new_items, state, loaded
      end
    end

    def self.expand_selection expandable_name, item

      thor   = Thor.new
      fetched_items  = SwiftlyPivotal::PivotalTracker.send expandable_name, item

      SwiftlyPivotal::Format.send expandable_name, fetched_items, item, 0, false

      # Start=blue Accepted=green Deliver=orange f=Finish Rejected=red Unstarted=white Unschedule=white
      directions_messaage = "\sq=Quit \s\ss=Start \s\sa=Accept \s\s\s\s\s\sd=Deliver f=Finish \n\sr=Reject u=Unstart unc=Unschedule #=Select\n\nAvailable Selections."
      allowed             = ['q', 's', 'a', 'd', 'f', 'r', 'u', 'unc']

      if !fetched_items.include?('Sorry')

        fetched_items.length.times do |number|

          allowed << (number+1).to_s
        end
      end

      thor.say
      thor.say '-----------------------------------------------------------------------'

      while answer = thor.ask(thor.set_color(directions_messaage, :yellow ),  :limited_to => allowed)

        self.exit_app if answer == 'q'

        # Check to see if a number was passed
        if answer.to_i  > 0

          # If so, do something with it and break out of this loop
          SwiftlyPivotal::PivotalTracker.put_task fetched_items[answer.to_i-1], item

          fetched_items  = SwiftlyPivotal::PivotalTracker.send expandable_name, item

          SwiftlyPivotal::Format.send expandable_name, fetched_items, item, 0, false

          # break
        end

      end

    end
  end
end

