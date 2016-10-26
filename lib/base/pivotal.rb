require 'httparty'

module SwiftlyPivotal
  class PivotalTracker

    include Helpers
    include HTTParty

    headers 'X-TrackerToken' => '847d6b5ff008a5d79a5367fb3cc1b876'
    base_uri 'https://www.pivotaltracker.com'


    def self.config

      SwiftlyPivotal::Tracker.retrieve :pivotal, $project_name
    end

    def self.projects

      self.get("/services/v5/projects")
    end

    def self.project

      self.get("/services/v5/projects/#{config.id}")
    end

    def self.stories


      self.get("/services/v5/projects/#{config.id}/stories")
    end

  end
end