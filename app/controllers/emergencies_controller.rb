class EmergenciesController < ApplicationController
  before_action :set_emergency, only: [:show, :update]
  before_action :render_404, only: [:new, :edit, :destroy]
  def create
    if emergency_params.is_a? Hash
      @emergency = Emergency.new(emergency_params)
      if @emergency.save
        responders, full_response = @emergency.dispatch_responder
        json_message = get_json_response(@emergency, responders, full_response)
        respond_in_json(json_message, :created)
      else
        respond_in_json({ message: @emergency.errors.messages }, :unprocessable_entity)
      end
    else
      respond_in_json({ message: emergency_params.message }, :unprocessable_entity)
    end
  end

  def index
    @emergencies = Emergency.all
    respond_to do |format|
      format.json { render json: { emergencies: @emergencies, full_responses: [1, @emergencies.count] }, status: :ok }
    end
  end

  def show
    if @emergency
      respond_in_json({ emergency: @emergency }, :ok)
    else
      respond_in_json({}, :not_found)
    end
  end

  def update
    if emergency_params_for_update.is_a? Hash
      if @emergency.update(emergency_params_for_update)
        Responder.make_available(@emergency.code) if @emergency.resolved_at
        respond_in_json({ emergency: @emergency }, :ok)
      else
        respond_in_json(@emergency.errors, :unprocessable_entity)
      end
    else
      respond_in_json({ message: emergency_params_for_update.message }, :unprocessable_entity)
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
    params.require(:emergency).permit(:code, :fire_severity, :police_severity, :medical_severity)
  rescue => ex
    ex
  end

  def emergency_params_for_update
    params.require(:emergency).permit(:fire_severity, :police_severity, :medical_severity, :resolved_at)
  rescue => ex
    ex
  end

  def get_json_response(emergency, responders, full_response)
    {
      emergency:
      {
        code: emergency.code,
        fire_severity: emergency.fire_severity,
        police_severity: emergency.police_severity,
        medical_severity: emergency.medical_severity,
        responders: responders,
        full_response: full_response
      }
    }
  end
end
