#http://railscasts.com/episodes/219-active-model?view=asciicasthttp://railscasts.com/episodes/219-active-model?view=asciicast

class Theaters
  #include ActiveModel::Validations
  #include ActiveModel::Conversion
  #extend ActiveModel::Naming

  attr_accessor :tname, :tlink, :tid, :tmovies

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value) if respond_to?("#{name}=")
    end

  end


  def persisted?
    false
  end

end
