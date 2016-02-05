require 'digest'
class Robot
  attr_accessor :name, :city, :state, :avatar,
                :birthdate, :date_hired, :department, :id
  def initialize(properties= nil)
    self.robot_props.each do |key, value|
      self.send("#{key}=",value)
    end
    self.id = Random.rand(400000)
  end

  def robot_props
    bd = Faker::Time.between(Date.parse("2000-01-01"), DateTime.now-1)
    props = {name: Faker::Name.name,
     city: Faker::Address.city,
     state: Faker::Address.state_abbr,
     birthdate: bd,
     date_hired: Faker::Time.between(bd, DateTime.now),
     department: departments[Random.rand(departments.length)]}
    props[:avatar] = Faker::Avatar.image(Digest::SHA1.hexdigest(props.to_s))
    props
  end

  def departments
    ["Recreation", "Mining", "Data Collection", "Organization", "Posse Cup",
     "Administration", "Maintenance", "Education", "War"]
  end
end
