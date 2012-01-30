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


                    #render :json => { :listings => ml.listings }
               }


          end

     end

end
