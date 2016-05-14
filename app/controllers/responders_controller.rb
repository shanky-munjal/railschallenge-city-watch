class RespondersController < ApplicationController
  before_action :set_responder, only: [:show, :update]
  before_action :render_404, only: [:new, :edit, :destroy]
  def create
    if responder_params.is_a? Hash
      @responder = Responder.new(responder_params)

      respond_to do |format|
        if @responder.save
          format.json { render json: {responder: @responder} , status: :created }
        else
          format.json { render json: {message: @responder.errors.messages}, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.json { render json: {message: responder_params.message} , status: :unprocessable_entity }
      end
    end
  end

  def index
    if params[:show].try('downcase') == "capacity"
      fire_responder = Fire.all
      total_fire_capacity, total_fire_available, total_fire_on_duty, total_fire_available_and_on_duty = Fire.calculate_capacity
      total_police_capacity, total_police_available, total_police_on_duty, total_police_available_and_on_duty = Police.calculate_capacity
      total_medical_capacity, total_medical_available, total_medical_on_duty, total_medical_available_and_on_duty = Medical.calculate_capacity
      respond_to do |format|
        format.json { render json: {capacity: 
          {"Fire" => [total_fire_capacity, total_fire_available, total_fire_on_duty, total_fire_available_and_on_duty],
           "Police" => [total_police_capacity, total_police_available, total_police_on_duty, total_police_available_and_on_duty],
           "Medical" => [total_medical_capacity, total_medical_available, total_medical_on_duty, total_medical_available_and_on_duty]}}, status: :ok}
      end
    else
      @responders = Responder.all
      respond_to do |format|
        format.json { render json: {responders: @responders}, status: :ok}
      end
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
    if responder_params_for_update.is_a? Hash
        respond_to do |format|
          if @responder.update(responder_params_for_update)
            format.json { render json: {responder: @responder}, status: :ok }
          else
            format.json { render json: @responder.errors, status: :unprocessable_entity }
          end
        end
    else
      respond_to do |format|
        format.json { render json: {message: responder_params_for_update.message} , status: :unprocessable_entity }
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
    def set_responder
      @responder = Responder.find_by(name: params[:name])
    end

  def responder_params
    begin
      params.require(:responder).permit(:type, :name, :capacity)
    rescue => ex
      ex
    end
  end 

  def responder_params_for_update
    begin
      params.require(:responder).permit(:on_duty)
    rescue => ex
      ex
    end
  end 

end
