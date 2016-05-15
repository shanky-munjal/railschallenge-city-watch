class Responder < ActiveRecord::Base
  scope :on_duty, -> { where(on_duty: true) }
  scope :order_by_capacity_desc, -> { order('capacity DESC') }
  scope :order_by_capacity_asc, -> { order('capacity asc') }
  scope :less_than_or_equal_severity, -> (severity) { where('capacity <= ?', severity) }
  scope :greater_than_severity, -> (severity) { where('capacity > ?', severity) }

  validates :type, :name, :capacity, presence: true
  # validates_inclusion_of :capacity, :in => 1..5, message: 'is not included in the list'
  validates :capacity, inclusion: { in: 1..5, message: 'is not included in the list' }
  validates :name, uniqueness: { message: 'has already been taken' }

  def as_json(*)
    {
      emergency_code: emergency_code,
      type: type,
      name: name,
      capacity: capacity,
      on_duty: on_duty
    }
  end

  def self.dispatch_for_emergency(severity, emergency_code)
    selected_responder, severity = available_responder_for_emergency(severity)
    dispatch_responder(selected_responder, emergency_code)
    [selected_responder.collect(&:name), severity <= 0]
  end

  def self.available_responder_for_emergency(severity)
    selected_responder = []
    on_duty.less_than_or_equal_severity(severity).order_by_capacity_desc.each do |responder|
      if severity > 0
        selected_responder.push(responder)
        severity -= responder.capacity
      else
        break
      end
    end
    if severity > 0
      just_greater_responder = on_duty.greater_than_severity(severity).order_by_capacity_asc.first
      selected_responder = [just_greater_responder] if just_greater_responder
    end
    [selected_responder, severity]
  end

  def self.dispatch_responder(responders, emergency_code)
    responders.each do |responder|
      responder.dispatch = true
      responder.emergency_code = emergency_code
      responder.save
    end
  end

  def self.make_available(emergency_code)
    where(emergency_code: emergency_code).find_each do |responder|
      responder.dispatch = false
      responder.emergency_code = nil
      responder.save
    end
  end
end
