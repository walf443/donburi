
class Clock
  def initialize hour, minute=0, second=0
    raise ArgumentError if minute >= 60 or second >= 60

    @hour, @minute, @second = hour, minute, second
  end

  def self.from_sec sec
    hour = sec / 3600
    sec = sec - 3600 * hour
    min = sec / 60
    sec = sec - 60 * min

    new(hour, min, sec)
  end

  attr_reader :hour, :minute, :second

  def + anothor
    self.class.from_sec(self.to_i + anothor.to_i)
  end

  def - anothor
    self.class.from_sec(self.to_i - anothor.to_i)
  end

  def <=> anothor
    self.to_i <=> anothor.to_i
  end

  def to_i
    @hour * 3600 + @minute * 60 + @second
  end

  include Comparable
end

class TimeRange
  def initialize from, to
    @from, @to = from, to

    @a_day = case from
    when Clock
      Clock.new(24)
    else
      24
    end

    @diff = ( @from > @to ) ? ( @to + @a_day - @from ) : ( @to - @from )
  end

  def include? time
    return true if @from == @to && @from == time

    delta_time = ( @from > time ) ? time + @a_day - @from : time - @from
    (0...@diff.to_i).include?(delta_time.to_i)
  end

  def inspect
    "#<TimeRange: #{@from.inspect}...#{@to.inspect}>"
  end

end

if __FILE__ == $0
  require 'test/unit'

  class TestClock < Test::Unit::TestCase
    def test_equal
      assert_equal(Clock.new(10, 0, 0), Clock.new(10, 0, 0))
      assert_equal(Clock.new(10, 1, 0), Clock.new(10, 1, 0))
      assert_equal(Clock.new(10, 1, 1), Clock.new(10, 1, 1))
    end

    def test_less_than
      assert(Clock.new(10, 0, 0) < Clock.new(11, 0, 0), "hour")
      assert(Clock.new(10, 0, 0) < Clock.new(10, 1, 0), "minute")
      assert(Clock.new(10, 0, 0) < Clock.new(10, 0, 1), "second")
    end
    
    def test_greater_than
      assert(Clock.new(11, 0, 0) > Clock.new(10, 0, 0), "hour")
      assert(Clock.new(10, 1, 0) > Clock.new(10, 0, 0), "hour")
      assert(Clock.new(10, 0, 1) > Clock.new(10, 0, 0), "hour")
    end
  end

  class TestTimeRange < Test::Unit::TestCase
    def test_include
      normal_range = TimeRange.new(5, 20)

      assert(normal_range.include?(5), "start time should be in time")
      assert(!normal_range.include?(4), "before start time should not be in time")
      assert(normal_range.include?(6), "after start time should not be in time")

      assert(!normal_range.include?(20), "end time should not be in time")
      assert(normal_range.include?(19), "before end time should be in time")
      assert(!normal_range.include?(21), "after end time should be in time")
    end

    def test_include_reverse
      reverse_range = TimeRange.new(20, 5)

      assert(reverse_range.include?(20), "start time should be in time")
      assert(!reverse_range.include?(19), "before start time should not be in time")
      assert(reverse_range.include?(21), "after start time should be in time")

      assert(!reverse_range.include?(5), "end time should not be in time")
      assert(reverse_range.include?(4), "before end time should be in time")
      assert(!reverse_range.include?(6), "after end time should not be in time")
    end

    def test_include_same
      same_range = TimeRange.new(5, 5)

      assert(same_range.include?(5))
      assert(!same_range.include?(10))
    end

    def test_include_with_clock
      range_with_clock = TimeRange.new(Clock.new(10, 30), Clock.new(11, 15))

      assert(range_with_clock.include?(Clock.new(11, 10)), "it should be in time")

      assert(!range_with_clock.include?(Clock.new(10, 29)), "before start time should not be in time")
      assert(range_with_clock.include?(Clock.new(10, 30)), "start time should be in time")

      assert(range_with_clock.include?(Clock.new(11, 14)), "before end time should be in time")
      assert(!range_with_clock.include?(Clock.new(11, 15)), "end time should not be in time")
    end

    def test_include_with_clock_reverse
      range_with_clock = TimeRange.new(Clock.new(11, 30), Clock.new(5, 15))

      assert(range_with_clock.include?(Clock.new(11, 30)), "start time should be in time")
      assert(!range_with_clock.include?(Clock.new(11, 29)), "before start time should not be in time")

      assert(range_with_clock.include?(Clock.new(5, 14)), "before end time should be in time")
      assert(!range_with_clock.include?(Clock.new(5, 15)), "end time should not be in time")
    end
  end

end
