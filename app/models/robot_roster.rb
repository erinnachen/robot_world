class RobotRoster
  attr_reader :database

  def initialize(database)
    @database = database
  end

  def create(properties = nil)
    robot_props = Robot.new(properties).robot_props
    database.transaction do
      database['robots'] ||= []
      database['total'] ||= 0
      database['total'] += 1
      robot_props[:id] = database['total']
      database['robots'] << robot_props
    end
  end

  def raw_robots
    database.transaction do
      database['robots'] || []
    end
  end

  def find(id)
    props = raw_robots.find {|data| data[:id] == id }
    Robot.new(props)
  end

  def update(robot, id)
    database.transaction do
      target_robot = database["robots"].find { |robot| robot[:id] == id }
      target_robot[:name] = robot[:name] unless robot[:name].empty?
      target_robot[:birthdate] = Time.parse(robot[:birthdate]) unless robot[:birthdate].empty?
      target_robot[:city] = robot[:city] unless robot[:city].empty?
      target_robot[:state] = robot[:state] unless robot[:state].empty?
      target_robot[:department] = robot[:department]
      target_robot[:date_hired] = Faker::Time.between(Time.parse(robot[:birthdate]), Time.now) unless Time.parse(robot[:birthdate]) < target_robot[:date_hired]
    end
  end

  def delete(id)
    database.transaction do
      database['robots'].delete_if { |robot| robot[:id] == id }
    end
  end

  def all
    raw_robots.map {|data| Robot.new(data)}
  end

end
