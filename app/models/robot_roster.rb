class RobotRoster
  attr_reader :database
  def initialize(database)
    @database = database
  end

  def create(properties = nil)
    if properties
      robot_props = {}
      properties.each do |key, value|
        robot_props[key.to_sym] = value
      end
    else
      robot_props = Robot.new.robot_props
    end
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

  def all
    raw_robots.map {|data| Robot.new(data)}
  end

end
