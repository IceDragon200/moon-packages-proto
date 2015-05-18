class String
  def to_duration
    Moon::TimeUtil.parse_duration(self)
  end
end
