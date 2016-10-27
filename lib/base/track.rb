module SwiftlyPivotal
  class Track < Thor

    include Helpers

    def initialize(*args)
      super

      $project_name = args[0][0]
    end

    desc "project PROJECT_NAME", "Track Project"

    def project( project_name )

      # Go out and get the project by project name
      project = SwiftlyPivotal::PivotalTracker.project

      # Format the project for display
      SwiftlyPivotal::Format.project project

    end

    desc "unscheduled PROJECT_NAME", "Track unscheduled"

    #
    # Get the unscheduled stories associated with the project name
    # @param project_name [string] The name of the pivotal tracker project
    #
    # @return [void]
    def unscheduled( project_name )

      SwiftlyPivotal::Stories.get_stories 'unscheduled'
    end

    desc "finished PROJECT_NAME", "Track finished"

    #
    # Get the finished stories associated with the project name
    # @param project_name [string] The name of the pivotal tracker project
    #
    # @return [void]
    def finished( project_name )

      SwiftlyPivotal::Stories.get_stories 'finished'
    end

    register SwiftlyPivotal::Stories, "stories", "stories PROJECT_NAME", "Retrieve info about [project_name]"

  end
end



