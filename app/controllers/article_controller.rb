class ArticleController < ApplicationController

 

  def show
    @article = Article.where(id:params[:id]).first
    if @article
      render :show
    else
      render :not_found
    end
  end

  def download
    @article = Article.where(id:params[:id]).first
    if @article
      content = @article.file_content
      title = @article.title
      send_data content, filename: "#{title}.txt"
    else
      render :not_found
    end
  end
end
