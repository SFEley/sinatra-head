require 'sinatra/base'

require 'sinatra/head/data_helpers'
require 'sinatra/head/tag_helpers'

module Sinatra
  module Head
    
    def self.registered(app)
      app.helpers DataHelpers
      app.helpers TagHelpers
      
      app.configure do
        app.set :charset, 'utf-8'

        app.set :title, []
        app.set :title_separator, ' | '
        
        app.set :stylesheets, []
        app.set :stylesheet_path, '/stylesheets'
        app.set :stylesheet_splitter, ' '
        
        app.set :javascripts, []
        app.set :javascript_path, '/javascript'        
      end
    end
    
    def inherited(child)
      super
      # Copy our arrays, because otherwise changes on subclasses will go upwards to superclasses
      child.set :title, title.clone
      child.set :stylesheets, stylesheets.clone
      child.set :javascripts, javascripts.clone
    end

  end
end