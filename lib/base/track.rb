module SwiftlyPivotal
  class Track < Thor

    include Helpers

    def initialize(*args)
      super

      $project_name = args[0][0]
    end

    desc "track project PROJECT_NAME", "Track Project"

    def project( project_name )

      project = SwiftlyPivotal::PivotalTracker.project

    end

    desc "track stories PROJECT_NAME", "Track Stories"

    #
    # Get the stories associated with the project name
    # @param project_name [string] The name of the pivotal tracker project
    #
    # @return [void]
    def stories( project_name )

      stories = SwiftlyPivotal::PivotalTracker.stories

    end
  end
end



