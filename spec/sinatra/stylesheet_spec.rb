require File.dirname(__FILE__) + '/../spec_helper'

describe Sinatra::Head, "stylesheets" do
  include DummyFixture
  
  
  class DummyFixture::DummyApp
    stylesheets << 'main.css'
  end
  
  class DummyFixture::DummyChild
    stylesheets << 'secondary.css'
    set :stylesheet_path, '/stuff/stylesheets'
  end
  
  before(:each) do
    app DummyFixture::DummyChild
    @instance = app.new
  end
  
  it "can be appended to in a top-level class" do
    @instance.stylesheets.should include('main.css')
  end
  
  it "can be appended to in a subclass" do
    @instance.stylesheets.should include('secondary.css')
  end
  
  it "can be appended to in an instance" do
    @instance.stylesheets << 'specific.css'
    @instance.stylesheets.should == ['main.css', 'secondary.css', 'specific.css']
  end

  
  it "expands the assets path for relative filenames" do
    @instance.expand_stylesheet_path(@instance.stylesheets.first).should == '/stuff/stylesheets/main.css'
  end
  
  it "leaves fully qualified hyperlinks intact" do
    @instance.stylesheets << 'http://google.com/google_style.css'
    @instance.expand_stylesheet_path(@instance.stylesheets[2]).should == 'http://google.com/google_style.css'
  end
  
  it "knows how to make a tag" do
    @instance.stylesheet_tag(@instance.stylesheets.first).should == "<link rel='stylesheet' href='/stuff/stylesheets/main.css' />"
  end
  
  it "knows how to make all the tags" do
    @instance.stylesheets << 'http://yahoo.com/yahoo_style.css'
    @instance.stylesheet_tags.should == "<link rel='stylesheet' href='/stuff/stylesheets/main.css' />\n<link rel='stylesheet' href='/stuff/stylesheets/secondary.css' />\n<link rel='stylesheet' href='http://yahoo.com/yahoo_style.css' />"
  end
  
  it "shows up in the header" do
    visit '/'
    within 'head' do
      page.should have_css("link[rel='stylesheet'][href='/stuff/stylesheets/main.css']")
      page.should have_css("link[rel='stylesheet'][href='/stuff/stylesheets/secondary.css']")
    end

  end
  
end