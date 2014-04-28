class AddUrlAndAuthorToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :url, :string
    add_column :articles, :author, :string
  end
end
