module SwiftlyPivotal
  class Track < Thor

    include Helpers
    include Curses

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

    desc "accepted PROJECT_NAME", "Track accepted"

    #
    # Get the accepted stories associated with the project name
    # @param project_name [string] The name of the pivotal tracker project
    #
    # @return [void]

    def accepted project_name
Curses.init_screen
Curses.curs_set(0)  # Invisible cursor


begin

  # Building a static window
  win1 = Curses::Window.new(Curses.lines / 2 - 1, Curses.cols / 2 - 1, 0, 0)
  # win1.box("o", "o")
  win1.setpos(2, 2)
  stories = SwiftlyPivotal::PivotalTracker.stories 0, 'accepted'
  stories.each_with_index do |(k,v),i|


    # win1.addstr stories[i]['name']
    win1.addstr stories[i]['name']
    row = []
    col = []

    # win1.addstr row.first


    win1.setpos(2+(i*2), 2)
    Curses.begy(5)
    win1.refresh
    sleep 0.05
  end
    win1.getch
    win1.refresh


rescue => ex
  # Curses.close_screen
end

      # SwiftlyPivotal::Stories.get_stories 'accepted'
    end

    desc "delivered PROJECT_NAME", "Track delivered"

    #
    # Get the delivered stories associated with the project name
    # @param project_name [string] The name of the pivotal tracker project
    #
    # @return [void]

    def delivered project_name

      SwiftlyPivotal::Stories.get_stories 'delivered'
    end

    desc "finished PROJECT_NAME", "Track finished"

    #
    # Get the finished stories associated with the project name
    # @param project_name [string] The name of the pivotal tracker project
    #
    # @return [void]

    def finished project_name

      SwiftlyPivotal::Stories.get_stories 'finished'
    end

    desc "started PROJECT_NAME", "Track started"

    #
    # Get the started stories associated with the project name
    # @param project_name [string] The name of the pivotal tracker project
    #
    # @return [void]

    def started project_name

      SwiftlyPivotal::Stories.get_stories 'started'
    end

    desc "rejected PROJECT_NAME", "Track rejected"

    #
    # Get the rejected stories associated with the project name
    # @param project_name [string] The name of the pivotal tracker project
    #
    # @return [void]

    def rejected project_name

      SwiftlyPivotal::Stories.get_stories 'rejected'
    end

    desc "planned PROJECT_NAME", "Track planned"

    #
    # Get the planned stories associated with the project name
    # @param project_name [string] The name of the pivotal tracker project
    #
    # @return [void]

    def planned project_name

      SwiftlyPivotal::Stories.get_stories 'planned'
    end

    desc "unstarted PROJECT_NAME", "Track unstarted"

    #
    # Get the unstarted stories associated with the project name
    # @param project_name [string] The name of the pivotal tracker project
    #
    # @return [void]

    def unstarted project_name

      SwiftlyPivotal::Stories.get_stories 'unstarted'
    end

    desc "unschedule PROJECT_NAME", "Track unschedule"

    #
    # Get the unscheduled stories associated with the project name
    # @param project_name [string] The name of the pivotal tracker project
    #
    # @return [void]

    def unscheduled project_name

      SwiftlyPivotal::Stories.get_stories 'unscheduled'
    end

    register SwiftlyPivotal::Stories, "stories", "stories PROJECT_NAME", "Retrieve info about [project_name]"

  end
end



