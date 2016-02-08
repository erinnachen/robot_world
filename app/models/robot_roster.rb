class RobotRoster
  attr_reader :database

  def initialize(database)
    @database = database
  end

  def dataset
    database.from(:robots)
  end

  def create(properties = nil)
    robot_props = Robot.new(properties).robot_props
    robot_props.delete(:id)
    dataset.insert(robot_props)
  end

  def find(id)
    props = dataset.where(:id =>id)
    Robot.new(props.to_a[0]) unless props.to_a.empty?
  end

  def update(robot, id)

    target_robot = dataset.where(:id => id)
    return if target_robot.to_a.empty?

    target_robot.update(:name => robot[:name]) unless robot[:name].empty?
    target_robot.update(:city => robot[:city]) unless robot[:city].empty?
    target_robot.update(:state => robot[:state]) unless robot[:state].empty?
    target_robot.update(:department => robot[:department])

    unless robot[:birthdate].empty?
      target_robot.update(:birthdate => robot[:birthdate])
      if Time.parse(robot[:birthdate]) > Time.parse(dataset.select(:date_hired).where(:id => id).to_a[0][:date_hired])
        target_robot.update(:date_hired => Faker::Time.between(Time.parse(robot[:birthdate]), Time.now).to_s)
      end
    end
  end

  def delete(id)
    dataset.where(:id => id).delete
  end

  def all
    dataset.to_a.map {|data| Robot.new(data)}
  end

  def stats(date = nil)
    robots = all
    {avg_age: average_robot_age(robots, date),
     hires: calculate_hires_by_year(robots),
     num: robots.length}
  end

  private

  def calculate_hires_by_year(robots)
    robot_years = robots.group_by { |robot| robot.date_hired.year }
    num_hires = {}
    robot_years.each do |year, robs|
      num_hires[year] = robs.length
    end
    num_hires.sort_by {|year, hires| year }.reverse
  end

  def average_robot_age(robots, date)
    return 0 if robots.empty?
    if date
      date = Time.parse(date) if date.class != Time
    else
      date = Time.now
    end
    age_in_secs = robots.map {|robot| date-robot.birthdate}
    (age_in_secs.reduce(0,:+)/robots.length).round(2)
  end
end
