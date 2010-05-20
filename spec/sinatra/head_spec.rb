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
  
  it "has a meta tag for the charset" do
    within 'head' do
      page.should have_css("meta[charset='utf-8']")
    end
  end
  
  it "lets you override the charset" do
    class DummyGrandkid < DummyFixture::DummyChild
      set :charset, 'iso-8859-1'
      get '/new' do
        title << 'Really Low Level'
        haml "This is something new."
      end
    end
    app DummyGrandkid

    visit '/'
    within 'head' do
      page.should have_css("meta[charset='iso-8859-1']")
    end    
  end
  
  
end