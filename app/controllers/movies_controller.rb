class MoviesController < ApplicationController

  require 'geoip'

  def show

    #if not passed in via post (i.e. selected) use default
    ip_addr = request.remote_ip
    g = GeoIP.new('GeoLiteCity.dat').city(ip_addr)
    coords = [g.latitude, g.longitude]






    #return results
    respond_to do |format|

      format.json { render :json => {:g =>g, :test => noko_movies(coords) } }
      format.html

    end

  end



  
private 
  #build request w/ location



  def noko_movies(coords)

    


  end



end
