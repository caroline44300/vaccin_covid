class PagesController < ApplicationController

  def home
    @availabilities = []
    @dispo_docto, @dispo_maiia, @dispo_keldoc = CheckAvailabilitiesJob.perform_now
  end

end
