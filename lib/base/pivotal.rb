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

      self.get("/services/v5/projects")
    end

    def self.project

      self.get("/services/v5/projects/#{project_settings.id}")
    end

    def self.stories offset = 0, with_state = ''

      with_state = "&with_state=#{with_state}" unless with_state == ''

      self.get("/services/v5/projects/#{project_settings.id}/stories?limit=5&offset=#{offset}#{with_state}")
    end

  end
end