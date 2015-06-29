class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :url_long
      t.string :url_short

      t.timestamps null: false
    end
  end
end
