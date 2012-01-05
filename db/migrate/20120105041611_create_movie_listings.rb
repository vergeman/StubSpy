class CreateMovieListings < ActiveRecord::Migration
  def change
    create_table :movie_listings do |t|

      t.timestamps
    end
  end
end
