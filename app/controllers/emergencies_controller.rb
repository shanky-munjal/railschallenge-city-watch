class EmergenciesController < ApplicationController
	before_action :set_emergency, only: [:show, :update]
	def create
		# debugger
		@emergency = Emergency.new(emergency_params)

		respond_to do |format|
			if @emergency.save
				format.json { render json: {emergency: @emergency} , status: :created }
			else
				format.json { render json: {message: @emergency.errors.messages}, status: :unprocessable_entity }
			end
		end
	end

	def index
		@emergencies = Emergency.all
		respond_to do |format|
			format.json { render json: {emergencies: @emergencies, full_responses: [1, @emergencies.count]}, status: :ok}
		end
	end

	def show
		respond_to do |format|
			if @emergency
				format.json { render json: {emergency: @emergency}, status: :ok}
			else
				format.json { render json: {}, status: :not_found}
			end
		end		
	end

	def update
	    respond_to do |format|
	      if @emergency.update(emergency_params)
	        format.json { render json: {emergency: @emergency}, status: :ok }
	      else
	        format.json { render json: @emergency.errors, status: :unprocessable_entity }
	      end
	    end		
	end

	private
    def set_emergency
      @emergency = Emergency.find_by(code: params[:code])
    end

	def emergency_params
		params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity, :resolved_at)
	end	

end
