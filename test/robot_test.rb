require 'test/unit'
require 'robot'

class RobotTest < Test::Unit::TestCase

  def setup
    @subject = Robot.new
  end

  def test_add_operation_parsing
    reply = @subject.operation_for("add chips")
    assert_equal(Robot::Operation::ADD, reply)
    reply = @subject.operation_for("we need chips")
    assert_equal(Robot::Operation::ADD, reply)
    reply = @subject.operation_for("we need more chips")
    assert_equal(Robot::Operation::ADD, reply)
  end

end
