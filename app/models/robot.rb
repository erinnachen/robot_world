require 'digest'
require 'pry'
class Robot
  attr_accessor :name, :city, :state, :avatar,
                :birthdate, :date_hired, :department, :id
  def initialize(properties= nil)
    self.robot_props.each do |key, value|
      if properties
        value = properties[key] if properties[key]
      end
      self.send("#{key}=",value)
    end
    set_dates
  end

  def set_dates
    self.birthdate = Date.parse(birthdate) if birthdate.class == String
    self.date_hired = Faker::Time.between(birthdate, DateTime.now)
  end

  def robot_props
    bd = Faker::Time.between(Date.parse("2000-01-01"), DateTime.now-10)
    props = {id: Random.rand(400000),
     name: Faker::Name.name,
     city: Faker::Address.city,
     state: Faker::Address.state_abbr,
     birthdate: bd,
     department: departments[Random.rand(departments.length)]}
    props[:avatar] = Faker::Avatar.image(Digest::SHA1.hexdigest(props.to_s))
    props
  end

  def departments
    ["Recreation", "Mining", "Data Collection", "Organization", "Posse Cup",
     "Administration", "Maintenance", "Education", "War"]
  end


end
