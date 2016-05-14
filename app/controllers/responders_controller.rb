class RespondersController < ApplicationController
	def create
		# debugger
		@responder = Responder.new(responder_params)
		
		respond_to do |format|
			if @responder.save
				format.json { render json: {responder: {emergency_code: nil, type: @responder.type, name: @responder.name, capacity: @responder.capacity, on_duty: false}} , status: :created }
			else
				format.json { render json: {message: @responder.errors.messages}, status: :unprocessable_entity }
			end
		end
	end

	private
	def set_responder
		@responder = Responder.find(params[:id])
	end

	def responder_params
		params.require(:responder).permit(:type, :name, :capacity)
	end	
end
