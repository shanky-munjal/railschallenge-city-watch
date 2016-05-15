class Police < Responder
  def self.calculate_capacity
    police_responders = all
    total_responders = police_responders.map(&:capacity).sum
    total_available = police_responders.where(dispatch: false).map(&:capacity).sum
    total_on_duty = police_responders.where(on_duty: true).map(&:capacity).sum
    total_available_on_duty = police_responders.where(on_duty: true).where(dispatch: false).map(&:capacity).sum
    [total_responders, total_available, total_on_duty, total_available_on_duty]
  end
end
