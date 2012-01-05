class CreateTheaters < ActiveRecord::Migration
  def change
    create_table :theaters do |t|

      t.timestamps
    end
  end
end
