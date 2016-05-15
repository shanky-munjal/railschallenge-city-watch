class ApplicationController < ActionController::Base
  private

  def render_404
    respond_to do |format|
      format.json { render json: { message: 'page not found' }, status: :not_found }
    end
  end

  def respond_in_json(json_message, status)
    respond_to do |format|
      format.json { render json: json_message, status: status }
    end
  end
end
