class RespondersController < ApplicationController
	before_action :set_responder, only: [:show, :update]
	def create
		# debugger
		@responder = Responder.new(responder_params)

		respond_to do |format|
			if @responder.save
				format.json { render json: {responder: @responder} , status: :created }
			else
				format.json { render json: {message: @responder.errors.messages}, status: :unprocessable_entity }
			end
		end
	end

	def index
		@responders = Responder.all
		respond_to do |format|
			format.json { render json: {responders: @responders}, status: :ok}
		end
	end

	def show
		respond_to do |format|
			if @responder
				format.json { render json: {responder: @responder}, status: :ok}
			else
				format.json { render json: {}, status: :not_found}
			end
		end		
	end

	def update
	    respond_to do |format|
	      if @responder.update(responder_params)
	        format.json { render json: {responder: @responder}, status: :ok }
	      else
	        format.json { render json: @responder.errors, status: :unprocessable_entity }
	      end
	    end		
	end

	private
    def set_responder
      @responder = Responder.find_by(name: params[:name])
    end

	def responder_params
		params.require(:responder).permit(:type, :name, :capacity)
	end	

end
