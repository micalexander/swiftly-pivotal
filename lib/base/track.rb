module SwiftlyPivotal
  class Track < Thor

    include Helpers

    def initialize(*args)
      super

      $project_name = args[0][0]
    end

    desc "track project PROJECT_NAME", "Track Project"

    def project( project_name )

      # Go out and get the project by project name
      project = SwiftlyPivotal::PivotalTracker.project

      # Format the project for display
      SwiftlyPivotal::Format.project project

    end

    register SwiftlyPivotal::Unscheduled, "unscheduled", "unscheduled PROJECT_NAME", "Retrieve info about type"
    register SwiftlyPivotal::Stories, "stories", "stories PROJECT_NAME", "Retrieve info about [project_name]"

  end
end



