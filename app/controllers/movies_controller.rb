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
                    @ml = MovieListings.new(:ip_addr => request.remote_ip,
                                           :location => params[:location])

                    #calculate width and column size for display
                    #hour_blocks = (@ml.max_time - @ml.min_time) / 60 / 60
                    ##@col_size = (17 * 40 / hour_blocks).floor
                    #puts hour_blocks
                    #puts @col_size

                    puts @ml.min_time
                    puts @ml.max_time

                    @start_time = (@ml.min_time - @ml.min_time.min.minutes - @ml.min_time.sec.seconds) - 1.hour
                    @end_time = (@ml.max_time - @ml.max_time.min.minutes - @ml.max_time.sec.seconds) + 1.hour
                    @col_size = (@end_time - @start_time) /60 / 60
                    puts @start_time
                    puts @end_time
                    puts @col_size

                    #generate time headers based on that
                    #populate: use some % basis to margin-left the movie from start time
                    #width of movie as % duration of total time
                    

                    #render :json => { :listings => ml.listings }
               }


          end

     end

end
