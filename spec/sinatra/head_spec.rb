require File.dirname(__FILE__) + '/../spec_helper'

describe Sinatra::Head do
  include DummyFixture
  
  before(:each) do
    visit '/'
  end
  
  it "displays the head" do
    page.should have_css('head')
  end
  
  it "has a title element" do
    within 'head' do
      page.should have_css('title')
    end
  end
  
    

end