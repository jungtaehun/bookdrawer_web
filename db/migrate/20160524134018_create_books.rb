class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|

      t.string :title
      t.string :type
      t.string :author
      t.string :writer
      t.text :description
      t.text :content
      t.string :img

      t.timestamps null: false
    end
  end
end
