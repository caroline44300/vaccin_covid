class PagesController < ApplicationController

  def home
    @dispo_docto, @dispo_maiia, @dispo_keldoc = CheckAvailabilitiesJob.perform_now
  end

end
