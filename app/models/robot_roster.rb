class RobotRoster
  attr_reader :database
  def initialize(database)
    @database = database
  end

  # def create(properties)
  #   database.transactions do
  #     database['robots'] ||= []
  #     database['total'] ||= 0
  #     database['total'] += 1
  #     raw_robot = { "id" => database['total']}
  #     properties.each do |key, value|
  #       raw_robot[key.to_s] = value
  #     }
  #     database['robots'] << properties
  #   end
  # end
  #
  # def raw_robots
  #   database.transactions do
  #     database['robots'] || []
  #   end
  # end
  #
  # def all
  #   raw_robots.map {|data| Robot.new(data)}
  # end

end
