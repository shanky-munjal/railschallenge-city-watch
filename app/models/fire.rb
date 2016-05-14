class Fire < Responder
	scope :on_duty, -> {where(on_duty: true)}
	scope :order_by_capacity, -> {order("capacity DESC")}

	def self.find_for_dispatch(severity)
		selected_responder = []
		on_duty.order_by_capacity.each do |fire_responder|
			if severity > 0
				selected_responder.push(fire_responder.name)
				severity - fire_responder.capacity
			else
				break
			end
		end
		selected_responder
	end
end