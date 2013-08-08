class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :login_required
  
  protected

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) 
  end
  helper_method :current_user

  def current_time
    Time.zone.now
  end
  helper_method :current_time

  def login_required
    redirect_to root_path, :alert => 'Please login.' unless current_user
  end

  # used in users and matches controller
  def restrict_to_open_tournaments
    @current_tournament =  Tournament.find(params[:tournament_id])
    access_denied unless @current_tournament.started?
  end

  # used in predictions controller
  def restrict_to_closed_tournaments
    @current_tournament = Tournament.find(params[:tournament_id])
    access_denied if @current_tournament.predictions_closed?
  end

  def restrict_to_admins
    access_denied unless current_user.admin?
  end

  def access_denied
    redirect_to home_path, :alert => 'Sorry! Access denied.'
  end

end
