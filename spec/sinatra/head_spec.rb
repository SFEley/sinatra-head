require File.dirname(__FILE__) + '/../spec_helper'

describe Sinatra::Head do
  it "displays the title" do
    get '/'
    last_response.body.should have_tag('title')
  end
  
end