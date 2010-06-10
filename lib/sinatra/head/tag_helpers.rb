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
          #{charset_tag}
          #{title_tag}
          #{stylesheet_tags}
          #{javascript_tags}
        </head>
        HEAD_TAG
      end
      
      # Spits out a <meta> tag with the named charset.  Defaults to UTF-8, but you can override it 
      # with the Sinatra 'charset' setting.
      def charset_tag
        "<meta charset='#{settings.charset}' />"
      end
      
      # Spits out a <title> element with anything that's been added to the title by various actions.
      # The title array is treated like a stack; items are popped off of it in reverse order of 
      # inclusion.
      def title_tag
        "<title>#{title_string}</title>"
      end

      # Spits out a <link rel='stylesheet'> element for the given stylesheet reference.
      # Relative filenames will be expanded with the Sinatra assets path, if set.
      # If the filename string contains multiple words (separated by spaces), all
      # words after the first will be used for _media_ identifiers.
      #
      # @param [String] sheet
      def stylesheet_tag(reference)
        sheet, *media = reference.split
        if media.empty?
          "<link rel='stylesheet' href='#{expand_stylesheet_path(sheet)}' />"
        else
          "<link rel='stylesheet' href='#{expand_stylesheet_path(sheet)}' media='#{media.join(', ')}' />"
        end
      end
      
      # Spits out stylesheet tags for all declared stylesheets, one per line.
      def stylesheet_tags
        stylesheets.uniq.collect{|s| stylesheet_tag(s)}.join("\n")
      end
      
      # Spits out a <script src='filename'> element for the given javascript file.
      # Relative filenames will be expanded with the Sinatra assets path, if set.
      # 
      # EXCEPTION: If an item in 'javascripts' contains a semicolon, it will be interpreted
      # as Javascript source code instead of a filename, and will be included inline in the
      # script tag instead of on the 'src' element.
      # 
      # @param [String] script
      def javascript_tag(script)
        if script.include?(';')
          "<script>\n#{script}\n</script>"
        else
          "<script src='#{expand_javascript_path(script)}'></script>"
        end
      end
      
      # Spits out javascript tags for all declared scripts, one per line.
      def javascript_tags
        javascripts.uniq.collect{|s| javascript_tag(s)}.join("\n")
      end
      
    end
  end
end