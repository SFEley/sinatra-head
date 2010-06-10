require File.dirname(__FILE__) + '/../spec_helper'

describe Sinatra::Head, "titles" do
  include DummyFixture
  

  before(:each) do
    @instance = app.new
  end
  
  it "can be appended to in a top-level class" do
    @instance.title.should include('High Level')
  end
  
  it "can be appended to in a subclass" do
    @instance.title.should include('Mid-Level')
  end
  
  it "can be appended to in an instance" do
    @instance.title << 'Low Level'
    @instance.title.should == ['High Level', 'Mid-Level', 'Low Level']
  end
    
  it "can be overridden" do
    @instance.title = 'Kaboom!'
    @instance.title.should == ['Kaboom!']
  end
  
  it "leaves its superclass's value alone" do
    instance = DummyFixture::DummyApp.new
    instance.title.should == ['High Level']
  end
  
  it "returns itself as a string" do
    @instance.title << 'Low Level'
    @instance.title_string.should == 'Low Level | Mid-Level | High Level'
  end
  
  it "only shows a given element once" do
    @instance.title << 'Mid-Level'
    @instance.title_string.should_not =~ /Mid-Level.*Mid-Level/
  end
  
  it "can set a different title separator" do
    class DummyGrandkid < DummyFixture::DummyChild
      set :title_separator, ' <*> '
    end
    
    instance = DummyGrandkid.new
    instance.title_string.should == 'Mid-Level <*> High Level'
  end
    
  it "knows how to make a tag" do
    @instance.title_tag.should == '<title>Mid-Level | High Level</title>'
  end
  
  it "shows up in the title tag" do
    class DummyGrandkid < DummyFixture::DummyChild
      get '/new' do
        title << 'Really Low Level'
        haml "This is something new."
      end
    end
    app DummyGrandkid

    visit '/new'
    page.locate('title').text.should == 'Really Low Level | Mid-Level | High Level'
  end
  
end