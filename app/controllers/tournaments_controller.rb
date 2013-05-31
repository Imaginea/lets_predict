class TournamentsController < ApplicationController

  def index
    @tournaments = Tournament.order("start_date DESC").all
  end
  
  def show
    @tournament = Tournament.find(params[:id])
  end
end
