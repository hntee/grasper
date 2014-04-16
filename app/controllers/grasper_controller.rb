class GrasperController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  # require 'pry'
  include GrasperHelper
  include TestHelper

  def index
  end

  def parse
    url    = params[:url]
    topic  = Topic.new url#, :parse_pages => 0..1
    # @text = topic.author_posts#.join
    @text =  "#{topic.title} / #{topic.author}\n"
    @text << "#{topic.url}"
    @text << "\n\n---------\n\n"
    @text << topic.author_posts.join("\n\n")
    # @shit = topic.pages_url
    # send_data @text,  :filename => "#{title}.txt" 

  end

  def download
    send_data @text,  :filename => "yea.txt" 
  end
end
