class Time
  def label
    self.localtime.strftime("%d %b %I:%M%p %Z")
  end
end

class Date
  def label
    self.strftime("%d %b, %Y")
  end
end
