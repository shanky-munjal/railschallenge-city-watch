class Fire < Responder
  def self.calculate_capacity
    fire_responders = all
    total_responders = fire_responders.map(&:capacity).sum
    total_available = fire_responders.where(dispatch: false).map(&:capacity).sum
    total_on_duty = fire_responders.where(on_duty: true).map(&:capacity).sum
    total_available_on_duty = fire_responders.where(on_duty: true).where(dispatch: false).map(&:capacity).sum
    [total_responders, total_available, total_on_duty, total_available_on_duty]
  end
end
