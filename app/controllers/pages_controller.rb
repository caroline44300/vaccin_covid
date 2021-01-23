class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    @dispo_docto, @dispo_maiia, @dispo_keldoc = dispos_sites
  end

  private

  def dispos_sites
    # open a browser
    browser = Watir::Browser.new :chrome
    # go to doctolib site
    browser.goto("https://www.doctolib.fr/vaccination-covid-19/44300-nantes")

    # accept cookies
    cookie_button = browser.element(id: 'didomi-notice-agree-button')
    cookie_button.click

    # scroll to bottom
    browser.scroll.to :bottom

    # check if alert_no_availabilities exists
    alert = browser.element(class: 'dl-alert').exists?
    # availabilities
    if alert
      docto_dispo = "Pas de disponitilités"
    else
      docto_dispo = "Il y a des disponibilités"
    end

    #  repeat for maiia site

    browser.goto("https://www.maiia.com/centre-de-vaccination/44000-NANTES")

    cookie_button = browser.element(text: 'Accepter tous les cookies')
    cookie_button.click


    #check if alert exists
    alert = browser.element(class: 'info-availability').exists?

    if alert
      maiia_dispo = "Pas de disponitilités"
    else
      maiia_dispo = "Il y a des disponibilités"
    end

    # repeat for kedoc site

    browser.goto("https://www.keldoc.com/vaccination-covid-19/nantes")

    cookie_button = browser.button(class: 'nehs-cookie-button')


    cookie_button.click

    #check if alert exists
    alert = browser.div(class: 'alert').exists?

    if alert
      keldoc_dispo = "Pas de disponitilités"
    else
      keldoc_dispo = "Il y a des disponibilités"
    end

    browser.close

    return docto_dispo, maiia_dispo, keldoc_dispo
  end
end
