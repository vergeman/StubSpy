# -*- coding: utf-8 -*-
class MovieListings
     require 'net/http'
     require 'geoip'
     require 'open-uri'
     require 'nokogiri'

     require 'thread'

     attr_accessor :ip_addr, :location, :theaters, :listings, 
     :min_time, :max_time, :all_movies

     def initialize(attributes = {})
          attributes.each do |name, value|
               send("#{name}=", value) if respond_to?("#{name}=")
          end

          unless attributes[:ip_addr].empty?
               self.theaters = load               
          end

     end

     def persisted?
          false
     end

     #build listings
     def load

          #TODO: select from cache based on ip_addr / location
          self.listings = []
          coords = get_coords(ip_addr)

          #TODO: probably move this out to a separate function 
          #(handle zips, city, etc)

          #determining location data to use
          #if no location, use geo coords
          #if location param input is different (ie user input), use it instead
          #otherwise, use coords generated by ip since of finer location
          unless self.location.empty?

               loc = MovieListings.get_geo(ip_addr)

               if self.location != "#{loc.city_name}, #{loc.region_name}"
                    coords = self.location.to_s.split(',')
                    coords[0].strip!

                    #allow zipcodes or hoods
                    unless coords[1].nil?
                         coords[1].strip!
                    end
               end

          end

          #a hash of unique movie objs (mid, movie_obj)
          #populated in parse_doc->parse_movies
          self.all_movies = {}
          theaters = parse_doc get_doc coords

          #get image information
          threads = []
          self.all_movies.each do |mid, movie|
               threads << Thread.new(mid, movie) do
                    movie.mimg = get_img(coords, mid)
               end
          end

          threads.each do |t|
               t.join
          end

          #foreach theater, calc and grab max/min times for layoaut
          theaters.each { |theater|
               #puts theater.tname

               results = theater.calc

               #theater max time = start movie + duration + buffer (20min)
               set_min_max_time(theater.min_time, theater.max_time)


               self.listings.push( {:tname => theater.tname,
                                        :tid => theater.tid,
                                        :list => results,
                                        :tscore => results.length} )


          }

          #self.listings.sort! { |x,y| y[:tscore] <=> x[:tscore] }

          #alphabetize 'all_movies' filter for easy viewing
          self.all_movies = self.all_movies.sort_by {|mid, movie| movie.mname}
          theaters
     end

     #get default location (static call)
     def self.get_geo(_ip_addr)
          g = GeoIP.new('GeoLiteCity.dat').city(_ip_addr)
     end




     #utility and parsing foos
     private

     def set_min_max_time(min, max)

          if self.min_time.nil? || self.min_time > min
               self.min_time = min
          end

          if self.max_time.nil? || self.max_time < max
               self.max_time = max
          end
     end


     #build request w/ location ==> return pair of lat/long
     def get_coords(_ip_addr)
          g = GeoIP.new('GeoLiteCity.dat').city(_ip_addr)
          [g.latitude, g.longitude]
     end


     def get_doc(coords)
          #will pass a parameter to indicate want more results (i..e the 2dn page
          url = URI(URI.encode("http://google.com/movies?near="\
                    "#{coords[0]},#{coords[1]}\&view=list"))

          doc_str = Net::HTTP.get(url)
     end


     #TODO: make this check cache so avoid requests
     def get_img(coords, mid)
          url = URI(URI.encode("http://google.com/movies?near=#{coords[0]}, #{coords[1]}&mid=#{mid}"))


          doc_str = Net::HTTP.get(url)
          doc = Nokogiri::HTML(doc_str)

#working here
          str = nil
          if doc.css('.img img').empty?
               return nil
          else
               str = doc.css('.img img').attr('src').to_s
               if str.include?('tbn')
                    return str
               end
          end
               return nil
     end


     def parse_showtimes(movie_noko, movie, css_key)
          
          movie_noko.css(css_key).each do |t|

               showtimes = t.text.to_s.scan(/([0-9]+:[0-9]+[am|pm]*)/)

               movie.set_mtimes showtimes

          end
     end



     def parse_movies(theater_noko, movies)

          theater_noko.css('.showtimes .movie').each do |m|

               ahref = m.css('.name a')

               #some movies lack detailed information
               unless m.css('.info').text.to_s[/([0-9]+hr(\s)[0-9]+min)+/].nil?
                    movie = Movies.new(:mname => ahref.text.to_s,
                                       :mlink => ahref.to_s,
                                       :mid => ahref.attr('href').to_s[/mid=(.+)/, 1].to_s,
                                       :mduration => 
                                       m.css('.info').text.to_s[/([0-9]+hr(\s)[0-9]+min)+/])

                    #add to hash of all unique movies
                    #(not theater specific! mduration, mtimes not valid)
                    self.all_movies[movie.mid] = movie

                    #grab showtimes
                    parse_showtimes(m, movie, '.times')

                    movies.push movie
               end
          end
     end


     def parse_doc(doc_str)
          theaters = []

          doc = Nokogiri::HTML(doc_str)

          #parse by theater
          doc.css('#movie_results .movie_results .theater').each do |theater|

               theater.css('h2 a').each do |t|

                    movies = []
                    t_rec = Theaters.new(:tname => t.content,
                                         :tlink => t.to_s.gsub(/&amp;/, "&"),
                                         :tid => t.attr('id').to_s[/[0-9]+\z/])

                    #grab movies foreach theater        
                    parse_movies(theater, movies)

                    t_rec.tmovies = movies

                    #arthouses/museums tend to have only movies w/
                    #no information, so make sure we don't make a theater
                    #of 'no movies'
                    unless t_rec.tmovies.empty?
                         theaters.push t_rec
                    end

               end

          end

          theaters
     end




end
