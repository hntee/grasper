class AddFileContentToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :file_content, :string
  end
end
