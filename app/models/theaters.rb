#http://railscasts.com/episodes/219-active-model?view=asciicasthttp://railscasts.com/episodes/219-active-model?view=asciicast
TIME_BUF = 20

class Theaters
  #include ActiveModel::Validations
  #include ActiveModel::Conversion
  #extend ActiveModel::Naming

  attr_accessor :tname, :tlink, :tid, :tmovies, :tcalc


  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value) if respond_to?("#{name}=")
    end

  end


  def persisted?
    false
  end

=begin
T1
     M1--------M1------M1-------
M2----------M2--------M2-------
=end
  #algo here

  Movie_tuple = Struct.new(:name, :time, :duration)

  def calc
       results = []

       movie_tuples = []
       populate movie_tuples

       while (!movie_tuples.empty?)
            movie_time = movie_tuples.pop
            neighbors = find_neighbors(movie_time) #returns []

            if !neighbors.empty?
                 neighbors.each { |neighbor| 
                      movie_tuples.push(movie_time.clone.push(neighbor))
                 }
            else
                 results.push({:movie_times => movie_time,
                                   :score => movie_time.length })
            end
       end

       results.sort { |x,y| y[:score] <=> x[:score] }
  end


  #iterate through movie times, see if there is a movie within range
  #of the "latest_movie"

  def get_next_time(latest_movie, movie)
       #last movie is Movie_tuple v. movie obj
       m_time = latest_movie.time + latest_movie.duration.minutes

       movie.mtimes.each { |time|
            #puts movie.mname
            #puts time

            if ((time > m_time) && (time < m_time + TIME_BUF.minutes))
                 return Movie_tuple.new(movie.mname, time, movie.mduration)
            end
       }

       return nil
  end


  #finds "neighboring" movies
  #movie time is an [Movie_tuple]
  def find_neighbors(movie_time)

       neighbors = []
       latest_movie = movie_time[-1]

       movie_names = []
       movie_time.each { |m| movie_names.push(m.name) }

       self.tmovies.each { |movie|

            if (!movie_names.include?(movie.mname))

                 #get_next_time returns Movie_tuple or nil
                 neighbor = get_next_time(latest_movie, movie)

                 unless neighbor.nil?
                      neighbors.push(neighbor)
                 end

            end
       }

       return neighbors
  end


  def populate(movie_tuples)

       self.tmovies.each { |movie| 

            movie.mtimes.each { |time| 
                 m = []
                 m.push(Movie_tuple.new(movie.mname, time, movie.mduration))
                 movie_tuples.push(m)
            }
            
       }
  end




end
