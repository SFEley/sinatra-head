$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'rack/test'
require 'spec'
require 'spec/autorun'
require 'capybara'
require 'capybara/dsl'

require 'sinatra/head'
require 'support/dummy_app'

Spec::Runner.configure do |config|
  include Rack::Test::Methods
  include Capybara
  Capybara.default_selector = :css
end

# Confirm our dummy app
describe "Dummy app" do
  include DummyFixture
  
  it "returns a page" do
    app DummyApp
    visit('/')
    page.should have_content('Hello dummy')
  end
end
