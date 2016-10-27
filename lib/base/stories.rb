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

      SwiftlyPivotal::Stories.get_stories
    end

    no_commands do

      def self.get_stories state = ''

        thor = Thor.new

        # Go out and get 5 stories
        stories = SwiftlyPivotal::PivotalTracker.stories 0, state

        # Format the retrieved stories
        SwiftlyPivotal::Format.stories stories

        # Start the loaded at zero
        loaded = 0

        # Create an array to stor story ids
        story_ids = []

        # Set the initial allowed answers
        allowed = ['y', '1', '2', '3', '4', '5']

        # Create a map of stores associated by number
        stories.each do |story|

          story_ids << story['id']
        end


        # Ask a question and as long as the answers to the question are allowed
        while answer = thor.ask(thor.set_color('Load 5 more or enter number to expand', :yellow, :bold ),  :limited_to => allowed)

          # Increment the loaded by 5
          loaded = loaded + 5

          # Go out and get 5 more stories
          stories = SwiftlyPivotal::PivotalTracker.stories loaded, state

          # Loop throut the loaded numbers
          loaded.times do |number|

            # Add them to the allowed array
            allowed << stories.length + (number+1)
          end

          # Check to see if a number was passed
          if answer.to_i  > 0

            # If so, do something with it and break out of this loop
            self.expand_story story_ids, answer.to_i

            break
          end

          # Format the retrieved stories
          SwiftlyPivotal::Format.stories stories, loaded

          # Create a map of stores associated by number
          stories.each do |story|

            story_ids << story['id']
          end


          # Jump out of this loop if there are no more stories
          break unless stories.length > 4
        end

        thor.say 'No more stories'

      end

      def self.expand_story story_ids, answer

        answer = answer -1

        tasks = SwiftlyPivotal::PivotalTracker.tasks story_ids[answer]

        SwiftlyPivotal::Format.tasks tasks

      end

    end

    default_task :stories
  end
end



