require 'httparty'

module SwiftlyPivotal
  class PivotalTracker

    include Helpers
    include HTTParty

    headers 'X-TrackerToken' => '847d6b5ff008a5d79a5367fb3cc1b876'
    base_uri 'https://www.pivotaltracker.com'


    def self.project_settings

      SwiftlyPivotal::Tracker.retrieve :pivotal, $project_name
    end

    def self.projects

      self.attempt_resourse "/services/v5/projects"
    end

    def self.project

      self.attempt_resourse "/services/v5/projects/#{project_settings.id}"
    end

    def self.stories offset = 0, state = ''

      with_state = "&with_state=#{state}" unless state == ''

      self.attempt_resourse state, "/services/v5/projects/#{project_settings.id}/stories?limit=5&offset=#{offset}#{with_state}"

    end

    def self.tasks story_id, state = ''

      state = "?with_state=#{state}" unless state == ''

      self.attempt_resourse state, "/services/v5/projects/#{project_settings.id}/stories/#{story_id}/tasks"
    end

    def self.attempt_resourse state, path

      begin

        response = self.get(path)

        if !response.success?

          raise response.parsed_response['error']
        end

      rescue Exception => e

        error    = response.parsed_response['code'].gsub('_',' ').capitalize
        response = {}

        response['Error']      = error
        response['Project ID'] = project_settings.id
        response['State']      = state unless state == ''
        response['Message']    = e.to_s.gsub('  ', ' ').gsub('. ', ".\n\t\t\s\s\s\s").gsub(', ', ",\n\t\t\s\s\s\s")

      end

      response
    end

  end
end