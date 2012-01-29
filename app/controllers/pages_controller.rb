class PagesController < ApplicationController
  def home
       respond_to do |format| 
            format.html {
                 ip_addr = request.remote_ip
                 @location  = MovieListings.get_geo(ip_addr)
            }
       end
  end

end
