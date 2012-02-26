#locally defined per theater, not BNF-ish

class Movies

  attr_accessor :mname, :mlink, :mid, :mtimes, :mduration, :mimg

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value) if respond_to?("#{name}=")
    end

       self.mduration = convert_duration

  end


  def persisted?
    false
  end

  #TODO: don't change to 24hr time if not already 24 hr time
  def set_mtimes(times)
       pm = false
       _24hr = true

       times_24 = []
       now = Time.now
  
       #convert to '24hr' for consistency
       #start backwards to make sure its am or pm
       times.reverse_each do |t|

            hr, min = t[0].to_s.split(':', 2)

            #change to pm
            if (min.include?("pm"))
                 pm = true
                 _24hr = false
            end

            #change from pm to am
            if (min.include?("am") && !_24hr)
                 pm = false
            end

            #only am start - hackish
            if (min.include?("am") && times.length < 3)
                 _24hr = false
            end

            if (_24hr)
                 augment =0
                 if (hr.to_i == 12)
                      augment = 12
                 end

                 t = Time.new(now.year, now.month, now.day,
                              hr.to_i - augment, min[/[0-9]+/]) + 24*60*60 #add a day
            elsif (pm)
                 augment = 0
                 if hr.to_i != 12
                      augment = 12
                 end
                 t = Time.new(now.year, now.month, now.day,
                              hr.to_i + augment, min[/[0-9]+/])

            elsif (!pm & !_24hr)
                 t = Time.new(now.year, now.month, now.day,
                              hr.to_i, min[/[0-9]+/])
            end

=begin
            #midnight seems to be latest
            if ((!pm && min.include?("am") && hr.to_i == 12) ||
                ((!pm && hr.to_i == 12)))
                 
                 t = Time.new(now.year, now.month, now.day,
                              hr.to_i - 12, min[/[0-9]+/]) + 24*60*60 #add a day

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
=end
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
