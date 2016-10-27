module SwiftlyPivotal
  class Format

    include Helpers

    def self.project project

    end

    def self.stories stories

      thor   = Thor.new
      number = 0

      if stories


        stories.each do |story|

          numbered = false
          message  = {
            '#'         => thor.set_color( number = number+1, :blue, :bold ),
            'ID'        => story['id'],
            'Name'      => story['name'],
            'Estimated' => story['estimate'],
            'Currently' => story['current_state'].capitalize,
            'Updated'   => Time.iso8601(story['updated_at']).strftime('%B %e,%l:%M %p'),
            'URL'       => story['url']
          }

          thor.say

          message.each do |k, v|

            if !numbered

              underline = '--'
              thor.say thor.set_color("\t#{k.rjust(11)}#{v}", :blue, :bold )
              thor.say thor.set_color("\t#{underline.rjust(12)}", :blue, :bold )

            else
              thor.say "\t#{k.rjust(10)}: #{v}"

            end


            numbered = true
          end

          thor.say

        end
      end
    end
  end
end



