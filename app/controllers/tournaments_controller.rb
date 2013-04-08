class TournamentsController < ApplicationController

  def index
    @tournaments = Tournament.order("start_date DESC").all
  end
  
end
