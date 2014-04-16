class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :author
      t.text :content

      t.timestamps
    end
  end
end
