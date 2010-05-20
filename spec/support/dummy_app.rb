require 'sinatra/base'

module DummyFixture
  # A simple dummy app to perform our tests against. We make our templates out of strings so that we
  # can change them easily in our tests.
  class DummyApp < Sinatra::Base
    set :environment, :test
    enable :inline_templates
  
    register Sinatra::Head
    title << 'High Level'
    stylesheets << 'main.css'
    javascripts << 'main.js'
  
    get "/" do
      haml :index
    end
  end
  
  class DummyChild < DummyApp
    title << 'Mid-Level'
    
    stylesheets << 'secondary.css'
    set :stylesheet_path, '/stuff/stylesheets'
    
    javascripts << 'secondary.js'
    set :javascript_path, '/things/javascript'
    
  end
  
  def app(klass=nil)
    if klass
      Capybara.app = klass
    else
      Capybara.app ||= DummyChild
    end
  end
end

__END__

@@ layout
%html
  =head_tag
  %body
    = yield

@@ index
Hello dummy!
