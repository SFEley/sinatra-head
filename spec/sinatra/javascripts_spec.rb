require File.dirname(__FILE__) + '/../spec_helper'

describe Sinatra::Head, "javascripts" do
  include DummyFixture
  
  
  class DummyFixture::DummyApp
    javascripts << 'main.js'
  end
  
  class DummyFixture::DummyChild
    javascripts << 'secondary.js'
    set :javascript_path, '/things/javascript'
  end
  
  before(:each) do
    app DummyFixture::DummyChild
    @instance = app.new
  end
  
  it "can be appended to in a top-level class" do
    @instance.javascripts.should include('main.js')
  end
  
  it "can be appended to in a subclass" do
    @instance.javascripts.should include('secondary.js')
  end
  
  it "can be appended to in an instance" do
    @instance.javascripts << 'specific.js'
    @instance.javascripts.should == ['main.js', 'secondary.js', 'specific.js']
  end

  
  it "expands the assets path for relative filenames" do
    @instance.expand_javascript_path(@instance.javascripts.first).should == '/things/javascript/main.js'
  end
  
  it "leaves fully qualified hyperlinks intact" do
    @instance.javascripts << 'http://google.com/google_script.js'
    @instance.expand_javascript_path(@instance.javascripts[2]).should == 'http://google.com/google_script.js'
  end
  
  it "knows how to make a tag" do
    @instance.javascript_tag(@instance.javascripts.first).should == "<script src='/things/javascript/main.js'></script>"
  end
  
  it "can make a tag for inline code" do
    @instance.javascripts << "window.onload=alert('This is a page!');"
    @instance.javascript_tag(@instance.javascripts[2]).should == "<script>\nwindow.onload=alert('This is a page!');\n</script>"
  end
  
  
  it "knows how to make all the tags" do
    @instance.javascripts << 'http://yahoo.com/yahoo_script.js'
    @instance.javascript_tags.should == "<script src='/things/javascript/main.js'></script>\n<script src='/things/javascript/secondary.js'></script>\n<script src='http://yahoo.com/yahoo_script.js'></script>"
  end
  
  it "shows up in the header" do
    visit '/'
    within 'head' do
      page.should have_css("script[src='/things/javascript/main.js']")
      page.should have_css("script[src='/things/javascript/secondary.js']")
    end
  end
  
end