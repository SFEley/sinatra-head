module Sinatra
  module Head
    
    # Helpers intended to be used in your Sinatra actions rather than your views.  (Yes, you can use them both places,
    # but setting any of these in a view _after_ your layout's rendered the <head> element is sort of pointless.)
    module DataHelpers
      # Exposes an array of title elements that you can read or add to.  Can be set at both the class and
      # instance (action) level.
      #
      # @example Recommended usage
      #   class MyApp < Sinatra::Base
      #     register Sinatra::Head
      #     title << 'My Application'
      #     
      #     get '/people' do
      #       title << 'Directory'
      #     end
      #   end
      #
      # This will create a title by default that looks like:
      #   Directory | My Application
      def title
        @title ||= Array(settings.title.clone)
      end
      
      # Overrides any title elements you've already set.  It's more conventional to use the << operator instead.
      def title=(val)
        @title = Array(val)
      end
      
      # Returns the title elements you've set, in reverse order, separated by ' | '.  (You can override this with
      # a Sinatra option: `set :title_separator, ' <*> '`)
      def title_string
        title.uniq.reverse.join(settings.title_separator)
      end
      
      # Exposes an array of stylesheets.  Can be set at both the class and the instance (action) level.
      # Full hyperlinks or relative filenames can be set; if relative, the final result will include the
      # Sinatra stylesheet_path setting.
      # @example Recommended usage
      #   class MyApp < Sinatra::Base
      #     register Sinatra::Head
      #     stylesheets << 'main.css'
      #     stylesheets << 'http://example.org/some_famous_grid_stylesheet.css'
      #
      #     get '/form' do
      #       stylesheets << 'form.css'
      #     end
      #   end
      def stylesheets
        @stylesheets ||= Array(settings.stylesheets.clone)
      end
      
      # Returns the full path for a stylesheet's filename, with the Sinatra `stylesheet_path` setting
      # prepending it.  Full hyperlinks are not altered.
      def expand_stylesheet_path(sheet)
        if sheet =~ %r{^https?://}
          sheet
        else
          File.join(settings.stylesheet_path, sheet)
        end
      end
      
      # Exposes an array of javascript sources.  Can be set at both the class and the instance (action) level.
      # Full hyperlinks or relative filenames can be set; if relative, the final result will include the
      # Sinatra stylesheet_path setting.
      # @example Recommended usage
      #   class MyApp < Sinatra::Base
      #     register Sinatra::Head
      #     javascripts << 'main.js'
      #     javascripts << 'http://example.org/some_popular_script.js'
      #
      #     get '/form' do
      #       javascripts << 'form.js'
      #     end
      #   end
      def javascripts
        @javascripts ||= Array(settings.javascripts.clone)
      end
      
      # Returns the full path for a javascript source's filename, with the Sinatra `javascript_path` setting
      # prepending it.  Full hyperlinks are not altered.
      def expand_javascript_path(script)
        if script =~ %r{^https?://}
          script
        else
          File.join(settings.javascript_path, script)
        end
      end
      
    end
    
  end
end