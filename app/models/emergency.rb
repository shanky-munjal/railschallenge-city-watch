class Emergency < ActiveRecord::Base
  validates :code, :fire_severity, :police_severity, :medical_severity, presence: true
  validates_numericality_of :fire_severity, :police_severity, :medical_severity, :only_integer => true, message: "is not a number"
  validates_numericality_of :fire_severity, :greater_than_or_equal_to => 0, :if => :fire_severity_is_number?, :message => "must be greater than or equal to 0"
  validates_numericality_of :police_severity, :greater_than_or_equal_to => 0, :if => :police_severity_is_number?, :message => "must be greater than or equal to 0"
  validates_numericality_of :medical_severity, :greater_than_or_equal_to => 0, :if => :medical_severity_is_number?, :message => "must be greater than or equal to 0"
  validates :code, uniqueness: { :message => "has already been taken"}

  def fire_severity_is_number?
    self.fire_severity.is_a? Numeric
  end
  def police_severity_is_number?
    self.police_severity.is_a? Numeric
  end
  def medical_severity_is_number?
    self.medical_severity.is_a? Numeric
  end

  def dispatch_responder
    fire_responders, is_fire_done = Fire.dispatch_for_emergency(self.fire_severity, self.code)
    police_responders, is_police_done = Police.dispatch_for_emergency(self.police_severity, self.code)
    medical_responders, is_medical_done = Medical.dispatch_for_emergency(self.medical_severity, self.code)
    responders = fire_responders + police_responders + medical_responders
    responder_done = is_fire_done & is_police_done & is_medical_done
    return responders, responder_done
  end
end

