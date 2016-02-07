require 'digest'

class Robot
  attr_accessor :name, :city, :state, :avatar,
                :birthdate, :date_hired, :department, :id
  def initialize(properties= nil)
    random_robot_props.each do |key, value|
      if properties
        value = properties[key] if properties[key]
      end
      self.send("#{key}=",value)
    end
    set_dates
  end

  def set_dates
    begin
    self.birthdate = Time.parse(birthdate) if birthdate.class == String
  rescue ArgumentError
      self.birthdate = random_robot_props[:birthdate]
    end
    self.birthdate = random_robot_props[:birthdate] if birthdate > Time.now
    self.date_hired = Time.parse(birthdate) if birthdate.class == String
    self.date_hired = Faker::Time.between(birthdate, Time.now) if date_hired < birthdate
  end

  def random_robot_props
    bd = Faker::Time.between(Time.parse("2000-01-01"), Time.now-10)
    props = {id: Random.rand(400000),
     name: Faker::Name.name,
     city: Faker::Address.city,
     state: Faker::Address.state_abbr,
     birthdate: bd,
     date_hired: Faker::Time.between(bd, Time.now),
     department: departments[Random.rand(departments.length)]}
    props[:avatar] = Faker::Avatar.image(Digest::SHA1.hexdigest(props.to_s))
    props
  end

  def robot_props
    {id: id,
     name: name,
     city: city,
     state: state,
     birthdate: birthdate,
     department: department,
     date_hired: date_hired,
     avatar: avatar}
  end

  def departments
    ["Recreation", "Mining", "Data Collection", "Organization", "Posse Cup",
     "Administration", "Maintenance", "Education", "War"]
  end


end
