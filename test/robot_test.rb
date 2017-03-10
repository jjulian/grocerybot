require 'test/unit'
require 'robot'

class RobotTest < Test::Unit::TestCase

  def setup
    @subject = Robot.new(creator: '14445556666')
  end

  def test_add_operation_parsing
    reply = @subject.operation_for("add chips")
    assert_equal(Robot::Operation::ADD, reply)
    reply = @subject.operation_for("we need chips")
    assert_equal(Robot::Operation::ADD, reply)
  end

  def test_unknown_operation_parsing
    reply = @subject.operation_for("pop chips")
    assert_equal(Robot::Operation::UNKNOWN, reply)
  end

  def test_items_parsing
    items = @subject.parse_items_from("add chips")
    assert_equal(['chips'], items)
    items = @subject.parse_items_from("add chips, cookies")
    assert_equal(['chips','cookies'], items)
    items = @subject.parse_items_from("add chips,cookies")
    assert_equal(['chips','cookies'], items)
    items = @subject.parse_items_from("please add chips, peeled garlic")
    assert_equal(['chips','peeled garlic'], items)
    items = @subject.parse_items_from("please add")
    assert_equal([], items)
  end

end
