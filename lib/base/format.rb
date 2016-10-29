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
      if !project.include? 'Sorry'

        # If so, send project to get rendered to the screen
        self.render_hash({
          '#'         => 1,
          'ID'        => project['id'],
          'Name'      => project['name'],
          'Points'    => project['point_scale'],
          'Velocity'  => project['velocity_averaged_over'],
          'Created'   => Time.iso8601(project['created_at']).strftime('%B %e,%l:%M %p'),
          'Updated'   => Time.iso8601(project['updated_at']).strftime('%B %e,%l:%M %p'),
        })
      else
        # If so, send story to get rendered to the screen
        self.render_hash(project, false)
        # abort
      end
    end

    #
    # Filter stories before sending them to be rendered
    # @param stories [hash] Hash of stories
    # @param number = 0 [int] Number of the story as a counter
    #
    # @return [void]
    def self.stories stories, state, number = 0

      # Check to see if any stories were passed in
      if stories.include?('Sorry') && number == 0

        # If not, send message to be rendered to the screen
        self.render_hash(stories, false)

        # End program
        abort

      elsif !stories.include?('Sorry')

        self.render_heading 'stories', state

        stories.each do |story|

          # If so, send story to get rendered to the screen
          self.render_hash({
            '#'         => number = number+1,
            'ID'        => story['id'],
            'Name'      => story['name'],
            'Estimated' => story.include?('estimate') ? story['estimate'] : 'Not Estimated',
            'Currently' => story['current_state'].capitalize,
            'Updated'   => Time.iso8601(story['updated_at']).strftime('%B %e,%l:%M %p'),
            'URL'       => story['url']
          })
        end
      end

      if stories.include?('Sorry') && number != 0 || stories.length < 5

        self.render_no_more
      end
    end

    #
    # Filter tasks before sending it to be rendered
    # @param tasks [hash] Hash of stories
    # @param number = 0 [int] Number of the tasks as a counter
    #
    # @return [void]
    def self.tasks tasks, story, number = 0, finish = true

      if !tasks.include? 'Sorry'

        self.render_heading 'tasks', story['name']

        tasks.each do |task|

          # If so, send task to get rendered to the screen
          self.render_hash({
            '#'           => number = number+1,
            'ID'          => task['id'],
            'Description' => task['description'],
            'Complete'    => task['complete'],
            'Updated'     => Time.iso8601(task['updated_at']).strftime('%B %e,%l:%M %p'),
          })
        end

      else

        self.render_heading 'tasks', story['name']

        # If so, send story to get rendered to the screen
        self.render_hash(tasks, false)

        if finish
          # abort
        end
      end
    end

    def self.render_heading type, meta = ''

      thor = Thor.new

      # Give me some spacers
      thor.say
      thor.say '-----------------------------------------------------------------------'
      thor.say

      # Let the user know what project we are looking at
      thor.say thor.set_color("Project: ".rjust(20)+$project_name.capitalize, :blue )

      case type
      when 'stories'

        # Cache the Sub Heading
        meta_heading = meta == '' ? 'All Stories' : meta.capitalize+" Stories"

        # Calculate the padding
        #
        # This math assumes that the current status and the word stories
        # character are no more than 19 characters. Being that the longest
        # status is unscheduled everything will line up nicely.
        meta_length = 28 - ((19 - meta_heading.length)/2)

        # Let the user know the current status of stories we are looking at
        thor.say thor.set_color(meta_heading.rjust(meta_length), :blue )

      when 'tasks'

        # Calculate the padding
        sub_heading   = "\s\s\s\s\e[4mStory:\e[0m"
        tasks_heading = "\s\s\s\s\e[4mTasks:\e[0m"


        # Let the user know the current status of stories we are looking at
        thor.say
        thor.say thor.set_color(sub_heading, :blue )
        thor.say
        thor.say self.reformat_wrapped meta.capitalize
        thor.say
        thor.say thor.set_color(tasks_heading, :blue )

      end
    end

    def self.reformat_wrapped(s, width=35)

      lines = []
      line  = ""

      s.split(/\s+/).each do |word|

        if line.size + word.size >= width

          lines << "\s\s#{line}"

          line = "\s\s#{word}"

        elsif line.empty?

         line = "\s\s#{word}"

        else

         line << " " << word
        end

      end

      lines << "\s\s"+line if line

      return lines.join "\n"
    end

    #
    # Render a has to the screen formatted nicely
    # @param message [hash] A hash of fields to output
    # @param number = 0 [int] [description]
    #
    # @return [echo] Renders to the screen
    def self.render_hash message, use_numbers = true

      # Instantiate Thor
      thor = Thor.new

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
          thor.say thor.set_color("\t#{k.rjust(11)}#{v}", :blue )

          # Add an underline under the first line
          underline = '--'

          # Set underline to blue and output it
          thor.say thor.set_color("\t#{underline.rjust(12)}", :blue )
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

    def self.render_no_more

      # Instantiate Thor
      thor = Thor.new

      # Output a spacer
      thor.say

      thor.say thor.set_color("You've reached the end of the road.".rjust(37), :yellow )
      thor.say thor.set_color("Please make a selection below.".rjust(35), :yellow )

      # Output a spacer
      thor.say
    end
  end
end



