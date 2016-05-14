class Responder < ActiveRecord::Base
  scope :on_duty, -> {where(on_duty: true)}
  scope :order_by_capacity_desc, -> {order("capacity DESC")}
  scope :order_by_capacity_asc, -> {order("capacity asc")}
  scope :less_than_or_equal_severity, -> (severity) {where("capacity <= ?", severity)}
  scope :greater_than_severity, -> (severity) {where("capacity > ?", severity)}

  validates :type, :name, :capacity, presence: true
  validates_inclusion_of :capacity, :in => 1..5, :message => "is not included in the list"
  validates :name, uniqueness: { :message => "has already been taken"}

  def as_json options={}
    {
      emergency_code: emergency_code,
      type: type, 
      name: name, 
      capacity: capacity, 
      on_duty: on_duty
    }
  end

  def self.dispatch_responder(responders, emergency_code)
    responders.each do |responder| 
      responder.dispatch = true
      responder.emergency_code = emergency_code
      responder.save
    end
    
  end

  def self.make_available(emergency_code)
    where(emergency_code: emergency_code).each do |responder|
      responder.dispatch = false
      responder.emergency_code = nil
      responder.save
    end
  end
end