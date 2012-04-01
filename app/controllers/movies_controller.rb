class MoviesController < ApplicationController

     def show

          #TODO: will pass a parameter to
          #indicate want more results (i..e the 2dn page

          #return results
          respond_to do |format|

               format.json {
                    #if not passed in via post (i.e. selected) use default
                    ml = MovieListings.new(:ip_addr => request.remote_ip)

                    render :json => { :listings => ml.listings }                
               }
               
               format.html {
                    @movie_view = true
                    @location = params[:location]

                    @ml = MovieListings.new(:ip_addr => request.remote_ip,
                                           :location => @location)

                    #calculate width and column size for display
                    @start_time = (@ml.min_time - @ml.min_time.min.minutes - 
                                   @ml.min_time.sec.seconds) - 1.hour

                    @end_time = (@ml.max_time - @ml.max_time.min.minutes - 
                                 @ml.max_time.sec.seconds) + 1.hour

                    @col_size = (@end_time - @start_time) / 60 / 60

                    #generate time headers based on that
                    #populate: use some % basis to margin-left the movie from start time
                    #width of movie as % duration of total time

               }


          end

     end

end
