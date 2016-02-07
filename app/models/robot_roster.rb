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

  def all
    raw_robots.map {|data| Robot.new(data)}
  end

end
