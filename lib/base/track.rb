require 'fileutils'
require 'base/app_module'
require 'httparty'
require 'awesome_print'
require "time"

module SwiftlyPivotal
  class Track < Thor

    include Helpers
    include HTTParty

    headers 'X-TrackerToken' => '847d6b5ff008a5d79a5367fb3cc1b876'

    desc "track project PROJECT_NAME", "Track Project"

    def project( project_name )

      data = self.class.get("https://www.pivotaltracker.com/services/v5/projects")

      data.parsed_response.each do |project|

        if project['name'].downcase == project_name.downcase

            say_status "\n\s\spivotal: ", "#{project['id']} - #{project['name']}\n", :yellow
        end
      end
    end

    desc "track stories PROJECT_NAME", "Track Stories"

    #
    # Get the stories associated with the project name
    # @param project_name [string] The name of the pivotal tracker project
    #
    # @return [void]
    def stories( project_name )

      # @obj returns a tracker object of based on the setting in the config file
      tracker = SwiftlyPivotal::Tracker.retrieve :pivotal, project_name

      # Check to see if the tracker variable contains an object
      if tracker

        # If so check to see if it has the id property
        if tracker.id

          # If so perform an api call to pivotal tracker for a project with the tracker.id
          stories = self.class.get("https://www.pivotaltracker.com/services/v5/projects/#{tracker.id}/stories")

          # Check to see if any stories were found for the project id
          if stories

            # If so loop through the stories
            stories.parsed_response.each do |story|
              ap story

              # Output each story to the terminal
              say_status "\n   pivotal: ", "#{story['id']} - #{story['name']}\n              #{story['current_state']} - #{Time.iso8601(story['updated_at']).strftime('%B %e,%l:%M %p')}\n              #{story['url']}\n", :yellow
            end
          end
        end
      end
    end
  end
end



