class TournamentsController < ApplicationController

  def index
    @tournaments = Tournament.order("start_date DESC").all
  end

  def find_tournament
    @selected_tournament = Tournament.find(params[:id])
  end

end
