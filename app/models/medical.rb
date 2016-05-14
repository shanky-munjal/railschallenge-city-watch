class Medical < Responder
  # scope :on_duty, -> {where(on_duty: true)}
  # scope :order_by_capacity, -> {order("capacity DESC")}

  def self.dispatch_for_emergency(severity, emergency_code)
    selected_responder = []
    on_duty.less_than_or_equal_severity(severity).order_by_capacity_desc.each do |medical_responder|
      if severity > 0
        selected_responder.push(medical_responder)
        severity -= medical_responder.capacity
      else
        break
      end
    end
    if severity > 0
      just_greater_respnder = on_duty.greater_than_severity(severity).order_by_capacity_asc.first
      if just_greater_respnder
        selected_responder = [just_greater_respnder]
      end
    end
    dispatch_responder(selected_responder, emergency_code)
    return selected_responder.collect(&:name), severity <= 0
  end 
  def self.calculate_capacity
    medical_responders = all
    total_responders = medical_responders.map(&:capacity).sum
    total_available = medical_responders.where(dispatch: false).map(&:capacity).sum
    total_on_duty = medical_responders.where(on_duty: true).map(&:capacity).sum
    total_available_on_duty = medical_responders.where(on_duty: true).where(dispatch: false).map(&:capacity).sum
    return total_responders, total_available, total_on_duty, total_available_on_duty
  end 
end
