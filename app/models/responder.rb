class Responder < ActiveRecord::Base
	# validates_numericality_of :capacity, :only_integer => true, :greater_than_or_equal_to => 1, :message => "is not included in the list"

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
end