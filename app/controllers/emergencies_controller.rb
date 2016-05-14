class EmergenciesController < ApplicationController
	before_action :set_emergency, only: [:show, :update]
	before_action :render_404, only: [:new, :edit, :destroy]
	def create
		@emergency = Emergency.new(emergency_params)
		respond_to do |format|
			if @emergency.save
				responders, full_response = @emergency.dispatch_responder
				format.json { render json: {emergency: {code: @emergency.code, fire_severity: @emergency.fire_severity, police_severity: @emergency.police_severity, medical_severity: @emergency.medical_severity, responders: responders, full_response: full_response}} , status: :created }
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
				if @emergency.resolved_at
					Responder.make_available(@emergency.code)
				end
				format.json { render json: {emergency: @emergency}, status: :ok }
			else
				format.json { render json: @emergency.errors, status: :unprocessable_entity }
			end
		end		
	end

	def new
	end

	def destroy
	end
	def edit
	end

	private
	def set_emergency
		@emergency = Emergency.find_by(code: params[:code])
	end

	def emergency_params
		params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity, :resolved_at)
	end	
end
