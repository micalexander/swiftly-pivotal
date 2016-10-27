module SwiftlyPivotal
  class Format

    include Helpers

    #
    # Filter project before sending it to be rendered
    # @param project [hash] Hash of project
    #
    # @return [void]
    def self.project project

      # Check to see if a project was passed in
      if project.parsed_response

        # If so, send project to get rendered to the screen
        self.render_hash({
          '#'         => 1,
          'ID'        => project.parsed_response['id'],
          'Name'      => project.parsed_response['name'],
          'Points'    => project.parsed_response['point_scale'],
          'Velocity'  => project.parsed_response['velocity_averaged_over'],
          'Created'   => Time.iso8601(project.parsed_response['created_at']).strftime('%B %e,%l:%M %p'),
          'Updated'   => Time.iso8601(project.parsed_response['updated_at']).strftime('%B %e,%l:%M %p'),
        })
      end
    end

    #
    # Filter stories before sending them to be rendered
    # @param stories [hash] Hash of stories
    # @param number = 0 [int] Number of the story as a counter
    #
    # @return [void]
    def self.stories stories, number = 0
      # puts stories.parsed_response
      # exit
      # Check to see if any stories were passed in
      if !stories.include? 'Error'

        stories.parsed_response.each do |story|

          # If so, send story to get rendered to the screen
          self.render_hash({
            '#'         => number = number+1,
            'ID'        => story['id'],
            'Name'      => story['name'],
            'Estimated' => story['estimate'],
            'Currently' => story['current_state'].capitalize,
            'Updated'   => Time.iso8601(story['updated_at']).strftime('%B %e,%l:%M %p'),
            'URL'       => story['url']
          })
        end

      else
          # If so, send story to get rendered to the screen
          self.render_hash(stories, false)
          abort
      end
    end

    #
    # Filter tasks before sending it to be rendered
    # @param tasks [hash] Hash of stories
    # @param number = 0 [int] Number of the tasks as a counter
    #
    # @return [void]
    def self.tasks tasks, number = 0

      if tasks.parsed_response.length > 0

        tasks.parsed_response.each do |task|

          # If so, send task to get rendered to the screen
          self.render_hash({
            '#'           => number = number+1,
            'ID'          => task['id'],
            'Description' => task['description'],
            'Complete'    => task['complete'],
            'Updated'     => Time.iso8601(task['updated_at']).strftime('%B %e,%l:%M %p'),
          })
        end
      end
    end



    #
    # Render a has to the screen formatted nicely
    # @param message [hash] A hash of fields to output
    # @param number = 0 [int] [description]
    #
    # @return [echo] Renders to the screen
    def self.render_hash message, use_numbers = true

      # Instantiate Thor
      thor     = Thor.new

      # Set number to false indicating that
      # it has not been outputted yet
      numbered = false

      # Output a spacer
      thor.say

      # Loop though set of key, values of the hash
      message.each do |k, v|

        # Check to see if the number has been displayed
        if !numbered && use_numbers

          # If not, set first line to blue and output it
          thor.say thor.set_color("\t#{k.rjust(11)}#{v}", :blue, :bold )

          # Add an underline under the first line
          underline = '--'

          # Set underline to blue and output it
          thor.say thor.set_color("\t#{underline.rjust(12)}", :blue, :bold )
        else

          # If so then just output it normally
          thor.say "\t#{k.rjust(10)}: #{v}"
        end

        # Set number to true to indicate that
        # it has already been outputted
        numbered = true
      end

      # Output a spacer
      thor.say
    end
  end
end



