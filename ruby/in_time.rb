
class TimeRange
  def initialize from, to
    @from, @to = from, to

    @diff = ( @from > @to ) ? ( @to + 24 - @from ) : ( @to - @from )
  end

  def include? time
    return true if @from == @to && @from == time

    delta_time = ( @from > time ) ? time + 24 - @from : time - @from
    (0...@diff).include?(delta_time)
  end

end

if __FILE__ == $0
  require 'test/unit'

  class TestTimeRange < Test::Unit::TestCase
    def setup
      @normal_range = TimeRange.new(5, 20)
      @reverse_range = TimeRange.new(20, 5)
      @same_range = TimeRange.new(5, 5)
    end

    def test_include
      assert(@normal_range.include?(5), "start time should be in time")
      assert(!@normal_range.include?(4), "before start time should not be in time")
      assert(@normal_range.include?(6), "after start time should not be in time")

      assert(!@normal_range.include?(20), "end time should not be in time")
      assert(@normal_range.include?(19), "before end time should be in time")
      assert(!@normal_range.include?(21), "after end time should be in time")

    end

    def test_include_reverse
      assert(@reverse_range.include?(20), "start time should be in time")
      assert(!@reverse_range.include?(19), "before start time should not be in time")
      assert(@reverse_range.include?(21), "after start time should be in time")

      assert(!@reverse_range.include?(5), "end time should not be in time")
      assert(@reverse_range.include?(4), "before end time should be in time")
      assert(!@reverse_range.include?(6), "after end time should not be in time")
    end

    def test_include_same
      assert(@same_range.include?(5))
      assert(!@same_range.include?(10))
    end

  end

end
