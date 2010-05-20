require 'sinatra/base'

require 'sinatra/head/data_helpers'
require 'sinatra/head/tag_helpers'

module Sinatra
  module Head
    
    # # Exposes the 'title' setting so that it can be overwritten or appended to.
    # # @see DataHelpers#title
    # def title
    #   settings.title
    # end
    # 
    # # Exposes the 'stylesheets' setting so that it can be overwritten or appended to.
    # # @see DataHelpers#stylesheets
    # def stylesheets
    #   settings.stylesheets
    # end
    
    def self.registered(app)
      app.helpers DataHelpers
      app.helpers TagHelpers
      
      app.configure do
        app.set :charset, 'utf-8'

        app.set :title, []
        app.set :title_separator, ' | '
        
        app.set :stylesheets, []
        app.set :stylesheet_path, '/stylesheets'
        
        app.set :javascripts, []
        app.set :javascript_path, '/javascript'        
      end
    end
  end
end