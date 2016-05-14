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

	def find_responder
		responders = []
		responders.push(Fire.find_for_dispatch(self.fire_severity))
		responders.push(Police.find_for_dispatch(self.police_severity))
		responders.push(Medical.find_for_dispatch(self.medical_severity))
		responders
	end


end
