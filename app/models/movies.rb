#locally defined per theater, not BNF-ish

class Movies

  attr_accessor :mname, :mlink, :mid, :mtimes, :mduration

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value) if respond_to?("#{name}=")
    end

       self.mduration = convert_duration
  end


  def persisted?
    false
  end


  def set_mtimes(times)
       pm = false
       times_24 = []
       now = Time.now
  
       #convert to '24hr' for consistency
       #start backwards to make sure its am or pm
       times.reverse_each do |t|

            hr, min = t[0].to_s.split(':', 2)

            #midnight seems to be latest
            if (!pm && min.include?("am") && hr.to_i == 12)
                 t = Time.new(now.year, now.month, now.day + 1,
                              hr.to_i - 12, min[/[0-9]+/])

            elsif (!pm && min.include?("am"))
                 pm = false

                 t = Time.new(now.year, now.month, now.day,
                              hr.to_i, min[/[0-9]+/])

            elsif (pm || min.include?("pm"))
                 pm = true
                 augment = 0
                 if (hr.to_i != 12)
                      augment = 12
                 end

                 t = Time.new(now.year, now.month, now.day,
                              hr.to_i + augment, min[/[0-9]+/])

            end

            times_24.push t
       end

       self.mtimes = times_24
  end


  def convert_duration
       hr = self.mduration.to_s[/([0-9]*)+hr/].to_i
       min = self.mduration.to_s[/([0-9]*)min/].to_i
       hr * 60 + min
  end

end
