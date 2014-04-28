class GrasperController < ApplicationController
  require 'nokogiri'
  require 'open-uri'
  # require 'pry'
  include GrasperHelper

  def index
  end

  def parse
    url    = params[:url]
    @topic  = Topic.new url, :parse_pages => 0..1

    @text =  "#{@topic.title} / #{@topic.author}\n"
    @text << "#{@topic.url}"
    @text << "\n\n---------\n\n"
    @text << @topic.author_posts.join("\n\n")

    @article = Article.new title:@topic.title, content:@text

    if @article.save
      redirect_to article_path(@article)
    else
      render plain: "error"
    end

  end

  def show
    @article = Article.where(id:params[:id]).first
    if @article
      render :show
    else
      render plain: "404"
    end
  end

  def download
    @article = Article.where(id:params[:id]).first
    content = @article.content
    title = @article.title
    send_data content, filename: "#{title}.txt"
    # send_file "#{Rails.root}/text/" + filename
  end
end
