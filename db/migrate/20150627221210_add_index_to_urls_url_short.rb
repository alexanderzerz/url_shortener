class AddIndexToUrlsUrlShort < ActiveRecord::Migration
  def change
  	add_index :urls, :url_short, unique: true
  end
end
