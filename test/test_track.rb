require 'thor'
require 'fileutils'
require 'awesome_print'
require "time"
require "minitest/autorun"
require 'webmock/minitest'
require 'base/version'
require 'base/app_module'
require 'base/pivotal'
require 'base/tracker'

module SwiftlyPivotal

  describe PivotalTracker do

    before do

      $testing          = true
      $project_name     = 'TestProject'
      @project_settings = PivotalTracker.project_settings
    end

    describe "return project settings" do

      it "must return project setting" do

        assert @project_settings.name  == 'TestProject'
        assert @project_settings.id    == '5555555'
        assert @project_settings.token == '55555555555'

      end
    end

    describe "access web address" do

      it "This address must match the one being called in the api class" do

        @stub_project_get = stub_request(:get, "https://www.pivotaltracker.com/services/v5/projects/5555555")
          .to_return({body: '{
            "id"                              :1906937,
            "kind"                            :"project",
            "name"                            :"TestProject",
            "version"                         :132,
            "iteration_length"                :1,
            "week_start_day"                  :"Monday",
            "point_scale"                     :"0,1,2,3",
            "point_scale_is_custom"           :false,
            "bugs_and_chores_are_estimatable" :false,
            "automatic_planning"              :true,
            "enable_tasks"                    :true,
            "time_zone":{
              "kind"       :"time_zone",
              "olson_name" :"America/Los_Angeles",
              "offset"     :"-07:00"
            },
            "velocity_averaged_over"            :3,
            "number_of_done_iterations_to_show" :12,
            "has_google_domain"                 :false,
            "enable_incoming_emails"            :true,
            "initial_velocity"                  :10,
            "public"                            :false,
            "atom_enabled"                      :false,
            "project_type"                      :"private",
            "start_time"                        :"2016-10-24T07:00:00Z",
            "created_at"                        :"2016-10-26T01:56:40Z",
            "updated_at"                        :"2016-10-26T02:01:18Z",
            "account_id"                        :939667,
            "current_iteration_number"          :1,
            "enable_following"                  :true
          }'}
        )

        PivotalTracker.project

        assert_requested(@stub_project_get)
      end
    end

    describe "access web address" do

      it "This address must match the one being called in the api class" do

        @stub_stories_get = stub_request(:get, "https://www.pivotaltracker.com/services/v5/projects/5555555/stories?limit=5&offset=0")
          .to_return({body: '{
            "kind"            :"story",
            "id"              :133153763,
            "created_at"      :"2016-10-26T01:57:55Z",
            "updated_at"      :"2016-10-26T03:49:13Z",
            "accepted_at"     :"2016-10-26T03:49:12Z",
            "estimate"        :1,
            "story_type"      :"feature",
            "name"            :"Add the ability for a config to be read containing the api credentials",
            "current_state"   :"accepted",
            "requested_by_id" :3333333,
            "url"             :"https://www.pivotaltracker.com/story/show/133153763",
            "project_id"      :5555555,
            "owner_ids"       :[
              3333333
            ],
            "labels"          :[
            ],
            "owned_by_id"     :3333333
          }'}
        )

        PivotalTracker.stories

        assert_requested(@stub_stories_get)
      end
    end
  end
end