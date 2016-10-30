require 'Thor'
require 'pathname'
require 'awesome_print'

module SwiftlyPivotal

  #
  # Navigation
  #
  # @author [micalexander]
  #
  class Navigation

    #
    # Kick off the navigation process
    # @param items_name [string] Name to use for the navigated item
    # @param selected_name [string] Name to use for the sub page item
    # @param items [hash] Hash of items
    # @param state = '' [string] The state of an item
    # @param loaded = 0 [int] A number specifying the amound of items previously loaded
    #
    # @return [void]
    def self.navigate items_name, selected_name, items, state = '', loaded = 0

      # Set the initial allowed answers
      allowed_selections = {
        :selected => {
          'q' => 'Quit',
          'n' => 'Next',
        },
        :fetched => []
      }

      # Loop through the items count and add
      # the numbers to the allowed selections
      items.length.times do |number|

        allowed_selections[:fetched] << (number+1).to_s
      end

      # Display the items and return the item selected if one was made
      selection = self.display_items allowed_selections, loaded, state, items_name, items

      # Check to see if an item was selected
      if !selection.empty?

        # If so the get the selected item
        self.get_selected selected_name, selection
      end
    end


    #
    # Displays the items and returns one if an item choice was made
    # @param allowed_selections [hash] Hash of allowed selection
    # @param loaded [int] The number of items previosly loaded
    # @param state [string] The item state
    # @param items_name [string] Name of the item to use
    # @param items [hash] Hash of items
    #
    # @return [hash] Hash of selected item
    def self.display_items allowed_selections, loaded, state, items_name, items

      # Ask a question as long as the answers to the question are allowed
      while answer = self.question(allowed_selections, "\n\nEnter a number to select a #{items_name}")

        # Quit app if the letter q is entered
        Helpers.quit_app if answer == 'q'

        # Keep track of the items loaded while in this loop
        loaded = loaded + items.length

        # Go out and get 5 more items
        fetched_items = SwiftlyPivotal::PivotalTracker.send items_name, loaded, state

        # Check to see if we run out of items to fetch
        if !fetched_items.include? 'Sorry'

          # If not then them to the fetched items
          items += fetched_items

          # Loop through the loaded numbers
          fetched_items.length.times do |number|

            # Add them to the allowed array
            allowed_selections[:fetched] << loaded + (number+1)
          end

        end

        # Jump out of this loop and return the
        # item selected
        return items[item_index(answer)] unless !item_index(answer)

        # Check to see if we ran out of items or
        # the count is lower than 5
        if fetched_items.include?('Sorry') || fetched_items.length < 5

          # If so then remove the letter n
          # from the allowed selections hash
          allowed_selections[:selected].delete_if { |v| v == 'n' }

        end

        # Format the retrieved items
        SwiftlyPivotal::Format.send items_name, fetched_items, state, loaded
      end
    end


    #
    # Get the selected item
    # @param selected_name [string] The name to use for the selected item
    # @param item [hash] Hash of the item
    #
    # @return [void]
    def self.get_selected selected_name, item

      # Go out and get sub items
      # items = SwiftlyPivotal::PivotalTracker.send selected_name, item

      # Format the retrieved sub items
      SwiftlyPivotal::Format.send selected_name, item, 0, false

      # Start=blue Accepted=green Deliver=orange f=Finish Rejected=red Unstarted=white Unschedule=white
      #
      # Create a hash of the allowed selections
      allowed_selections = {
        :selected => {
          'q' => 'Quit',
          's' => 'Start',
          'a' => 'Accept',
          'd' => 'Deliver',
          'f' => 'Finish',
          'r' => 'Reject',
          'u' => 'Unstart',
          'c' => 'Unschedule'
        },
        :fetched => []
      }

      # Check to see if we have any sub items
      if !item['tasks'].empty?

        # If we do then loop through them
        item['tasks'].length.times do |number|

          # And add the index to the allowed selections
          allowed_selections[:fetched] << (number+1).to_s
        end
      end

      # Display the selected item
      self.display_selection allowed_selections, selected_name, item
    end

    #
    # Display the selected item
    # @param allowed_selections [hash] Hash of allowed selections
    # @param items_name [string] Name of item type
    # @param items [hash] Hash of items
    # @param item [hash] Item hash
    #
    # @return [type] [description]
    def self.display_selection allowed_selections, items_name, item

      # Begin the loop to retrieve answers from the user
      while answer = self.question(allowed_selections, "\n\nEnter a number to select a #{items_name}")

        # Quit the app if q is pressed
        Helpers.quit_app if answer == 'q'

        # Capture the item selected
        item_index = self.item_index(answer) unless !item_index(answer)

        # Check to see if a number was passed
        if item_index

          # If so, update the sub item that corresponds with the number entered
          task = SwiftlyPivotal::PivotalTracker.put_task item['tasks'][item_index]

          # add the updated task back to the story
          item['tasks'][item_index] = task

          # Format the retieved items
          SwiftlyPivotal::Format.send items_name, item, 0, false

        else

          # Check to see if the answer is unschedule
          if answer == 'c'

            # If so suffix with a d
            suffix = 'd'
          else

            # If not suffix with ed
            suffix = 'ed'
          end

          # Cache tasks
          tasks = item['tasks']

          # Return the updated story
          item = SwiftlyPivotal::PivotalTracker.put_story item, "#{allowed_selections[:selected][answer]}#{suffix}".downcase

          # Add tasks back to the story
          item['tasks'] = tasks

          # Format the retieved items
          SwiftlyPivotal::Format.send items_name, item, 0, false
        end

      end
    end


    #
    # Create a dashed line
    #
    # @return [string] A dashed line
    def self.dashed_line

      # Create empty string
      line = ''

      # Build string
      71.times do |n|

        line << '-'
        line << "\n" if n == 70

      end

      # Return string
      line
    end


    #
    # Retrun a 0 based index
    # @param answer [mixed] Number or letter
    #
    # @return [mixed] int or false
    def self.item_index answer

      # Return a decremented number if it is a number
      return answer.to_i-1 if answer.to_i > 0

      false
    end

    def self.question allowed_selections, additional_info

      # Initialize thor
      thor  = Thor.new

      # Create our separater for or instructions
      instructions = self.dashed_line

      # Loop through and space out the options
      allowed_selections[:selected].each_with_index do |(k,v),i|

        # Check to see if we are at the forth value
        if i%4 == 0 && i != 0

          # If so, add a newline character
          instructions << "\n"
        end

        # Space out each option
        instructions << "#{k}=#{v}".ljust(20)
      end

      # Add any other instructions to be printed out
      instructions << additional_info


      # Merge allowed selection keys with allowed selections
      # to create the limited to array
      limited_to = allowed_selections[:selected].keys + allowed_selections[:fetched]

      thor.ask(thor.set_color(instructions, :yellow ),  :limited_to => limited_to)
    end
  end
end

