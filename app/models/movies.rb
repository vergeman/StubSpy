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


  def convert_duration
       hr = self.mduration.to_s[/([0-9]*)+hr/].to_i
       min = self.mduration.to_s[/([0-9]*)min/].to_i
       hr * 60 + min
  end

end
