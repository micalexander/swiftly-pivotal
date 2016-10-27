require 'httparty'

module SwiftlyPivotal
  class PivotalTracker

    include Helpers
    include HTTParty


    def self.project_settings

      # Retrieve the project setting from the config file
      project_settings = SwiftlyPivotal::Tracker.retrieve :pivotal, $project_name

      # Set headers
      headers 'X-TrackerToken' => project_settings.token

      # Set the base uri
      base_uri 'https://www.pivotaltracker.com'

      # Return the project settings
      project_settings
    end

    def self.projects

      self.attempt_resource 'projects', "/services/v5/projects"
    end

    def self.project

      self.attempt_resource 'project', "/services/v5/projects/#{project_settings.id}"
    end

    def self.stories offset = 0, state = ''

      with_state = "&with_state=#{state}" unless state == ''

      self.attempt_resource 'stories', "/services/v5/projects/#{project_settings.id}/stories?limit=5&offset=#{offset}#{with_state}", state

    end

    def self.tasks story_id

      self.attempt_resource 'tasks', "/services/v5/projects/#{project_settings.id}/stories/#{story_id}/tasks"
    end


    #
    # Attempt to get resourse
    # @param state [string] state of resourse started, finished, etc
    # @param path [string] path to resourse in api call
    #
    # @return [type] [description]
    def self.attempt_resource resource, path, state = ''

      with_state = " #{state} " unless state == ''

      # Error handling with begin and rescue
      begin

        # Make the api call
        response = self.get(path)

        # Cache the response
        parsed_response = response.parsed_response

        # Check to see if we are successful
        if !response.success?

          # If not raise an error
          raise '1'
        end

        # Check to see if the response was empty
        if parsed_response.empty?

          # If it is then raise an error
          raise '2'
        end

      # Rescue errors
      rescue Exception => e

        # Check to see what raise the error
        case e.message
        when '1'

          # Store errors to usable variables
          error   = parsed_response['code'].gsub('_',' ').capitalize
          message = parsed_response['error']

        when '2'

          # Create a message for empty resources
          message = "Could not find #{with_state} #{resource}"
        end

        # Set response back to an empty hash
        parsed_response = {}

        # Check to see if response was successful
        if e.message == '1'

          # If so then provide the error
          parsed_response['Error'] = error
        end


        # Provide the project id
        parsed_response['Project ID'] = project_settings.id

        # Check to see if the state was requested
        if state != ''

          # If so provide the state
          parsed_response['State'] = state
        end

        # Provide a somewhat formatted message
        parsed_response['Message'] = message.to_s.gsub('  ', ' ').gsub('. ', ".\n\t\t\s\s\s\s").gsub(', ', ",\n\t\t\s\s\s\s")

      end

      # Return response
      parsed_response
    end

  end
end