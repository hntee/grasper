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
    @topic  = Topic.new url#, :parse_pages => 0..1

    @text =  "#{@topic.title} / #{@topic.author}\n"
    @text << "#{@topic.url}"
    @text << "\n\n---------\n\n"
    @text << @topic.author_posts.join("\n\n")

    filename = "#{@topic.title}.txt" 
    path = "#{Rails.root}/text/" + filename

    File.open(path, 'w+') do |f|
      f.write @text
    end
  end

  def download
    filename = params[:filename]
    send_file "#{Rails.root}/text/" + filename
  end
end
