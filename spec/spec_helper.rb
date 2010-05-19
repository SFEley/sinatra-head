$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rack/test'
require 'spec'
require 'spec/autorun'
require 'capybara'
require 'capybara/dsl'

require 'sinatra/head'
require 'support/dummy_app'

# Stub out our application; it's silly, but we have to do it. (http://www.sinatrarb.com/testing.html)
module SinatraApp
  def app
    DummyApp
  end
end

Spec::Runner.configure do |config|
  include Rack::Test::Methods
  include Capybara
  include SinatraApp  
  Capybara.app = DummyApp
end

# Confirm our dummy app
describe "Dummy app" do
  it "returns a page" do
    visit('/')
    page.should have_content('Hello dummy')
  end
end
