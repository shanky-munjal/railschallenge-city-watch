class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :update]
  before_action :render_404, only: [:new, :edit, :destroy]
  def create
    if responder_params.is_a? Hash
      @responder = Responder.new(responder_params)

      if @responder.save
        respond_in_json({ responder: @responder }, :created)
      else
        respond_in_json({ message: @responder.errors.messages }, :unprocessable_entity)
      end
    else
      respond_in_json({ message: responder_params.message }, :unprocessable_entity)
    end
  end

  def index
    if params[:show].try('downcase') == 'capacity'
      fire_capacity_info = Fire.calculate_capacity
      police_capacity_info = Police.calculate_capacity
      medical_capacity_info = Medical.calculate_capacity
      json_message = get_json_response(fire_capacity_info, police_capacity_info, medical_capacity_info)
      respond_in_json(json_message, :ok)
    else
      @responders = Responder.all
      respond_to do |format|
        format.json { render json: { responders: @responders }, status: :ok }
      end
    end
  end

  def show
    if @responder
      respond_in_json({ responder: @responder }, :ok)
    else
      respond_in_json({}, :not_found)
    end
  end

  def update
    if responder_params_for_update.is_a? Hash
      if @responder.update(responder_params_for_update)
        respond_in_json({ responder: @responder }, :ok)
      else
        respond_in_json(@responder.errors, :unprocessable_entity)
      end
    else
      respond_in_json({ message: responder_params_for_update.message }, :unprocessable_entity)
    end
  end

  def new
  end

  def destroy
  end

  def edit
  end

  private

  def set_responder
    @responder = Responder.find_by(name: params[:name])
  end

  def responder_params
    params.require(:responder).permit(:type, :name, :capacity)
  rescue => ex
    ex
  end

  def responder_params_for_update
    params.require(:responder).permit(:on_duty)
  rescue => ex
    ex
  end

  def get_json_response(fire_capacity_information, police_capacity_information, medical_capacity_information)
    {
      capacity:
      {
        "Fire": fire_capacity_information,
        "Police": police_capacity_information,
        "Medical": medical_capacity_information
      }
    }
  end
end
