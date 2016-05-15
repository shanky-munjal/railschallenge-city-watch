class Medical < Responder
  def self.calculate_capacity
    medical_responders = all
    total_responders = medical_responders.map(&:capacity).sum
    total_available = medical_responders.where(dispatch: false).map(&:capacity).sum
    total_on_duty = medical_responders.where(on_duty: true).map(&:capacity).sum
    total_available_on_duty = medical_responders.where(on_duty: true).where(dispatch: false).map(&:capacity).sum
    [total_responders, total_available, total_on_duty, total_available_on_duty]
  end
end
