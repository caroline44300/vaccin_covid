class PagesController < ApplicationController
  require 'webdrivers'

  def home
    @dispo_docto, @dispo_maiia, @dispo_keldoc = CheckAvailabilitiesJob.perform_now
  end

end
