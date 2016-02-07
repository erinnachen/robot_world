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
      unless robot[:birthdate].empty?
        target_robot[:birthdate] = Time.parse(robot[:birthdate])
        if Time.parse(robot[:birthdate]) > target_robot[:date_hired]
          target_robot[:date_hired] = Faker::Time.between(Time.parse(robot[:birthdate]), Time.now)
        end
      end
      target_robot[:city] = robot[:city] unless robot[:city].empty?
      target_robot[:state] = robot[:state] unless robot[:state].empty?
      target_robot[:department] = robot[:department]
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

  def stats
    robots = all
    {avg_age: average_robot_age(robots),
     hires: calculate_hires_by_year(robots),
     num: robots.length}
  end

  def calculate_hires_by_year(robots)
    robot_years = robots.group_by { |robot| robot.date_hired.year }
    num_hires = {}
    robot_years.each do |year, robs|
      num_hires[year] = robs.length
    end
    num_hires.sort_by {|year, hires| year }.reverse
  end

  def average_robot_age(robots, date = nil)
    date ||= Time.now
    age_in_secs = robots.map {|robot| date-robot.birthdate}
    age_in_secs.reduce(0,:+)/robots.length
  end
end
