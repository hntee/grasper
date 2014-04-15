class GrasperController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  include GrasperHelper
  include TestHelper

  def index
    url = "http://www.walmart.com/search/search-ng.do?search_constraint=0&ic=48_0&search_query=batman&Find.x=0&Find.y=0&Find=Find"
    doc = Nokogiri::HTML(open(url))
    @mattVar = doc.at_css("title").text
  end

  def foo
    # @url = params[:url]
    # @foo = parse_a 'http://guides.rubyonrails.org/'
    @foo = Topic.new "http://cl.man.lv/htm_data/20/1404/1063468.html"

  end

  def download
    content = "chunky bacon\r\nis awesome"
    send_data content,  :filename => "bacon.txt" 
  end
end
