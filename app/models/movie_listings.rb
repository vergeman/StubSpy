# -*- coding: utf-8 -*-
class MovieListings
     require 'net/http'
     require 'geoip'
     require 'open-uri'
     require 'nokogiri'

     attr_accessor :ip_addr, :theaters

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
          t = parse_doc get_doc get_coords(ip_addr)
          
          test_print(t)
          t
     end



     #algo time

     

     #utility and parsing foos
     private 

     def test_print(t)
          t.each { |z|
               puts z
               puts z.tid

               z.tmovies.each { |m| 
                    puts m.mname
                    puts m.mlink
                    puts m.mtimes
               }
          }          
     end

     #build request w/ location
     def get_coords(_ip_addr)
          g = GeoIP.new('GeoLiteCity.dat').city(_ip_addr)
          [g.latitude, g.longitude]
     end


     def get_doc(coords)
          #will pass a parameter to indicate want more results (i..e the 2dn page
          url = URI("http://google.com/movies?near="\
                    "#{coords[0]},#{coords[1]}&view=list")

          doc_str = Net::HTTP.get(url)
     end



     def parse_showtimes(movie_noko, movie, css_key)
          
          movie_noko.css(css_key).each do |t|

               showtimes = t.text.to_s.scan(/([0-9]+:[0-9]+[am|pm]*)/)

               movie.set_mtimes showtimes

               #Rails.logger.debug(movie.mtimes)
          end
     end



     def parse_movies(theater_noko, movies)
          theater_noko.css('.showtimes .movie').each do |m|

               ahref = m.css('.name a')

               movie = Movies.new(:mname => ahref.text.to_s,
                                  :mlink => ahref.to_s,
                                  :mid => ahref.attr('href').to_s[/mid(.*)/],
                                  :mduration => 
                                  m.css('.info').text.to_s[/([0-9]+hr(\s)[0-9]+min)+/])

               #grab showtimes
               parse_showtimes(m, movie, '.times')

               movies.push movie
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

                    theaters.push t_rec
               end

          end

          theaters
     end




end
