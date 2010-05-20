require 'sinatra/head/data_helpers'

# Helper methods 
module Sinatra
  module Head
    # Methods intended for view or layout templates, to generate the usual set of metadata and include tags.
    module TagHelpers
      
      # Spits out a default <head> element which incorporates the <meta> and <title> elements as well as any given
      # stylesheet or Javascript includes.  This is a convenience; if there are other things you want in your head,
      # there's no need to use this instead of making your own inside your layout.
      def head_tag
        <<-HEAD_TAG
        <head>
          #{title_tag}
          #{stylesheet_tags}
        </head>
        HEAD_TAG
      end
      
      # Spits out a <title> element with anything that's been added to the title by various actions.
      # The title array is treated like a stack; items are popped off of it in reverse order of 
      # inclusion.
      def title_tag
        "<title>#{title_string}</title>"
      end

      # Spits out a <link rel='stylesheet'> element for the given stylesheet reference.
      # Relative filenames will be expanded with the Sinatra assets path, if set.
      #
      # @param [String] sheet
      def stylesheet_tag(sheet)
        "<link rel='stylesheet' href='#{expand_stylesheet_path(sheet)}'>"
      end
      
      # Spits out stylesheet tags for all defined stylesheets, one per line.
      def stylesheet_tags
        stylesheets.collect{|s| stylesheet_tag(s)}.join("\n")
      end
      
    end
  end
end