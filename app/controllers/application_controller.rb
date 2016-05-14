class ApplicationController < ActionController::Base
  private
  def render_404
    respond_to do |format|
      format.json { render :json => {message: "page not found"}, :status => :not_found }
    end
  end

end