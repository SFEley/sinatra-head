require 'sinatra/base'

# A simple dummy app to perform our tests against. We make our templates out of strings so that we
# can change them easily in our tests.
class DummyApp < Sinatra::Base
  set :environment, :test
  enable :inline_templates
  
  get "/" do
    haml :index
  end
end

__END__

@@ layout
%html
  %head
  %body
    = yield

@@ index
Hello dummy!
