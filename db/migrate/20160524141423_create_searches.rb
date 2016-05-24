class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :title
      t.string :author
      t.integer :isbn

      t.timestamps null: false
    end
  end
end
