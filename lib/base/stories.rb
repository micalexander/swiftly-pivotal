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

        # Start the loaded at zero
        loaded = 0

        # Go out and get 5 stories
        stories = SwiftlyPivotal::PivotalTracker.stories 0, state

        # Format the retrieved stories
        SwiftlyPivotal::Format.stories stories, state, 0

        SwiftlyPivotal::Navigation.navigate 'stories', 'tasks', stories, state

      end
    end

    default_task :stories
  end
end



