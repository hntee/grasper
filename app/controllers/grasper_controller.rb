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

    content = @topic.author_posts.join("\n\n")

    file_content =  "#{@topic.title} / #{@topic.author}\n" +
                    "#{@topic.url}" + 
                    "\n\n---------\n\n" +
                    content

    @article = Article.new title:@topic.title, url:@topic.url,
                           author:@topic.author,
                           content:content, 
                           file_content:file_content
                           
    if @article.save
      redirect_to articles_path(@article)
    else
      render plain: "error"
    end

  end

  # def show
  #   @article = Article.where(id:params[:id]).first
  #   if @article
  #     render :show
  #   else
  #     render :not_found
  #   end
  # end

  # def download
  #   @article = Article.where(id:params[:id]).first
  #   content = @article.content
  #   title = @article.title
  #   send_data content, filename: "#{title}.txt"
  # end
end
