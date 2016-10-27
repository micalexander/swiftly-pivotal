module SwiftlyPivotal
  class Stories < Thor

    include Helpers

    def initialize(*args)
      super

      $project_name = args[0][0]
    end

    desc "track stories PROJECT_NAME", "Track Stories"

    #
    # Get the stories associated with the project name
    # @param project_name [string] The name of the pivotal tracker project
    #
    # @return [void]
    def stories( project_name )

      # Go out and get 5 stories
      stories = SwiftlyPivotal::PivotalTracker.stories

      # Format the retrieved stories
      SwiftlyPivotal::Format.stories stories

      # Start the loaded at zero
      loaded = 0

      # Set the initial allowed answers
      allowed = ['y', '1', '2', '3', '4', '5']

      # Ask a question and as long as the answers to the question are allowed
      while answer = ask(set_color('Load 5 more or enter number to expand', :yellow, :bold ),  :limited_to => allowed)

        # Increment the loaded by 5
        loaded = loaded + 5

        # Go out and get 5 more stories
        stories = SwiftlyPivotal::PivotalTracker.stories loaded

        # Loop throut the loaded numbers
        loaded.times do |number|

          # Add them to the allowed array
          allowed << stories.length + (number+1)
        end

        # Format the retrieved stories
        SwiftlyPivotal::Format.stories stories, loaded

        # Jump out of this loop if there are no more stories
        break unless stories.length > 4

        # Check to see if a number was passed
        if answer.to_i  > 0

          # If so, do something with it and break out of this loop
          break

        end
      end

      say 'No more stories'
    end

    default_task :stories
  end
end



