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

        thor = Thor.new

        self.render_heading 'stories', state

        stories.each do |story|

          # If so, send story to get rendered to the screen
          self.render_hash({
            '#'         => number = number+1,
            'ID'        => story['id'],
            'Name'      => story['name'],
            'Tasks'     => story['tasks'].length,
            'Estimated' => story.include?('estimate') ? story['estimate'] : 'N',
            'Currently' => story['current_state'].capitalize,
            'Updated'   => Time.iso8601(story['updated_at']).strftime('%B %e,%l:%M %p'),
            'URL'       => story['url']
          })
        end

        thor.say
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
    def self.tasks story, number = 0, finish = true

      if !story['tasks'].empty?

        thor = Thor.new

        self.render_heading 'tasks', story

        story['tasks'].each do |task|

          # If so, send task to get rendered to the screen
          self.render_hash({
            '#'           => number = number+1,
            'ID'          => task['id'],
            'Description' => task['description'],
            'Complete'    => task['complete'],
            'Updated'     => Time.iso8601(task['updated_at']).strftime('%B %e,%l:%M %p'),
          }, true, false)
        end

        thor.say

      else

        self.render_heading 'tasks', story

        # If so, send story to get rendered to the screen
        self.render_hash(story['tasks'], false, false)

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
        thor.say

      when 'tasks'

        # Calculate the padding
        sub_heading    = "\s\s\s\s\e[4mStory:\e[0m"
        tasks_heading  = "\s\s\s\s\e[4mTasks:\e[0m"
        status_heading = "\s\s\s\s\e[4mStatus:\e[0m"
        id_heading     = "\s\s\s\s\e[4mId:\e[0m"

        output = ''

        name = self.reformat_wrapped meta['name'].capitalize

        output << "\n\n\s\s\s\s("
        output << thor.set_color(meta['url'].to_s, :blue)
        output << ')-('
        output << thor.set_color(meta['current_state'].capitalize, :yellow)
        output << ")\n\n"
        output << name

        thor.say output
        thor.say

      end
    end

    def self.reformat_wrapped(s, width=60)

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
    def self.render_hash message, use_numbers = true, story = true

      # Instantiate Thor
      thor = Thor.new

      # Set number to false indicating that
      # it has not been outputted yet
      numbered = false

      # Output a spacer
      thor.say

      if story
        output = ''
        output << '('
        output << thor.set_color(message['#'].to_s, :blue)
        output << ')-('
        output << thor.set_color(message['URL'], :blue)
        output << ')-('
        output << color_status(message['Currently'])
        output << ")\n\s\s\s\s("
        output << "Estimated #{message['Estimated']}"
        output << ')-('
        output << "Tasks #{message['Tasks']}"
        output << ')-('
        output << "Updated #{message['Updated']}"
        output << ")\n\n\s\s\s\s"
        output << message['Name']

      elsif !message.empty?

        status = message['Complete'] ? 'Is Completed' : 'Not Completed'

        output = ''
        output << "\s\s\s\s("
        output << thor.set_color(message['#'].to_s, :blue)
        output << ')-('
        output << thor.set_color("ID ##{message['ID']}", :blue)
        output << ')-('
        output << color_status(status)
        output << ")\n\s\s\s\s\s\s\s\s("
        output << "Updated #{message['Updated']}"
        output << ")\n\n\s\s\s\s\s\s\s\s"
        output << message['Description']

      end

      thor.say output
    end

    def self.color_status status

      thor = Thor.new

      case status
        when 'Accepted'

          color = :green
        when 'Delivered'

          color = :yellow
        when 'Finished'

          color = :orange
        when 'Started'

          color = :blue
        when 'Rejected'

          color = :red
        when 'Planned'

          color = :white
        when 'Unstarted'

          color = :white
        when 'Unscheduled'

          color = :white
      end

      thor.set_color(status, color)
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



