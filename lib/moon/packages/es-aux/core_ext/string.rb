class String
  # Parses the current string as a time notation see
  # {Moon::TimeUtil.parse_duration}
  #
  # @return [Float]
  def to_duration
    Moon::TimeUtil.parse_duration(self)
  end
end
