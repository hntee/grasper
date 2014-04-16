class GrasperController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  include GrasperHelper
  include TestHelper

  def index
  end

  def foo
    # @url = params[:url]
    # @foo = parse_a 'http://guides.rubyonrails.org/'
    @foo = Topic.new "http://cl.man.lv/htm_data/20/1404/1063468.html"
    @text = @foo.author_posts.join
    content = @text
    send_data content,  :filename => "bacon.txt" 
  end

  def download
    content = "chunky bacon\r\nis awesome"
    send_data content,  :filename => "bacon.txt" 
  end
end
