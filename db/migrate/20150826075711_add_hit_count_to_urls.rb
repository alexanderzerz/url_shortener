class AddHitCountToUrls < ActiveRecord::Migration
  def change
    add_column :urls, :hit_count, :integer
    change_column_default :urls, :hit_count, 0
  end
end
