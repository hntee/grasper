class GrasperController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  include GrasperHelper
  include TestHelper

  def index
  end

  def parse
    url = "http://www.douban.com/group/topic/18524871/"
    topic = Topic.new url
    @text = topic.author_posts.join
    send_data @text,  :filename => "yea.txt" 
  end

  def download
    send_data @text,  :filename => "yea.txt" 
  end
end
