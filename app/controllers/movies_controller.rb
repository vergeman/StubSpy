class MoviesController < ApplicationController

  def show

    #will pass a parameter to indicate want more results (i..e the 2dn page

    #return results
    respond_to do |format|

      format.json {
        #if not passed in via post (i.e. selected) use default
        ml = MovieListings.new(:ip_addr => request.remote_ip)

        render :json => { :coords => ml.ip_addr }}

      format.html

    end

  end

end
